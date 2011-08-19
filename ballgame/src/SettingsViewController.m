//
//  SettingsViewController.m
//  ballgame
//
//  Created by Ryan Hart on 7/31/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (id)init
{
    self = [super initWithNibName:@"SettingsViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)worldGravityChanged:(id)sender{
    NSNumber *newGravity = [NSNumber numberWithFloat:[_worldGravitySlider value]];
    [[AssetManager defaults] setValue:newGravity forKey:@"world_gravity"];
    [_worldGravityLabel setText:[NSString stringWithFormat:@"%i", [newGravity intValue]]];
}

-(IBAction)maxSpeedValueChanged{
    NSNumber *newSpeed =  [NSNumber numberWithFloat:[_maxSpeedSlider value]];
    [[AssetManager defaults] setValue:newSpeed forKey:@"max_speed"];
    [_maxSpeedLabel setText:[NSString stringWithFormat:@"%i", [newSpeed intValue]]];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    int defaultsMaxSpeed = [[[AssetManager defaults] valueForKey:@"max_speed"] intValue];
    [_maxSpeedSlider setValue:defaultsMaxSpeed];
    [_maxSpeedLabel setText:[NSString stringWithFormat:@"%i", defaultsMaxSpeed]];
    
    int defaultsWorldGravity = [[[AssetManager defaults] valueForKey:@"world_gravity"] intValue];
    [_worldGravitySlider setValue:defaultsWorldGravity];
    [_worldGravityLabel setText:[NSString stringWithFormat:@"%i", defaultsWorldGravity]];
                    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
