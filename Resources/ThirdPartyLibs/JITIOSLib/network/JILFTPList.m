//
//  JILFTPList.m
//  JITIOSLib
//
//  Created by user on 13-7-5.
//
//
#import "JILBase.h"
#import "JILFTPList.h"

@interface JILFTPList () <NSStreamDelegate>
@property (nonatomic, strong, readwrite) NSInputStream *   networkStream;
@property (nonatomic, strong, readwrite) NSMutableData *   listData;
@end

@implementation JILFTPList

+ (long long) sizeOfFileAtURL:(NSString *) url
{
	long long s = -1;
	JILFTPList *l = [[JILFTPList alloc] initWithURL:url];
	[l startReceive];
	[l waitForFinishingReceiving];
	s = l.resourceSize;
	[l release];
	return s;
}

- (id) initWithURL:(NSString *) resourceURL;
{
	self = [super init];
	if(self) {
		self.resourceURL = [NSURL URLWithString:resourceURL];
		assert(self.resourceURL);
		self.listEntries = [NSMutableArray array];
	}
	return self;
}

- (void)dealloc
{
	if([self isReceiving])
		[self stopReceive];
	[_resourceURL release];
	[_listEntries release];
	[super dealloc];
}

- (void)addListEntries:(NSArray *)newEntries
{
    assert(self.listEntries != nil);
	[self.listEntries addObjectsFromArray:newEntries];
}

#pragma mark * Core transfer code

// This is the code that actually does the networking.

- (BOOL)isReceiving
{
    return (self.networkStream != nil);
}

- (void) waitForFinishingReceiving
{
	while ([self isReceiving]) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
	}
}

