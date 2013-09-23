//
//  TTApplicationManager
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 7/8/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTAppDelegate.h"
#import "TTTasksViewController.h"
#import "TTStatisticsViewController.h"
#import "TTSettingsViewController.h"
#import "TTMainClockViewController.h"
#import "TTNewProjectViewController.h"
#import "TTCustomTrackerViewController.h"
#import "TTMenuViewController.h"

@interface TTApplicationManager : NSObject
{

}
extern NSString *const VIEW_MENU;
extern NSString *const VIEW_STATISTICS;
extern NSString *const VIEW_CURRENT_TASKS;
extern NSString *const VIEW_NEW_TASK;
extern NSString *const VIEW_SELECT_PROPERTY;
extern NSString *const VIEW_CREATE_PROPERTY;
extern NSString *const VIEW_PROFILE;
extern NSString *const VIEW_CUSTOM_TRACKER;
extern NSString *const VIEW_MAIN_CLOCK;
extern NSString *const VIEW_SETTINGS;

extern NSString *const STR_NEW_PROJECT_CELLS;

+ (TTApplicationManager *)sharedApplicationManager;
-(void) pushViewTo:(NSString*) strNewView forNavigationController:(UINavigationController*) navController;
-(void) switchViewTo:(NSString*) strNewView forNavigationController:(UINavigationController*) navController;
//-(void) switchViewTo:(NSString*) strNewView
//        forNavigationController:(UINavigationController*) navController
//        withParams:(NSMutableDictionary*)dictParams;

@end
