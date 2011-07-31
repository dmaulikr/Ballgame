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
        
        //Take the name and plist and convert them to actual Documents Directory URLS
        NSMutableDictionary *_changeDict = [NSMutableDictionary dictionaryWithDictionary:plistDefaults];
        NSString *absolutePngPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/%@", [plistDefaults objectForKey:@"SpriteSheetPngName"], nil];
        NSString *absolutePlistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/%@", [plistDefaults objectForKey:@"SpriteSheetPlistName"], nil];
        [_changeDict setValue:absolutePlistPath forKey:@"SpriteSheetPlistName"];
        [_changeDict setValue:absolutePngPath forKey:@"SpriteSheetPngName"];
        [plistDefaults release];
        plistDefaults = [_changeDict retain];
        //NSLog(@"defaults: %@", plistDefaults);
    }
    
    return self;
}


+(NSArray*)allBundledLevels{
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSArray *pathsInBundle = [fileMan contentsOfDirectoryAtPath:[[NSBundle mainBundle] bundlePath] error:nil];
    NSMutableArray *levels = [NSMutableArray arrayWithCapacity:20];
    for (NSString *path in pathsInBundle){
        //NSLog(@"lastPathComponent %@", [path lastPathComponent]);
        if ([[path lastPathComponent] hasSuffix:@"level"]){
            
            NSString *levelName = [[path lastPathComponent] stringByDeletingPathExtension];
            //NSLog(@"Adding Level: %@", levelName);
            NSDictionary *level = [[AssetManager sharedInstance] levelWithName:levelName];
            if ([level valueForKey:@"name"] == nil){
                //NSLog(@"Adding name key: %@", levelName);
                level = [NSMutableDictionary dictionaryWithDictionary:level];
                [level setValue:levelName forKey:@"name"];
            }
            [levels addObject:level];
        }
    }
    return levels;
}

+(NSDictionary*)defaults{
    return [[AssetManager sharedInstance] getDefaults];
}

-(NSDictionary *)getDefaults
{
    return plistDefaults;
}

-(BOOL)cacheResourceFromURL:(NSURL*)url withDelegate:(id)delegate resultSelector:(SEL)selector andDefaultsKey:(NSString*)key{
    if (_isDownloading){
        //NSLog(@"Already downloading");
        //[NSException raise:@"Attempt to start downloading a second URL before the first finished or failed" format:@"",nil];
        return NO;
    }
    _downloadDelegate = [delegate retain];
    _resultSelector = selector;
    _isDownloading = YES;
    _cachedData = [[NSMutableData  alloc] initWithLength:0];
    _defaultsKeyToSet = key;
    _placeToWrite = [[NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0 ] stringByAppendingPathComponent:[url lastPathComponent]]] retain];
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSError *err = nil;
    [fileMan removeItemAtURL:_placeToWrite error:&err];
    if (err != nil){
        NSLog(@"err: %@", [err description]);
    }
    //NSLog(@"URL: %@", [_placeToWrite absoluteString]);
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    if ([NSURLConnection canHandleRequest:theRequest]){
        //NSLog(@"Yeah we can handle that request");
    }
    else{
        //NSLog(@"That request is too scary");
        return NO;
    }
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    [connection start];
    [connection release];
    return YES;
}


-(NSDictionary*)levelWithName:(NSString*)levelName{
    
    NSString *pathToDefaultsPlist = [[NSBundle mainBundle] pathForResource:levelName ofType:@"level"];
    //NSLog(@"found: %@", pathToDefaultsPlist);
    NSDictionary *levelDefaults = [[NSDictionary alloc] initWithContentsOfFile:pathToDefaultsPlist];
    return [levelDefaults autorelease];
}
#pragma mark - URL loading 
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_cachedData appendData:data];
    //NSLog(@"Data");
}
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [connection release];
    //NSLog(@"%@", [error description]);
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
    //NSLog(@"writing %i bytes to %@", [_cachedData length], [_placeToWrite absoluteString]);
    
    NSError *err;
    if ([_cachedData writeToURL:_placeToWrite options:NSDataWritingFileProtectionComplete error:&err]){
        //NSLog(@"Write Succeeded!");
    }else{
        //NSLog(@"Write Failed: %@", [err description]);
        _placeToWrite = nil;
    }
    [_downloadDelegate performSelectorOnMainThread:_resultSelector withObject:_placeToWrite waitUntilDone:NO];
    [_downloadDelegate release];
    //[_downloadDelegate performSelector:_resultSelector withObject:_placeToWrite];
    NSMutableDictionary *_changeDict = [NSMutableDictionary dictionaryWithDictionary:plistDefaults];
    [_changeDict setValue:[_placeToWrite path] forKey:_defaultsKeyToSet];
    [plistDefaults release];
    plistDefaults = [_changeDict retain];
    [_placeToWrite release];
    [_cachedData release];
    //NSLog(@"Data Load completed");
    //NSLog(@"%@", plistDefaults);
    
}
@end
