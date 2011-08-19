//
//  Collectible.m
//  ballgame
//
//  Created by Alexei Gousev on 8/14/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Collectible.h"

@implementation Collectible

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    
    [super setupGameObject:game_object forWorld:world];
    
    _identifier = GameObjectIDCollectible;
    
}

-(void) wasPickedUpByPlayer:(Player*)player
{
    // ToDo:  Keep track of how many of these the player has collected once we have some way of doing so.
}

@end
