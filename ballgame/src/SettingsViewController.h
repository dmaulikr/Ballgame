//
//  SettingsViewController.h
//  ballgame
//
//  Created by Ryan Hart on 7/31/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetManager.h"

@interface SettingsViewController : UIViewController{
    IBOutlet UISlider *_maxSpeedSlider;
    IBOutlet UILabel *_maxSpeedLabel;
    
    IBOutlet UISlider *_worldGravitySlider;
    IBOutlet UILabel *_worldGravityLabel;
}
-(IBAction)maxSpeedValueChanged;
-(IBAction)worldGravityChanged:(id)sender;
@end
