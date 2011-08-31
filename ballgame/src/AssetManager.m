//
//  AssetManager.m
//  RaidLeader
//
//  Created by Ryan Hart on 7/4/11.
//  Copyright 2011 __myCompanyName__. All rights reserved.
//

#import "AssetManager.h"

NSString* const MainSpriteSheetPlistKey = @"SpriteSheetPlistName";
NSString* const MainSpriteSheetImageKey = @"SpriteSheetPngName";

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
        //HARDCODE
        NSString *pathToDefaultsPlist = [[NSBundle mainBundle] pathForResource:@"GameDefaults" ofType:@"plist"];
        plistDefaults = [[NSDictionary alloc] initWithContentsOfFile:pathToDefaultsPlist];
        _isDownloading = NO;
        
        //Take the name and plist and convert them to actual Documents Directory URLS
        NSMutableDictionary *_changeDict = [NSMutableDictionary dictionaryWithDictionary:plistDefaults];
        NSString *absolutePngPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/%@", [plistDefaults objectForKey:MainSpriteSheetImageKey], nil];
        NSString *absolutePlistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/%@", [plistDefaults objectForKey:MainSpriteSheetPlistKey], nil];
        [_changeDict setValue:absolutePlistPath forKey:MainSpriteSheetPlistKey];
        [_changeDict setValue:absolutePngPath forKey:MainSpriteSheetImageKey];
        [plistDefaults release];
        plistDefaults = [_changeDict retain];
    }
    
    return self;
}


+(NSArray*)allBundledLevels{
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSArray *pathsInBundle = [fileMan contentsOfDirectoryAtPath:[[NSBundle mainBundle] bundlePath] error:nil];
    NSMutableArray *levels = [NSMutableArray arrayWithCapacity:20];
    for (NSString *path in pathsInBundle){
        //HARDCODE - If we ever make our levels not end in .level this has to change
        if ([[path lastPathComponent] hasSuffix:@"level"]){
            
            //GROSS....I really wish the AssetManager didnt need to import the DataDefinitions.  This is why it does
            NSString *levelName = [[path lastPathComponent] stringByDeletingPathExtension];
            NSDictionary *level = [[AssetManager sharedInstance] levelWithName:levelName];
            if ([level valueForKey:LEVEL_NAME_KEY] == nil){
                level = [NSMutableDictionary dictionaryWithDictionary:level];
                [level setValue:levelName forKey:LEVEL_NAME_KEY];
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
    //HARDCODE
    NSString *pathToDefaultsPlist = [[NSBundle mainBundle] pathForResource:levelName ofType:@"level"];
    NSDictionary *levelDefaults = [[NSDictionary alloc] initWithContentsOfFile:pathToDefaultsPlist];
    return [levelDefaults autorelease];
}
#pragma mark - URL loading 
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_cachedData appendData:data];
}
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [connection release];
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
    
    NSError *err;
    if ([_cachedData writeToURL:_placeToWrite options:NSDataWritingFileProtectionComplete error:&err]){
        //Write succeeded
    }else{
        NSLog(@"Write Failed after loading: %@", [err description]);
        _placeToWrite = nil;
    }
    [_downloadDelegate performSelectorOnMainThread:_resultSelector withObject:_placeToWrite waitUntilDone:NO];
    [_downloadDelegate release];
    NSMutableDictionary *_changeDict = [NSMutableDictionary dictionaryWithDictionary:plistDefaults];
    [_changeDict setValue:[_placeToWrite path] forKey:_defaultsKeyToSet];
    [plistDefaults release];
    plistDefaults = [_changeDict retain];
    [_placeToWrite release];
    [_cachedData release];
}

+(bool) settingsMusicOn
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs boolForKey:@"soundMusicOn"];
}

+(bool) settingsEffectsOn
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs boolForKey:@"soundEffectsOn"];
}

@end
