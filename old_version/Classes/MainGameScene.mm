
// ToDo:  Scrolling if off screen
// ToDo:  enable touch movement
// ToDo:  wall rotation
// ToDo:  create goal object


//
// Demo of calling integrating Box2D physics engine with cocos2d AtlasSprites
// a cocos2d example
// http://code.google.com/p/cocos2d-iphone
//
// by Steve Oldmeadow
//

#include <stdlib.h>
#include <GameVariables.h>

// Import the interfaces
#import "MainGameScene.h"
#import "MainMenuScene.h"
#import "GameOverScene.h"
#import "LoadingScene.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagSpriteManager = 1,
	kTagAnimation1 = 1,
};

enum {
	kTagSprite1,
	kTagSprite2,
	kTagSprite3,
	kTagSprite4,
	kTagSprite5,
	kTagSprite6,
	kTagSprite7,
	kTagSprite8,
};


@interface HelloWorld ()

-(b2Body*) getBallObject;

@end

// HelloWorld implementation
@implementation HelloWorld

@synthesize gs;
@synthesize timer;


//TODO: Settings File
int sizeOfCoin = 36;
double scaleOfCoin = .5;
int sizeOfPower2x = 24;
int sizeOfPowerFly = 54;

+(id) scene
{
	// 'scene' is an autorelease object.
	Scene *scene = [Scene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
	
	
}

// initialize your instance here
-(id) init
{
	if( (self=[super init])) {
		
	}

	[self startGame];	
	
	return self;
}

-(void) startGame
{
		
	bodyToBeRemoved = NULL;
	
	WORLD_SIZE = 3000;
	
	screen_x = 0;
	screen_y = 0;

	
	// enable touches
	self.isTouchEnabled = YES;
	
	// enable accelerometer
	self.isAccelerometerEnabled = YES;
	
	CGSize screenSize = [Director sharedDirector].winSize;
	CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
	
	// Define the gravity vector.
	b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f);
	
	// Do we want to let bodies sleep?
	// This will speed up the physics simulation
	bool doSleep = false;
	
	// Construct a world object, which will hold and simulate the rigid bodies.
	world = new b2World(gravity,doSleep);
	
	world->SetContinuousPhysics(true);
	
	// Debug Draw functions
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2DebugDraw::e_shapeBit;
	flags += b2DebugDraw::e_jointBit;
	flags+= b2DebugDraw::e_aabbBit;
	flags += b2DebugDraw::e_pairBit;
	flags += b2DebugDraw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner

	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2PolygonShape groundBox;		
	
	
	// bottom
	groundBox.SetAsEdge(b2Vec2(-WORLD_SIZE/2/PTM_RATIO,-WORLD_SIZE/2/PTM_RATIO), b2Vec2(WORLD_SIZE/2/PTM_RATIO,-WORLD_SIZE/2/PTM_RATIO));
	groundBody->CreateFixture(&groundBox);
	
	// top
	groundBox.SetAsEdge(b2Vec2(-WORLD_SIZE/2/PTM_RATIO,WORLD_SIZE/2/PTM_RATIO), b2Vec2(WORLD_SIZE/2/PTM_RATIO,WORLD_SIZE/2/PTM_RATIO));
	groundBody->CreateFixture(&groundBox);
	
	// left
	groundBox.SetAsEdge(b2Vec2(-WORLD_SIZE/2/PTM_RATIO,WORLD_SIZE/2/PTM_RATIO), b2Vec2(-WORLD_SIZE/2/PTM_RATIO,-WORLD_SIZE/2/PTM_RATIO));
	groundBody->CreateFixture(&groundBox);
	
	// right
	groundBox.SetAsEdge(b2Vec2(WORLD_SIZE/2/PTM_RATIO,WORLD_SIZE/2/PTM_RATIO), b2Vec2(WORLD_SIZE/2/PTM_RATIO,-WORLD_SIZE/2/PTM_RATIO));
	groundBody->CreateFixture(&groundBox);

	//Set up sprite
	
	mgr = [AtlasSpriteManager spriteManagerWithFile:@"textures.gif" capacity:1500];
	//[self addChild:mgr z:0 tag:kTagSpriteManager];
	
	voidNode = [ParallaxNode node];
	[voidNode addChild:mgr z:1 parallaxRatio:ccp(1.0f,1.0f) positionOffset:CGPointZero];

	
	[self addNewSpriteWithCoords:ccp(screenSize.width/2,screenSize.height/2)];

	[self schedule: @selector(tick:)];
	
	NSLog(@"starting walls");
	// add walls to map
	//mgr = [AtlasSpriteManager spriteManagerWithFile:@"blue_texture.png" capacity:150];
	int NUM_WALLS = 650;
	for(int i = 0; i < NUM_WALLS; i++) [self addWall];
	NSLog(@"Done with walls");
	
	int NUM_COINS = 250;
	for(int i = 0; i < NUM_COINS; i++) [self addCoin];
	NSLog(@"Done loading coins...");
	
	int NUM_POW_2X = 15;
	for(int i = 0; i < NUM_POW_2X; i++) [self addPower2x];
	NSLog(@"Done loading 2x powers...");
	
	int NUM_POW_FLY = 5;
	for(int i = 0; i < NUM_POW_FLY; i++) [self addPowerFly];	
	NSLog(@"Done loading fly powers...");
	
	
	
	// background texture
	CGSize winSize = [Director sharedDirector].winSize;
	int NUM_TILES = 5;
	int IMAGE_SIZE = 512 - 0; // -5 so tiles overlap slightly
	for(int i = 0; i < NUM_TILES; i++)
		for(int j = 0; j < NUM_TILES; j++)
		{
			Sprite *background = [Sprite spriteWithFile:@"paper_bg.jpg"];
			background.position = ccp(IMAGE_SIZE*i+winSize.width/2,IMAGE_SIZE*j+winSize.height/2);
			[self addChild:background z:-1]; // UNCOMMENT THIS ONE TO RENEW BACKGROUND
			
			//[voidNode addChild:background z:-1 parallaxRatio:ccp(0.1f,0.1f) positionOffset:CGPointZero];
		}
	
	
	// info bar texture
	//CGSize winSize = [Director sharedDirector].winSize;
	//int NUM_TILES = 1;
	IMAGE_SIZE = 480 - 0; // -5 so tiles overlap slightly
	for(int i = 0; i < NUM_TILES; i++)
		for(int j = 0; j < NUM_TILES; j++)
		{
			Sprite *background = [Sprite spriteWithFile:@"dark_texture.png"];
			background.position = ccp(IMAGE_SIZE*i+winSize.width/2,winSize.height-48);
			[self addChild:background z:10]; // UNCOMMENT THIS ONE TO RENEW BACKGROUND
			
			//[voidNode addChild:background z:-1 parallaxRatio:ccp(0.1f,0.1f) positionOffset:CGPointZero];
		}
	
	
	 
	[self addChild:voidNode];
	//[voidNode setPosition:ccp(-winSize.width/2/PTM_RATIO,-winSize.height/2/PTM_RATIO)];

	
	self.gs = gs->sharedGameStateInstance();
	self.gs->score = 0;
	
	// Difficulty and sound settings
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	self.gs->difficulty = [settings integerForKey:@"Difficulty"];
	
    
    //TODO: Remove - This is unnecessary 
	switch(gs->difficulty)
	{
		case 0:
			ballSizeIncrement = 0.08;
			ballSizeBonus = 0.11;
			break;
		case 1:
			ballSizeIncrement = 0.10;
			ballSizeBonus = 0.10;
			break;
		case 2:
			ballSizeIncrement = 0.14;
			ballSizeBonus = 0.15;
			break;			
		case 3:
			ballSizeIncrement = 0.25;
			ballSizeBonus = 0.20;
			break;
	}

			
			
	// Score display label
	Label *label1 = [Label labelWithString:@"Score:0" fontName:@"Marker Felt" fontSize:24];
	[self addChild:label1 z:12 tag:kTagSprite7];
	label1.position = ccp(420,307);
	label1.opacity = 200;
	[label1  setRGB:133 :133 :133];
	
	/*
	// Ball size display label
	Label *label2 = [Label labelWithString:@"Size:1.0" fontName:@"Times New Roman" fontSize:24];
	[self addChild:label2 z:12 tag:kTagSprite4];
	label2.position = ccp(280,307);
	label2.opacity = 200;
	 */
	
	// Pow2x display label
	Label *label2x = [Label labelWithString:@"2x points!" fontName:@"Marker Felt" fontSize:18];
	[self addChild:label2x z:12 tag:48];
	label2x.position = ccp(40,307);
	label2x.opacity = 200;
	label2x.visible = false;
	[label2x  setRGB:133 :133 :133];

	// PowFly display label
	Label *labelFly = [Label labelWithString:@"Flying!" fontName:@"Marker Felt" fontSize:18];
	[self addChild:labelFly z:12 tag:49];
	labelFly.position = ccp(120,307);
	labelFly.opacity = 200;
	labelFly.visible = false;
	[labelFly  setRGB:133 :133 :133];
		
	// restart game button
	BitmapFontAtlas *quitLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Quit Game" fntFile:@"bitmapFontTest3.fnt"];
	MenuItemLabel *item1 = [MenuItemLabel itemWithLabel:quitLabel target:self selector:@selector(onQuitGame:)];
	[item1 setScale:.85];
	
	Menu *menu = [Menu menuWithItems: item1, nil];
	[menu alignItemsVertically];
	menu.position = ccp(250,307);
	menu.opacity = 255;
	
	[self addChild: menu z:12];	
	
	// pointer used to remove coins once they're picked up
	self.gs->setBodyPtr(bodyToBeRemoved);
	
	

	 
	
}
-(void) draw
{
	[super draw];
	// DEBUG
	//glEnableClientState(GL_VERTEX_ARRAY);
	//world->DrawDebugData();
	//glDisableClientState(GL_VERTEX_ARRAY);


	//NSLog([NSString stringWithFormat:@"%i",gs->score]);
	
}

