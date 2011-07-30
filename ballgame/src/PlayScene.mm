//
//  PlayScene.mm
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//  Copyright __myCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "PlayScene.h"
#import "DataDefinitions.h"
#import "GameOverScene.h"

#define DEBUG_DRAW 0
// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

@interface PlayScene ()

-(Player*) addPlayer;
-(id)addGameObject:(NSDictionary *)gameObject;
-(void)processCollisionSet:(NSSet*)collisionSet withTime:(ccTime)dt;
@end

// HelloWorldLayer implementation
@implementation PlayScene


#pragma mark - Init
-(id)loadCurrentLevel{
    return [self loadLevelWithName:[[GameStateManager currentLevel] valueForKey:@"name"]];
}


-(id)loadLevelWithName:(NSString *)levelName{
    _levelInfo = [[[AssetManager sharedInstance]levelWithName:levelName] retain];
    [_levelInfo setValue:[NSNumber numberWithInt:LevelStatusStarted] forKey:@"LevelStatus"];
    _collisionManager = [[CollisionManager alloc] init];
    _previousCollisions = [[NSSet alloc] initWithObjects:nil];
    _gameObjects = [[NSMutableArray arrayWithCapacity:50] retain];
#pragma mark Layer Settings
    
#pragma mark Game World Settings
    // enable touches
    self.isTouchEnabled = YES;
    
    // enable accelerometer
    self.isAccelerometerEnabled = YES;
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
    
    // Define the gravity vector.
    b2Vec2 gravity;
    gravity.Set(0.0f, 0.0f);
    
    // Do we want to let bodies sleep?
    // This will speed up the physics simulation
    bool doSleep = false;
    
    // Construct a world object, which will hold and simulate the rigid bodies.
    world = new b2World(gravity, doSleep);
    
    world->SetContinuousPhysics(true);
    
    // Debug Draw functions
    m_debugDraw = new GLESDebugDraw( PTM_RATIO );
    world->SetDebugDraw(m_debugDraw);
    
    uint32 flags = 0;
    flags += b2DebugDraw::e_shapeBit;
    //		flags += b2DebugDraw::e_jointBit;
    //		flags += b2DebugDraw::e_aabbBit;
    //		flags += b2DebugDraw::e_pairBit;
    //		flags += b2DebugDraw::e_centerOfMassBit;
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
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2([[_levelInfo valueForKey:@"level_width"] floatValue] / PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // top
    groundBox.SetAsEdge(b2Vec2(0,[[_levelInfo valueForKey:@"level_height"] floatValue] / PTM_RATIO), b2Vec2([[_levelInfo valueForKey:@"level_width"] floatValue] / PTM_RATIO,[[_levelInfo valueForKey:@"level_height"] floatValue] / PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    
    
     
    // left
    groundBox.SetAsEdge(b2Vec2(0,[[_levelInfo valueForKey:@"level_height"] floatValue] / PTM_RATIO), b2Vec2(0,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // right
    groundBox.SetAsEdge(b2Vec2([[_levelInfo valueForKey:@"level_width"] floatValue] / PTM_RATIO, 0), b2Vec2([[_levelInfo valueForKey:@"level_width"] floatValue] / PTM_RATIO,[[_levelInfo valueForKey:@"level_height"] floatValue] / PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    
    
    
#pragma mark Game Object Initialization
    

    
    //Initialize the Sprite Sheet
    NSLog(@"Purging and removing");
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    NSURL *fileURL = [NSURL fileURLWithPath:[[AssetManager defaults] valueForKey:@"SpriteSheetPngName"]];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[fileURL path]];
    CCTexture2D *spriteSheetTexture = [[CCTexture2D alloc] initWithImage:image];
    [image release];
    CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithTexture:spriteSheetTexture  capacity:150]; 
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[[AssetManager defaults] valueForKey:@"SpriteSheetPlistName"]];
    
    // Initialize the scrolling layer
    // This layer is in between the main game layer (this class) and the sprite layer, and makes it easy to scroll through the level
    scrollNode = [CCLayer node];
    [scrollNode setPosition:CGPointMake(-[[_levelInfo valueForKey:@"start_x"] floatValue] + screenSize.width/2 , -[[_levelInfo valueForKey:@"start_y"] floatValue] + screenSize.height/2  )];
    [scrollNode addChild:batch];
	//[scrollNode addChild:batch z:0 parallaxRatio:ccp(1.0f,1.0f) positionOffset:CGPointZero];
    [scrollNode setTag:kTagBatchNode];
    [self addChild:scrollNode];
    
    //Add the game Objects
    _thePlayer = [self addPlayer];
    
    for (NSDictionary *game_object in [_levelInfo objectForKey:@"game_objects"]){
        NSLog(@"Adding an object");
        [self addGameObject:game_object];
    }
    
    //Now we need to resolve any dependencies any objects might have on other game objects in the world
    for (GameObject *game_object in _gameObjects){
        if ([game_object conformsToProtocol:@protocol(DependantObject)]){
            //Find his dependant object and set it
            GameObject <DependantObject>* depObject = game_object;
            for (GameObject *searchObject in _gameObjects){
                if ([[searchObject name] isEqualToString:[depObject getDependantObjectName]]){
                    NSLog(@"Found our dependant object");
                    [depObject setDependantObject:searchObject];
                    break;
                }
            }
        }
    }
    
    [_collisionManager subscribeCollisionManagerToWorld:world];
    
    
#pragma mark Initialize the game loop
    [self schedule: @selector(update:)];

    return self;
}

#pragma mark - Level Creation

-(Player*)addPlayer
{
	CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
	
	//CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(32 * idx,32 * idy,32,32)];
    Player *player = [Player spriteWithSpriteFrameName:@"player_amoeba.png"];

    
    
	[batch addChild:player z:PLAYER_Z_ORDER];
    [player setLevelInfo:_levelInfo];
    [player setupGameObject:nil forWorld:world];
	
    return player;
}

-(id)addGameObject:(NSDictionary *)gameObject{
    CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
    
    NSString *type = [gameObject objectForKey:@"type"];
    NSString *frameName = [gameObject objectForKey:@"frame_name"];
    
    GameObject* object = [NSClassFromString(type) spriteWithSpriteFrameName:frameName];
    [batch addChild:object];
    [object setupGameObject:gameObject forWorld:world];
    
    [_gameObjects addObject:object];
    return nil;
}




#pragma mark - Premade Scenes
+(CCScene*)currentLevelScene{
    CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayScene *layer = [[PlayScene alloc] initWithColor:ccc4(0, 125, 200, 255)];
	[layer loadCurrentLevel];
    //[layer setColor:ccWHITE];
	// add layer as a child to scene
	[scene addChild: layer];
	[layer release];
	// return the scene
	return scene;
}

+(CCScene*)debugScene{
    
    CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayScene *layer = [[PlayScene alloc] initWithColor:ccc4(0, 125, 200, 255)];
	[layer loadLevelWithName:@"DemoLevel"];
    //[layer setColor:ccWHITE];
	// add layer as a child to scene
	[scene addChild: layer];
	[layer release];
	// return the scene
	return scene;
}

#pragma mark - Game Loop Methods

-(void) draw
{
    
     // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
     // Needed states:  GL_VERTEX_ARRAY, 
     // Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
    
#if DEBUG_DRAW

    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
    // Needed states:  GL_VERTEX_ARRAY,
    // Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glPushMatrix();
    
    //tileLayer is the view being offset
    float translateX = (scrollNode.position.x);
    float translateY = (scrollNode.position.y);
    glTranslatef(	translateX, translateY, 0.0f);
    
    world->DrawDebugData();
    
    glPopMatrix();
    
    // restore default GL states
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

     
#endif
    [super draw];
}

-(void) update: (ccTime) dt
{
    
   // NSLog(@"current - %f, %f, new - %f, %f", currentPos.x, currentPos.y, newPosition.x, newPosition.y);
    
    [_thePlayer updateGameObject:dt];
    for (GameObject *object in _gameObjects){
        [object updateGameObject:dt];
        //NSLog(@"Updated :%@", object);
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
    [self processCollisionSet:[_collisionManager collisionSet] withTime:dt];
    
    //Check Level Status.  Are we finished?
	if (_thePlayer.status == PlayerCompletedLevel || _thePlayer.status == PlayerDied){
        [[CCDirector sharedDirector] replaceScene:[GameOverScene scene]];
    }
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
    
#pragma mark Movement of the Scroll Node
    CGPoint currentPos = [scrollNode position];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    b2Vec2 velocity = [_thePlayer getVelocity];
	// if ball moved off the edge
    
    

	if(_thePlayer.position.x < -currentPos.x + SCROLL_BORDER && _thePlayer.position.x > 0 && velocity.x < 0){
		CGPoint currentPos = [scrollNode position];
		[scrollNode setPosition: ccpAdd(currentPos, ccp(-PTM_RATIO*velocity.x*dt,0))];
	}
	if(_thePlayer.position.x > (-currentPos.x+winSize.width) - SCROLL_BORDER && _thePlayer.position.x < ([[_levelInfo valueForKey:@"level_width"] floatValue]) - SCROLL_BORDER && velocity.x > 0){
		CGPoint currentPos = [scrollNode position];
		[scrollNode setPosition: ccpAdd(currentPos, ccp(-PTM_RATIO*velocity.x*dt,0))];
	}
	if(_thePlayer.position.y < -currentPos.y+SCROLL_BORDER && _thePlayer.position.y > 0 + SCROLL_BORDER && velocity.y < 0){
		CGPoint currentPos = [scrollNode position];
		[scrollNode setPosition: ccpAdd(currentPos, ccp(0,-PTM_RATIO*velocity.y*dt))];
	}
	if(_thePlayer.position.y > (-currentPos.y+winSize.height)-SCROLL_BORDER && _thePlayer.position.y < ([[_levelInfo valueForKey:@"level_height"] floatValue] - SCROLL_BORDER) && velocity.y > 0){
		CGPoint currentPos = [scrollNode position];
		[scrollNode setPosition: ccpAdd(currentPos, ccp(0,-PTM_RATIO*velocity.y*dt))];
	}
}

-(void)processCollisionSet:(NSSet*)collisionSet withTime:(ccTime)dt{
    
    NSSet *newCollisions = [collisionSet setDifferenceFromSet:_previousCollisions];
    NSSet *removedCollisions = [_previousCollisions setDifferenceFromSet:collisionSet];
    
    if ([newCollisions count] != 0){
        NSLog(@"new: %@", [newCollisions description]);
    }
    if ([removedCollisions count] != 0){
        NSLog(@"removed: %@", [removedCollisions description]);
    }
    
    for (GameObjectCollision *collision in newCollisions){
        if ([[collision objectA] isEqual:_thePlayer]){
            [_thePlayer handleCollisionWithObject:[collision objectB]];
        }
        else if ([[collision objectB] isEqual:_thePlayer]){
            [_thePlayer handleCollisionWithObject:[collision objectA]];
        }
    }
    
    for (GameObjectCollision *collision in removedCollisions){
        if ([[collision objectA] isEqual:_thePlayer]){
            [_thePlayer noLongerCollidingWithObject:[collision objectB]];
        }
        else if ([[collision objectB] isEqual:_thePlayer]){
            [_thePlayer noLongerCollidingWithObject:[collision objectA]];
        }
    }
    //The last thing we do is remember last iteration's collision set
    //So we can build change sets
    [_previousCollisions release];
    _previousCollisions = [collisionSet copy];
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
     // set velocity of ball to 0
     b2Vec2 v(0, 0);
     b2Body* b = [_thePlayer body];
     b->SetLinearVelocity(v);
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
		
		CGPoint currentPos = [scrollNode position];
		CGPoint point = [touch locationInView:[touch view]];
		
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
		float pointX = point.x + -1*currentPos.x;
		float pointY = (screenSize.height - point.y) + -1*currentPos.y;
		
		NSLog(@"%1.2f, %1.2f, %1.2f, %1.2f",point.x,point.y,currentPos.x,currentPos.y);
		NSLog(@"Ball Location %1.2f, %1.2f", [_thePlayer position].x, [_thePlayer position].y);
		
        
		double vConst = .05;  // multiplier
		
		b2Body* b = [_thePlayer body];
		float objectX = b->GetPosition().x*PTM_RATIO;
		float objectY = b->GetPosition().y*PTM_RATIO;
		
		float accelX = vConst*(pointX-objectX) ;
		float accelY = vConst*(pointY-objectY);
		//NSLog([NSString stringWithFormat:@"%1.2f, %1.2f : %1.2f, %1.2f",objectX,objectY,point.x,point.y]);
		
		b2Vec2 v(accelX, accelY);	
        v.Normalize();
        v *= 10;
		b->SetLinearVelocity(v);
         
	}	
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
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity( -accelY * 10, accelX * 10);
	
	world->SetGravity( gravity );
}

#pragma mark - Data Management
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;
    
    [_levelInfo release];
    [_gameObjects release];
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
