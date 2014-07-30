//
//  WXWConnector.m
//  Project
//
//  Created by XXX on 11-11-3.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWConnector.h"
#import "WXWUIUtils.h"
#import "WXWTextPool.h"
#import "WXWDebugLogOutput.h"
#import "WXWSystemInfoManager.h"
#import "WXWCommonUtils.h"

@interface WXWConnector()
@property (nonatomic, retain) NSTimer *connectionTimer;
@property (nonatomic, copy) NSString *postParam;
@property (nonatomic, retain) NSURLConnection *conn;

@end

@implementation WXWConnector

@synthesize delegate = _delegate;
@synthesize connectionTimer = _connectionTimer;
@synthesize receivedData = _receivedData;
@synthesize requestUrl = _requestUrl;
@synthesize postParam = _postParam;
@synthesize conn = _conn;
@synthesize interactionContentType = _interactionContentType;

- (id)initWithDelegate:(id<WXWConnectorDelegate>)delegate
interactionContentType:(NSInteger)interactionContentType{
  self = [super init];
  if (self) {
    self.delegate = delegate;
    self.interactionContentType = interactionContentType;
    
    DLog(@"---1---");
  }
  return self;
}

- (void)dealloc {
  DLog(@"---2---");
  
  self.delegate = nil;
  self.requestUrl = nil;
  self.receivedData = nil;
  self.postParam = nil;
  self.conn = nil;
  
  [super dealloc];
}

#pragma mark - customized connectioin methods

- (void)asyncTimeoutHandler {
  if (_running) {
    
    if (_showAlertMsg) {
      [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSTimeoutMsg, nil)
                                    msgType:ERROR_TY
                         belowNavigationBar:YES];
    }
  }
}

- (void)syncTimeoutHandler {
  
  if (!_syncConnectionDone) {
    [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSTimeoutMsg, nil)
                                  msgType:ERROR_TY
                       belowNavigationBar:YES];
  }
}

- (void)connectionStopHandler {
  
  if (self.conn) {
    [self.conn cancel];
  }
  self.conn = nil;
  
  _expectedContentLength = 0ll;
  
  if (self.connectionTimer.isValid) {
    [self.connectionTimer invalidate];
  }
  
  _running = NO;
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)prepare {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  self.requestUrl = nil;
  
  _statusCode = 0;
  
  _expectedContentLength = 0ll;
  
  self.conn = nil;
  self.receivedData = nil;
  
  self.receivedData = [NSMutableData data];
  
  if ([self.connectionTimer isValid]) {
    [self.connectionTimer invalidate];
  }
}

- (NSString *) convertParaToHttpBodyStr:(NSDictionary *)dic {
	NSArray *keys = [dic allKeys];
	NSString *res = [NSString string];
	
	for (int i = 0; i < [keys count]; i++) {
		res = [res stringByAppendingString:
           [@"--" stringByAppendingString:
            [WXW_FORM_BOUNDARY stringByAppendingString:
             [@"\nContent-Disposition: form-data; name=\"" stringByAppendingString:
              [keys[i] stringByAppendingString:
               [@"\"\n\n" stringByAppendingString:
                [[dic valueForKey: keys[i]] stringByAppendingString:@"\n"]]]]]]];
    
	}
	
	return res;
}

- (NSData *)assembleContentData:(NSDictionary *)dic {
	NSString *param = [self convertParaToHttpBodyStr:dic];
	
	NSMutableData *contentData = [NSMutableData data];
	
	[contentData appendData:[param dataUsingEncoding:NSUTF8StringEncoding
                              allowLossyConversion:YES]];
	
	// append footer
	NSString *footer = [[NSString alloc] initWithFormat:@"\n--%@--\n", WXW_FORM_BOUNDARY];
	[contentData appendData:[footer dataUsingEncoding:NSUTF8StringEncoding
                               allowLossyConversion:YES]];
	
	[footer release];
	footer = nil;
  
  //NSLog(@"parame: %@", [[[NSString alloc] initWithData:contentData encoding:NSUTF8StringEncoding] autorelease]);
	
	return contentData;
}

#pragma mark - parser http response

