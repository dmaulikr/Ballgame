//
//  HighScores.m
//  BallGame
//
//  Created by Alexei Gousev on 12/2/09.
//  Copyright 2009 UC Davis. All rights reserved.
//

#include <stdlib.h>
#include <Foundation/Foundation.h>
#include "HighScoresScene.h"
#include "MainMenuScene.h"


@implementation HighScores

@synthesize gs;

+(id) scene
{
	// 'scene' is an autorelease object.
	Scene *scene = [Scene node];
	
	// 'layer' is an autorelease object.
	HighScores *layer = [HighScores node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;	
}


-(id) init
{
	// initialize your instance here
	if( (self=[super init])) {
		
		// BACKGROUND
		CGSize winSize = [Director sharedDirector].winSize;
		Sprite *background = [Sprite spriteWithFile:@"menu_texture.jpg"];
		background.position = ccp(winSize.width/2,winSize.height/2);
		[self addChild:background z:-1];
		
		/*
		NSMutableArray hScores = [NSMutableArray array];
		for(int i = 0; i < 5; i++)
		{
			[hScores addObject:[NSString stringWithFormat:@"%i",i]];
		}
		
		[hScores writeToFile:@"highscores.plist" atomically:YES];
		 */
		
		
		NSUserDefaults *hScores = [NSUserDefaults standardUserDefaults];

		Label *hScoreLabel = [Label labelWithString:@"High Scores" fontName:@"Marker Felt" fontSize:36];
		hScoreLabel.position = ccp(240,280);
		hScoreLabel.opacity = 200;
		[hScoreLabel setRGB:133 :133 :133];
		
		
		[self addChild:hScoreLabel z:0 tag:33];
		
		for(int i = 1; i <= 5; i++)
		{
			NSString *key = [NSString stringWithFormat:@"Scores%i",i];
			int integer = [hScores integerForKey:key];
			NSLog(key);
			NSLog(@"%i",integer);
			Label *scoreLabel = [Label labelWithString:[NSString stringWithFormat:@"%i: %i",i, integer] fontName:@"Marker Felt" fontSize:18];
			[self addChild:scoreLabel z:0 tag:32];
			scoreLabel.position = ccp(240,260-30*i);
			[scoreLabel setRGB:133 :133 :133];
			scoreLabel.opacity = 200;
		}
		
		// Back button
		BitmapFontAtlas *label1 = [BitmapFontAtlas bitmapFontAtlasWithString:@"Back to Main Menu" fntFile:@"bitmapFontTest3.fnt"];
		MenuItemLabel *item1 = [MenuItemLabel itemWithLabel:label1 target:self selector:@selector(onBack:)];
		
		Menu *menu = [Menu menuWithItems: item1, nil];
		[menu alignItemsVertically];
		menu.position = ccp(240,60);
		
		[self addChild: menu];
		
		
		// reset high scores
		/*
		for(int i = 1; i <= 5; i++)
		{
			NSString *key = [NSString stringWithFormat:@"Scores%i",i];
			//NSLog(key);
			//NSLog(@"bonk");
			[hScores setInteger:0 forKey:key];
		}
		 */
		
		
		
		
		
		
	}
	
	return self;
}


-(void) onBack: (id) sender
{
	[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:1 scene:[MainMenu scene]]];
}

-(void) onViewHighScores: (id) sender
{
}


-(void) onQuit: (id) sender
{
	[[Director sharedDirector] end];
	
	// HA HA... no more terminate on sdk v3.0
	// http://developer.apple.com/iphone/library/qa/qa2008/qa1561.html
	if( [[UIApplication sharedApplication] respondsToSelector:@selector(terminate)] )
		[[UIApplication sharedApplication] performSelector:@selector(terminate)];
	else
		NSLog(@"YOU CAN'T TERMINATE YOUR APPLICATION PROGRAMATICALLY in SDK 3.0+");
}

@end
