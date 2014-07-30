//
//  ProjectUserDefaults.m
//  Project
//
//  Created by XXX on 13-10-23.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ProjectUserDefaults.h"

#define APP_PROP_NAME @"GoHigh"


@interface ProjectUserDefaults()
@property (nonatomic, retain) NSUserDefaults *defaults;
@end

@implementation ProjectUserDefaults{
    NSDictionary *_appProps;
}

- (id) init
{
	self = [super init];
	if(self) {
		NSString *p = [[NSBundle mainBundle] pathForResource:APP_PROP_NAME ofType:@"plist"];
		_appProps = [[NSDictionary dictionaryWithContentsOfFile:p] retain];
		assert(_appProps);
	}
	return self;
}

- (void) dealloc
{
	[_appProps release];
	[_defaults release];
	[super dealloc];
}

//system defaults
- (id) valueForAppProperty:(NSString *) key
{
	assert(_appProps);
	return [_appProps objectForKey:key];
}

- (NSString *) usernameRemembered
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
}

- (NSString *) passwordRemembered
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
}

- (NSString *)customerNameRemembered {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"customerName"];
}

- (void) rememberUsername:(NSString *) username
			  andPassword:(NSString *) password
{
	NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
	if(username == nil) {
		[_def removeObjectForKey:@"username"];
		[_def removeObjectForKey:@"password"];
	} else {
		[_def setObject:username forKey:@"username"];
		[_def setObject:password forKey:@"password"];
	}
	[_def synchronize];
}

- (void)rememberCustomerName:(NSString *)customerName
                    userName:(NSString *)userName
                    password:(NSString *)password {
    NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
	if(userName == nil || customerName == nil) {
        [_def removeObjectForKey:@"customerName"];
		[_def removeObjectForKey:@"username"];
		[_def removeObjectForKey:@"password"];
	} else {
        [_def setObject:customerName forKey:@"customerName"];
		[_def setObject:userName forKey:@"username"];
		[_def setObject:password forKey:@"password"];
	}
	[_def synchronize];
}

@end
