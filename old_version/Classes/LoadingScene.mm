//
//  MainMenuScene.mm
//  BallGame
//
//  Created by Alexei Gousev on 12/2/09.
//  Copyright 2009 UC Davis. All rights reserved.
//

#include <stdlib.h>
#include "MainMenuScene.h"
#include "HelloWorldScene.h"
#include "LoadingScene.h"


@implementation Loading

@synthesize gs;

+(id) scene
{
	// 'scene' is an autorelease object.
	Scene *scene = [Scene node];
	
	// 'layer' is an autorelease object.
	Loading *layer = [Loading node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;	
}


-(id) init
{
	// initialize your instance here
	if( (self=[super init])) {
		
		Label *load = [Label labelWithString:@"Loading..." fontName:@"Times New Roman" fontSize:64];
		load.position = ccp(240,160);
		load.opacity = 200;
		[self addChild:load];
	}
	return self;
}


@end
