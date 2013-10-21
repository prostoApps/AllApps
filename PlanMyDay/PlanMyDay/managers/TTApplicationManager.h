//
//  TTApplicationManager
//  PlanMyDay
//
//  Created by ProstoApps* on 7/8/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTAppDelegate.h"
#import "TTTasksViewController.h"
#import "TTStatisticsViewController.h"
#import "TTStatisticFilterViewController.h"
#import "TTSettingsViewController.h"
#import "TTMainClockViewController.h"
#import "TTNewProjectViewController.h"
#import "TTCustomTrackerViewController.h"
#import "TTMenuViewController.h"

@interface TTApplicationManager : NSObject
{

}
extern NSString *const VIEW_TEST;
extern NSString *const VIEW_MENU;
extern NSString *const VIEW_STATISTICS;
extern NSString *const VIEW_STATISTICS_FILTER;
extern NSString *const VIEW_CURRENT_TASKS;
extern NSString *const VIEW_NEW_TASK;
extern NSString *const VIEW_SELECT_PROPERTY;
extern NSString *const VIEW_SELECT_COLOR;
extern NSString *const VIEW_CREATE_PROPERTY;
extern NSString *const VIEW_PROFILE;
extern NSString *const VIEW_CUSTOM_TRACKER;
extern NSString *const VIEW_MAIN_CLOCK;
extern NSString *const VIEW_SETTINGS;

extern NSString *const STR_NEW_PROJECT_CELLS;
extern NSString *const STR_NEW_PROJECT_VALUE;
extern NSString *const STR_NEW_PROJECT_NAME;
extern NSString *const STR_NEW_PROJECT_TYPE;

extern int const INT_NEW_PROJECT_TYPE_SELECT;
extern int const INT_NEW_PROJECT_TYPE_INPUT;
extern int const INT_NEW_PROJECT_TYPE_SWITCH;
extern int const INT_NEW_PROJECT_TYPE_COLOR;
extern int const INT_NEW_PROJECT_TYPE_PICKER;

extern NSString *const STR_NEW_PROJECT_TASK;
extern NSString *const STR_NEW_PROJECT_PROJECT;

extern NSString *const STR_NEW_PROJECT_CLIENT;
extern NSString *const STR_NEW_PROJECT_CLIENT_PHONE;
extern NSString *const STR_NEW_PROJECT_CLIENT_SKYPE;
extern NSString *const STR_NEW_PROJECT_CLIENT_MAIL;
extern NSString *const STR_NEW_PROJECT_CLIENT_NOTE;
extern NSString *const STR_NEW_PROJECT_COLOR;
extern NSString *const STR_NEW_PROJECT_COLOR_NAME;
extern NSString *const STR_NEW_PROJECT_COLOR_COLOR;
extern NSString *const STR_NEW_PROJECT_START_DATE;
extern NSString *const STR_NEW_PROJECT_END_DATE;

extern int const NUM_NEW_PROJECT_SELECTED_SEGMENT_TASK;
extern int const NUM_NEW_PROJECT_SELECTED_SEGMENT_CLIENT;
extern int const NUM_NEW_PROJECT_SELECTED_SEGMENT_PROJECT;

extern NSString *const FONT_HELVETICA_NEUE_LIGHT;
extern NSString *const FONT_HELVETICA_NEUE_REGULAR;
extern NSString *const FONT_HELVETICA_NEUE_MEDIUM;

//@property (nonatomic, retain)
//Создание нового таска. индекс ячейки, которую редактируем.
@property (nonatomic,copy) NSIndexPath * ipNewProjectSelectedProperty;
@property (nonatomic,copy) NSIndexPath * ipNewProjectSelectedColor;
//Создание нового таска. название раздела Task/Project/Client.
@property (nonatomic,copy) NSString * strNewProjectSelectedCategory;
@property (nonatomic,copy) NSArray * arrTaskColors;

+ (TTApplicationManager *)sharedApplicationManager;
-(void) pushViewTo:(NSString*) strNewView forNavigationController:(UINavigationController*) navController;
-(void) switchViewTo:(NSString*) strNewView forNavigationController:(UINavigationController*) navController;
//-(void) switchViewTo:(NSString*) strNewView
//        forNavigationController:(UINavigationController*) navController
//        withParams:(NSMutableDictionary*)dictParams;

@end
