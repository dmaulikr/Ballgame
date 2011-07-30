//
//  HorseshoeWall.m
//  ballgame
//
//  Created by Ryan Hart on 7/23/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "HorseshoeWall.h"

@implementation HorseshoeWall

-(void)handleCollisionWithObject:(GameObject*)object{
    NSLog(@"%@ ran into a %@", NSStringFromClass([self class]), NSStringFromClass([object class]));
}

-(void)noLongerCollidingWithObject:(GameObject*)object{
    NSLog(@"%@ moved away from %@",NSStringFromClass([self class]), NSStringFromClass([object class]));
}

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    //This does nothing.  Subclasses override this for custom initialization
    _identifier = GameObjectIDObstacle;
    
    CGSize size;
    size.width = [[game_object valueForKey:@"width"] floatValue];
    size.height = [[game_object valueForKey:@"height"] floatValue];
    CGPoint p;
    p.x = [[game_object valueForKey:@"x"] floatValue];
    p.y = [[game_object valueForKey:@"y"] floatValue];
    
    
    CGSize originalSize = [self contentSize];
    //NSLog(@"Content Size %f, %f", originalSize.width, originalSize.height);
    float originalWidth = originalSize.width;
    float originalHeight = originalSize.height;
    
    // TODO:  put start size in level and move this to the player class
    float newScaleX = (float)(size.width) / originalWidth;
    float newScaleY = (float)(size.height) / originalHeight;
    //NSLog(@"newScaleX: %f, newScaleY: %f", newScaleX, newScaleY);
    [self setScaleX:newScaleX];
    [self setScaleY:newScaleY];
    
    
    b2BodyDef bodyDef;
	bodyDef.position.Set((p.x) /PTM_RATIO , (p.y ) /PTM_RATIO );
	bodyDef.userData = self;
	_body = world->CreateBody(&bodyDef);
	_body->SetAwake(NO);
	
	// Define another box shape for our dynamic body.
    
//Define the base
	b2PolygonShape base;
    
	base.SetAsBox(size.width/PTM_RATIO/2 , .2* size.height/2/PTM_RATIO);
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &base;	
	fixtureDef.density = 0.0f;
	fixtureDef.friction = 0.3f;
	_currentFixture = _body->CreateFixture(&fixtureDef);
    
//Define the left side
//    b2PolygonShape right;
//    right.SetAsBox(.2* size.width/PTM_RATIO/2, size.height/2/PTM_RATIO);
//    
//    b2FixtureDef rightFixtureDef;
//    fixtureDef.shape = &right;
//    fixture
    
//Define the right side
}
@end
