//
//  GameState.h
//  BallGame
//
//  Created by Alexei Gousev on 11/23/09.
//  Copyright 2009 UC Davis. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameState : NSObject {

	int score;
}

@property(nonatomic) int score;

+(GameState*) gameStateInstance;

@end
