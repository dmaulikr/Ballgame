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
#import "math.h"

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
    kTagPauseMenu = 1337,
};

@interface PlayScene ()

-(Player*)addPlayer;
-(id)addGameObject:(NSDictionary *)gameObject;
-(void)processCollisionSet:(NSSet*)collisionSet withTime:(ccTime)dt;
-(void)sanitizeCollisionSetForObject:(GameObject*)gameObj;

@end

// HelloWorldLayer implementation
@implementation PlayScene


#pragma mark - Init
-(id)loadCurrentLevel{
    return [self loadLevelWithName:[[PlayerStateManager currentLevel] valueForKey:@"name"]];
}


-(id)loadLevelWithName:(NSString *)levelName{

    gameIsPaused = false;
    scrollNodeAnimated = false;
    currentZoomLevel = 1.0f;
    
    _levelInfo = [[[AssetManager sharedInstance]levelWithName:levelName] retain];
    if (_levelInfo == nil){
        [NSException raise:@"Loading the Level Failed" format:@"The level file was not setup correctly"];
        return nil;
    }
    [_levelInfo setValue:[NSNumber numberWithInt:LevelStatusStarted] forKey:@"LevelStatus"];
    _collisionManager = [[CollisionManager alloc] init];
    _previousCollisions = [[NSSet alloc] initWithObjects:nil];
    _gameObjects = [[NSMutableArray arrayWithCapacity:50] retain];
    _gsm = [[GameStateManager alloc] init];
    if ([_levelInfo valueForKey:@"GameStates"] != nil){
        [_gsm setOrderedGameStates:[_levelInfo valueForKey:@"GameStates"]];
    }
    else{
        GameState *defaultState = [GameState defaultInitialState];
        [defaultState setIsFinalState:YES];
        [_gsm setOrderedGameStates:[NSArray arrayWithObject:defaultState]];
    }
    
    // Enable touches
    self.isTouchEnabled = YES;
    
    // Enable accelerometer
    self.isAccelerometerEnabled = YES;
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    // Define the gravity vector.
    b2Vec2 gravity;
    gravity.Set(0.0f, 0.0f);
    
    // Make sure we set the gravity offsets the first time we get an accel message
    firstAccel = true;
    
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
    
    // If DebugDraw is on, we don't want to draw the background which would obscure the debug draw
#if !DEBUG_DRAW
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    // background texture
    int NUM_TILES = 1;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        NUM_TILES = 2;
    }
	for(int i = 0; i < NUM_TILES; i++)
		for(int j = 0; j < NUM_TILES; j++)
		{
            [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
            // ToDo:  make the background dependend on which hardware it's running on
			CCSprite *background = [CCSprite spriteWithFile:@"metalbackground_iPhone@2x.png"];
            background.position = ccp(j * background.contentSize.width, i*background.contentSize.height);
			[self addChild:background z:BACKGROUND_Z_ORDER]; // UNCOMMENT THIS ONE TO RENEW BACKGROUND
			
		}
#endif
    
    //Initialize the Sprite Sheet
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
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
    
    // Delete this crap
    // Temporary button to make sure scroll to position is working
    // Standard method to create a button
    CCMenuItem *starMenuItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"ZOMG SCROLL" fontName:@"Arial" fontSize:16.0] target:self selector:@selector(starButtonTapped:)];
    starMenuItem.position = ccp(60, 60);
    CCMenuItem *starMenuItem2 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"ZOMG ZOOM" fontName:@"Arial" fontSize:16.0] target:self selector:@selector(starButtonTapped2:)];
    starMenuItem2.position = ccp(60, 120);
    CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem, starMenuItem2, nil];
    starMenu.position = CGPointZero;
    [self addChild:starMenu];
    // Stop deleting here
    
    //Add the game Objects
    _thePlayer = [[self addPlayer] retain];
    
    for (NSDictionary *game_object in [_levelInfo objectForKey:@"game_objects"]){
        //NSLog(@"Adding an object");
        [self addGameObject:game_object];
    }
    
    //Now we need to resolve any dependencies any objects might have on other game objects in the world
    for (GameObject *game_object in _gameObjects){
        if ([game_object conformsToProtocol:@protocol(DependantObject)]){
            //Find his dependant object and set it
            GameObject <DependantObject>* depObject = (GameObject <DependantObject>*) game_object;
            for (GameObject *searchObject in _gameObjects){
                
                if ([[searchObject name] isEqualToString:[depObject getDependantObjectName]]){
                    //NSLog(@"Found our dependant object");
                    [depObject setDependantObject:searchObject];
                    break;
                }
            }
        }
    }
    
    [_collisionManager subscribeCollisionManagerToWorld:world];
    
    [self schedule: @selector(update:)];

    return self;
}

