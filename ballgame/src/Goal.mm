//
//  Goal.m
//  ballgame
//
//  Created by Ryan Hart on 7/16/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Goal.h"

@implementation Goal

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{

    [super setupGameObject:game_object forWorld:world];
    
    _identifier = GameObjectIDGoal;
    
}

@end