-(void) addCoin
{
	
	CGSize screenSize = [Director sharedDirector].winSize;
	CGPoint p;
	int xValue = arc4random() % WORLD_SIZE;
	int yValue = arc4random() % WORLD_SIZE;

	
	//NSLog(@"%d, %d",xValue,yValue);
	p.x = xValue - WORLD_SIZE/2;
	p.y = yValue - WORLD_SIZE/2;
	
	float WALL_width = .1;
	float wall_length = .1;
	
	AtlasSprite *sprite = [AtlasSprite spriteWithRect:CGRectMake(527-sizeOfCoin,0,sizeOfCoin,sizeOfCoin) spriteManager:mgr];
	//AtlasSprite *sprite = [Sprite spriteWithFile:@"stone_bg2.gif"];
	[mgr addChild:sprite];
	[sprite setScale:.67];
	
	
	sprite.position = ccp( p.x, p.y);
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	body->PutToSleep();
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	
	dynamicBox.SetAsBox(WALL_width * .67,wall_length * .67);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 0.0f;
	fixtureDef.friction = 314.0f;
	body->CreateFixture(&fixtureDef);	
}

-(void) addPowerFly
{
	
	CGSize screenSize = [Director sharedDirector].winSize;
	CGPoint p;
	int xValue = arc4random() % WORLD_SIZE;
	int yValue = arc4random() % WORLD_SIZE;
	
	
	//NSLog(@"%d, %d",xValue,yValue);
	p.x = xValue - WORLD_SIZE/2;
	p.y = yValue - WORLD_SIZE/2;
	
	float WALL_width = .1;
	float wall_length = .1;
	
	AtlasSprite *sprite = [AtlasSprite spriteWithRect:CGRectMake(sizeOfPower2x*3/2+2 ,527-sizeOfPowerFly,sizeOfPowerFly,sizeOfPowerFly) spriteManager:mgr];
	//AtlasSprite *sprite = [Sprite spriteWithFile:@"stone_bg2.gif"];
	[mgr addChild:sprite];
	
	sprite.position = ccp( p.x, p.y);
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	body->PutToSleep();
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	
	dynamicBox.SetAsBox(WALL_width,wall_length);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 0.0f;
	fixtureDef.friction = 317.0f;
	body->CreateFixture(&fixtureDef);	
}

