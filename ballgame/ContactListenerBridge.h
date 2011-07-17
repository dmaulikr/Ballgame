//
//  ContactListenerBridge.h
//  ballgame
//
//  Created by Ryan Hart on 7/15/11.
//  
//

#import "Box2D.h"
//DO NOT IMPLEMENT ANYTHING ELSE HERE.  THIS IS CALLING UP TO OUR OBJECTIVE-C CLASS
//WHERE WE KNOW MORE ABOUT THE WORLD.  THIS CLASS EXISTS ONLY AS A BRIDGE FROM C++->OBJECTIVE-C
class ContactListenerBridge : public b2ContactListener{
public:
    
    void BeginContact(b2Contact* contact);
    
    void EndContact(b2Contact* contact);
    
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
    
    ContactListenerBridge(void* collisionManager);
    
    //Data
    
    void *_collisionManager;
    
};