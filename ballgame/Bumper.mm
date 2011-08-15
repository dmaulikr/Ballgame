//
//  Bumper.m
//  ballgame
//
//  Created by Alexei Gousev on 8/14/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Bumper.h"
#import "AssetManager.h"
#import "SimpleAudioEngine.h"

@implementation Bumper

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    
    [super setupGameObject:game_object forWorld:world];
    
    _identifier = GameObjectIDBumper;
    
    selectorIsScheduled = false;
    
}

// Overwrite this method so the body is a circle instead of a rectangle
-(void) setupBody:(b2World*) world
{
    CGPoint p;
    p.x = [[_objectInfo valueForKey:@"x"] floatValue];
    p.y = [[_objectInfo valueForKey:@"y"] floatValue];
    
    b2BodyDef bodyDef;
	bodyDef.position.Set((p.x) /PTM_RATIO , (p.y ) /PTM_RATIO );
	bodyDef.userData = self;
    
	_body = world->CreateBody(&bodyDef);
    float angle = CC_DEGREES_TO_RADIANS(([[_objectInfo valueForKey:@"rotation"] floatValue]));
    _body->SetTransform(_body->GetPosition(), angle);
	_body->SetAwake(NO);
	
	// Define another box shape for our dynamic body.  Assuming that width and height are the same
    b2CircleShape dynamicCircle;
	dynamicCircle.m_radius = [[_objectInfo valueForKey:@"width"] floatValue] / 2 / PTM_RATIO;
    
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicCircle;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	_body->CreateFixture(&fixtureDef);
}

-(void)handleCollisionWithObject:(GameObject *)object{
    [super handleCollisionWithObject:object];
    
    switch ([object identifier]){
            
            // If player collides into us
        case GameObjectIDPlayer:
            
            // If we didn't recollide again with 1/16 a second
            if(!selectorIsScheduled)
            {
                selectorIsScheduled = true;
                
                // ToDo
                // Change sprite to something else
                CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                        spriteFrameByName:@"bumper.png"];
                [self setDisplayFrame:frame];
                
                // Schedule a selector to change the sprite back to normal after 1/16 second
                [self schedule:@selector(changeBack:) interval:.125];
                
                // Play sound effect
                // HARDCODED SOUND EFFECT NAME
                if([AssetManager settingsEffectsOn])
                {
                    SimpleAudioEngine *audio = [SimpleAudioEngine sharedEngine];
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"Metal_Ting" ofType:@"wav"];
                    [audio playEffect:path];
                }
                
                // Send player flying away.
                b2Vec2 playerPos = [object getBody]->GetPosition();
                b2Vec2 bumperPos = [self getBody]->GetPosition();
                b2Vec2 impulseDirection(playerPos.x - bumperPos.x, playerPos.y - bumperPos.y);
                float impulsePower = [[_objectInfo valueForKey:@"power"] floatValue];
                impulseDirection.Normalize();
                impulseDirection *= impulsePower;
                
                b2Vec2 impulseLocation = [object getBody]->GetPosition();
                [object getBody]->ApplyLinearImpulse(impulseDirection, impulseLocation);
                
                // Make this object grow and shrink once really fast
                float scaleRatio = [[_objectInfo valueForKey:@"width"] floatValue]/originalSize.width;
                id action = [CCSequence actions:
                             [CCScaleTo actionWithDuration:.08 scale:1.4f * scaleRatio],
                             [CCScaleTo actionWithDuration:.18 scale:1.0f * scaleRatio],
                             nil];
                
                [self runAction:action];
            }
            
            break;
        default:
            break;
    }
    
    //[object handleCollisionWithObject:self];
}

- (void)changeBack: (ccTime) dt
{
    // Safe to collide again
    selectorIsScheduled = false;
    
    // Unscehdule this selector so that it only runs once
    [self unschedule:@selector(eventHappend:)];
    
    // Change sprite back to normal
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                            spriteFrameByName:@"bumper.png"];
    [self setDisplayFrame:frame];
}

@end
