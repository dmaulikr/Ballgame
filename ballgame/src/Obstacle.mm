//
//  Obstacle.m
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//  Copyright 2011 __myCompanyName__. All rights reserved.
//

#import "Obstacle.h"


@implementation Obstacle

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    //This does nothing.  Subclasses override this for custom initialization
    [super setupGameObject:game_object forWorld:world];
    _identifier = GameObjectIDObstacle;
    
}

@end
