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
    NSDictionary *_objectInfo;
    
    //Game State Info
    NSMutableArray *_effects;
    
    //Physics Info
    b2Body *_body; //I have a body!
    GameObjectID _identifier;
    
    CGSize originalSize;
    
    // Stores whether fixtureDef.isSensor should be set while creating b2fixture.
    // Default is no, but is overridden to yes for switches
    bool isSensor;
    
    // Moveable objects functionality
    bool isMoveable;
    NSMutableArray *positionPoints;
}
@property (readonly) GameObjectID identifier;
@property (readwrite) b2Body *body;
@property (readonly) CGSize size;

-(NSString*)name;
-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world;

// Setup functions
-(void) setupSprite;
-(void) setupBody:(b2World*) world;

// Sync position of sprite to match box2d object.  Subclasses may override this to do this opposite.
-(void)syncPosition;

-(b2Vec2)getVelocity;
-(b2Body*) getBody;

-(void)handleCollisionWithObject:(GameObject*)object;
-(void)noLongerCollidingWithObject:(GameObject*)object;
-(void)updateGameObject:(ccTime)dt;

// Rescale object based on given size
-(void) rescale:(CGSize) size;

// For Moveable Objects
-(void) setupMoveable;
// helper function
-(id) actionMutableArray: (NSMutableArray*) _actionList;

@end
