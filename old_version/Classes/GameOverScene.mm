//
//  GameOver.m
//  BallGame
//
//  Created by Alexei Gousev on 12/2/09.
//  Copyright 2009 UC Davis. All rights reserved.
//

#include <stdlib.h>
#include "GameOverScene.h"
#include "MainMenuScene.h"
#include "MainGameScene.h"
#include "HighScoresScene.h"

@implementation GameOver

@synthesize gs;

+(id) scene
{
	// 'scene' is an autorelease object.
	Scene *scene = [Scene node];
	
	// 'layer' is an autorelease object.
	GameOver *layer = [GameOver node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;	
}

+(id) sceneIntentional
{
	// 'scene' is an autorelease object.
	Scene *scene = [Scene node];
	
	// 'layer' is an autorelease object.
	GameOver *layer = [GameOver node];
	
	[layer setLabelGameOver];
	
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
		NSUserDefaults *hScores = [NSUserDefaults standardUserDefaults];
		
		gs = gs->sharedGameStateInstance();
		
		int newHighScore = -1;
		
		for(int i = 5; i >= 1; i--)
		{
			NSString *key = [NSString stringWithFormat:@"Scores%i",i];
			int integer = [hScores integerForKey:key];
			if(integer > gs->score) break;
			else newHighScore = i;
		}
		
		if(newHighScore != -1)
		{
			for(int i = 5; i > newHighScore; i--)
			{
				NSString *key = [NSString stringWithFormat:@"Scores%i",i];
				NSString *keyNext = [NSString stringWithFormat:@"Scores%i",(i-1)];
				
				[hScores setInteger:[hScores integerForKey:keyNext] forKey:key];
			}
			NSString *key = [NSString stringWithFormat:@"Scores%i",newHighScore];
			[hScores setInteger:gs->score forKey:key];
		}
		
		
		
		[MenuItemFont setFontSize:30];
		[MenuItemFont setFontName: @"Courier New"];
		
		Label *deadLabel = [Label labelWithString:@"Oops! You grew too big..." fontName:@"Marker Felt" fontSize:36];
		[self addChild:deadLabel z:0 tag:36];
		deadLabel.position = ccp(240,270);
		deadLabel.opacity = 200;
		[deadLabel setRGB:133 :133 :133];
		
		if(newHighScore == 1)
		{
			Label *omgHighScore = [Label labelWithString:@"New High Score!" fontName:@"Marker Felt" fontSize:28];
			omgHighScore.position = ccp(240,210);
			omgHighScore.opacity = 200;
			[self addChild:omgHighScore z:0 tag:34];
			[omgHighScore  setRGB:133 :133 :133];
		}
		
		NSString *score = @"Score: ";
		score = [score stringByAppendingFormat:@"%i",gs->score];		
		
		Label *scoreLabel = [Label labelWithString:score fontName:@"Marker Felt" fontSize:24];
		[self addChild:scoreLabel z:0 tag:32];
		scoreLabel.position = ccp(240,210);
		if(newHighScore == 1) scoreLabel.position = ccp(240,180);
		scoreLabel.opacity = 200;
		[scoreLabel  setRGB:133 :133 :133];
		
		
		// Font Item
		BitmapFontAtlas *label1 = [BitmapFontAtlas bitmapFontAtlasWithString:@"Play again!" fntFile:@"bitmapFontTest3.fnt"];
		MenuItemLabel *item1 = [MenuItemLabel itemWithLabel:label1 target:self selector:@selector(onPlay:)];
		BitmapFontAtlas *label2 = [BitmapFontAtlas bitmapFontAtlasWithString:@"View High Scores" fntFile:@"bitmapFontTest3.fnt"];
		MenuItemLabel *item2 = [MenuItemLabel itemWithLabel:label2 target:self selector:@selector(onViewHighScores:)];
		BitmapFontAtlas *label3 = [BitmapFontAtlas bitmapFontAtlasWithString:@"Main Menu" fntFile:@"bitmapFontTest3.fnt"];
		MenuItemLabel *item3 = [MenuItemLabel itemWithLabel:label3 target:self selector:@selector(onReturn:)];
		
		Menu *menu = [Menu menuWithItems: item1, item2, item3, nil];
		[menu alignItemsVerticallyWithPadding:16];
		menu.position = ccp(240,100);
		if(newHighScore == 1) menu.position = ccp(240,70);
		
		[self addChild: menu z:0 tag:97];

		Label *loading = [Label labelWithString:@"Loading..." fontName:@"Times New Roman" fontSize:48];
		loading.position = ccp(240, 160);
		loading.opacity = 200;
		loading.visible = false;
		[loading setRGB:133 :133 :133];
		[self addChild:loading z:0 tag:43];
	}
	
	return self;
}

-(void) setLabelGameOver
{
	Label *lbl = [self getChildByTag:36];
	[lbl setString:@"Game Over"];
}

-(void) onPlay: (id) sender
{	
	[self getChildByTag:43].visible = true; // "Loading" label
	[self getChildByTag:97].visible = false; // menu
	[self getChildByTag:32].visible = false;
	[self getChildByTag:34].visible = false;
	[self getChildByTag:36].visible = false;
	[[self getChildByTag:43] runAction:[FadeIn actionWithDuration:0.10]];
	
	[self schedule:@selector(playGame:) interval:0.1];
	
}

-(void) playGame: (id) sender
{	
	[self unschedule:@selector(playGame:)]; // only once
	
	[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:2 scene:[HelloWorld scene]]];
	
}

-(void) onReturn: (id) sender
{
	[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:1 scene:[MainMenu scene]]];
}

-(void) onViewHighScores: (id) sender
{
	[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:1 scene:[HighScores scene]]];
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
