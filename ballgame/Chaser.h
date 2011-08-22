//
//  Chaser.h
//  ballgame
//
//  Created by Alexei Gousev on 8/14/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "GameObject.h"
#import "Player.h"
//
@interface Chaser : GameObject
{
    // Pointer to player
    Player* player;
    
    bool playerIsInRange;
}

-(void) didCollideWithPlayer;

@end