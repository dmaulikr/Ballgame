//
//  Bumper.m
//  ballgame
//
//  Created by Alexei Gousev on 8/14/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Bumper.h"

@implementation Bumper

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    
    [super setupGameObject:game_object forWorld:world];
    
    _identifier = GameObjectIDBumper;
    
}

@end
