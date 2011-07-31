//
//  Goal.m
//  ballgame
//
//  Created by Ryan Hart on 7/16/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Goal.h"

@implementation Goal

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    //TODO: Rotation
    [super setupGameObject:game_object forWorld:world];
    
    _identifier = GameObjectIDGoal;
    
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
	bodyDef.position.Set((p.x) /PTM_RATIO, (p.y) /PTM_RATIO);
	bodyDef.userData = self;
	_body = world->CreateBody(&bodyDef);
	_body->SetAwake(NO);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
    
	dynamicBox.SetAsBox(size.width/PTM_RATIO/2 ,size.height/PTM_RATIO/2);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 0.0f;
	fixtureDef.friction = 0.3f;
	_body->CreateFixture(&fixtureDef);
    
}

@end
