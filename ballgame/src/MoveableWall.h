//
//  MoveableWall.h
//  ballgame
//
//  Created by Alexei Gousev on 7/30/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Wall.h"

@interface MoveableWall : Wall{

    NSMutableArray *positionPoints;    
}

// helper function
-(id) actionMutableArray: (NSMutableArray*) _actionList;

@end
