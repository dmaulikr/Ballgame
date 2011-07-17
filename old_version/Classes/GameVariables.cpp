/*
 *  GameVariables.cpp
 *  BallGame
 *
 *  Created by Alexei Gousev on 11/23/09.
 *  Copyright 2009 UC Davis. All rights reserved.
 *
 */

#include "GameVariables.h"


void GameVariables::setScore(int newScore)
{
	score = newScore;
}

int GameVariables::getScore()
{
	return score;
}
