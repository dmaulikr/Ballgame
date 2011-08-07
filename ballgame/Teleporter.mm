//
//  Teleporter.m
//  ballgame
//
//  Created by Ryan Hart on 8/6/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Teleporter.h"

@implementation Teleporter

@synthesize dependantObject=_dependantObject;
-(void)setupGameObject:(NSDictionary *)game_object forWorld:(b2World *)world{
    [super setupGameObject:game_object forWorld:world];
    
    _identifier = GameObjectIDTeleporter;
    
    
    //SHARED CODE WITH SWITCH
    CGSize size;
    size.width = [[game_object valueForKey:@"width"] floatValue];
    size.height = [[game_object valueForKey:@"height"] floatValue];
    CGPoint p;
    p.x = [[game_object valueForKey:@"x"] floatValue];
    p.y = [[game_object valueForKey:@"y"] floatValue];
    
    _dependantObjectName = [game_object valueForKey:@"dependant_object_name"];
    
    [self rescale:CGSizeMake(size.width, size.height)];
    
    b2BodyDef bodyDef;
	bodyDef.position.Set((p.x) /PTM_RATIO , (p.y ) /PTM_RATIO );
	bodyDef.userData = self;
	_body = world->CreateBody(&bodyDef);
	_body->SetAwake(NO);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
    
	dynamicBox.SetAsBox(size.width/PTM_RATIO/2 ,size.height/2/PTM_RATIO);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
    fixtureDef.isSensor = YES;
	fixtureDef.density = 0.0f;
	fixtureDef.friction = 0.3f;
    _body->CreateFixture(&fixtureDef);
    //SHARED CODE WITH SWITCH
}

-(void)handleCollisionWithObject:(GameObject *)object{
    [super handleCollisionWithObject:object];
    
    if ([object identifier] == GameObjectIDPlayer){
        if (! _disableCollisionsFromRecentTeleport && !_isReceiver ) {
            //We should teleport the player since we're not disabled and not a receiver
            
            [_dependantObject teleportPlayer:(Player*)object];
        }
    }
    
}

-(void)noLongerCollidingWithObject:(GameObject*)object{
    [super noLongerCollidingWithObject:object];
    
    if (_disableCollisionsFromRecentTeleport && [object identifier] == GameObjectIDPlayer){
        _disableCollisionsFromRecentTeleport = NO;
    }
    
}

-(void)teleportPlayer:(Player *)player{
    _disableCollisionsFromRecentTeleport = YES;
    b2Vec2 b2Position = b2Vec2(self.position.x/PTM_RATIO,
                               self.position.y/PTM_RATIO);
    b2Body *body = [player body];
    body->SetTransform(b2Position, 0);
}

-(NSString*)getDependantObjectName{
    return _dependantObjectName;
}
@end
