//
//  CollisionManager.h
//  ballgame
//
//  Created by Ryan Hart on 7/15/11.
//  
//

#import "CollisionManager.h"

@implementation GameObjectCollision
@synthesize objectA=_objectA, objectB=_objectB;
-(id)initWithGameObjectA:(GameObject*)objectA andObjectB:(GameObject*)objectB{
    self = [super init];
    if (self){
        _objectA = [objectA retain];
        _objectB = [objectB retain];
    }
    return self;
}
-(BOOL)isEqual:(GameObjectCollision*)collision{
    if (self.objectA == collision.objectA && self.objectB == collision.objectB){
        return YES;
    }
    return NO;
}
-(BOOL)eitherObjectIsEqual:(GameObject*)objectToCompare{
    if (_objectA == objectToCompare || _objectB == objectToCompare){
        NSLog(@"One was equal");
        return YES;
    }
    return NO;
}
-(void)dealloc{
    [_objectA release];
    [_objectB release];
    [super dealloc];
}
@end


@interface CollisionManager ()

@end

@implementation CollisionManager

@synthesize collisionSet=_collisionSet;
-(id)init{
    self = [super init];
    if (self){
        _bridge = new ContactListenerBridge(self);
        _collisionSet = [[NSMutableSet alloc] initWithCapacity:10];
        _gameObjectToIgnoreContacts = [[NSMutableSet alloc] initWithCapacity:50];
    }
    return self;
}
-(void)addGameObjectToFilter:(GameObject*)object{
    [_gameObjectToIgnoreContacts addObject:object];
}

-(void)subscribeCollisionManagerToWorld:(b2World*)world{
    world->SetContactListener(_bridge);
}

-(void)beginContact:(b2Contact *)contact{
    
    b2Fixture *fixtureA = contact->GetFixtureA();
    b2Body *bodyA = fixtureA->GetBody();
    GameObject *gameObjectA = (GameObject*)bodyA->GetUserData();
    
    b2Fixture *fixtureB = contact->GetFixtureB();
    b2Body *bodyB = fixtureB->GetBody();
    GameObject *gameObjectB = (GameObject*)bodyB->GetUserData();
    
    //NSLog(@"Beginning contact: %i+%i", [gameObjectA identifier], [gameObjectB identifier]);
    GameObjectCollision *newCollision = [[GameObjectCollision alloc] initWithGameObjectA:gameObjectA andObjectB:gameObjectB];
    BOOL _collisionExists = NO;
    for (GameObjectCollision *collision in _collisionSet){
        if (![collision isEqual:newCollision]){
            
        }else{
            _collisionExists = YES;
            break;
        }
    }
    if (!_collisionExists){
        //NSLog(@"Adding collision: %i+%i", [gameObjectA identifier], [gameObjectB identifier]);
        [_collisionSet addObject:newCollision];
    }else{
        //This collision is already being tracked in our list.  No need to create another event.
    }
    
    [newCollision release];
}
-(void)endContact:(b2Contact *)contact{
    //NSLog(@"Ending Contact");
    b2Fixture *fixtureA = contact->GetFixtureA();
    b2Body *bodyA = fixtureA->GetBody();
    GameObject *gameObjectA = (GameObject*)bodyA->GetUserData();
    
    b2Fixture *fixtureB = contact->GetFixtureB();
    b2Body *bodyB = fixtureB->GetBody();
    GameObject *gameObjectB = (GameObject*)bodyB->GetUserData();
    
    GameObjectCollision *newCollision = [[GameObjectCollision alloc] initWithGameObjectA:gameObjectA andObjectB:gameObjectB];
    for (GameObjectCollision *collision in _collisionSet){
        if ([collision isEqual:newCollision]){
            //NSLog(@"Removing Collision");
            [_collisionSet removeObject:collision];
            break;
        }
    }
    [newCollision release];
}
-(void)preSolve:(b2Contact *)contact withManifold:(const b2Manifold *)manifold{
}
-(void)postSolve:(b2Contact *)contact withImpulse:(const b2ContactImpulse *)manifold{
}

-(void)dealloc{
    delete _bridge;
    [_collisionSet release];
    [_gameObjectToIgnoreContacts release];
    [super dealloc];
}

@end