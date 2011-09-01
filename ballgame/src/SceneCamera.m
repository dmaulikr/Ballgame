//
//  SceneCamera.m
//  ballgame
//
//  Created by Ryan Hart on 9/1/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "SceneCamera.h"

@interface SceneCamera ()
-(void)animationCompleted;
@end

@implementation SceneCamera

@synthesize scrollNode=_scrollNode, worldLayer=_worldLayer;

- (id)initWithWorldLayer:(CCNode*)worldLayer andTag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        // Initialization code here.
        scrollNodeAnimated = false;
        currentZoomLevel = 1.0f;
        self.scrollNode = [CCLayer node];
        self.worldLayer = worldLayer;
        [self.scrollNode setTag:tag];
        [self.scrollNode addChild:worldLayer];
        
    }
    
    return self;
}


-(BOOL)setPosition:(CGPoint)worldPosition{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    if (!scrollNodeAnimated){
        [self.scrollNode setPosition:CGPointMake(-worldPosition.x + screenSize.width/2 , -worldPosition.y + screenSize.height/2  )];
        return YES;
    }
    return NO;
}

-(CGPoint)position{
    CGSize screenSize = [CCDirector sharedDirector].winSize;    
    return CGPointMake(-self.scrollNode.position.x - (screenSize.width/2), -self.scrollNode.position.y - (screenSize.height/2));
}

#pragma mark - Scroll and Zoom

-(void) scrollToX:(int)x Y:(int)y withDuration:(ccTime)duration
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    id action = [CCMoveTo actionWithDuration:duration position:CGPointMake(-x + winSize.width/2, -y + winSize.height/2)];
    [self.scrollNode runAction:action];
    [NSTimer timerWithTimeInterval:duration target:self selector:@selector(animationCompleted) userInfo:nil repeats:NO];
    // Make sure we don't follow the player for now
    scrollNodeAnimated = true;
}

-(void) zoomToScale:(float)zoom withDuration:(ccTime)duration
{
    id action = [CCScaleTo actionWithDuration:duration scale:zoom];
    [self.scrollNode runAction:action];
    [NSTimer timerWithTimeInterval:duration target:self selector:@selector(animationCompleted) userInfo:nil repeats:NO];
    
    currentZoomLevel = zoom;
}

-(void)animationCompleted{
    scrollNodeAnimated = false;
}
//-(void) zoomToNormalWithDuration:(ccTime)duration
//{
//    [self zoomToScale:1.0 withDuration:duration];
//    
//    // Recenter on the player
//    [self scrollToPlayerWithDuration:duration];
//}

//-(void) zoomToFullLevelWithDuration:(ccTime)duration
//{
//    // Figure out horizontal and vertical components of zoom
//    CGSize winSize = [CCDirector sharedDirector].winSize;
//    float vertZoom = winSize.height / [[_levelInfo valueForKey:LEVEL_HEIGHT_KEY] floatValue];
//    float horZoom = winSize.width / [[_levelInfo valueForKey:LEVEL_WIDTH_KEY] floatValue];
//    
//    // Take the smaller (more zoomed out) of the two
//    float zoom = vertZoom;
//    if(horZoom < vertZoom)
//        zoom = horZoom;
//    
//    // Figure out where we're scrolling to
//    float scroll = [[_levelInfo valueForKey:LEVEL_WIDTH_KEY] floatValue]/2 - winSize.width/2;
//    if(vertZoom == zoom)
//        scroll = [[_levelInfo valueForKey:LEVEL_HEIGHT_KEY] floatValue]/2 - winSize.height/2;
//    
//    // Zoom to that level
//    [self zoomToScale:zoom withDuration:duration];
//    
//    // Make sure we are centered on the level
//    [self scrollToX:scroll Y:scroll withDuration:duration];
//}

-(void)dealloc{
    [self.worldLayer removeFromParentAndCleanup:YES];
    [super dealloc];
}
@end
