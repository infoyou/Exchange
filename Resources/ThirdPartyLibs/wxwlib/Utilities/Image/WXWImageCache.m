//
//  WXWImageCache.m
//  Project
//
//  Created by XXX on 11-11-9.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWImageCache.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"
#import "WXWImageFetcher.h"
#import "WXWDebugLogOutput.h"
#import "WXWConstants.h"
#import "WXWCommonUtils.h"

#define MAX_CONNECTION 6

@interface WXWImageCache()
@property (nonatomic, retain) NSMutableDictionary *imageDic;
@property (nonatomic, retain) NSMutableDictionary *callerDic;
@property (nonatomic, retain) NSMutableDictionary *pendingDic;
@end

@implementation WXWImageCache

#pragma mark - properties
- (NSMutableDictionary *)imageDic {
  if (nil == _imageDic) {
    _imageDic = [[NSMutableDictionary alloc] init];
  }
  return _imageDic;
}

- (NSMutableDictionary *)callerDic {
  if (nil == _callerDic) {
    _callerDic = [[NSMutableDictionary alloc] init];
  }
  return _callerDic;
}

- (NSMutableDictionary *)pendingDic {
  if (nil == _pendingDic) {
    _pendingDic = [[NSMutableDictionary alloc] init];
  }
  return _pendingDic;
}

#pragma mark - life cycle methods
- (id)init {
	self = [super init];

  return self;
}
/*
- (NSMutableDictionary *)imageDic {
  if (nil == _callerDic) {
    _callerDic = [[NSMutableDictionary alloc] init];
  }
  return _callerDic;
}
 */

- (void)saveImageIntoCache:(NSString *)url image:(UIImage *)image {
    (self.imageDic)[url] = image;
}

- (UIImage *)getImage:(NSString*)anUrl {
	
	UIImage *image = (self.imageDic)[anUrl];
    if (image) {
        return image;
    } else {
        return nil;
    }
}

- (void)clearAllCache {
    [self.imageDic removeAllObjects];
}

- (void)removeDelegate:(id)delegate forUrl:(NSString *)key
{
	NSMutableArray *arr = (self.imageDic)[key];
	if (arr) {
		[arr removeObject:delegate];
		if ([arr count] == 0) {
			[self.imageDic removeObjectForKey:key];
		}
	}
}

- (void)dealloc {
  
  self.imageDic = nil;
  self.pendingDic = nil;
  self.callerDic = nil;
  
  [super dealloc];
}

#pragma mark - image db management
- (void)insertImageIntoDB:(NSData *)imgData forUrl:(NSString *)anUrl {
	static WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO images VALUES(?,?,?)"];
		[inserStmt retain];
	}
	[inserStmt bindString:anUrl forIndex:1];
	[inserStmt bindData:imgData forIndex:2];
  [inserStmt bindDouble:[WXWCommonUtils convertToUnixTS:[NSDate date]] forIndex:3];
	
	//ignore error
	[inserStmt step];
	[inserStmt reset];
}

- (UIImage *)fetchImageFromDB:(NSString *)url {
  UIImage *image = nil;
	static WXWStatement *stmt = nil;
	if (stmt == nil) {
		stmt = [WXWDBConnection statementWithQuery:"SELECT image FROM images WHERE url=?"];
    // because the image table may not have been created at this moment, e.g., user photo loaded
    // from linkedin during sign up confirmation, but the user has not been created, then no need
    // to save the image into DB
    if (nil == stmt) {
      return nil;
    }
		[stmt retain];
	}
	
	[stmt bindString:url forIndex:1];
	if ([stmt step] == SQLITE_ROW) {
		NSData *data = [stmt getData:0];
		image = [UIImage imageWithData:data];
	}
	
	[stmt reset];
	return image;
}

- (void)deleteImageFromDB:(NSString *)url {
  WXWStatement *deleteStmt = [WXWDBConnection statementWithQuery:"DELETE FROM images WHERE url=?;"];
	  
	[deleteStmt bindString:url 
                forIndex:1];
	
	if ([deleteStmt step] != SQLITE_DONE) {
		debugLog(@"delete image for url: %@ failed", url);
	}
  
	[deleteStmt reset];
}

#pragma mark - image cache management
- (UIImage *)fetchImageFromCache:(NSString *)url {
  UIImage *image = nil;
  if (url && url.length > 0) {
    image = (self.imageDic)[url];
  }
  if (image) {
    return image;
  }
  
  image = [self fetchImageFromDB:url];
  if (image) {
    if (url && url.length > 0) {
      [self.imageDic setObject:image forKey:url];
    }
    return image;
  }
  return nil;
}

