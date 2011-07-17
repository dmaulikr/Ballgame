//
//  SettingsScene.h
//  BallGame
//
//  Created by Alexei Gousev on 12/2/09.
//  Copyright 2009 UC Davis. All rights reserved.
//


// When you import this file, you import all the cocos2d classes

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

// Settings Layer
@interface SettingsScene : Layer
{
	SettingsScene *gs;
}

// returns a Scene that contains the SettingsScene as the only child
+(id) scene;

-(void) onReturn:(id) sender;

@end