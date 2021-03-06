//
//  AssetManager.h
//  RaidLeader
//
//  Created by Ryan Hart on 7/4/11.
//  Copyright 2011 __myCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataDefinitions.h"

extern NSString* const MainSpriteSheetPlistKey;
extern NSString* const MainSpriteSheetImageKey;

@interface AssetManager : NSObject {
    NSDictionary *plistDefaults;
    
    //AssetDownloading
    NSMutableData *_cachedData;
    NSURL *_placeToWrite;
    BOOL _isDownloading;
    id _downloadDelegate;
    SEL _resultSelector;
    NSString *_defaultsKeyToSet;
}

@property(nonatomic, retain) NSDictionary *plistDefaults;

+(id)sharedInstance;
+(id)alloc;
+(NSDictionary*)defaults;
+(NSArray*)allBundledLevels;

//Returns NO if it can't
-(BOOL)cacheResourceFromURL:(NSURL*)url withDelegate:(id)delegate resultSelector:(SEL)selector andDefaultsKey:(NSString*)key;
-(NSDictionary*) getDefaults;
-(NSDictionary*)levelWithName:(NSString*)levelName;

// Settings utility functions.  These might be better suited in their own class, but I don't care enough.
+(bool) settingsMusicOn;
+(bool) settingsEffectsOn;

@end