- (void)fetchImage:(NSString*)url 
            caller:(id<WXWImageFetcherDelegate>)caller
          forceNew:(BOOL)forceNew {
  
  UIImage *image = nil;
  if (forceNew) {
    if ((self.imageDic)[url]) {
      [self.imageDic removeObjectForKey:url];
    }
  } else {
    image = [self fetchImageFromCache:url];
    if (image) {
      
      //[caller imageFetchDone:image url:url];
      [caller imageFetchFromeCacheDone:image url:url];
      
      return;
    }
  }
  
  if (url && url.length > 0) {
    WXWImageFetcher *imageFetcher = (self.pendingDic)[url];
    if (nil == imageFetcher) {
      imageFetcher = [[[WXWImageFetcher alloc] initWithDelegate:self interactionContentType:LOAD_IMAGE_TY] autorelease];
      (self.pendingDic)[url] = imageFetcher;
    }
    
    NSMutableArray *array = (self.callerDic)[url];
    if (array) {
      [array addObject:caller];
    } else {
      (self.callerDic)[url] = [NSMutableArray arrayWithObject:caller];
    }
    
    if ([self.pendingDic count] <= MAX_CONNECTION) {
            
      [imageFetcher fetchImage:url showAlertMsg:NO];
    }
  }
}

- (void)fetchPendingImage:(NSString *)requestUrl {
  [self.pendingDic removeObjectForKey:requestUrl];
  
  NSArray *keys = [self.pendingDic allKeys];
  
  for (NSString *url in keys) {
    WXWImageFetcher *imageFetcher = (self.pendingDic)[url];
    
    NSMutableArray *array = (self.callerDic)[url];
    if (nil == array) {
      [self.pendingDic removeObjectForKey:url];      
    } else if (0 == [array count]) {
      [self.callerDic removeObjectForKey:url];
      
      [self.pendingDic removeObjectForKey:url];
    } else {
      //if (nil == imageFetcher.requestUrl) {
      if (![imageFetcher imageBeingLoaded:url]) {
        [imageFetcher fetchImage:url showAlertMsg:NO];
        break;
      }
    }
  }
}

- (void)cancelPendingImageLoadProcess:(NSMutableDictionary *)urlDic {
  NSArray *urls = [urlDic allValues];
  for (NSString *url in urls) {
    WXWImageFetcher *imageFetcher = (self.pendingDic)[url];
    if (imageFetcher) {
      [imageFetcher cancelConnection];
    }
  }
}

// should be called in caller dealloc method
- (void)clearCallerFromCache:(NSString *)url {
  
  if (nil == url || [url length] == 0) {
    return;
  }

  if (self.callerDic.count == -1) {
    NSLog(@"this is -1!");
  }
  
  if (self.callerDic.count != -1) {   // why cout could be -1 sometimes???
    
    //if ([[self.callerDic allKeys] containsObject:url]) {
    
    // avoid get null value for null key, so check whether this url (key) existing in dic firstly
    
    NSMutableArray *array = (self.callerDic)[url];   
    if (array) { 
      [self.callerDic removeObjectForKey:url];
      /*
       if ([array count] > 0) {
       [array removeLastObject];
       
       if (array) {
       if (0 == [array count]) {
       [self.callerDic removeObjectForKey:url];
       
       RELEASE_OBJ(array);
       }      
       }
       
       }
       */
    }     
    //NSLog(@"after remove dic: %@", self.callerDic);
    // }
    
    [self.pendingDic removeObjectForKey:url];
  }
}

// be called in dealloc method of image consumer to keep cache in low footprint
- (void)clearAllCachedImages {
  [self.imageDic removeAllObjects];
}

// be called when app terminal or startup
- (void)clearAllCachedAndLocalImages {
  [self clearAllCachedImages];
  
  // delete the images that loaded a month ago
  NSDate *monthAgoDatetime = [WXWCommonUtils getOffsetDateTime:[NSDate date] offset:-30];
  
  WXWStatement *deleteStmt = [WXWDBConnection statementWithQuery:"DELETE FROM images where updated_at < ?;"];
  [deleteStmt bindDouble:[WXWCommonUtils convertToUnixTS:monthAgoDatetime] forIndex:1];
	
  if ([deleteStmt step] != SQLITE_DONE) {
		debugLog(@"delete all images");
	}
  
	[deleteStmt reset];
}

- (void)didReceiveMemoryWarning {
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
	for (id key in self.imageDic) {
		UIImage *image = (self.imageDic)[key];
		if (image.retainCount == 1) {
      [array addObject:key];
		}
	}
	[self.imageDic removeObjectsForKeys:array];
}

#pragma mark - WXWConnectorDelegate methods 
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
  if (url && url.length > 0) {
    NSMutableArray *array = (self.callerDic)[url];
    for (id<WXWImageFetcherDelegate> caller in array) {
      [caller imageFetchStarted:url];
    }
  }
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
  [self fetchPendingImage:url];
  
  NSMutableArray *array = (self.callerDic)[url];
  for (id<WXWImageFetcherDelegate> caller in array) {
    [caller imageFetchFailed:error url:url];
  }

  [self.callerDic removeObjectForKey:url];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
  
  UIImage *image = [UIImage imageWithData:result];
  
  if (image) {
    NSMutableArray *array = (self.callerDic)[url];
    
    [self insertImageIntoDB:result forUrl:url];
  
    if (array) {
      for (id<WXWImageFetcherDelegate> caller in array) {
        [caller imageFetchDone:image url:url];        
      }
      
      [self.callerDic removeObjectForKey:url];
    }
    
    (self.imageDic)[url] = image;
  }
  
  [self fetchPendingImage:url];
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
  [self clearCallerFromCache:url];  
}


@end
