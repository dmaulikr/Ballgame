//
//  Switch.m
//  ballgame
//
//  Created by Ryan Hart on 7/28/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Switch.h"
#import "AssetManager.h"

@implementation Switch
@synthesize  maxCharge=_maxCharge, dependantObject=_dependant_object;

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    
    [super setupGameObject:game_object forWorld:world];
    _identifier = GameObjectIDSwitch;
    
    //Switches start uncharged
    _charge = 0.0;
    
    _maxCharge = [[game_object valueForKey:GO_MAX_CHARGE_KEY] floatValue];
    _chargePerSecond = [[game_object valueForKey:GO_CHARGE_PER_SEC_KEY] floatValue];
    
    _depObjectName = [game_object valueForKey:GO_DEP_OBJECT_KEY];
    
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
    
    if (_charging && _charge < _maxCharge){
        float deltaCharge = _chargePerSecond * dt;
        if ([_thePlayer chargeLevel] >= deltaCharge){
            [_thePlayer setChargeLevel:[_thePlayer chargeLevel] - deltaCharge];
            _charge += deltaCharge;
        }
    }
    
    if (_charge >= _maxCharge && !_activated){
        [self switchBecameOn];
    }
}

-(void) switchBecameOn{
    [self setColor:ccGREEN];
    [_dependant_object switchStateChanged:YES]; 
    _activated = YES;
    
    // Play sound effect
    // HARDCODE - SOUND EFFECT NAME
    if([AssetManager settingsEffectsOn])
    {
        SimpleAudioEngine *audio = [SimpleAudioEngine sharedEngine];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SwitchOn" ofType:@"wav"];
        [audio playEffect:path];
    }
}

-(void)handleCollisionWithObject:(GameObject *)object{
    [super handleCollisionWithObject:object];
    if ([object identifier] == GameObjectIDPlayer){
        _charging = YES;
        _thePlayer = (Player*)object;
    }
}

-(void)noLongerCollidingWithObject:(GameObject *)object{
    [super noLongerCollidingWithObject:object];
    if ([object identifier] == GameObjectIDPlayer){
        _charging = NO;
        _thePlayer = nil;
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
