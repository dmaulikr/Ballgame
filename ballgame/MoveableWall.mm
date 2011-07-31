//
//  MoveableWall.m
//  ballgame
//
//  Created by Alexei Gousev on 7/30/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "MoveableWall.h"

@implementation MoveableWall


-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    
    [super setupGameObject:game_object forWorld:world];
    
    NSArray *tempArray = [NSMutableArray arrayWithArray:[game_object objectForKey:@"positions"]];
    
    for(int i = 0; i < [positionPoints count]; i++)
    {
        [positionPoints addObject:[NSValue valueWithCGPoint:ccp([[[tempArray objectAtIndex:i] valueForKey:@"x"] floatValue], [[[tempArray objectAtIndex:i] valueForKey:@"y"] floatValue])]];
    }
    
    id action = [CCMoveTo actionWithDuration:1. position:CGPointMake(100, 100)];    
    [self runAction:action];
    
}

@end
