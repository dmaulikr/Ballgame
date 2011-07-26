//
//  HorseshoeWall.h
//  ballgame
//
//  Created by Ryan Hart on 7/23/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Obstacle.h"

@interface HorseshoeWall : Obstacle{
    b2FixtureDef leftFixture;
    b2FixtureDef rightFixture;
}
@end
