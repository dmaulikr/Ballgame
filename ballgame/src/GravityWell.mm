//
//  GravityWell.m
//  ballgame
//
//  Created by Alexei Gousev on 8/14/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "GravityWell.h"

@implementation GravityWell


-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    
    [super setupGameObject:game_object forWorld:world];
    _identifier = GameObjectIDGravityWell;
    
    playerIsInRange = false;
    
}

-(void) setupSprite
{
    CGPoint p;
    p.x = [[_objectInfo valueForKey:@"x"] floatValue];
    p.y = [[_objectInfo valueForKey:@"y"] floatValue];
    self.position = ccp( p.x,p.y);
    
    [self rescale:CGSizeMake(objectSize.width, objectSize.height)];
    
    self.rotation = [[_objectInfo valueForKey:@"rotation"] floatValue];
}

-(void) setupBody:(b2World*) world
{
    CGPoint p;
    p.x = [[_objectInfo valueForKey:@"x"] floatValue];
    p.y = [[_objectInfo valueForKey:@"y"] floatValue];
    
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
    // I have no idea why I have to multiply by 2 here
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = self;
	_body = world->CreateBody(&bodyDef);
	_body->SetAwake(false);
    
	// Define another box shape for our dynamic body.
    b2CircleShape dynamicCircle;
	dynamicCircle.m_radius = [[_objectInfo valueForKey:@"width"] floatValue] * 2 / PTM_RATIO;
    
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicCircle;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
    fixtureDef.isSensor = true;
	_body->CreateFixture(&fixtureDef);
}

-(void)handleCollisionWithObject:(GameObject *)object{
    [super handleCollisionWithObject:object];
    
    switch ([object identifier]){
            
            // If player collides into us
        case GameObjectIDPlayer:
            
            player = (Player*) object;
            playerIsInRange = true;
            
            break;
        default:
            break;
    }
}

-(void)noLongerCollidingWithObject:(GameObject *)object{
    [super handleCollisionWithObject:object];
    
    switch ([object identifier]){
            
            // If player collides into us
        case GameObjectIDPlayer:
            
            player = nil;
            playerIsInRange = false;
            
            break;
        default:
            break;
    }
}

-(void) updateGameObject: (ccTime) dt
{ 
    // If the player isn't in the circle, don't do anything
    if(!playerIsInRange)
        return;
    
    // Calculate force direction and power
    b2Vec2 playerPos = [player getBody]->GetPosition();
    b2Vec2 wellPos = [self getBody]->GetPosition();
    b2Vec2 forceDirection(wellPos.x - playerPos.x, wellPos.y - playerPos.y);
    
    float distance = sqrt(forceDirection.x * forceDirection.x + forceDirection.y * forceDirection.y);
    float forcePower = [[_objectInfo valueForKey:@"power"] floatValue];
    forceDirection.Normalize();
    forceDirection *= forcePower;
    forceDirection *= [self getBody]->GetMass();
    
    // change the 2 to something else ( 1 < x < 2 ) to change the effect that distance from the center has on the force
    forceDirection *= (1.0/pow(distance, 2));

    b2Vec2 forceLocation = [player getBody]->GetPosition();
    [player getBody]->ApplyForce(forceDirection, forceLocation);
}


@end