- (void)traceLogIfNecessary:(NSError *)error {
  
  if (_statusCode != HTTP_RESP_OK) {
    if (_getMethod) {
      debugLog(@"GET method url: %@, http response code: %i", [self.requestUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _statusCode);
    } else {
      debugLog(@"POST method param: %@, http response code: %i", self.postParam, _statusCode);
    }
  }
  
  if (error) {
    NSString *msg = [NSString stringWithFormat:@"Error: %@ %@, error code:%i",
                     [error localizedDescription],
                     [error userInfo][NSURLErrorFailingURLStringErrorKey],
                     error.code];
    debugLog(@"Connection error: %@", msg);
  }
}

- (void)releaseResource {
  self.delegate = nil;
}

- (void)showConnectionErrorMsgAndReleaseResource:(NSString *)error {
  
  if (self.delegate) {
    [self.delegate connectFailed:nil url:self.requestUrl contentType:self.interactionContentType];
  }
  
  /*
   if (_showAlertMsg) {
   [WXWUIUtils alert:error
   message:nil];
   }
   */
  
  [self releaseResource];
}

- (void)handleNoResponseStatus:(BOOL)showAlertMsg {
  if (self.delegate) {
    [self.delegate connectFailed:nil
                             url:self.requestUrl
                     contentType:self.interactionContentType];
  }
  /*
   if (showAlertMsg) {
   [WXWUIUtils alert:LocaleStringForKey(NSNoResponseMsg, nil)
   message:nil];
   }
   */
  if (_getMethod) {
    debugLog(@"GET method url: %@, no response xml content", [self.requestUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
  } else {
    debugLog(@"POST method param: %@, no response xml content", self.postParam);
  }
  
}

- (void)parserResponse:(NSData *)data
                 error:(NSError *)error
          showAlertMsg:(BOOL)showAlertMsg
                  sync:(BOOL)sync {
  
  [self traceLogIfNecessary:error];
  
  switch (_statusCode) {
		case 401:
		{
      debugLog(@"Not Authorized: either you need to provide authentication credentials, or the credentials provided aren't valid. Error code: %d. Reason: %@",
               _statusCode,
               [NSHTTPURLResponse localizedStringForStatusCode:_statusCode]);
      [self showConnectionErrorMsgAndReleaseResource:LocaleStringForKey(NSUserAuthFailedMsg, nil)];
			return;
		}
      
		case 304:
		{
      debugLog(@"Not Modified: there was no new data to return. Error code: %d. Reason: %@",
               _statusCode,
               [NSHTTPURLResponse localizedStringForStatusCode:_statusCode]);
      [self showConnectionErrorMsgAndReleaseResource:LocaleStringForKey(NSResponse304Msg, nil)];
      
			return;
		}
      
    case 400:
    {
      debugLog(@"Bad Request: your request is invalid, and we'll return an error message that tells you why. This is the status code returned if you've exceeded the rate limit. Error code: %d. Reason: %@",
               _statusCode,
               [NSHTTPURLResponse localizedStringForStatusCode:_statusCode]);
      [self showConnectionErrorMsgAndReleaseResource:LocaleStringForKey(NSResponse400Msg, nil)];
      
      return;
    }
      
    case 200: // OK: everything went awesome.
		{
      if (data && [data length] > 0) {
        
        if (self.delegate) {
          [self.delegate connectDone:self.receivedData
                                 url:self.requestUrl
                         contentType:self.interactionContentType];
        }
        
      } else {
        [self handleNoResponseStatus:showAlertMsg];
      }
      
      if (!sync) {
        [self releaseResource];
      }
      
      return;
		}
      
    case 403:
    {
      debugLog(@"Forbidden: we understand your request, but are refusing to fulfill it.  An accompanying error message should explain why. Error code: %d. Reason: %@",
               _statusCode,
               [NSHTTPURLResponse localizedStringForStatusCode:_statusCode]);
      [self showConnectionErrorMsgAndReleaseResource:LocaleStringForKey(NSResponse403Msg, nil)];
      return;
    }
			
    case 404:
    {
      debugLog(@"Not Found: either you're requesting an invalid URI or the resource in question doesn't exist. Error code: %d. Reason: %@",
               _statusCode,
               [NSHTTPURLResponse localizedStringForStatusCode:_statusCode]);
      [self showConnectionErrorMsgAndReleaseResource:LocaleStringForKey(NSResponse404Msg, nil)];
      return;
    }
      
    case 500:
		{
      debugLog(@"Internal Server Error: we did something wrong. Error code: %d. Reason: %@",
               _statusCode,
               [NSHTTPURLResponse localizedStringForStatusCode:_statusCode]);
      [self showConnectionErrorMsgAndReleaseResource:LocaleStringForKey(NSResponse500Msg, nil)];
      
			return;
		}
      
		case 501:
		{
      debugLog(@"Invalid url parameters. Error code: %d. Reason: %@",
               _statusCode,
               [NSHTTPURLResponse localizedStringForStatusCode:_statusCode]);
      [self showConnectionErrorMsgAndReleaseResource:LocaleStringForKey(NSResponse501Msg, nil)];
      
			return;
		}
      
		case 502:
    {
      debugLog(@"Bad Gateway: returned if server is down or being upgraded. Error code: %d. Reaso: %@",
               _statusCode,
               [NSHTTPURLResponse localizedStringForStatusCode:_statusCode]);
      [self showConnectionErrorMsgAndReleaseResource:LocaleStringForKey(NSResponse502Msg, nil)];
      
			return;
    }
      
    case 503:
    {
      debugLog(@"Service Unavailable: the server are up, but are overloaded with requests.  Try again later. Error code: %d. Reason: %@",
               _statusCode,
               [NSHTTPURLResponse localizedStringForStatusCode:_statusCode]);
      [self showConnectionErrorMsgAndReleaseResource:LocaleStringForKey(NSResponse503Msg, nil)];
      
			return;
    }
      
    default:
		{
      debugLog(@"Server responsed with error. Error code: %d. Reason: %@",
               _statusCode,
               [NSHTTPURLResponse localizedStringForStatusCode:_statusCode]);
      [self showConnectionErrorMsgAndReleaseResource:[NSString stringWithFormat:@"%@: %@.",
                                                      LocaleStringForKey(NSResponseCommonErrorMsg, nil),
                                                      [NSHTTPURLResponse localizedStringForStatusCode:_statusCode]]];
			return;
		}
	}
}


#pragma mark - sync methods

- (NSData *)getDataFromWeb:(NSString *)urlStr {
  
  if (urlStr == nil || 0 == urlStr.length) {
		return nil;
	}
	
  _getMethod = YES;
  
  self.requestUrl = urlStr;
  
	NSURL *url = [[NSURL alloc] initWithString:urlStr];
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:NETWORK_TIMEOUT];
  _connectionTimer = [NSTimer scheduledTimerWithTimeInterval:(NETWORK_TIMEOUT + 1)
                                                      target:self
                                                    selector:@selector(syncTimeoutHandler)
                                                    userInfo:nil
                                                     repeats:NO];
	NSURLResponse * response = nil;
	NSError * error = nil;
	NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                        returningResponse:&response
                                                    error:&error];
  NSHTTPURLResponse *urlResp = (NSHTTPURLResponse *)response;
  
  [self parserResponse:data error:error showAlertMsg:YES sync:NO];
  
  RELEASE_OBJ(url);
  
  _syncConnectionDone = YES;
  if (HTTP_RESP_OK == urlResp.statusCode) {
    return data;
  } else {
    return nil;
  }
}

- (NSData *)syncGet:(NSString *)urlStr {
	  
	return [self getDataFromWeb:urlStr];
}

- (NSData *)syncPost:(NSString *)aUrl paramDic:(NSDictionary *)paramDic {
  
	if (aUrl == nil || 0 == aUrl.length) {
		// set a temp url, then force the operation failed, the notification will be
		// displayed for user if necessary
		return nil;
	}
  
  NSData *data = [self assembleContentData:paramDic];
  self.postParam = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
  // format the post param to avoid the mis-parser log content as real post param
  self.postParam = [self.postParam stringByReplacingOccurrencesOfString:@"\n" withString:@"^||^"];
  
  
	NSString *url = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aUrl, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
	[url autorelease];
	
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                     cachePolicy:/*NSURLRequestReloadIgnoringLocalCacheData*/NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:NETWORK_TIMEOUT];
	
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", WXW_FORM_BOUNDARY];
	[req setHTTPMethod:POST];
	[req setValue:contentType forHTTPHeaderField:HTTP_HEADER_FIELD];
	NSString *tmpValue = [[NSString alloc] initWithFormat:@"%d", [data length]];
	[req setValue:tmpValue forHTTPHeaderField:HTTP_HEADER_LEN];
	[req setHTTPBody:data];
	
	[tmpValue release];
	tmpValue = nil;
  
  NSURLResponse * response = nil;
	NSError * error = nil;
	NSData *returnData = [NSURLConnection sendSynchronousRequest:req
                                             returningResponse:&response
                                                         error:&error];
  NSHTTPURLResponse *urlResp = (NSHTTPURLResponse *)response;
  
  _statusCode = urlResp.statusCode;
  
  [self parserResponse:returnData error:error showAlertMsg:NO sync:YES];
  
  if (urlResp.statusCode == HTTP_RESP_OK) {
    return returnData;
  } else {
    return nil;
  }
}

