//
//  TimedSwitch.m
//  ballgame
//
//  Created by Ryan Hart on 8/7/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "TimedSwitch.h"

@interface TimedSwitch () 
-(void)switchExpired;
@end

@implementation TimedSwitch

-(void)setupGameObject:(NSDictionary *)game_object forWorld:(b2World*)world{
    [super setupGameObject:game_object forWorld:world];
    
    _duration = [[game_object valueForKey:GO_DURATION_KEY] floatValue];
    
}

-(void)switchBecameOn{
    [super switchBecameOn];
    
    //Start the disable timer
    [self schedule:@selector(switchExpired) interval:_duration];
    
}

-(void)switchExpired{
    [self unschedule:@selector(switchExpired)];
    _activated = NO;
    _charge = 0;
    [self setColor:ccRED];
    [_dependant_object switchStateChanged:_activated];
}

@end
