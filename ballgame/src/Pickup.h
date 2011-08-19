//
//  Pickup.h
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//  Copyright 2011 __myCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "Player.h"

@interface Pickup : GameObject {
    

}

// Doesn't do anything here, but is overridden in subclasses.
-(void) wasPickedUpByPlayer:(Player*)player;

@end
