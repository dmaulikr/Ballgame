//
//  SceneCamera.h
//  ballgame
//
//  Created by Ryan Hart on 9/1/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SceneCamera : NSObject{
    // Set to true if scrollToX:Y: was called, but hasn't finished animating yet.
    bool scrollNodeAnimated;
    
    // Default is 1, > 1 means zoomed in, < 1 means zoomed out
    float currentZoomLevel;
}
@property (nonatomic, retain) CCLayer *scrollNode;
@property (nonatomic, retain) CCNode *worldLayer;

//Give us the world that our camera is watching and we will give you the power of sight
- (id)initWithWorldLayer:(CCNode*)worldLayer andTag:(NSInteger)tag;

//Centers the position of the camera on this location.  The location should be in world coordinates.
//This method returns NO if it fails to set the position because the camera is currently animating
-(BOOL)setPosition:(CGPoint)worldPosition;
//Returns the position of the scroll node in world coordinates.
-(CGPoint)position;

// Scroll camera to given point in world coordinates
-(void) scrollToX:(int)x Y:(int)y withDuration:(ccTime)duration;

// General method
-(void) zoomToScale:(float)zoom withDuration:(ccTime) duration;

@end
