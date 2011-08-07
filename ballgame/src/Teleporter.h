//
//  Teleporter.h
//  ballgame
//
//  Created by Ryan Hart on 8/6/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "GameObject.h"
#import "Player.h"

@interface Teleporter : GameObject <DependantObject>{
    BOOL _disableCollisionsFromRecentTeleport;
    BOOL _isReceiver;

    NSString *_dependantObjectName;
    Teleporter* _dependantObject;
}

-(void)teleportPlayer:(Player*)player;

@end
