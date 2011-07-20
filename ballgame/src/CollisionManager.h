//
//  CollisionManager.h
//  ballgame
//
//  Created by Ryan Hart on 7/15/11.
//  
//
#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "ContactListenerBridge.h"
#import "GameObjects.h"
#import "NSSetDifference.h"

@interface GameObjectCollision : NSObject {
@private
    GameObject *_objectA;
    GameObject *_objectB;
}
@property (readonly) GameObject *objectA;
@property (readonly) GameObject *objectB;
-(id)initWithGameObjectA:(GameObject*)objectA andObjectB:(GameObject*)objectB;
-(BOOL)eitherObjectIsEqual:(GameObject*)objectToCompare;
-(BOOL)isEqual:(GameObjectCollision*)collision;
@end


@interface CollisionManager : NSObject{
    
@private
    ContactListenerBridge *_bridge;
    NSMutableSet *_collisionSet;
    NSMutableSet *_gameObjectToIgnoreContacts;
}
@property (nonatomic, retain) NSSet *collisionSet;

-(void)addGameObjectToFilter:(GameObject*)object;
-(void)subscribeCollisionManagerToWorld:(b2World*)world;
-(void)beginContact:(b2Contact *)contact;
-(void)endContact:(b2Contact *)contact;
-(void)preSolve:(b2Contact *)contact withManifold:(const b2Manifold *)manifold;
-(void)postSolve:(b2Contact *)contact withImpulse:(const b2ContactImpulse *)manifold;
@end