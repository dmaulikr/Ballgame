//
//  Gate.m
//  ballgame
//
//  Created by Ryan Hart on 7/30/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Gate.h"

@implementation Gate
@synthesize isLocked=_isLocked;

-(void)setupGameObject:(NSDictionary *)game_object forWorld:(b2World *)world{
    [super setupGameObject:game_object forWorld:world];
    
    _identifier = GameObjectIDGate;
}


-(void)switchStateChanged:(BOOL)isOn{
    if (isOn){
        //Our switch was turned on.  We should shut down...
        //NSLog(@"Gate shutting down");
        self.visible = NO;
        _body->SetActive(NO);
        
    }
}
@end
