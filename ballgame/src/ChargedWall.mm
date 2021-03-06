//
//  ChargedWall.m
//  ballgame
//
//  Created by Alexei Gousev on 7/31/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "ChargedWall.h"
#import "AssetManager.h"
#import "Player.h"

@implementation ChargedWall
@synthesize chargeIncrement;

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world
{
    [super setupGameObject:game_object forWorld:world];
    _identifier = GameObjectIDChargedWall;
    
    chargeIncrement = [[game_object valueForKey:@"charge"] floatValue];
    
    selectorIsScheduled = false;
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
                
                // HARDCODED NAME
                // Change sprite to something else
                CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                        spriteFrameByName:@"GreenWallSegment1.png"];
                [self setDisplayFrame:frame];
                
                // Schedule a selector to change the sprite back to normal after 1/16 second
                [self schedule:@selector(changeBack:) interval:.125];
                
                // Play sound effect
                // HARDCODED SOUND EFFECT NAME
                if([AssetManager settingsEffectsOn])
                {
                    SimpleAudioEngine *audio = [SimpleAudioEngine sharedEngine];
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"ChargedWallCollision" ofType:@"wav"];
                    [audio playEffect:path];
                }
                
                // Send player flying away.  Limit to player's velocity is annoying.
                // TODO:  don't hardcode the value, it should be in the object plist
                b2Vec2 impulseDirection(0, 100);
                
                b2Vec2 impulseLocation = [object getBody]->GetPosition();
                [object getBody]->ApplyLinearImpulse(impulseDirection, impulseLocation);
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
    [self unschedule:@selector(changeBack:)];
    
    // Change sprite back to normal
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                            spriteFrameByName:@"GreenWallSegment2.png"];
    [self setDisplayFrame:frame];
}


@end