// Delete this crap
-(void) starButtonTapped:(id)sender
{
    id action1 = [CCCallFunc actionWithTarget:self selector:@selector(func1)];
    id action3 = [CCCallFunc actionWithTarget:self selector:@selector(func2)];
    id action5 = [CCCallFunc actionWithTarget:self selector:@selector(func3)];
    id action7 = [CCCallFunc actionWithTarget:self selector:@selector(func4)];
    
    id action2 = [CCDelayTime actionWithDuration:1.5f];
    id action4 = [CCDelayTime actionWithDuration:1.5f];
    id action6 = [CCDelayTime actionWithDuration:1.5f];
    
    id seq = [CCSequence actions:action1, action2, action3, action3, action4, action5, action6, action7, nil];
    
    [self runAction:seq];
    
    NSLog(@"button triggered!");
}

-(void) func1
{
    [self scrollToX:1000 Y:0 withDuration:1.0];
}

-(void) func2
{
    [self scrollToX:0 Y:0 withDuration:1.0];
}

-(void) func3
{
    [self scrollToX:0 Y:1000 withDuration:1.0];
}

-(void) func4
{
    [self scrollToPlayerWithDuration:1.0];
}

-(void) starButtonTapped2:(id)sender
{
    id action1 = [CCCallFunc actionWithTarget:self selector:@selector(func5)];
    id action3 = [CCCallFunc actionWithTarget:self selector:@selector(func6)];
    
    id action2 = [CCDelayTime actionWithDuration:2.5f];
    
    id seq = [CCSequence actions:action1, action2, action3, action3, nil];
    
    [self runAction:seq];
    
    NSLog(@"button triggered!");
}

-(void) func5
{
    [self zoomToFullLevelWithDuration:1.0];
}

-(void) func6
{
    [self zoomToNormalWithDuration:1.0];
}

// Stop deleting this crap here


#pragma mark - Level Creation

-(Player*)addPlayer
{
	CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
	
	//CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(32 * idx,32 * idy,32,32)];
    Player *player = [Player spriteWithSpriteFrameName:@"Volt0.png"];
	[batch addChild:player z:PLAYER_Z_ORDER];
    [player setLevelInfo:_levelInfo];
    [player setupGameObject:nil forWorld:world];
    [player setGsm:_gsm];
	
    return player;
}

-(id)addGameObject:(NSDictionary *)gameObject{
    CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
    
    NSString *type = [gameObject objectForKey:@"type"];
    NSString *frameName = [gameObject objectForKey:@"frame_name"];
    
    GameObject* object = [NSClassFromString(type) spriteWithSpriteFrameName:frameName];
    [batch addChild:object z:OBJECT_Z_ORDER];
    [object setupGameObject:gameObject forWorld:world];
    
    [_gameObjects addObject:object];
    return nil;
}

#pragma mark - Premade Scenes
+(CCScene*)currentLevelScene{
    CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayScene *layer = [[PlayScene alloc] init];
	[layer loadCurrentLevel];
	// add layer as a child to scene
	[scene addChild: layer];
	[layer release];
	// return the scene
	return scene;
}
#pragma mark - Game State Delegate Methods

-(void)gameStateWillAdvance{
    //Check the game state and figure out if there's anything we need 
    //To do for the end of the current game statee
}

-(void)gameStateDidAdvance{
    //Check the game state and figure out if there is anything we need
    //to do for the beginning of the new game state.
}

-(void)gameShouldEndDidSucceed:(BOOL)succeeded{
    NSLog(@"Game is over with Result: %i", succeeded);
    [[CCDirector sharedDirector] replaceScene:[GameOverScene scene]];
}

#pragma mark - Game Loop Methods

-(void) draw
{
    
#if DEBUG_DRAW

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
    
}

