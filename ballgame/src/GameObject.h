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
#import "Effect.h"


@protocol DependantObject
@property (nonatomic, retain) id dependantObject;
-(NSString*)getDependantObjectName;
@end

@interface GameObject : CCSprite <NSCopying> {
    
    NSDictionary *defaults;
    NSDictionary *_objectInfo;
    
    //Game State Info
    NSMutableArray *_effects;
    
    //Physics Info
    b2Body *_body; //I have a body!
    GameObjectID _identifier;
}
@property (readonly) GameObjectID identifier;
@property (readwrite) b2Body *body;
@property(nonatomic, retain) NSDictionary *defaults;

-(NSString*)name;
-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world;
-(b2Vec2)getVelocity;
-(void)handleCollisionWithObject:(GameObject*)object;
-(void)noLongerCollidingWithObject:(GameObject*)object;
-(void)updateGameObject:(ccTime)dt;
@end
