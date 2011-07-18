//
//  AppDelegate.h
//  ballgame
//
//  Created by Ryan Hart on 7/10/11.
//  
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    UINavigationController *_navController;
}
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) UIWindow *window;

@end
