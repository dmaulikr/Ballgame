//
//  Switch.h
//  ballgame
//
//  Created by Ryan Hart on 7/28/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "GameObject.h"
#import "Player.h"

@interface Switch : GameObject{
    //State
    BOOL _activated;
    BOOL _charging;
    float _charge;
    
    //Settings
    float _maxCharge;
    float _chargePerSecond;
    
    Player *_thePlayer;
    
}
@property (readwrite) float maxCharge;
@end
