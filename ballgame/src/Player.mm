//
//  Player.m
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//  Copyright 2011 __myCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Goal.h"

@interface Player ()


@end

@implementation Player

@synthesize levelInfo=_levelInfo, status=_status;

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    if (_levelInfo == nil){
        [NSException raise:@"Attempt to setup a player object that doesn't have levelInfo" format:@"Make sure you set the level info for the player object before setupGameObject"];
        return;
    }
    [super setupGameObject:game_object forWorld:world];
    _status = PlayerBeganLevel;
    
    _identifier = GameObjectIDPlayer;
    CGPoint p;
    p.x = [[_levelInfo valueForKey:@"start_x"] floatValue];
    p.y = [[_levelInfo valueForKey:@"start_y"] floatValue];
    
    CGSize originalSize = [self contentSize];
    float originalWidth = originalSize.width;
    float originalHeight = originalSize.height;
    
    // TODO:  put start size in level and move this to the player class
    float newSize = [[_levelInfo valueForKey:@"starting_size"] floatValue];
    float newScaleX = (float)(newSize) / originalWidth;
    float newScaleY = (float)(newSize) / originalHeight;
    [self setScaleX:newScaleX];
    [self setScaleY:newScaleY];
    
    
    _growRate = [[_levelInfo valueForKey:@"size_grow_rate"] floatValue];
    _radius = [[_levelInfo valueForKey:@"starting_size"] floatValue] / 2;
    _chargeLevel = 0.0;
    
	self.position = ccp( p.x,p.y );
    
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = self;
	_body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
    b2PolygonShape dynamicPolygon;
    b2CircleShape dynamicCircle;
	dynamicCircle.m_radius = _radius / PTM_RATIO;
	dynamicPolygon.SetAsBox(_radius / PTM_RATIO, _radius / PTM_RATIO);
    
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicPolygon;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	_currentFixture= _body->CreateFixture(&fixtureDef);
}

-(void) updateGameObject: (ccTime) dt
{
    float oldRadius = _radius;
    _radius += (_growRate * dt);
    _chargeLevel += _growRate;
    
    [self setScale: [self scale] * _radius/oldRadius];
    
    b2CircleShape dynamicCircle;
	dynamicCircle.m_radius = _radius / PTM_RATIO;
    
    b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicCircle;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.30f;
	_body->DestroyFixture(_currentFixture);
	_currentFixture = _body->CreateFixture(&fixtureDef);
    //NSLog(@"New size - %f.  Scaling factor - %f", _radius, _radius/oldRadius);
    
    //HARDCODE
    if (_radius >= 50){
        _status = PlayerDied;
    }
    for (Effect *effect in _effects){
        [effect updateEffect:dt];
    }
}

-(void)handleCollisionWithObject:(GameObject *)object{
    [super handleCollisionWithObject:object];
    //DONT DO THIS.  THIS IS FUCKING TERRIBLE.  We should not be querying classes.  The object should return some sort of description
    NSLog(@"%@", [[object class] description]);
    switch ([object identifier]){
        case GameObjectIDGoal:
            NSLog(@"Level Completed");
            _status = PlayerCompletedLevel;
            break;
        case GameObjectIDSwitch:
            
            break;
    }
    
    [object handleCollisionWithObject:self];
}

-(void)noLongerCollidingWithObject:(GameObject*)object{
    [super noLongerCollidingWithObject:object];
    [object noLongerCollidingWithObject:self];
}

-(void) reduceCharge:(float)amount{
    _chargeLevel -= amount;
}

@end