-(void) addPower2x
{
	
	CGSize screenSize = [Director sharedDirector].winSize;
	CGPoint p;
	int xValue = arc4random() % WORLD_SIZE;
	int yValue = arc4random() % WORLD_SIZE;
	
	
	//NSLog(@"%d, %d",xValue,yValue);
	p.x = xValue - WORLD_SIZE/2;
	p.y = yValue - WORLD_SIZE/2;
	
	float WALL_width = .1;
	float wall_length = .1;
	
	AtlasSprite *sprite = [AtlasSprite spriteWithRect:CGRectMake(0,527-sizeOfPower2x*3/2,sizeOfPower2x*3/2,sizeOfPower2x*3/2) spriteManager:mgr];
	//AtlasSprite *sprite = [Sprite spriteWithFile:@"stone_bg2.gif"];
	[mgr addChild:sprite];
	[sprite setScale:.67];
	
	sprite.position = ccp( p.x, p.y);
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	body->PutToSleep();
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	
	dynamicBox.SetAsBox(WALL_width,wall_length);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 0.0f;
	fixtureDef.friction = 319.0f;
	body->CreateFixture(&fixtureDef);	
}

-(void) addWall
{
	CGSize screenSize = [Director sharedDirector].winSize;
	CGPoint p;
	int xValue = arc4random() % WORLD_SIZE;
	int yValue = arc4random() % WORLD_SIZE;
	//NSLog(@"%d, %d",xValue,yValue);
	p.x = xValue - WORLD_SIZE/2;
	p.y = yValue - WORLD_SIZE/2;
	
	float WALL_width = .2;
	float WALL_length_min = .3;
	float WALL_length_max = 4.3;
	
	bool HorVer = arc4random() % 2;  // whether wall is horizontal or vertical;
	
	float wall_length = (float)(arc4random() % (int)((WALL_length_max - WALL_length_min)*10)) / 10 + WALL_length_min;
	if(HorVer) { // if horizontal, swap length and width
		float temp = WALL_width;
		WALL_width = wall_length;
		wall_length = temp;
	}
		
	//NSLog(@"Adding wall: %1.2f, %1.2f : Length: %1.2f",p.x,p.y,wall_length);
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
	int idx = (CCRANDOM_0_1() * 128);
	int idy = (CCRANDOM_0_1() * 128);

	AtlasSprite *sprite = [AtlasSprite spriteWithRect:CGRectMake(idx,idy,WALL_width * PTM_RATIO*2,wall_length * PTM_RATIO*2) spriteManager:mgr];
	//AtlasSprite *sprite = [Sprite spriteWithFile:@"stone_bg2.gif"];
	[mgr addChild:sprite];
	
	
	
	sprite.position = ccp( p.x, p.y);
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	body->PutToSleep();
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	
	dynamicBox.SetAsBox(WALL_width,wall_length);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 0.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
	 
}


