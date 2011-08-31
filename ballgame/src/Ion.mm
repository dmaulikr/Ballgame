//
//  Ion.m
//  ballgame
//
//  Created by Alexei Gousev on 8/14/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "Ion.h"
#import "AssetManager.h"

@implementation Ion

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{

    [super setupGameObject:game_object forWorld:world];
    
    _identifier = GameObjectIDIon; 
}

-(void) setupSprite
{
    // Get ion diameter from a combination of object plist and game defaults
    int ionSize = [[_objectInfo valueForKey:GO_ION_SIZE_KEY] intValue];
    //HARDCODE - This is Gross.  Lets not do this
    int diameter = [[[[[AssetManager defaults] objectForKey:@"ion_config"] objectAtIndex:ionSize] objectForKey:@"diameter"] intValue];
    
    // Overwrite whatever (if anything) was in the object plist
    objectSize.height = diameter;
    objectSize.width = diameter;
    
    [super setupSprite];
}

-(void) setupBody:(b2World *)world
{
    // Get ion diameter from a combination of object plist and game defaults
    int ionSize = [[_objectInfo valueForKey:GO_ION_SIZE_KEY] intValue];
    //HARDCODE - This is Gross.  Lets not do this.
    int diameter = [[[[[AssetManager defaults] objectForKey:@"ion_config"] objectAtIndex:ionSize] objectForKey:@"diameter"] intValue];
    
    // Overwrite whatever (if anything) was in the object plist
    objectSize.height = diameter;
    objectSize.width = diameter;
    
    [super setupBody:world];
}

-(void)wasPickedUpByPlayer:(Player*)player
{
    // Get ion diameter from a combination of object plist and game defaults
    int ionSize = [[_objectInfo valueForKey:GO_ION_SIZE_KEY] intValue];
    //HARDCODE - This is Gross.  Lets not do this.
    int chargeDec = [[[[[AssetManager defaults] objectForKey:@"ion_config"] objectAtIndex:ionSize] objectForKey:@"charge_decrement"] intValue];
    
    // Update player size
    player.chargeLevel -= chargeDec;
    
    // Make sure we're not negative
    if(player.chargeLevel < 0)
        player.chargeLevel = 0;

}

@end
