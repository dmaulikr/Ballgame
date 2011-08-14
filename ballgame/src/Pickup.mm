//
//  Pickup.m
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//  Copyright 2011 __myCompanyName__. All rights reserved.
//

#import "Pickup.h"


@implementation Pickup

-(void)handleCollisionWithObject:(GameObject *)object{
    [super handleCollisionWithObject:object];
    
    switch ([object identifier]){
            
        // If player collides into us
        case GameObjectIDPlayer:
            
            // Handle any logic that needs to be handled when a pickup is picked up
            [self wasPickedUpByPlayer:(Player*)object];
            
            // Delete this object at the end of this game loop
            flaggedForDeletion = true;
            
            break;
        default:
            break;
    }
    
    //[object handleCollisionWithObject:self];
}

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    //This does nothing.  Subclasses override this for custom initialization
    [super setupGameObject:game_object forWorld:world];
    _identifier = GameObjectIDPickup;
}

-(void)setupBody:(b2World *)world
{
    // Override default value of false
    isSensor = true;
    
    [super setupBody:world];
}

-(void) wasPickedUpByPlayer:(Player*)player
{
    // Do nothing. :(
}

@end
