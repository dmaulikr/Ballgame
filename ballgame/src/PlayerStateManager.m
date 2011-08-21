//
//  GameStateManager.m
//  ballgame
//
//  Created by Ryan Hart on 7/30/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "PlayerStateManager.h"

@implementation PlayerStateManager

@synthesize currentLevelIndex=_currentLevelIndex;

#pragma mark - Singleton stuff
static PlayerStateManager* sharedManager = nil;

+(id)sharedInstance
{
	@synchronized([PlayerStateManager class]){
		if (sharedManager == nil){
            sharedManager = [[self alloc] init];
		}
	}
	return sharedManager;
}

+(id)alloc
{
	@synchronized([PlayerStateManager class])
	{
		NSAssert(sharedManager == nil, @"Attempted to allocate a second instance of a singleton.");
		sharedManager = [super alloc];
		return sharedManager;
	}
	
	return nil;
}

#pragma mark -Methods

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _currentLevelIndex = 0;
    }
    
    return self;
}

+(NSDictionary*)currentLevel{
    return [[AssetManager allBundledLevels] objectAtIndex:[[PlayerStateManager sharedInstance] currentLevelIndex]];
}

@end
