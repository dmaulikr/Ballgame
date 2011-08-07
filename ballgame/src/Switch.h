//
//  Switch.h
//  ballgame
//
//  Created by Ryan Hart on 7/28/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "GameObject.h"
#import "Player.h"

@protocol Switchable

-(void)switchStateChanged:(BOOL)isOn;

@end

@interface Switch : GameObject <DependantObject>{
    //State
    BOOL _activated;
    BOOL _charging;
    float _charge;
    
    //Settings
    float _maxCharge;
    float _chargePerSecond;
    
    Player *_thePlayer;
    
    NSString *_depObjectName;
    id<Switchable> _dependant_object;
    
}

-(void) setupBody:(b2World *)world;

@property (readwrite) float maxCharge;

@end
