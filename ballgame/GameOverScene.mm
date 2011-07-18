//
//  GameOverScene.m
//  ballgame
//
//  Created by Ryan Hart on 7/17/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "GameOverScene.h"
#import "PlayScene.h"


@interface GameOverScene ()

-(void)restartTapped:(id)sender;

@end

@implementation GameOverScene

-(void)loadScene{
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    _gameOverLabel = [[CCLabelTTF labelWithString:@"Game Over" fontName:@"Arial" fontSize:32.0] retain];
    _gameOverLabel.position = ccp(winSize.width * .4, winSize.height * .2);
    [self addChild:_gameOverLabel];
    

    CCMenuItem *_menuItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Restart" fontName:@"Arial" fontSize:32.0] target:self selector:@selector(restartTapped:)];
    
    CCMenu *_menu = [CCMenu menuWithItems:_menuItem, nil];
    [_menu setPosition:ccp(100,100)];
    [_menu setColor:ccc3(255, 255, 255)];
    [self addChild:_menu];
    
    //[self addChild:_restartItem];
}
-(void)restartTapped:(id)sender{
    NSLog(@"Tapped");
    [[CCDirector sharedDirector] replaceScene:[PlayScene debugScene]];
}
                            
+(CCScene *) scene{
    CCScene *scene = [CCScene node];
    GameOverScene *layer = [GameOverScene node];
    [layer loadScene];
    [scene addChild:layer];
    
    return scene;
}

-(void)dealloc{
    
    [super dealloc];
}
@end
