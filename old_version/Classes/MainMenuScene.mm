//
//  MainMenuScene.mm
//  BallGame
//
//  Created by Alexei Gousev on 12/2/09.
//  Copyright 2009 UC Davis. All rights reserved.
//

#include <stdlib.h>
#include "MainMenuScene.h"
#include "HighScoresScene.h"
#include "LoadingScene.h"
#include "MainGameScene.h"
#include "SettingsScene.h"
#import "SimpleAudioEngine.h"


@implementation MainMenu

@synthesize gs;

+(id) scene
{
	// 'scene' is an autorelease object.
	Scene *scene = [Scene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
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
	
		
		// MENU
		[MenuItemFont setFontSize:30];
		[MenuItemFont setFontName: @"Courier New"];
		
		// Font Item
		BitmapFontAtlas *label1 = [BitmapFontAtlas bitmapFontAtlasWithString:@"Play!" fntFile:@"bitmapFontTest3.fnt"];
		MenuItemLabel *item1 = [MenuItemLabel itemWithLabel:label1 target:self selector:@selector(onPlay:)];
		BitmapFontAtlas *label2 = [BitmapFontAtlas bitmapFontAtlasWithString:@"View High Scores" fntFile:@"bitmapFontTest3.fnt"];
		MenuItemLabel *item2 = [MenuItemLabel itemWithLabel:label2 target:self selector:@selector(onViewHighScores:)];
		BitmapFontAtlas *label3 = [BitmapFontAtlas bitmapFontAtlasWithString:@"Settings" fntFile:@"bitmapFontTest3.fnt"];
		MenuItemLabel *item3 = [MenuItemLabel itemWithLabel:label3 target:self selector:@selector(onSettings:)];

		
		Menu *menu = [Menu menuWithItems: item1, item2, item3, nil];
		[menu alignItemsVerticallyWithPadding:32];

		Label *loading = [Label labelWithString:@"Loading..." fontName:@"Times New Roman" fontSize:48];
		loading.position = ccp(240, 160);
		loading.opacity = 200;
		loading.visible = false;
		[loading setRGB:133 :133 :133];
		[self addChild:loading z:0 tag:43];
		
		[self addChild:menu z:0 tag:97];

		// background music
		self.gs = gs->sharedGameStateInstance();
		NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
		self.gs->sound = [settings boolForKey:@"Sound"];
		
		NSString *baseDirectory = [NSString string];
		baseDirectory = NSHomeDirectory();
		baseDirectory = [baseDirectory stringByAppendingString:@"/BallGame.app/"];
		NSString *filename = [baseDirectory stringByAppendingString:@"Game1.mp3"];
		
		SimpleAudioEngine *audio = [SimpleAudioEngine sharedEngine];
		if(!gs->sound) audio.muted = true;
		if(![audio isBackgroundMusicPlaying]) [audio playBackgroundMusic:filename];
		
		
	}

return self;
}


-(void) onPlay: (id) sender
{	
	[self getChildByTag:43].visible = true; // "Loading" label
	[self getChildByTag:97].visible = false; // Main menu
	
	[[self getChildByTag:43] runAction:[FadeIn actionWithDuration:0.10]];
	[self schedule:@selector(playGame:) interval:0.1];
	
}

-(void) playGame: (id) sender
{	
	[self unschedule:@selector(playGame:)]; // only once
	
	[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:2 scene:[HelloWorld scene]]];

}

-(void) onViewHighScores: (id) sender
{
	[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:1 scene:[HighScores scene]]];
}

-(void) onSettings: (id) sender
{
	[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:1 scene:[SettingsScene scene]]];
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