-(void) addNewSpriteWithCoords:(CGPoint)p
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	//AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:kTagSpriteManager];
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
	ballSizeIncrementer = 0;
	ballSize = 1;
	
	//AtlasSpriteManager *ballMgr = [AtlasSpriteManager spriteManagerWithFile:@"stone_bg2.gif" capacity:150];
	ballSprite = [AtlasSprite spriteWithRect:CGRectMake(527-84,527-84,84,84) spriteManager:mgr];
	[ballSprite setScale:(32.0 / 84.0)];
	[mgr addChild:ballSprite];
	
	
	ballSprite.position = ccp( p.x, p.y);
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = ballSprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
	
	b2CircleShape dynamicCircle;
	dynamicCircle.m_radius = 0.5f / (84.0 / 76.0);

	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicCircle;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.314f;
	currentFixture = body->CreateFixture(&fixtureDef);
	

}



-(void) tick: (ccTime) dt
{
	
	b2Body* ball = [self getBallObject];
	
	// remove coin if necessary
	if(bodyToBeRemoved)
	{
		
		double friction = bodyToBeRemoved->GetFixtureList()->GetFriction();
		bool pow_2x = false;
		bool pow_fly = false;
		if(friction > 318.5 && friction < 319.5) pow_2x = true;
		else if(friction > 316.5 && friction < 317.5) pow_fly = true;
		
		AtlasSprite *sprite = (AtlasSprite*)bodyToBeRemoved->GetUserData();
		
		int spriteCenterX = sizeOfCoin/2 + sprite.quad.bl.vertices.x;
		int spriteCenterY = sizeOfCoin/2 + sprite.quad.bl.vertices.y;
		
		if(pow_2x)
		{
			spriteCenterX = sizeOfPower2x/2 + sprite.quad.bl.vertices.x;
			spriteCenterY = sizeOfPower2x/2 + sprite.quad.bl.vertices.y;
		}
		else if(pow_fly)
		{
			spriteCenterX = sizeOfPowerFly/2 + sprite.quad.bl.vertices.x;
			spriteCenterY = sizeOfPowerFly/2 + sprite.quad.bl.vertices.y;
		}
		
		
		int ballCenterX = (ballSprite.quad.tr.vertices.x + ballSprite.quad.bl.vertices.x) / 2;
		int ballCenterY = (ballSprite.quad.tr.vertices.y + ballSprite.quad.bl.vertices.y) / 2;
		
		double radiusBall = sqrt((ballSprite.quad.bl.vertices.x-ballSprite.quad.tr.vertices.x)*(ballSprite.quad.bl.vertices.x-ballSprite.quad.tr.vertices.x)+(ballSprite.quad.bl.vertices.y-ballSprite.quad.tr.vertices.y)*(ballSprite.quad.bl.vertices.y-ballSprite.quad.tr.vertices.y)) / sqrt(2.0) / 2;
		double minDistance = sizeOfCoin/2 + radiusBall;
		if(pow_2x) minDistance = sizeOfPower2x/2 + radiusBall;
		else if(pow_fly) minDistance = sizeOfPowerFly/2 + radiusBall;
		
		double actualDistance = sqrt((ballCenterX-spriteCenterX)*(ballCenterX-spriteCenterX) + (ballCenterY-spriteCenterY)*(ballCenterY-spriteCenterY));
		
		//NSLog(@"About to remove?");
		
		if(actualDistance <= minDistance)
		{
			//NSLog(@"Yup, removing!");
			
			bodyToBeRemoved->SetUserData(NULL);
			[mgr removeChild:sprite cleanup:TRUE];
			world->DestroyBody(bodyToBeRemoved);
			
			if(!pow_2x && !pow_fly)
			{
				ballSize -= ballSizeBonus;
				if(ballSize <= 0.7f) ballSize = 0.7f;
				NSLog(@"%1.2f", ballSize);
				gs->score += (gs->scoreMultiplier * 10);
			}
			else if(pow_2x)// power 2x
			{
				gs->scoreMultiplier = 2;
				[self schedule:@selector(resetScoreMultiplier:) interval:10.0];
				((LabelAtlas*) [self getChildByTag:48]).visible = true;
			}
			else // pow_fly
			{
				gs->fly = true;
				[self schedule:@selector(resetFly:) interval:3.0];
				((LabelAtlas*) [self getChildByTag:49]).visible = true;
			}
			
			
			NSString *str = [NSString stringWithFormat:@"Score:%i",gs->score];
			LabelAtlas *label1 = (LabelAtlas*) [self getChildByTag:kTagSprite7];
			[label1 setString:str];
			
		}
		
		bodyToBeRemoved = NULL;

		
	}
	
	
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			AtlasSprite* myActor = (AtlasSprite*)b->GetUserData();
			if(myActor.tag == 56) continue;
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}
	}
	
	
	// LIMIT MAX VELOCITY
	b2Vec2 velocity = ball->GetLinearVelocity();
	double speed = sqrt(velocity.x*velocity.x + velocity.y*velocity.y);
	if(speed > 13)
	{
		velocity.x = velocity.x / (speed/13);
		velocity.y = velocity.y / (speed/13);
		ball->SetLinearVelocity(velocity);
	}
	
	
	// HANDLE BALL GOING OFF SCREEN
	CGPoint currentPos = [voidNode position];
	//[voidNode setPosition: ccpAdd(currentPos, ccp(1,1))];

	b2Vec2 position = ball->GetWorldCenter();
	
	//NSLog(@"%1.2f, %1.2f",position.x, position.y);
	
	CGSize winSize = [Director sharedDirector].winSize;
	// if ball moved off the edge
	if(position.x < -currentPos.x/PTM_RATIO+3 && position.x > (-WORLD_SIZE/2 / 32) + 3.05 && velocity.x < 0){
		CGPoint currentPos = [voidNode position];
		[voidNode setPosition: ccpAdd(currentPos, ccp(-36*velocity.x*dt,0))];
	}
	if(position.x > (-currentPos.x+winSize.width)/PTM_RATIO-3 && position.x < (WORLD_SIZE/2 / 32) - 3.00 && velocity.x > 0){
		CGPoint currentPos = [voidNode position];
		[voidNode setPosition: ccpAdd(currentPos, ccp(-36*velocity.x*dt,0))];
	}
	if(position.y < -currentPos.y/PTM_RATIO+3 && position.y > (-WORLD_SIZE/2 / 32) + 3.05 && velocity.y < 0){
		CGPoint currentPos = [voidNode position];
		[voidNode setPosition: ccpAdd(currentPos, ccp(0,-36*velocity.y*dt))];
	}
	if(position.y > (-currentPos.y+winSize.height)/PTM_RATIO-3 && position.y < (WORLD_SIZE/2 / 32) - 2.00 && velocity.y > 0){
		CGPoint currentPos = [voidNode position];
		[voidNode setPosition: ccpAdd(currentPos, ccp(0,-36*velocity.y*dt))];
	}
	

	
	
	// increase size of ball if necessary
	ballSize += (ballSizeIncrement * dt);
	if(ballSize > 3) [[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:1 scene:[GameOver scene]]]; // game over
	[ballSprite setScale:(ballSize*32.0/84.0)];
	
	NSString *str = [NSString stringWithFormat:@"Size:%1.1f",ballSize];
	LabelAtlas *label2 = (LabelAtlas*) [self getChildByTag:kTagSprite4];
	[label2 setString:str];
	
	// Deal with bigger bounding box
	
	// Define another box shape for our dynamic body.
	b2CircleShape dynamicCircle;
	dynamicCircle.m_radius = ballSize / 2.0 / (84.0 / 76.0);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicCircle;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.314f;
	ball->DestroyFixture(currentFixture);
	currentFixture = ball->CreateFixture(&fixtureDef);
	
	//NSLog(@"%1.2f, %1.2f",position.x,position.y);
}



- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
		
		CGPoint currentPos = [voidNode position];
		CGPoint point = [touch locationInView:[touch view]];
		
		float pointX = point.x - currentPos.y;
		float pointY = point.y - currentPos.x;
		
		//NSLog(@"%1.2f, %1.2f, %1.2f, %1.2f",point.x,point.y,currentPos.x,currentPos.y);
		
		CGSize screenSize = [Director sharedDirector].winSize;
		
		double vConst = .05;  // multiplier
		
		b2Body* b = [self getBallObject];
		float objectX = b->GetPosition().x*PTM_RATIO;
		float objectY = b->GetPosition().y*PTM_RATIO;
		
		float accelX = vConst*(pointX-objectY);
		float accelY = vConst*(pointY-objectX);
		
		//NSLog([NSString stringWithFormat:@"%1.2f, %1.2f : %1.2f, %1.2f",objectX,objectY,point.x,point.y]);
		
		b2Vec2 v(accelY, accelX);		
		b->SetLinearVelocity(v);
	}
	
	return kEventHandled;
	
}
 

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	// set velocity of ball to 0
	b2Vec2 v(0, 0);
	b2Body* b = [self getBallObject];
	b->SetLinearVelocity(v);
	
	return kEventHandled;
}


- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// acceleromete r values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity( -accelY * 35, accelX * 35);
	
	world->SetGravity( gravity );
	
}

//TODO: Make this nastiness go away when we implement the Player class.
// returns second to last object in the world, in this case the ball (which is inserted into the world first)
-(b2Body*) getBallObject
{
	b2Body* b = world->GetBodyList();
	b2Body* next = b->GetNext();
	
	while(next != NULL){
		next = next->GetNext();
		if(next != NULL) b = b->GetNext();
	}
	
	return b;
}

-(void) resetScoreMultiplier:(id) sender
{
	gs->scoreMultiplier = 1;
	[self unschedule:@selector(resetScoreMultiplier:)];
	((LabelAtlas*) [self getChildByTag:48]).visible = false;
	
}

-(void) resetFly:(id) sender
{
	gs->fly = false;
	[self unschedule:@selector(resetFly:)];
	((LabelAtlas*) [self getChildByTag:49]).visible = false;
}

-(void) onQuitGame: (id) sender
{
	[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:1 scene:[GameOver sceneIntentional]]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
