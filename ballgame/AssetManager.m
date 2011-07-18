//
//  AssetManager.m
//  RaidLeader
//
//  Created by Ryan Hart on 7/4/11.
//  Copyright 2011 __myCompanyName__. All rights reserved.
//

#import "AssetManager.h"


@implementation AssetManager

@synthesize plistDefaults;

static AssetManager* sharedAssetManager = nil;

+(id)sharedInstance
{
	@synchronized([AssetManager class]){
		if (sharedAssetManager == nil){
            sharedAssetManager = [[self alloc] init];
		}
	}
	return sharedAssetManager;
}

+(id)alloc
{
	@synchronized([AssetManager class])
	{
		NSAssert(sharedAssetManager == nil, @"Attempted to allocate a second instance of a singleton.");
		sharedAssetManager = [super alloc];
		return sharedAssetManager;
	}
	
	return nil;
}

-(id) init
{
    self = [super init];
    if (self)
    {
        // Load defaults plist into dictionary
        NSString *pathToDefaultsPlist = [[NSBundle mainBundle] pathForResource:@"GameDefaults" ofType:@"plist"];
        plistDefaults = [[NSDictionary alloc] initWithContentsOfFile:pathToDefaultsPlist];
        _isDownloading = NO;
    }
    
    return self;
}

-(NSDictionary *) getDefaults
{
    return plistDefaults;
}

-(void)cacheResourceOfType:(NSString*)type fromURL:(NSURL*)url withDelegate:(id)delegate andResultSelector:(SEL)selector;{
    if (_isDownloading){
        NSLog(@"Already downloading");
        //[NSException raise:@"Attempt to start downloading a second URL before the first finished or failed" format:@"",nil];
        return;
    }
    _isDownloading = YES;
    _cachedData = [[NSMutableData  alloc] initWithLength:0];
    _placeToWrite = [[NSURL URLWithString:[[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/%@", [url lastPathComponent], nil]] retain];
    NSLog(@"URL: %@", [_placeToWrite absoluteString]);
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    if ([NSURLConnection canHandleRequest:theRequest]){
        NSLog(@"Yeah we can handle that request");
    }
    else{
        NSLog(@"That request is too scary");
    }
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    [connection start];
}


-(NSDictionary*)levelWithName:(NSString*)levelName{
    //TODO: Make this work.
    NSString *pathToDefaultsPlist = [[NSBundle mainBundle] pathForResource:levelName ofType:@"level"];
    NSLog(@"found: %@", pathToDefaultsPlist);
    NSDictionary *levelDefaults = [[NSDictionary alloc] initWithContentsOfFile:pathToDefaultsPlist];
    return [levelDefaults autorelease];
}
#pragma mark - URL loading 
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_cachedData appendData:data];
    NSLog(@"Data");
}
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [connection release];
    NSLog(@"%@", [error description]);
    _isDownloading = NO;
    [_cachedData release];
}
- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [connection release];
    _isDownloading = NO;
    [_cachedData writeToFile:[_placeToWrite absoluteString] atomically:YES];
    [_downloadDelegate performSelector:_resultSelector withObject:_cachedData];
    [_placeToWrite release];
    [_cachedData release];
    NSLog(@"Data Load completed");
}
@end
