//
//  AssetManager.h
//  RaidLeader
//
//  Created by Ryan Hart on 7/4/11.
//  Copyright 2011 __myCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AssetManager : NSObject {
    
    NSDictionary *plistDefaults;
    
}

@property(nonatomic, retain) NSDictionary *plistDefaults;

+(id)sharedInstance;
+(id)alloc;

-(NSDictionary*) getDefaults;
-(NSDictionary*)levelWithName:(NSString*)levelName;
@end
