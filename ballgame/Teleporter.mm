//
//  Teleporter.m
//  ballgame
//
//  Created by Ryan Hart on 8/6/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Teleporter.h"

@implementation Teleporter

@synthesize dependantObject=_dependantObject;

-(void)setupGameObject:(NSDictionary *)game_object forWorld:(b2World *)world{
    [super setupGameObject:game_object forWorld:world];
    
    _identifier = GameObjectIDTeleporter;
    
    _dependantObjectName = [game_object valueForKey:@"dependant_object_name"];
    
}

-(void)setupBody:(b2World *)world
{
    // Override default value of false
    isSensor = true;
    
    [super setupBody:world];
}

-(void)handleCollisionWithObject:(GameObject *)object{
    [super handleCollisionWithObject:object];
    
    if ([object identifier] == GameObjectIDPlayer){
        if (! _disableCollisionsFromRecentTeleport && !_isReceiver ) {
            //We should teleport the player since we're not disabled and not a receiver
            
            [_dependantObject teleportPlayer:(Player*)object];
        }
    }
    
}

-(void)noLongerCollidingWithObject:(GameObject*)object{
    [super noLongerCollidingWithObject:object];
    
    if (_disableCollisionsFromRecentTeleport && [object identifier] == GameObjectIDPlayer){
        _disableCollisionsFromRecentTeleport = NO;
    }
    
}

-(void)teleportPlayer:(Player *)player{
    _disableCollisionsFromRecentTeleport = YES;
    b2Vec2 b2Position = b2Vec2(self.position.x/PTM_RATIO,
                               self.position.y/PTM_RATIO);
    b2Body *body = [player body];
    body->SetTransform(b2Position, 0);
}

-(NSString*)getDependantObjectName{
    return _dependantObjectName;
}
@end
