//
//  AssetManager.h
//  RaidLeader
//
//  Created by Ryan Hart on 7/4/11.
//  Copyright 2011 __myCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


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

//Returns NO if it can't
-(BOOL)cacheResourceFromURL:(NSURL*)url withDelegate:(id)delegate resultSelector:(SEL)selector andDefaultsKey:(NSString*)key;
-(NSDictionary*) getDefaults;
-(NSDictionary*)levelWithName:(NSString*)levelName;
@end
