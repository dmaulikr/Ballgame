//
//  SplashScreen.m
//  ballgame
//
//  Created by Ryan Hart on 7/17/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "SplashScene.h"
#import "PlayScene.h"
#import "SettingsScene.h"
#import "DebugConfigurationViewController.h"
#import "AppDelegate.h"

@implementation SplashScene
+(CCScene*)scene{
    CCScene *scene = [CCScene node];
    SplashScene *layer = [SplashScene node];
    [layer loadScene];
    [scene addChild:layer];
    
    return scene;
}

-(void)loadScene{
    
    // Start background music if necessary
    if([AssetManager settingsMusicOn])
        [self startBackgroundMusic];
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    CCMenuItem *_playItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Play" fontName:@"Arial" fontSize:32.0] target:self selector:@selector(playTapped:)];
    [_playItem setPosition:ccp(s.width / 2, s.height * 3/4)];
    CCMenuItem *_debugItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Debug" fontName:@"Arial" fontSize:32.0] target:self selector:@selector(debugTapped:)];
    [_debugItem setPosition:ccp(s.width / 2, s.height * 2/4)];
    CCMenuItem *_settingsItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Settings" fontName:@"Arial" fontSize:32.0] target:self selector:@selector(settingsTapped:)];
    [_settingsItem setPosition:ccp(s.width / 2, s.height * 1/4)];
    
    CCMenu *_menu = [CCMenu menuWithItems:_playItem,_debugItem,_settingsItem, nil];
    [_menu setPosition:ccp(0,0)];
    [self addChild:_menu];
    
    
}
-(void)playTapped:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[PlayScene currentLevelScene]];
}
-(void)debugTapped:(id)sender{
    [[CCDirector sharedDirector] pause];
    DebugConfigurationViewController *dbvc = [[DebugConfigurationViewController alloc] initWithStyle:UITableViewStylePlain];
    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] navController] pushViewController:dbvc animated:NO];
    //[[(AppDelegate*)[[UIApplication sharedApplication] delegate] navController] setNavigationBarHidden:YES];
    [dbvc release];
}

-(void) settingsTapped:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[SettingsScene scene]];
}

-(void) startBackgroundMusic
{
    SimpleAudioEngine *audio = [SimpleAudioEngine sharedEngine];
    
    if(![audio isBackgroundMusicPlaying])
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:BACKGROUND_MUSIC ofType:@"mp3"];
        [audio playBackgroundMusic:path];
    }
    
}

@end
