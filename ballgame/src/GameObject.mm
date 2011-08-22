//
//  GameObject.m
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//  
//

#import "GameObject.h"
#import "AssetManager.h"



@implementation GameObject

@synthesize body=_body, identifier=_identifier, flaggedForDeletion;


-(id)copyWithZone:(NSZone *)zone{
    GameObject *copy = [[GameObject alloc] init];
    [copy setBody:self.body];
    return [copy autorelease];
}

-(NSString*)name{
    return [_objectInfo valueForKey:@"name"];
}

-(void)updateGameObject:(ccTime)dt{
    [self syncPosition];
}

-(void) syncPosition
{
    if(!isMoveable)
    {
        //Synchronize the position and rotation with the corresponding box2d body
        self.position = CGPointMake( _body->GetPosition().x * PTM_RATIO, _body->GetPosition().y * PTM_RATIO);
        self.rotation = -1 * CC_RADIANS_TO_DEGREES(_body->GetAngle());
    }
    else
    {
        //Synchronize the position of the box2d body to match the sprite
        _body->SetTransform(b2Vec2(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO), -1 * CC_DEGREES_TO_RADIANS(self.rotation));
    }
}

-(void)handleCollisionWithObject:(GameObject*)object{
    //NSLog(@"%@ ran into a %@", NSStringFromClass([self class]), NSStringFromClass([object class]));
}

-(void)noLongerCollidingWithObject:(GameObject*)object{
    //NSLog(@"%@ moved away from %@",NSStringFromClass([self class]), NSStringFromClass([object class]));
}

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    
    // Used for managing collisions
    _identifier = GameObjectIDNone;
    
    // Save the object properties for later use
    _objectInfo = [game_object retain];
    
    // Save original size for use in resize() function
    originalSize = [self contentSize];
    
    //Save the world (You're a hero)
    _world = world;
    
    // This is overwritten in Ions
    objectSize.width = [[_objectInfo valueForKey:@"width"] floatValue];
    objectSize.height = [[_objectInfo valueForKey:@"height"] floatValue];
    
    // Setup size and position of sprite based on _objectInfo
    [self setupSprite];
    
    // Default is false; is overridden in switch.mm to true
    isSensor = false;
    
    // Setup physics body
    [self setupBody:world];
    
    // Find out if we are moveable or not
    isMoveable = ([game_object objectForKey:@"positions"] != nil);
    
    // Setup movable object if necessary
    if(isMoveable)
        [self setupMoveable];
    
    // Make sure we don't delete this object immediately :P
    flaggedForDeletion = false;
}

-(void) setupSprite
{
    CGPoint p;
    p.x = [[_objectInfo valueForKey:@"x"] floatValue];
    p.y = [[_objectInfo valueForKey:@"y"] floatValue];
    self.position = ccp( p.x * 2,p.y * 2);
    
    [self rescale:CGSizeMake(objectSize.width, objectSize.height)];
    
    self.rotation = [[_objectInfo valueForKey:@"rotation"] floatValue];
}


-(void) setupBody:(b2World*) world
{
    CGPoint p;
    p.x = [[_objectInfo valueForKey:@"x"] floatValue];
    p.y = [[_objectInfo valueForKey:@"y"] floatValue];
    
    b2BodyDef bodyDef;
	bodyDef.position.Set((p.x) /PTM_RATIO , (p.y ) /PTM_RATIO );
	bodyDef.userData = self;
    
	_body = world->CreateBody(&bodyDef);
    float angle = CC_DEGREES_TO_RADIANS(([[_objectInfo valueForKey:@"rotation"] floatValue]));
    _body->SetTransform(_body->GetPosition(), angle);
	_body->SetAwake(NO);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
    
	dynamicBox.SetAsBox(objectSize.width/PTM_RATIO/2 ,objectSize.height/2/PTM_RATIO);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
    
    // Is false by default, but is true for switches.
    if(isSensor)
    {
        fixtureDef.isSensor = YES;
    }
    
	fixtureDef.density = 0.0f;
	fixtureDef.friction = 0.3f;
	_body->CreateFixture(&fixtureDef);
}

-(void) setupMoveable
{
    // Load positions from plist
    NSArray *tempArray = [NSMutableArray arrayWithArray:[_objectInfo objectForKey:@"positions"]];
    
    // Store position points in case we need them later
    positionPoints = [NSMutableArray array];
    for(int i = 0; i < [tempArray count]; i++)
    {
        CGPoint point = ccp([[[tempArray objectAtIndex:i] valueForKey:@"x"] floatValue], [[[tempArray objectAtIndex:i] valueForKey:@"y"] floatValue]);
        [positionPoints addObject:[NSValue valueWithCGPoint:point]];
    }
    
    // Construct sequence of actions
    NSMutableArray *actions = [NSMutableArray array];
    for(int i = 1; i < [positionPoints count]; i++)
    {
        // ToDo: Variable timesteps
        [actions addObject: [CCMoveTo actionWithDuration:1 position:[[positionPoints objectAtIndex:i] CGPointValue]]];
    }
    // Add first position so it loops back
    [actions addObject: [CCMoveTo actionWithDuration:1 position:[[positionPoints objectAtIndex:0] CGPointValue]]];
    
    // Convert NSMutableArray to action sequence
    id act = [self actionMutableArray:actions];
    
    // Initialize position
    CGPoint pos = ccp([[_objectInfo valueForKey:@"x"] floatValue], [[_objectInfo valueForKey:@"y"] floatValue]);
    self.position = pos;
    
    // Initialize movement
    [self runAction:[CCRepeatForever actionWithAction:[CCSequence actions:act, nil]]];
    
}

// Helper function to form action sequence from NSMutableArray
-(id) actionMutableArray: (NSMutableArray*) _actionList {
	CCFiniteTimeAction *now;
	CCFiniteTimeAction *prev = [_actionList objectAtIndex:0];
    
	for (int i = 1 ; i < [_actionList count] ; i++) {
		now = [_actionList objectAtIndex:i];
		prev = [CCSequence actionOne: prev two: now];
	}
    
	return prev;
}

-(b2Vec2)getVelocity{
    
    return _body->GetLinearVelocity();
}

-(b2Body*) getBody
{
    return _body;
}

-(void)dealloc{
    
    [_objectInfo release];
    //TODO: Destroy all info about the object that we have created.
    [super dealloc];
}

-(void) rescale:(CGSize)size
{
    float originalWidth = originalSize.width;
    float originalHeight = originalSize.height;
    
    float newScaleX = size.width / originalWidth;
    float newScaleY = size.height / originalHeight;
    [self setScaleX:newScaleX];
    [self setScaleY:newScaleY];
}



@end
