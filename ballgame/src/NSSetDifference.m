//
//  NSSetDifference.m
//  ballgame
//
//  Created by Ryan Hart on 7/16/11.
//  
//

#import "NSSetDifference.h"


@implementation NSSet (NSSetDifference)
-(NSSet*)setDifferenceFromSet:(NSSet*)set{
    NSMutableSet *differenceSet = [[NSMutableSet alloc] initWithCapacity:[set count] + [self count]];;
    
    for (NSObject *objectSelf in self){
        bool contains = NO;
        for (NSObject *objectSet in set){
            if ([objectSelf isEqual:objectSet]){
                contains = YES;
            }
        }
        if (!contains){
            [differenceSet addObject:objectSelf];
        }
    }
    
    return [differenceSet autorelease];
}
@end
