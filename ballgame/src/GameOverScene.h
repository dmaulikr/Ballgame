//
//  GameOverScene.h
//  ballgame
//
//  Created by Ryan Hart on 7/17/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverScene : CCLayer {
    CCLabelTTF *_gameOverLabel;
}
+(CCScene *) scene;
-(void)loadScene;
@end
