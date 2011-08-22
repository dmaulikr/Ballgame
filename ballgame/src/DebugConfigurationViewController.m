//
//  DebugConfigurationViewController.m
//  ballgame
//
//  Created by Ryan Hart on 7/17/11.
//  Copyright 2011 NoName. All rights reserved.
//

#import "DebugConfigurationViewController.h"
#import "CCDirector.h"
#import "SpecifyURLViewController.h"
#import "SettingsViewController.h"

@implementation DebugConfigurationViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        cellTitles = [[NSArray arrayWithObjects:@"Dismiss", @"Settings", @"LoadSpriteSheetImage", @"LoadSpriteSheetPlist",nil] retain];
        
//        cellActions = [[NSArray arrayWithObjects:
//                       Block_copy(^(){
//                           //LoadSpriteSheetImage
//                       }), 
//                       Block_copy(^(){
//                           //LoadSpriteSheetPlist
//                       }),nil] retain];
        
        [self.navigationItem setHidesBackButton:YES];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[CCDirector sharedDirector] stopAnimation];
    levels = [[AssetManager allBundledLevels] retain];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [cellTitles release];
    [cellActions release];
    [levels release];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[CCDirector sharedDirector] resume];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Settings";
            break;
        case 1:
            return @"Levels";
        default:
            break;
    }
    return @"";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [cellTitles count];
            break;
        case 1:
            return [levels count];
        default:
            break;
    }
    return [cellTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    // Configure the cell...
    switch ([indexPath section]){
        case 0:
            [[cell textLabel] setText:[cellTitles objectAtIndex:[indexPath row]]];
            break;
        case 1:
            if ([indexPath row] == [[PlayerStateManager sharedInstance] currentLevelIndex]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            [[cell textLabel] setText:[NSString stringWithFormat:@"%i - %@", [indexPath row], [[levels objectAtIndex:[indexPath row]] valueForKey:@"name"]]];
            break;
    };
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecifyURLViewController *urlViewController;
    SettingsViewController *settingsVC;
    if ([indexPath section] == 0){
        switch ([indexPath row]) {
            case 0:
                [self.navigationController setNavigationBarHidden:YES];
                [self.navigationController popViewControllerAnimated:NO];
                break;
            case 1:
                settingsVC = [[SettingsViewController alloc] init];
                [self.navigationController pushViewController:settingsVC animated:YES];
                [settingsVC release];
                break;
            case 2:
                urlViewController = [[SpecifyURLViewController  alloc] initWithDefaultsKeyToSpecify:@"SpriteSheetPngName"];
                [self.navigationController pushViewController:urlViewController animated:YES];
                break;
            case 3:
                urlViewController = [[SpecifyURLViewController  alloc] initWithDefaultsKeyToSpecify:@"SpriteSheetPlistName"];
                [self.navigationController pushViewController:urlViewController animated:YES];
            default:
                break;
        }
    }
     
    if ([indexPath section] == 1){
        [[PlayerStateManager sharedInstance] setCurrentLevelIndex:[indexPath row]];
        [tableView reloadData];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
