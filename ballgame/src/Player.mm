//
//  Player.m
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//  Copyright 2011 __myCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Goal.h"
#import "AssetManager.h"

#define CHARGE_TO_PIXELS 3
@interface Player ()


@end

@implementation Player

@synthesize levelInfo=_levelInfo, chargeLevel=_chargeLevel, shouldCharge=_shouldCharge, gsm=_gsm, growRate=_growRate;

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    if (_levelInfo == nil){
        [NSException raise:@"Attempt to setup a player object that doesn't have levelInfo" format:@"Make sure you set the level info for the player object before setupGameObject"];
        return;
    }
    [super setupGameObject:game_object forWorld:world];
    
    _identifier = GameObjectIDPlayer;
    
    _growRate = [[_levelInfo valueForKey:GROW_RATE_KEY] floatValue];
    _radius = [[[AssetManager defaults] valueForKey:PLAYER_RADIUS] floatValue];
    _maxSpeed = [[[AssetManager defaults] valueForKey:MAX_SPEED_KEY] intValue];
    _chargeLevel = [[_levelInfo valueForKey:STARTING_SIZE_KEY] floatValue] / 2;;
    _shouldCharge = YES;
    
    [self startAnimating];
}


-(void) setupSprite
{
    CGPoint p;
    p.x = [[_levelInfo valueForKey:START_X_KEY] floatValue];
    p.y = [[_levelInfo valueForKey:START_Y_KEY] floatValue];
    
    [self rescale:CGSizeMake([[_levelInfo valueForKey:STARTING_SIZE_KEY] floatValue] * 2, [[_levelInfo valueForKey:STARTING_SIZE_KEY] floatValue] * 2)];    
    
	self.position = ccp( p.x,p.y );
    
    self.rotation = [[_objectInfo valueForKey:GO_ROTATION_KEY] floatValue];

}

-(void) setupBody:(b2World*) world
{
    CGPoint p;
    p.x = [[_levelInfo valueForKey:START_X_KEY] floatValue];
    p.y = [[_levelInfo valueForKey:START_Y_KEY] floatValue];
    
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
    bodyDef.linearDamping = 6.5;
    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = self;
	_body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
    b2CircleShape dynamicCircle;
	dynamicCircle.m_radius = [[_levelInfo valueForKey:STARTING_SIZE_KEY] floatValue] / 2 / PTM_RATIO;
    
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicCircle;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	_body->CreateFixture(&fixtureDef);
}

-(BOOL)isStuck{
    //TODO: Figure this out
    return NO;
}

-(void) updateGameObject: (ccTime) dt
{    
    if (_shouldCharge){
        self.chargeLevel += _growRate * dt;
        [[_gsm currentGameState] playerSizeChanged:self];
    }
    [super updateGameObject:dt];
    
    float32 _radiusSize = (_radius + _chargeLevel/CHARGE_TO_PIXELS) ;
    
    for (b2Fixture* f = _body->GetFixtureList(); f; f = f->GetNext()) 
    {
        b2CircleShape dynamicCircle;
        dynamicCircle.m_radius = _radiusSize / PTM_RATIO *2;
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicCircle;	
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.30f;
        _body->DestroyFixture(f);
        _body->CreateFixture(&fixtureDef);
    }
    
    [self rescale:CGSizeMake(_radiusSize * 4, _radiusSize * 4)];

    /*
    //LIMIT MAX VELOCITY
     // WE DECIDED NOT TO DO THIS.  LEAVING THIS HERE ANYWAY INCASE WE CHANGE OUR MIND
    const b2Vec2 velocity = _body->GetLinearVelocity();
    const float32 speed = velocity.Length();
    
    if (speed > _maxSpeed){
        _body->SetLinearVelocity((_maxSpeed/speed) * velocity);
    }
     */
    
    //HARDCODE
    if (_chargeLevel > 100 ){
        [[_gsm currentGameState] playerReachedMaximumSize:self];
    }
    if ([self isStuck]){
        [[_gsm currentGameState] playerIsStuck:self];
    }
    
    for (Effect *effect in _effects){
        [effect updateEffect:dt];
    }
}

-(void) startAnimating
{
    // HARDCODE - The spriteFrameName shouldn't be hardcoded.
    // Set up list of frames
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int i = 0; i <= 4; ++i) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"Volt%d.png", i]]];
    }
    
    // Create animation object
    CCAnimation *walkAnim = [CCAnimation 
                             animationWithFrames:walkAnimFrames delay:0.4f];
    
    CCAction *walkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
    
    [self runAction:walkAction];
}

-(void)handleCollisionWithObject:(GameObject *)object{
    [super handleCollisionWithObject:object];
    [[_gsm currentGameState] playerCollided:self andObject:object];
    
    switch ([object identifier]){
        case GameObjectIDGoal:
            //We hit the goal.  The GSM will take care of this
            break;
        case GameObjectIDSwitch:
            break;
        case GameObjectIDChargedWall:
            _chargeLevel += ((ChargedWall*)object).chargeIncrement;
#if COLLISION_DEBUG
            NSLog(@"Charge level - %f", _chargeLevel);
#endif
            break;
        default:
            break;
            
    }
}

-(void)noLongerCollidingWithObject:(GameObject*)object{
    [super noLongerCollidingWithObject:object];
    [object noLongerCollidingWithObject:self];
}

-(void)dealloc{
    [_gsm release];
    [super dealloc];
}
@end