- (void)startReceive
// Starts a connection to download the current URL.
{
    assert(self.networkStream == nil);      // don't tap receive twice in a row!
	assert(self.resourceURL != nil);
	JILDEBUG(@"Start get info of '%@'", self.resourceURL.absoluteString);
	self.resourceSize = -1;
	self.listData = [NSMutableData data];
	[self.listEntries removeAllObjects];
	assert(self.listData != nil);
	self.networkStream = CFBridgingRelease(CFReadStreamCreateWithFTPURL(NULL, (CFURLRef) self.resourceURL));
	assert(self.networkStream != nil);
	CFReadStreamSetProperty((CFReadStreamRef) self.networkStream, kCFStreamPropertyFTPFetchResourceInfo, kCFBooleanTrue);
	self.networkStream.delegate = self;
	[self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[self.networkStream open];
}

- (void) stopReceive
{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    self.listData = nil;
}

- (NSDictionary *)entryByReencodingNameInEntry:(NSDictionary *)entry encoding:(NSStringEncoding)newEncoding
{
    NSDictionary *  result;
    NSString *      name;
    NSData *        nameData;
    NSString *      newName;
    
    newName = nil;
    
    // Try to get the name, convert it back to MacRoman, and then reconvert it
    // with the preferred encoding.
    
    name = [entry objectForKey:(id) kCFFTPResourceName];
    if (name != nil) {
        assert([name isKindOfClass:[NSString class]]);
        
        nameData = [name dataUsingEncoding:NSMacOSRomanStringEncoding];
        if (nameData != nil) {
            newName = [[NSString alloc] initWithData:nameData encoding:newEncoding];
        }
    }
    
    // If the above failed, just return the entry unmodified.  If it succeeded,
    // make a copy of the entry and replace the name with the new name that we
    // calculated.
    
    if (newName == nil) {
       // assert(NO);                 // in the debug builds, if this fails, we should investigate why
        result = (NSDictionary *) entry;
    } else {
        NSMutableDictionary *   newEntry;
        
        newEntry = [entry mutableCopy];
        assert(newEntry != nil);
        
        [newEntry setObject:newName forKey:(id) kCFFTPResourceName];
        [newName release];
        result = newEntry;
        [newEntry release];
    }
    
    return result;
}

- (void)parseListData
{
    NSMutableArray *    newEntries;
    NSUInteger          offset;
    
    // We accumulate the new entries into an array to avoid a) adding items to the
    // table one-by-one, and b) repeatedly shuffling the listData buffer around.
    
    newEntries = [NSMutableArray array];
    assert(newEntries != nil);
    
    offset = 0;
    do {
        CFIndex         bytesConsumed;
        CFDictionaryRef thisEntry;
        
        thisEntry = NULL;
        
        assert(offset <= [self.listData length]);
        bytesConsumed = CFFTPCreateParsedResourceListing(NULL, &((const uint8_t *) self.listData.bytes)[offset], (CFIndex) ([self.listData length] - offset), &thisEntry);
        if (bytesConsumed > 0) {
			
            // It is possible for CFFTPCreateParsedResourceListing to return a
            // positive number but not create a parse dictionary.  For example,
            // if the end of the listing text contains stuff that can't be parsed,
            // CFFTPCreateParsedResourceListing returns a positive number (to tell
            // the caller that it has consumed the data), but doesn't create a parse
            // dictionary (because it couldn't make sense of the data).  So, it's
            // important that we check for NULL.
			
            if (thisEntry != NULL) {
                NSDictionary *  entryToAdd;
                
                // Try to interpret the name as UTF-8, which makes things work properly
                // with many UNIX-like systems, including the Mac OS X built-in FTP
                // server.  If you have some idea what type of text your target system
                // is going to return, you could tweak this encoding.  For example,
                // if you know that the target system is running Windows, then
                // NSWindowsCP1252StringEncoding would be a good choice here.
                //
                // Alternatively you could let the user choose the encoding up
                // front, or reencode the listing after they've seen it and decided
                // it's wrong.
                //
                // Ain't FTP a wonderful protocol!
				
                entryToAdd = [self entryByReencodingNameInEntry:(NSDictionary *) thisEntry encoding:NSUTF8StringEncoding];
                
                [newEntries addObject:entryToAdd];
            }
            
            // We consume the bytes regardless of whether we get an entry.
            
            offset += (NSUInteger) bytesConsumed;
        }
        
        if (thisEntry != NULL) {
            CFRelease(thisEntry);
        }
        
        if (bytesConsumed == 0) {
            // We haven't yet got enough data to parse an entry.  Wait for more data
            // to arrive.
            break;
        } else if (bytesConsumed < 0) {
            // We totally failed to parse the listing.  Fail.
            [self stopReceive];
            break;
        }
    } while (YES);
	
    if ([newEntries count] != 0) {
        [self addListEntries:newEntries];
    }
    if (offset != 0) {
        [self.listData replaceBytesInRange:NSMakeRange(0, offset) withBytes:NULL length:0];
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
#pragma unused(aStream)
    assert(aStream == self.networkStream);
	
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
			id prop = [self.networkStream propertyForKey:(id)kCFStreamPropertyFTPResourceSize];
			if (prop)
				self.resourceSize =  [prop longLongValue];
        } break;
        case NSStreamEventHasBytesAvailable: {
            NSInteger       bytesRead;
            uint8_t         buffer[32768];
			
	
            // Pull some data off the network.
            
            bytesRead = [self.networkStream read:buffer maxLength:sizeof(buffer)];
            if (bytesRead < 0) {
                [self stopReceive];
            } else if (bytesRead == 0) {
                [self stopReceive];
            } else {
                assert(self.listData != nil);
                
                // Append the data to our listing buffer.
                
                [self.listData appendBytes:buffer length:(NSUInteger) bytesRead];
                
                // Check the listing buffer for any complete entries and update
                // the UI if we find any.
                
                [self parseListData];
            }
        } break;
        case NSStreamEventHasSpaceAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventErrorOccurred: {
			JILERROR(@"Failed to open stream");
            [self stopReceive];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}
@end
