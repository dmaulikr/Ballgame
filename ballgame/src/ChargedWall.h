//
//  ChargedWall.h
//  ballgame
//
//  Created by Alexei Gousev on 7/31/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Wall.h"
#import "SimpleAudioEngine.h"

@interface ChargedWall : Wall
{
    float chargeIncrement;
    bool selectorIsScheduled;
}

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world;

@property(nonatomic) float chargeIncrement;

@end
