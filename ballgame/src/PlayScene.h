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
    
    //Sublayers
    CCLayer *scrollNode;
    
    //HUD
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
    
    // Set to true if scrollToX:Y: was called, but hasn't finished animating yet.
    bool scrollNodeAnimated;
    
    // Default is 1, > 1 means zoomed in, < 1 means zoomed out
    float currentZoomLevel;
    
}
-(id)loadLevelWithName:(NSString*)levelName;
-(void) showPauseMenu;

//Premade Levels
+(CCScene*) currentLevelScene;

// Scroll camera to given point in world coordinates
-(void) scrollToX:(int)x Y:(int)y withDuration:(ccTime)duration;

// Scroll camera back to player and re-enable camera tracking the player
-(void) scrollToPlayerWithDuration:(ccTime)duration;

// General method
-(void) zoomToScale:(float)zoom withDuration:(ccTime) duration;

// Utility methods
-(void) zoomToNormalWithDuration:(ccTime)duration;
-(void) zoomToFullLevelWithDuration:(ccTime)Duration;

@end
