//
//  ContactListenerBridge.cpp
//  ballgame
//
//  Created by Ryan Hart on 7/15/11.
//  
//

#include "ContactListenerBridge.h"
#import "CollisionManager.h"

ContactListenerBridge::ContactListenerBridge(void* collisionManager){
    _collisionManager = collisionManager;
}


void ContactListenerBridge::BeginContact(b2Contact* contact){
    //DO NOT IMPLEMENT ANYTHING ELSE HERE.  THIS IS CALLING UP TO OUR OBJECTIVE-C CLASS
    //WHERE WE KNOW MORE ABOUT THE WORLD.  THIS CLASS EXISTS ONLY AS A BRIDGE FROM C++->OBJECTIVE-C
    [(CollisionManager*)_collisionManager beginContact:contact];
}

void ContactListenerBridge::EndContact(b2Contact* contact){
    //DO NOT IMPLEMENT ANYTHING ELSE HERE.  THIS IS CALLING UP TO OUR OBJECTIVE-C CLASS
    //WHERE WE KNOW MORE ABOUT THE WORLD.  THIS CLASS EXISTS ONLY AS A BRIDGE FROM C++->OBJECTIVE-C
    [(CollisionManager*)_collisionManager endContact:contact];
}

void ContactListenerBridge::PreSolve(b2Contact* contact, const b2Manifold* oldManifold){
    //DO NOT IMPLEMENT ANYTHING ELSE HERE.  THIS IS CALLING UP TO OUR OBJECTIVE-C CLASS
    //WHERE WE KNOW MORE ABOUT THE WORLD.  THIS CLASS EXISTS ONLY AS A BRIDGE FROM C++->OBJECTIVE-C
    [(CollisionManager*)_collisionManager preSolve:contact withManifold:oldManifold];
}

void ContactListenerBridge::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse){
    //DO NOT IMPLEMENT ANYTHING ELSE HERE.  THIS IS CALLING UP TO OUR OBJECTIVE-C CLASS
    //WHERE WE KNOW MORE ABOUT THE WORLD.  THIS CLASS EXISTS ONLY AS A BRIDGE FROM C++->OBJECTIVE-C
    [(CollisionManager*)_collisionManager postSolve:contact withImpulse:impulse];
}