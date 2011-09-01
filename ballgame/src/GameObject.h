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


typedef enum {
    GameObjectIDNone,
    GameObjectIDPlayer,
    GameObjectIDWall,
    GameObjectIDObstacle,
    GameObjectIDGoal,
    GameObjectIDPickup,
    GameObjectIDSwitch,
    GameObjectIDGate,
    GameObjectIDChargedWall,
    GameObjectIDTeleporter,
    GameObjectIDIon,
    GameObjectIDCollectible,
    GameObjectIDBumper,
    GameObjectIDGravityWell,
    GameObjectIDChaser
} GameObjectID;

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
    b2World *_world;
    
    CGSize originalSize;
    
    // Stores whether fixtureDef.isSensor should be set while creating b2fixture.
    // Default is no, but is overridden to yes for switches
    bool isSensor;
    
    // Used only for ions at the moment, but could be used for other stuff later.
    CGSize objectSize;
    
    // Moveable objects functionality
    bool isMoveable;
    NSMutableArray *positionPoints;
    
    // This is checked at the end of each game loop to see if this object needs to go away
    bool flaggedForDeletion;
}
@property (readonly) GameObjectID identifier;
@property (readwrite) b2Body *body;
@property (readonly) bool flaggedForDeletion;

-(NSString*)name;
-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world;
-(void)removeFromWorld;

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


extern NSString* const GO_NAME_KEY;
extern NSString* const GO_TYPE_KEY;
extern NSString* const GO_FRAME_NAME_KEY;
extern NSString* const GO_ROTATION_KEY;
extern NSString* const GO_WIDTH_KEY;
extern NSString* const GO_HEIGHT_KEY;
extern NSString* const GO_POSITIONS_KEY;
extern NSString* const GO_X_KEY;
extern NSString* const GO_Y_KEY;
extern NSString* const GO_DURATION_KEY;
extern NSString* const GO_MAX_CHARGE_KEY;
extern NSString* const GO_CHARGE_PER_SEC_KEY;
extern NSString* const GO_SPEED_KEY;
extern NSString* const GO_CHARGE_INCR_KEY;
extern NSString* const GO_DEP_OBJECT_KEY;
extern NSString* const GO_POWER_KEY;
extern NSString* const GO_ION_SIZE_KEY;




