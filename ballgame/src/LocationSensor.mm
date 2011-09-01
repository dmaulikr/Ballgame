//
//  LocationSensor.mm
//  ballgame
//
//  Created by Ryan Hart on 8/31/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "LocationSensor.h"

@implementation LocationSensor

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    
    [super setupGameObject:game_object forWorld:world];
    _identifier = GameObjectIDLocationSensor;
    
}

-(void) setupSprite{
    [super setupSprite];
}

-(void)setupBody:(b2World *)world
{
    // Override default value of false
    isSensor = true;
    
    [super setupBody:world];
}

@end
