//
//  GameStateManager.h
//  ballgame
//
//  Created by Ryan Hart on 7/30/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssetManager.h"

@interface GameStateManager : NSObject{
    //Index into the current list of levels supplied by the asset manager
    NSInteger _currentLevelIndex;
}
@property (readwrite) NSInteger currentLevelIndex;

+(id)sharedInstance;
+(NSDictionary*)currentLevel;
@end
