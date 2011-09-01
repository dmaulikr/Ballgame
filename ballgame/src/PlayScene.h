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
#import "PlayerStateManager.h"
#import "CollisionManager.h"
#import "SplashScene.h"
#import "SimpleAudioEngine.h"
#import "GameStateManager.h"
#import "SceneCamera.h"

// PlayScene

@interface PlayScene : CCLayer <GameStateManagerDelegate>
{
    //Physics Data
	b2World* world;
    CollisionManager *_collisionManager;
    NSSet *_previousCollisions;
    
    //Debug Data
	GLESDebugDraw *m_debugDraw;
    
    //State Data
    GameStateManager *_gsm;
    NSDictionary *_levelInfo;
    NSMutableArray *_gameObjects;
    Player *_thePlayer;
    
    //HUD
    SceneCamera *_camera;
    CCLayer *_hudLayer;
    CCLabelTTF *_userMessageLabel;
    
    // Pausing
    CCLayer *pauseLayer;
    CCSprite *_pauseScreen;
    CCMenu *_pauseScreenMenu;
    bool gameIsPaused;
    
    // Accel offset on startup
    bool firstAccel;
    float accelAngle;
    
}
-(id)loadLevelWithName:(NSString*)levelName;
-(void) showPauseMenu;

//Premade Levels
+(CCScene*) currentLevelScene;





@end