-(void) update: (ccTime) dt
{    
    [_thePlayer updateGameObject:dt];
    for (GameObject *object in _gameObjects){
        [object updateGameObject:dt];
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
    
    //Center the scroll node on the player's position...sort of =)
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if(!scrollNodeAnimated)
    {
        [scrollNode setPosition:CGPointMake((-_thePlayer.position.x + winSize.width/2) * currentZoomLevel , (-_thePlayer.position.y + winSize.height/2) * currentZoomLevel )];
    }
    
    // Clean up objects that need to be deleted :(
    for(int i = 0; i < [_gameObjects count]; i++)
    {
        GameObject *obj = [_gameObjects objectAtIndex:i];
        if(obj.flaggedForDeletion)
        {   
            //Remove the object from our list of game objects and all parent nodes
            //Also remove the box2d representation from the world.
            [_gameObjects removeObjectAtIndex:i];
            CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
            [batch removeChild:obj cleanup:YES];
            world->DestroyBody([obj getBody]);
            i--;
            [self sanitizeCollisionSetForObject:obj];
        }
    }
    
}

-(void)processCollisionSet:(NSSet*)collisionSet withTime:(ccTime)dt{
    
    NSSet *newCollisions = [collisionSet setDifferenceFromSet:_previousCollisions];
    NSSet *removedCollisions = [_previousCollisions setDifferenceFromSet:collisionSet];
    
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

-(void)sanitizeCollisionSetForObject:(GameObject*)gameObj{
    //This is necessary since we generate events by looking into the past but we may have to remove an object from the past
    //If we release it....This seems so wrong...
    NSMutableSet *newPreviousItems = [NSMutableSet setWithSet:_previousCollisions];
    for (GameObjectCollision *collision in _previousCollisions){
        if ([collision eitherObjectIsEqual:gameObj]){
            NSLog(@"Found a collision holding onto this object");
            [newPreviousItems removeObject:collision];
        }
    }
        [_previousCollisions release];
        _previousCollisions = [newPreviousItems copy];

}


#pragma mark Scroll and Zoom

-(void) scrollToX:(int)x Y:(int)y withDuration:(ccTime)duration
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    id action = [CCMoveTo actionWithDuration:duration position:CGPointMake(-x + winSize.width/2, -y + winSize.height/2)];
    [scrollNode runAction:action];
    
    // Make sure we don't follow the player for now
    scrollNodeAnimated = true;
}

-(void) scrollToPlayerWithDuration:(ccTime)duration
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    id action = [CCMoveTo actionWithDuration:duration position:CGPointMake(-_thePlayer.position.x + winSize.width/2 , -_thePlayer.position.y + winSize.height/2  )];
    [scrollNode runAction:action];
    
    // Schedule a callback for when this is done
    [self schedule:@selector(doneScrollingToPlayer:) interval:duration];
}

- (void)doneScrollingToPlayer: (ccTime) dt
{    
    // Unscehdule this selector so that it only runs once
    [self unschedule:@selector(doneScrollingToPlayer:)];
    
    // Make sure we start following the player again
    scrollNodeAnimated = false;
}

-(void) zoomToScale:(float)zoom withDuration:(ccTime)duration
{
    id action = [CCScaleTo actionWithDuration:duration scale:zoom];
    [scrollNode runAction:action];
    
    currentZoomLevel = zoom;
}

-(void) zoomToNormalWithDuration:(ccTime)duration
{
    [self zoomToScale:1.0 withDuration:duration];
    
    // Recenter on the player
    [self scrollToPlayerWithDuration:duration];
}

-(void) zoomToFullLevelWithDuration:(ccTime)duration
{
    // Figure out horizontal and vertical components of zoom
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float vertZoom = winSize.height / [[_levelInfo valueForKey:@"level_height"] floatValue];
    float horZoom = winSize.width / [[_levelInfo valueForKey:@"level_width"] floatValue];
    
    // Take the smaller (more zoomed out) of the two
    float zoom = vertZoom;
    if(horZoom < vertZoom)
        zoom = horZoom;
    
    // Figure out where we're scrolling to
    float scroll = [[_levelInfo valueForKey:@"level_width"] floatValue]/2 - winSize.width/2;
    if(vertZoom == zoom)
        scroll = [[_levelInfo valueForKey:@"level_height"] floatValue]/2 - winSize.height/2;
    
    // Zoom to that level
    [self zoomToScale:zoom withDuration:duration];
    
    // Make sure we are centered on the level
    [self scrollToX:scroll Y:scroll withDuration:duration];
}

