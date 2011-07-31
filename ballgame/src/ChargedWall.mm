//
//  ChargedWall.m
//  ballgame
//
//  Created by Alexei Gousev on 7/31/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "ChargedWall.h"

@implementation ChargedWall
@synthesize chargeIncrement;

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world
{
    [super setupGameObject:game_object forWorld:world];
    _identifier = GameObjectIDChargedWall;
    
    chargeIncrement = [[game_object valueForKey:@"charge"] floatValue];
}

/*
-(void)handleCollisionWithObject:(GameObject *)object{
    [super handleCollisionWithObject:object];
    
    //NSLog(@"%@", [[object class] description]);
    switch ([object identifier]){
        case GameObjectIDGoal:
            //NSLog(@"Level Completed");
            _status = PlayerCompletedLevel;
            break;
        case GameObjectIDSwitch:
            
            break;
    }
    
    [object handleCollisionWithObject:self];
}
 */

@end
