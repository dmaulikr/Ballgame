//
//  Gate.h
//  ballgame
//
//  Created by Ryan Hart on 7/30/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "GameObject.h"
#import "Wall.h"
#import "Switch.h"

@interface Gate : Wall <Switchable>{
    BOOL _isLocked;
}
@property (readwrite) BOOL isLocked;


@end
