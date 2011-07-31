//
//  Wall.m
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//  Copyright 2011 __myCompanyName__. All rights reserved.
//

#import "Wall.h"

@implementation Wall

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
//TODO: Rotation
    [super setupGameObject:game_object forWorld:world];
    _identifier = GameObjectIDWall;
    
    CGSize size;
    size.width = [[game_object valueForKey:@"width"] floatValue];
    size.height = [[game_object valueForKey:@"height"] floatValue];
    CGPoint p;
    p.x = [[game_object valueForKey:@"x"] floatValue];
    p.y = [[game_object valueForKey:@"y"] floatValue];
    self.position = ccp( p.x * 2,p.y * 2);

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
	fixtureDef.density = 0.0f;
	fixtureDef.friction = 0.3f;
	_body->CreateFixture(&fixtureDef);
   
}

@end
