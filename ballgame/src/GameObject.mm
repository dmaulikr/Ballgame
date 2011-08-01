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

@synthesize defaults, body=_body, identifier=_identifier;


-(id)copyWithZone:(NSZone *)zone{
    GameObject *copy = [[GameObject alloc] init];
    [copy setDefaults:self.defaults];
    [copy setBody:self.body];
    return [copy autorelease];
}
// necessary for sub-classing CCSprite to work for some reason
-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
{
    if( (self=[super initWithTexture:texture rect:rect]))
    {
        defaults = [[AssetManager sharedInstance] getDefaults];
    }
    return self;
}

-(NSString*)name{
    return [_objectInfo valueForKey:@"name"];
}

-(void)updateGameObject:(ccTime)dt{
    
    [self syncPosition];
    
}

-(void) syncPosition
{
    //Synchronize the position and rotation with the corresponding box2d body
    self.position = CGPointMake( _body->GetPosition().x * PTM_RATIO, _body->GetPosition().y * PTM_RATIO);
    self.rotation = -1 * CC_RADIANS_TO_DEGREES(_body->GetAngle());
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
    
    // Establish rotation
    float degAngle = [[_objectInfo valueForKey:@"rotation"] floatValue];
    //float angle = CC_DEGREES_TO_RADIANS(degAngle);
    //[self setRotation:degAngle];
                                              
}

-(b2Vec2)getVelocity{
    
    return _body->GetLinearVelocity();
}

-(void)dealloc{
    [_objectInfo release];
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
