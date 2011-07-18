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

@synthesize levelInfo=_levelInfo;

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    if (_levelInfo == nil){
        [NSException raise:@"Attempt to setup a player object that doesn't have levelInfo" format:@"Make sure you set the level info for the player object before setupGameObject"];
        return;
    }
    _identifier = GameObjectIDPlayer;
    CGPoint p;
    p.x = [[_levelInfo valueForKey:@"start_x"] floatValue];
    p.y = [[_levelInfo valueForKey:@"start_y"] floatValue];
    
    CGSize originalSize = [self contentSize];
    float originalWidth = originalSize.width;
    float originalHeight = originalSize.height;
    
    // TODO:  put start size in level and move this to the player class
    float newSize = [[defaults valueForKey:@"starting_size"] floatValue];
    float newScaleX = (float)(newSize) / originalWidth;
    float newScaleY = (float)(newSize) / originalHeight;
    [self setScaleX:newScaleX];
    [self setScaleY:newScaleY];
    
    
    _growRate = [[defaults valueForKey:@"size_grow_rate"] floatValue];
    _radius = [[defaults valueForKey:@"starting_size"] floatValue] / 2;
    
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

-(void) updatePlayer: (ccTime) dt
{
    float oldRadius = _radius;
    _radius += (_growRate * dt);
    
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
}

-(void)handleCollisionWithObject:(GameObject *)object{
    [super handleCollisionWithObject:object];
    //DONT DO THIS.  THIS IS FUCKING TERRIBLE.  We should not be querying classes.  The object should return some sort of description
    if ([object identifier] == GameObjectIDGoal){
        [_levelInfo setValue:[NSNumber numberWithInt:LevelStatusCompleted] forKey:@"LevelStatus"];
    }
}

@end
