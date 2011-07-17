//
//  GameObject.h
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//  
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "DataDefinitions.h"

typedef enum{
    LevelStatusStarted,
    LevelStatusCompleted
} LevelStatus;

@interface GameObject : CCSprite <NSCopying> {
    
    NSDictionary *defaults;
    
    //Physics Info
    b2Body *_body; //I have a body!
    b2Fixture *_currentFixture; //I have a .... fixture?
}
@property (readwrite) b2Body *body;
@property (readwrite) b2Fixture *currentFixture;
@property(nonatomic, retain) NSDictionary *defaults;

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world;
-(b2Vec2)getVelocity;
-(void)handleCollisionWithObject:(GameObject*)object;
-(void)noLongerCollidingWithObject:(GameObject*)object;
@end
