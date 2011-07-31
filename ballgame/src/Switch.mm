//
//  Switch.m
//  ballgame
//
//  Created by Ryan Hart on 7/28/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Switch.h"

@implementation Switch
@synthesize  maxCharge=_maxCharge, dependantObject=_dependant_object;

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    //TODO: Rotation
    _identifier = GameObjectIDSwitch;
    
    CGSize size;
    size.width = [[game_object valueForKey:@"width"] floatValue];
    size.height = [[game_object valueForKey:@"height"] floatValue];
    CGPoint p;
    p.x = [[game_object valueForKey:@"x"] floatValue];
    p.y = [[game_object valueForKey:@"y"] floatValue];
    
    //Switches start uncharged
    _charge = 0.0;
    
    _maxCharge = [[game_object valueForKey:@"max_charge"] floatValue];
    _chargePerSecond = [[game_object valueForKey:@"charge_per_second"] floatValue];
    
    _depObjectName = [game_object valueForKey:@"dependant_object_name"];
    
    CGSize originalSize = [self contentSize];
    float originalWidth = originalSize.width;
    float originalHeight = originalSize.height;
    
    // TODO:  put start size in level and move this to the player class
    float newScaleX = (float)(size.width) / originalWidth;
    float newScaleY = (float)(size.height) / originalHeight;
    [self setScaleX:newScaleX];
    [self setScaleY:newScaleY];
    [self setColor:ccRED];
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
    
}

-(void)updateGameObject:(ccTime)dt{
    //NSLog(@"Update");
    if (_charging && _charge < _maxCharge){
        float deltaCharge = _chargePerSecond * dt;
        if ([_thePlayer chargeLevel] >= deltaCharge){
            NSLog(@"Siphoning %1.2f charge from the player.", deltaCharge);
            [_thePlayer setChargeLevel:[_thePlayer chargeLevel] - deltaCharge];
            _charge += deltaCharge;
        }
        //NSLog(@"charge: %1.2f", _charge);
    }
    
    if (_charge >= _maxCharge && !_activated){
        [self setColor:ccGREEN];
        [_dependant_object switchStateChanged:YES]; 
        _activated = YES;
        
    }
}

-(void)handleCollisionWithObject:(GameObject *)object{
    [super handleCollisionWithObject:object];
    if ([object identifier] == GameObjectIDPlayer){
        NSLog(@"Charging");
        _charging = YES;
        _thePlayer = (Player*)object;
        //[_thePlayer setShouldCharge:NO];
    }
}

-(void)noLongerCollidingWithObject:(GameObject *)object{
    [super noLongerCollidingWithObject:object];
    if ([object identifier] == GameObjectIDPlayer){
        NSLog(@"Not Charging");
        _charging = NO;
        _thePlayer = nil;
        //[_thePlayer setShouldCharge:YES];
    }
    
   
}

-(NSString*)getDependantObjectName{
    return _depObjectName;
}

-(void)dealloc{
    [_thePlayer release];
    [super dealloc];
}

@end
