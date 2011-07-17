
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#include "GameState.h"

// HelloWorld Layer
@interface HelloWorld : Layer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	TextureAtlas *textureAtlas;
	
	ParallaxNode *voidNode;
	AtlasSpriteManager *mgr;
	//AtlasSpriteManager *ballMgr;
	AtlasSprite *ballSprite;
	b2Fixture *currentFixture;
	
	b2Body *bodyToBeRemoved;
	
	int ballSizeIncrementer;
	double ballSize;
	
	int WORLD_SIZE;
	int screen_x;
	int screen_y;
	double ballSizeIncrement;
	double ballSizeBonus;
	
	GameState *gs;
	
	NSTimer *timer;
	
	AtlasSprite *pow2xSprite;
	AtlasSprite *powFlySprite;
}

@property(nonatomic) GameState *gs;
@property(nonatomic,retain) NSTimer *timer;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;


-(void) startGame;
-(void) addWall;
-(void) addCoin;
-(void) addPower2x;
-(void) addPowerFly;
-(void) resetScoreMultiplier:(id) sender;
-(void) resetFly:(id) sender;

-(void) onQuitGame: (id) sender;

@end
