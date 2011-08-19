//
//  SettingsScene.h
//  ballgame
//
//  Created by Ryan Hart on 7/17/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "DataDefinitions.h"


@interface SettingsScene : CCLayerColor {
    
    // Menu items.  These are stored here because they need to be accessed by updateMenu()
    CCMenuItemLabel *_musicItem;
    CCMenuItemLabel *_effectsItem;
    CCMenuItemLabel *_backItem;
}
+(CCScene *) scene;
-(void)loadScene;

// Menu items
-(void)musicTapped:(id)sender;
-(void)effectsTapped:(id)sender;
-(void)backTapped:(id)sender;

// Updates menu display based on new settings
-(void) updateMenu;

-(void) startBackgroundMusic;
-(void) stopBackgroundMusic;

@end
