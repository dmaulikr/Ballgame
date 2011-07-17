//
//  SettingsScene.m
//  BallGame
//
//  Created by Alexei Gousev on 12/22/09.
//  Copyright 2009 UC Davis. All rights reserved.
//

#include <stdlib.h>
#include "SettingsScene.h"
#include "MainMenuScene.h"
#include "MainGameScene.h"
#include "HighScoresScene.h"
#include "SimpleAudioEngine.h"

@implementation SettingsScene

+(id) scene
{
	// 'scene' is an autorelease object.
	Scene *scene = [Scene node];
	
	// 'layer' is an autorelease object.
	SettingsScene *layer = [SettingsScene node];
	
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
		
		NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
		
		[MenuItemFont setFontName: @"American Typewriter"];
		[MenuItemFont setFontSize:18];
		MenuItemFont *title1 = [MenuItemFont itemFromString: @"Difficulty"];
		[title1 setIsEnabled:NO];
		[MenuItemFont setFontName: @"Marker Felt"];
		[MenuItemFont setFontSize:34];
		MenuItemToggle *item1 = [MenuItemToggle itemWithTarget:self selector:@selector(changeDifficulty:) items:
								   [MenuItemFont itemFromString: @"Easy"],
								   [MenuItemFont itemFromString: @"Medium"],
								   [MenuItemFont itemFromString: @"Hard"],
								   [MenuItemFont itemFromString: @"Impossible"],								 
								   nil];
		
		[item1 setSelectedIndex:[settings integerForKey:@"Difficulty"]];
		
		[MenuItemFont setFontName: @"American Typewriter"];
		[MenuItemFont setFontSize:18];
		MenuItemFont *title2 = [MenuItemFont itemFromString: @"Sound"];
		[title2 setIsEnabled:NO];
		[MenuItemFont setFontName: @"Marker Felt"];
		[MenuItemFont setFontSize:34];
		MenuItemToggle *item2 = [MenuItemToggle itemWithTarget:self selector:@selector(changeSound:) items:
								   [MenuItemFont itemFromString: @"Off"],
								   [MenuItemFont itemFromString: @"On"],
								   nil];
		[item2 setSelectedIndex:[settings boolForKey:@"Sound"]];
		
		
		[MenuItemFont setFontName: @"Marker Felt"];
		[MenuItemFont setFontSize:34];
		
		BitmapFontAtlas *label = [BitmapFontAtlas bitmapFontAtlasWithString:@"go back" fntFile:@"bitmapFontTest3.fnt"];
		MenuItemLabel *back = [MenuItemLabel itemWithLabel:label target:self selector:@selector(onReturn:)];
		
		MenuItemFont *blank = [MenuItemFont itemFromString: @" "];
		
		Menu *menu = [Menu menuWithItems:
						title1, title2,
						item1, item2, blank,
						back, nil]; // 9 items.
		
		
		[menu alignItemsInColumns:
		 [NSNumber numberWithUnsignedInt:2],
		 [NSNumber numberWithUnsignedInt:2],
		 [NSNumber numberWithUnsignedInt:1],
		 [NSNumber numberWithUnsignedInt:1],
		 nil
		 ]; // 2 + 2 + 2 + 2 + 1 = total count of 9.
		 
		
		//[menu alignItemsVertically];
		
		[self addChild: menu];		
	}
	
	return self;
}

-(void) changeDifficulty: (id) sender
{
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[settings setInteger:[sender selectedIndex] forKey:@"Difficulty"];
	
	NSLog(@"selected item: %@ index:%d", [sender selectedItem], [sender selectedIndex] );
}

-(void) changeSound: (id) sender
{
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[settings setBool:[sender selectedIndex] forKey:@"Sound"];
	NSLog(@"selected item: %@ index:%d", [sender selectedItem], [sender selectedIndex] );
	
	SimpleAudioEngine *audio = [SimpleAudioEngine sharedEngine];
	audio.muted = ![sender selectedIndex];
	
	[audio stopBackgroundMusic];
	
	if([settings boolForKey:@"Sound"])
	{
		NSString *baseDirectory = [NSString string];
		baseDirectory = NSHomeDirectory();
		baseDirectory = [baseDirectory stringByAppendingString:@"/BallGame.app/"];
		NSString *filename = [baseDirectory stringByAppendingString:@"Game1.mp3"];
		
		[audio playBackgroundMusic:filename];
	}
}

-(void) onReturn: (id) sender
{
	[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:1 scene:[MainMenu scene]]];
}



@end
