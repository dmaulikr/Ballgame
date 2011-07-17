/*
 *  GameState.cpp
 *  BallGame
 *
 *  Created by Alexei Gousev on 11/23/09.
 *  Copyright 2009 UC Davis. All rights reserved.
 *
 */

#include "GameState.h"

GameState* GameState::sharedGameStateInstance()
{
	static GameState *sharedGameStateInstance;
	
	if(!sharedGameStateInstance)
	{
		// create new GameState
		sharedGameStateInstance = new GameState();
		sharedGameStateInstance->score = 0;
		sharedGameStateInstance->scoreMultiplier = 1;
		sharedGameStateInstance->fly = false;
	}
	
	return sharedGameStateInstance;
	
}

void GameState::setBodyPtr(b2Body *&ptr)
{
	bodyToBeRemoved = &ptr;
}

void GameState::removeSprite(b2Body *body)
{
	*bodyToBeRemoved = body;
}