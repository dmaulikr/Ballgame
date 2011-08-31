//
//  Chaser.m
//  ballgame
//
//  Created by Alexei Gousev on 8/14/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Chaser.h"
#import "AssetManager.h"

@implementation Chaser


-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    
    [super setupGameObject:game_object forWorld:world];
    _identifier = GameObjectIDChaser;
    
    playerIsInRange = false;    
}

-(void) setupSprite
{
    CGPoint p;
    p.x = [[_objectInfo valueForKey:GO_X_KEY] floatValue];
    p.y = [[_objectInfo valueForKey:GO_Y_KEY] floatValue];
    self.position = ccp( p.x,p.y);
    
    [self rescale:CGSizeMake(objectSize.width, objectSize.height)];
    
    self.rotation = [[_objectInfo valueForKey:GO_ROTATION_KEY] floatValue];
}

-(void) setupBody:(b2World*) world
{
    CGPoint p;
    p.x = [[_objectInfo valueForKey:GO_X_KEY] floatValue];
    p.y = [[_objectInfo valueForKey:GO_Y_KEY] floatValue];
    
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
    // I have no idea why I have to multiply by 2 here
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = self;
    bodyDef.linearDamping = 6.5;
	_body = world->CreateBody(&bodyDef);
	_body->SetAwake(false);
    
	// Define another box shape for our dynamic body.
    b2CircleShape dynamicCircle;
	dynamicCircle.m_radius = [[_objectInfo valueForKey:GO_WIDTH_KEY] floatValue] * 15 / PTM_RATIO; // size of tracking circle
    
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
            
            if(!playerIsInRange)
            {
                player = (Player*) object;
                playerIsInRange = true;
                
                // Play sound effect
                // HARDCODE -  SOUND EFFECT NAME
                if([AssetManager settingsEffectsOn])
                {
                    SimpleAudioEngine *audio = [SimpleAudioEngine sharedEngine];
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"Giggle" ofType:@"wav"];
                    [audio playEffect:path];
                }
            }
            
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
            
            if(playerIsInRange)
            {
                player = nil;
                playerIsInRange = false;
                
                // Play sound effect
                // HARDCODE - SOUND EFFECT NAME
                if([AssetManager settingsEffectsOn])
                {
                    SimpleAudioEngine *audio = [SimpleAudioEngine sharedEngine];
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"Buzz" ofType:@"wav"];
                    [audio playEffect:path];
                }
            }
            
            break;
        default:
            break;
    }
}

-(void) updateGameObject: (ccTime) dt
{ 
    [super updateGameObject:dt];
    
    // Make object ignore gravity by applying equal and opposite force to it
    b2Vec2 antiGravityForce = _world->GetGravity();
    antiGravityForce *= -1;
    antiGravityForce *= [self getBody]->GetMass();
    [self getBody]->ApplyForce(antiGravityForce, [self getBody]->GetPosition());    
    
    // If the player isn't in the circle, don't do anything
    if(!playerIsInRange)
        return;
    
    // Calculate force direction and power
    b2Vec2 playerPos = [player getBody]->GetPosition();
    b2Vec2 wellPos = [self getBody]->GetPosition();
    b2Vec2 forceDirection(wellPos.x - playerPos.x, wellPos.y - playerPos.y);
    float distance = sqrt(forceDirection.x * forceDirection.x + forceDirection.y * forceDirection.y);
    
    // If enemy collided into the player
    // HARDCODE:
    if(distance < 12.0 / PTM_RATIO)
    {
        [self didCollideWithPlayer];
        return;
    }
    
    float forcePower = [[_objectInfo valueForKey:GO_SPEED_KEY] floatValue];
    forceDirection.Normalize();
    forceDirection *= forcePower;
    forceDirection *= (1.0 / pow(distance, 1.4));
    
    forceDirection *= -10000;
    
    b2Vec2 forceLocation = [self getBody]->GetPosition();
    [self getBody]->ApplyForce(forceDirection, forceLocation);
}

-(void) didCollideWithPlayer
{
    // Delete this object at the end of this game loop
    [self removeFromWorld];
    
    int chargeDec = [[_objectInfo objectForKey:GO_CHARGE_INCR_KEY] intValue];
    
    // Update player size
    player.chargeLevel += chargeDec;
    
    // Play sound effect
    // HARDCODE - SOUND EFFECT NAME
    if([AssetManager settingsEffectsOn])
    {
        SimpleAudioEngine *audio = [SimpleAudioEngine sharedEngine];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Splash" ofType:@"wav"];
        [audio playEffect:path];
    }
}

@end