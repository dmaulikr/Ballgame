//
//  ChargedWall.h
//  ballgame
//
//  Created by Alexei Gousev on 7/31/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Wall.h"

@interface ChargedWall : Wall
{
    float chargeIncrement;
}

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world;

@property(nonatomic) float chargeIncrement;

@end
