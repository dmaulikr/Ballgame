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
    
    // Load positions from plist
    NSArray *tempArray = [NSMutableArray arrayWithArray:[game_object objectForKey:@"positions"]];
    
    // Store position points in case we need them later
    positionPoints = [NSMutableArray array];
    for(int i = 0; i < [tempArray count]; i++)
    {
        CGPoint point = ccp([[[tempArray objectAtIndex:i] valueForKey:@"x"] floatValue], [[[tempArray objectAtIndex:i] valueForKey:@"y"] floatValue]);
        [positionPoints addObject:[NSValue valueWithCGPoint:point]];
    }
    
    // Construct sequence of actions
    NSMutableArray *actions = [NSMutableArray array];
    for(int i = 1; i < [positionPoints count]; i++)
    {
        // ToDo: Variable timesteps
        [actions addObject: [CCMoveTo actionWithDuration:1 position:[[positionPoints objectAtIndex:i] CGPointValue]]];
    }
    // Add first position so it loops back
    [actions addObject: [CCMoveTo actionWithDuration:1 position:[[positionPoints objectAtIndex:0] CGPointValue]]];
    
    // Convert NSMutableArray to action sequence
    id act = [self actionMutableArray:actions];
    
    // Initialize position
    CGPoint pos = ccp([[game_object valueForKey:@"x"] floatValue], [[game_object valueForKey:@"y"] floatValue]);
    self.position = pos;
    
    // Initialize movement
    [self runAction:[CCRepeatForever actionWithAction:[CCSequence actions:act, nil]]];
    
}

// Helper function to form action sequence from NSMutableArray
-(id) actionMutableArray: (NSMutableArray*) _actionList {
	CCFiniteTimeAction *now;
	CCFiniteTimeAction *prev = [_actionList objectAtIndex:0];
    
	for (int i = 1 ; i < [_actionList count] ; i++) {
		now = [_actionList objectAtIndex:i];
		prev = [CCSequence actionOne: prev two: now];
	}
    
	return prev;
}

-(void) syncPosition
{
    //Synchronize the position of the box2d body to match the sprite
    _body->SetTransform(b2Vec2(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO), -1 * CC_DEGREES_TO_RADIANS(self.rotation));
}
@end
