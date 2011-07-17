//
//  LoadingScene.h
//  BallGame
//
//  Created by Alexei Gousev on 12/2/09.
//  Copyright 2009 UC Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#include "GameState.h"


// Loading Layer
@interface Loading: Layer
{
	GameState *gs;
}

@property(nonatomic) GameState *gs;

// returns a Scene that contains the Loading as the only child
+(id) scene;

@end
