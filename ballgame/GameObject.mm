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

@synthesize defaults, body=_body, currentFixture=_currentFixture;


-(id)copyWithZone:(NSZone *)zone{
    GameObject *copy = [[GameObject alloc] init];
    [copy setDefaults:self.defaults];
    [copy setBody:self.body];
    [copy setCurrentFixture:self.currentFixture];
    return copy;
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

-(void)handleCollisionWithObject:(GameObject*)object{
    NSLog(@"%@ ran into a %@", NSStringFromClass([self class]), NSStringFromClass([object class]));
}

-(void)noLongerCollidingWithObject:(GameObject*)object{
    NSLog(@"%@ moved away from %@",NSStringFromClass([self class]), NSStringFromClass([object class]));
}

-(void)setupGameObject:(NSDictionary*)game_object forWorld:(b2World*)world{
    //This does nothing.  Subclasses override this for custom initialization
    
}

-(b2Vec2)getVelocity{
    
    return _body->GetLinearVelocity();
}

@end
