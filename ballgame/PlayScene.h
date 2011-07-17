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
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    
    NSDictionary *_levelInfo;
    NSMutableArray *_gameObjects;
    CGSize _bounds;
    
    Player *_thePlayer;
    
    NSDictionary *defaults;
    
    CCLayer *scrollNode;
    
    //Collision Info
    CollisionManager *_collisionManager;
    NSSet *_previousCollisions;
}

@property(nonatomic, retain) NSDictionary *defaults;

-(id)loadLevelWithName:(NSString*)levelName;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;


//Premade Levels
+(CCScene*)debugScene;

@end