#pragma mark - User Input
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_gsm processEvent:GSEPlayerTapped withInfo:[touches anyObject]];
     // set velocity of ball to 0
     b2Vec2 v(0, 0);
     world->SetGravity(v);
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
		
        // If double tapped
        if(touch.tapCount > 1)
        {
            if(!gameIsPaused)
                [self showPauseMenu];
            
            // Assuming there's no multi-touch
            return;
        }
        
		CGPoint currentPos = [scrollNode position];
		CGPoint point = [touch locationInView:[touch view]];
        
        // X and Y of point are flipped for some reason
        float pointX = point.y + -1*currentPos.x;
		float pointY = point.x + -1*currentPos.y;
        
		double vConst = 1;  // multiplier
		
		b2Body* b = [_thePlayer body];
		float objectX = b->GetPosition().x*PTM_RATIO;
		float objectY = b->GetPosition().y*PTM_RATIO;
		
		float accelX = vConst*(pointX - objectX);
		float accelY = vConst*(pointY - objectY);
		
		b2Vec2 v(accelX, accelY);	
        v.Normalize();
        v *= 55;
		world->SetGravity(v);
        
	}	
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
    // The first this function is called, figure out what at angle the device is being held
    if(firstAccel)
    {
        float aX = (float)acceleration.x;
        if(aX > 1)
            aX = 1;
        if(aX < -1)
            aX = -1;
        
        // -sinInverse(aX)
        accelAngle = -asinf(aX);
        
        firstAccel = false;
    }
	static int gravAdjustment = [[[AssetManager defaults] valueForKey:@"world_gravity"] intValue];
	
	float accelX = (float) acceleration.x * cos(accelAngle) - (float)acceleration.z * sin(accelAngle);
	float accelY = (float) acceleration.y;
    
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity( -accelY * gravAdjustment, accelX * gravAdjustment);
    
    // Set limit on gravity (hardcoded, but I think that's ok)
    double gravLength = sqrt(gravity.x * gravity.x + gravity.y * gravity.y);
    if(gravLength > 100)
    {
        gravLength /= 100;
        gravity.x /= gravLength;
        gravity.y /= gravLength;
    }
	
	world->SetGravity( gravity );
}

-(void)resumeTapped:(id)sender
{
    // Remove pause menu
    [self removeChildByTag:kTagPauseMenu cleanup:YES];
    
    // Resume game
    [[CCDirector sharedDirector] resume];
    
    // Allow pausing again
    gameIsPaused = false;
}

-(void)quitTapped:(id)sender
{
    // Remove pause menu
    [self removeChildByTag:kTagPauseMenu cleanup:YES];
    
    // Resume game
    [[CCDirector sharedDirector] resume];
    
    // Return to Main Menu
    [[CCDirector sharedDirector] replaceScene:[SplashScene scene]];
}

#pragma mark - UI Methods
-(void) showPauseMenu
{
    gameIsPaused = true;
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    // Pause stuff
    [[CCDirector sharedDirector] pause];
    //[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    
    // Create black background layer that's slightly transparent
    pauseLayer = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 170) width: s.width height: s.height];
    pauseLayer.position = CGPointZero;
    
    // Add layer to the game scene
    [self addChild: pauseLayer z:PAUSE_MENU_Z_ORDER tag:kTagPauseMenu];
    
    // Create menu items
    CCMenuItem *_resumeItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Resume Game" fontName:@"Arial" fontSize:32.0] target:self selector:@selector(resumeTapped:)];
    [_resumeItem setPosition:ccp(s.width/2, s.height * 2/3)];
    CCMenuItem *_quitItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Quit to Main Menu" fontName:@"Arial" fontSize:32.0] target:self selector:@selector(quitTapped:)];
    [_quitItem setPosition:ccp(s.width/2, s.height * 1/3)];
    
    // Create menu
    CCMenu *_menu = [CCMenu menuWithItems:_resumeItem,_quitItem, nil];
    [_menu setPosition:ccp(0,0)];
    
    // Add menu to pause layer
    [pauseLayer addChild:_menu z:10];
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
    [_thePlayer release];
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