- (NSData *)syncPost:(NSString *)aUrl data:(NSData *)data {
  
  if (aUrl == nil || 0 == aUrl.length) {
    return nil;
  }
  
  self.postParam = [[[NSString alloc] initWithData:data
                                          encoding:NSUTF8StringEncoding] autorelease];
  // format the post param to avoid the mis-parser log content as real post param
  self.postParam = [self.postParam stringByReplacingOccurrencesOfString:@"\n" withString:@"^||^"];
  
	NSString *url = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aUrl, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
	[url autorelease];
	
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                     cachePolicy:/*NSURLRequestReloadIgnoringLocalCacheData*/NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:NETWORK_TIMEOUT];
	
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", WXW_FORM_BOUNDARY];
	[req setHTTPMethod:POST];
	[req setValue:contentType forHTTPHeaderField:HTTP_HEADER_FIELD];
	NSString *tmpValue = [[NSString alloc] initWithFormat:@"%d", [data length]];
	[req setValue:tmpValue forHTTPHeaderField:HTTP_HEADER_LEN];
	
	[req setHTTPBody:data];
	
  RELEASE_OBJ(tmpValue);
  
	NSURLResponse * response = nil;
	NSError * error = nil;
	NSData *returnData = [NSURLConnection sendSynchronousRequest:req
                                             returningResponse:&response
                                                         error:&error];
  NSHTTPURLResponse *urlResp = (NSHTTPURLResponse *)response;
  
  _statusCode = urlResp.statusCode;
  
  [self parserResponse:returnData error:error showAlertMsg:NO sync:YES];
  
  if (urlResp.statusCode == HTTP_RESP_OK) {
    return returnData;
  } else {
    return nil;
  }
}

