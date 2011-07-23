//
//  SpecifyURLViewController.m
//  ballgame
//
//  Created by Ryan Hart on 7/17/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "SpecifyURLViewController.h"


@implementation SpecifyURLViewController

-(id)initWithDefaultsKeyToSpecify:(NSString*)defaultsKey
{
    self = [super initWithNibName:@"SpecifyURLViewController"   bundle:nil];
    if (self) {
        // Custom initialization
        _defaultsKey = [defaultsKey retain];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(beginLoad)];
        self.navigationItem.rightBarButtonItem  = doneButton;
        [doneButton release];
        
        //self.navigationItem.hidesBackButton = YES;
        
    }
    return self;
}
-(void)beginLoad{
    //[[AssetManager sharedInstance] cacheResourceFromURL:[NSURL URLWithString:@"http://192.168.1.100/~ryanhart/BallGameSpriteSheet.png"] withDelegate:self resultSelector:@selector(finishedCache) andDefaultsKey:@"SpriteSheetPngName"];
    if ([[AssetManager sharedInstance] cacheResourceFromURL:[NSURL URLWithString:[_urlTextField text]] withDelegate:self resultSelector:@selector(loadFinished:) andDefaultsKey:_defaultsKey]){
        [[NSUserDefaults standardUserDefaults] setValue:[_urlTextField text] forKey:[PREVIOUSLY_USED_URL stringByAppendingString:_defaultsKey]];
        [_activityIndicator startAnimating];
        [_urlTextField setEnabled:NO];
    }else{
        UIAlertView *cantloadThat = [[UIAlertView alloc] initWithTitle:@"Can't load that" message:@"Unable to load the specified URL or a load is already taking place." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [cantloadThat show];
        [cantloadThat release];
    }
    
}
     
-(void)loadFinished:(id)resultPath{
    NSLog(@"Load Finished");
    [_activityIndicator stopAnimating];
    [_urlTextField setEnabled:YES];
    if (resultPath == nil){
        UIAlertView *loadFailed = [[UIAlertView alloc] initWithTitle:@"Load Failed" message:@"The load failed for some reason." delegate:nil cancelButtonTitle:@"Oh darn." otherButtonTitles: nil];
        [loadFailed show];
        [loadFailed release];
    }
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
     //[self.navigationController setNavigationBarHidden:NO];
    [_urlTextField setText:[[NSUserDefaults standardUserDefaults] valueForKey:[PREVIOUSLY_USED_URL stringByAppendingString:_defaultsKey]]];
    //[_urlTextField setText:@"http://192.168.1.100/~ryanhart/BallGameSpriteSheet.plist"];
    [_defaultsKeyLabel setText:_defaultsKey];
}


-(void)viewWillDisappear:(BOOL)animated{
     //[self.navigationController setNavigationBarHidden:YES];
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
    return YES;
}

#pragma mark - Memory Management
- (void)dealloc
{
    [_defaultsKey release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
@end
