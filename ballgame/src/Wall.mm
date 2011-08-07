//
//  Wall.m
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//  Copyright 2011 __myCompanyName__. All rights reserved.
//

#import "Wall.h"

@implementation Wall

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{

    [super setupGameObject:game_object forWorld:world];
    
    _identifier = GameObjectIDWall;
   
}

@end