#pragma mark - async methods
- (void)asyncGet:(NSString *)urlStr showAlertMsg:(BOOL)showAlertMsg {
  
  if (nil == urlStr || 0 == urlStr.length) {
    return;
  }
  
  if (self.conn) {
    // if current connection is loading, then no need continue, waiting last loading finish
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // connectStarted:contentType: of fetcher sometimes will trigger initialized loading status
    if (self.delegate) {
      [self.delegate connectStarted:self.requestUrl contentType:self.interactionContentType];
    }
    
    return;
  }
  
  _showAlertMsg = showAlertMsg;
  
  [self prepare];
  
  self.requestUrl = urlStr;
  
  if (self.delegate) {
    [self.delegate connectStarted:self.requestUrl contentType:self.interactionContentType];
    
    if ([self.delegate respondsToSelector:@selector(saveShowAlertFlag:)]) {
      [self.delegate saveShowAlertFlag:_showAlertMsg];
    }
  }
  
  _getMethod = YES;
  
#ifdef DEBUG
  DLog(@"url = %@", urlStr);
#endif
  
  NSString *requestUrl = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlStr, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
  
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]
                                                            cachePolicy:/*NSURLRequestReloadIgnoringLocalCacheData*/NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:NETWORK_TIMEOUT];
  
  self.conn = [[[NSURLConnection alloc] initWithRequest:urlRequest
                                               delegate:self
                                       startImmediately:YES] autorelease];
  
  
  self.connectionTimer = [NSTimer scheduledTimerWithTimeInterval:(NETWORK_TIMEOUT + 1)
                                                          target:self
                                                        selector:@selector(asyncTimeoutHandler)
                                                        userInfo:nil
                                                         repeats:NO];
  _running = YES;
  
  [requestUrl release];
}

