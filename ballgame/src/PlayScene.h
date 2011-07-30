//
//  PlayScene.h
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//  Copyright __myCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "GameObjects.h"
#import "AssetManager.h"
#import "CollisionManager.h"
// PlayScene

@interface PlayScene : CCLayer
{
    //Physics Data
	b2World* world;
    CollisionManager *_collisionManager;
    NSSet *_previousCollisions;
    
    //Debug Data
	GLESDebugDraw *m_debugDraw;
    
    //State Data
    NSDictionary *_levelInfo;
    NSMutableArray *_gameObjects;
    Player *_thePlayer;
    
    //Sublayers
    CCLayer *scrollNode;
    
}
-(id)loadLevelWithName:(NSString*)levelName;

//Premade Levels
+(CCScene*)debugScene;

@end
