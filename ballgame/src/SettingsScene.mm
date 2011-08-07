//
//  SettingsScene.m
//  ballgame
//
//  Created by Ryan Hart on 7/17/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "SplashScene.h"
#import "SettingsScene.h"

@implementation SettingsScene

+(CCScene*)scene{
    CCScene *scene = [CCScene node];
    SettingsScene *layer = [SettingsScene node];
    [layer loadScene];
    [scene addChild:layer];
    
    return scene;
}

-(void)loadScene{
        
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    // labels set to "error" because they're about to be overwritten in [self updateMenu]
    _musicItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Error" fontName:@"Arial" fontSize:32.0] target:self selector:@selector(musicTapped:)];
    [_musicItem setPosition:ccp(s.width / 2, s.height * 4/5)];
    _effectsItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Error" fontName:@"Arial" fontSize:32.0] target:self selector:@selector(effectsTapped:)];
    [_effectsItem setPosition:ccp(s.width / 2, s.height * 3/5)];
    _backItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Back to Main Menu" fontName:@"Arial" fontSize:32.0] target:self selector:@selector(backTapped:)];
    [_backItem setPosition:ccp(s.width / 2, s.height * 1/5)];
    
    CCMenu *_menu = [CCMenu menuWithItems:_musicItem, _effectsItem, _backItem, nil];
    [_menu setPosition:ccp(0,0)];
    [self addChild:_menu];
    
    [self updateMenu];
}

-(void) updateMenu
{
    // Load settings
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool musicOn = [prefs boolForKey:@"soundMusicOn"];
    bool effectsOn = [prefs boolForKey:@"soundEffectsOn"];
    
    // Prepare strings for display
    NSString *musicString = [NSString stringWithString:@"Off"];
    if(musicOn)
        musicString = [NSString stringWithString:@"On"];
    musicString = [NSString stringWithFormat:@"Music - %@", musicString];
    
    NSString *effectsString = [NSString stringWithString:@"Off"];
    if(effectsOn)
        effectsString = [NSString stringWithString:@"On"];
    effectsString = [NSString stringWithFormat:@"Sound Effects - %@", effectsString];
    
    // Update menu labels
    [_musicItem setLabel:[CCLabelTTF labelWithString:musicString fontName:@"Arial" fontSize:32.0]];
    [_effectsItem setLabel:[CCLabelTTF labelWithString:effectsString fontName:@"Arial" fontSize:32.0]];
    
}

-(void) musicTapped:(id)sender
{
    // Toggle music in NSUserDefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool musicOn = [prefs boolForKey:@"soundMusicOn"];
    musicOn = !musicOn;
    [prefs setBool:musicOn forKey:@"soundMusicOn"];
    
    // Toggle music
    if(musicOn)
    {
        [self startBackgroundMusic];
    }
    else
    {
        [self stopBackgroundMusic];
    }
    
    [self updateMenu];
}

-(void) startBackgroundMusic
{
    SimpleAudioEngine *audio = [SimpleAudioEngine sharedEngine];

    NSString *path = [[NSBundle mainBundle] pathForResource:BACKGROUND_MUSIC ofType:@"mp3"];
    [audio playBackgroundMusic:path];

}

-(void) stopBackgroundMusic
{
    SimpleAudioEngine *audio = [SimpleAudioEngine sharedEngine];
    
    [audio stopBackgroundMusic];
}

-(void) effectsTapped:(id)sender
{
    // Toggle effects in NSUserDefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool effectsOn = [prefs boolForKey:@"soundEffectsOn"];
    effectsOn = !effectsOn;
    [prefs setBool:effectsOn forKey:@"soundEffectsOn"];
    
    [self updateMenu];
}

-(void) backTapped:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[SplashScene scene]];
}

@end