#pragma mark - post method
- (void)post:(NSString *)aUrl data:(NSData *)data {
  
  if (nil == aUrl || 0 == aUrl.length) {
    return;
  }
  
  if (self.conn) {
    return;
  }
    
  [self prepare];
  
  self.requestUrl = aUrl;
  
  if (self.delegate) {
    [self.delegate connectStarted:self.requestUrl contentType:self.interactionContentType];
  }
  
  self.postParam = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
  // format the post param to avoid the mis-parser log content as real post param
  self.postParam = [self.postParam stringByReplacingOccurrencesOfString:@"\n" withString:@"^||^"];
  
	NSString *url = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aUrl, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
	[url autorelease];
	
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                     cachePolicy:/*NSURLRequestReloadIgnoringLocalCacheData*/NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:NETWORK_TIMEOUT];
	
	[req setHTTPMethod:POST];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[[NSString alloc] initWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    
	[req setHTTPBody:data];
	
  
	self.conn = [[[NSURLConnection alloc] initWithRequest:req
                                               delegate:self
                                       startImmediately:YES] autorelease];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)postImageWithUrl:(NSString *)aUrl data:(NSData *)data {
    
    if (nil == aUrl || 0 == aUrl.length) {
        return;
    }
    
    if (self.conn) {
        return;
    }
    
    [self prepare];
    
    self.requestUrl = aUrl;
    
    if (self.delegate) {
        [self.delegate connectStarted:self.requestUrl contentType:self.interactionContentType];
    }
    
    self.postParam = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    // format the post param to avoid the mis-parser log content as real post param
    self.postParam = [self.postParam stringByReplacingOccurrencesOfString:@"\n" withString:@"^||^"];
    
	NSString *url = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aUrl, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
	[url autorelease];
	
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                       cachePolicy:/*NSURLRequestReloadIgnoringLocalCacheData*/NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval:NETWORK_TIMEOUT];
	
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", WXW_FORM_BOUNDARY];
	[req setHTTPMethod:POST];
	[req setValue:contentType forHTTPHeaderField:HTTP_HEADER_FIELD];
	NSString *tmpValue = [[NSString alloc] initWithFormat:@"%d", [data length]];
	[req setValue:tmpValue forHTTPHeaderField:HTTP_HEADER_LEN];
	
	[req setHTTPBody:data];
	
    RELEASE_OBJ(tmpValue);
    
	self.conn = [[[NSURLConnection alloc] initWithRequest:req
                                                 delegate:self
                                         startImmediately:YES] autorelease];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

#pragma mark - cancel
- (void)cancelConnection {
  
  [self connectionStopHandler];
  
  [self.delegate connectCancelled:self.requestUrl contentType:self.interactionContentType];
  
}

#pragma mark - connection error/finish handle
- (void)connectionDidFailWithError:(NSError *)error {
  [self traceLogIfNecessary:error];
  
  if (self.delegate) {
 
    if ([self.delegate respondsToSelector:@selector(parserConnectionError:)]) {
      [self.delegate parserConnectionError:error];
    }
    
    [self.delegate connectFailed:error url:self.requestUrl contentType:self.interactionContentType];
  }
  
  if (_showAlertMsg) {
    [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSNetworkUnstableMsg, nil)
                                  msgType:ERROR_TY
                       belowNavigationBar:YES];
  }
  
	[self releaseResource];
}

- (void)connectionFinish {
  [self parserResponse:self.receivedData error:nil showAlertMsg:YES sync:NO];
}

#pragma mark - connection call back
- (BOOL)connection:(NSURLConnection *)connection
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
  return YES;
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data{
  [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection*)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge{
  /*
   NSString *method = [[challenge protectionSpace] authenticationMethod];
   if ([method isEqualToString:NSURLAuthenticationMethodServerTrust]) {
   SecTrustRef trust;
   trust = [[challenge protectionSpace] serverTrust];
   NSURLCredential *cred = [NSURLCredential credentialForTrust:trust];
   [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
   } else if ([challenge previousFailureCount] == 0) {
   
   NSURLCredential *cred = [NSURLCredential credentialWithUser:[self user] password:[self password]
   persistence:NSURLRequestUseProtocolCachePolicy];
   [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
   } else {
   // cancel connection
   }
   */
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
  
  [self connectionDidFailWithError:error];
  
  [self connectionStopHandler];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
  if (response) {
    _statusCode = ((NSHTTPURLResponse *)response).statusCode;
    
    if (_statusCode == HTTP_RESP_OK) {
      _expectedContentLength = response.expectedContentLength;
    }
  }
  self.receivedData.length = 0;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConn {
  
  [self connectionFinish];
  
  [self connectionStopHandler];
}

- (void)activeGPRSThread
{
  NSError *error;
  NSURLResponse *response;
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://123456"]];
  [request setHTTPMethod:@"GET"];
  
  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

@end
