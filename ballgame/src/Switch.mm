//
//  Switch.m
//  ballgame
//
//  Created by Ryan Hart on 7/28/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Switch.h"

@implementation Switch
@synthesize  maxCharge=_maxCharge, dependantObject=_dependant_object;

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    
    [super setupGameObject:game_object forWorld:world];
    _identifier = GameObjectIDSwitch;
    
    //Switches start uncharged
    _charge = 0.0;
    
    _maxCharge = [[game_object valueForKey:@"max_charge"] floatValue];
    _chargePerSecond = [[game_object valueForKey:@"charge_per_second"] floatValue];
    
    _depObjectName = [game_object valueForKey:@"dependant_object_name"];
    
    [self setColor:ccRED];
}


-(void)setupBody:(b2World *)world
{
    // Override default value of false
    isSensor = true;
    
    [super setupBody:world];
}



-(void)updateGameObject:(ccTime)dt{
    
    [super updateGameObject:dt];
    
    //NSLog(@"Update");
    if (_charging && _charge < _maxCharge){
        float deltaCharge = _chargePerSecond * dt;
        if ([_thePlayer chargeLevel] >= deltaCharge){
            //NSLog(@"Siphoning %1.2f charge from the player.", deltaCharge);
            [_thePlayer setChargeLevel:[_thePlayer chargeLevel] - deltaCharge];
            _charge += deltaCharge;
        }
        //NSLog(@"charge: %1.2f", _charge);
    }
    
    if (_charge >= _maxCharge && !_activated){
        [self setColor:ccGREEN];
        [_dependant_object switchStateChanged:YES]; 
        _activated = YES;
        
        // Play sound effect
        // HARDCODED SOUND EFFECT NAME
        SimpleAudioEngine *audio = [SimpleAudioEngine sharedEngine];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SwitchOn" ofType:@"wav"];
        [audio playEffect:path];
        
    }
}

-(void)handleCollisionWithObject:(GameObject *)object{
    [super handleCollisionWithObject:object];
    if ([object identifier] == GameObjectIDPlayer){
        //NSLog(@"Charging");
        _charging = YES;
        _thePlayer = (Player*)object;
        //[_thePlayer setShouldCharge:NO];
    }
}

-(void)noLongerCollidingWithObject:(GameObject *)object{
    [super noLongerCollidingWithObject:object];
    if ([object identifier] == GameObjectIDPlayer){
        //NSLog(@"Not Charging");
        _charging = NO;
        _thePlayer = nil;
        //[_thePlayer setShouldCharge:YES];
    }
    
   
}

-(NSString*)getDependantObjectName{
    return _depObjectName;
}

-(void)dealloc{
    [_thePlayer release];
    [super dealloc];
}

@end
