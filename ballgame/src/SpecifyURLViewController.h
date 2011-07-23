//
//  SpecifyURLViewController.h
//  ballgame
//
//  Created by Ryan Hart on 7/17/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetManager.h"

#define PREVIOUSLY_USED_URL @"PREVIOUSLY_USED_URL_FOR_BALLGAME="

@interface SpecifyURLViewController : UIViewController {
    IBOutlet UITextField *_urlTextField;
    IBOutlet UIActivityIndicatorView *_activityIndicator;
    IBOutlet UILabel *_defaultsKeyLabel;
    NSString *_defaultsKey;
}
-(id)initWithDefaultsKeyToSpecify:(NSString*)defaultsKey;
-(void)beginLoad;
-(void)loadFinished:(id)resultPath;
@end
