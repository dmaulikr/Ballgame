/*
 *  GameState.h
 *  BallGame
 *
 *  Created by Alexei Gousev on 11/23/09.
 *  Copyright 2009 UC Davis. All rights reserved.
 *
 */
#import "Box2D.h"

#ifndef _GAME_STATE
#define _GAME_STATE

class GameState
{
	b2Body **bodyToBeRemoved;
public:
	
	int score;
	int scoreMultiplier;
	bool fly;
	int difficulty;
	bool sound;
	
	
	static GameState* sharedGameStateInstance();
	void removeSprite(b2Body *body);
	void setBodyPtr(b2Body *&ptr);
};

#endif