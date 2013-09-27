//
//  TTApplicationManager
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 7/8/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTApplicationManager.h"


@implementation TTApplicationManager

NSString *const VIEW_MENU                   = @"viewMenu";
NSString *const VIEW_STATISTICS             = @"viewStatistics";
NSString *const VIEW_CURRENT_TASKS          = @"viewCurrentTasks";
NSString *const VIEW_NEW_TASK               = @"viewNewTask";
NSString *const VIEW_SELECT_PROPERTY        = @"viewSelectProperty";
NSString *const VIEW_CREATE_PROPERTY        = @"viewCreateProperty";
NSString *const VIEW_PROFILE                = @"viewProfile";
NSString *const VIEW_CUSTOM_TRACKER         = @"viewCustomTracker";
NSString *const VIEW_MAIN_CLOCK             = @"viewMainClock";
NSString *const VIEW_SETTINGS               = @"viewSettings";

NSString *const STR_NEW_PROJECT_CELLS       = @"cells";
NSString *const STR_NEW_PROJECT_VALUE       = @"value";
NSString *const STR_NEW_PROJECT_NAME        = @"name";
NSString *const STR_NEW_PROJECT_TYPE        = @"type";
NSString *const STR_NEW_PROJECT_TASK        = @"Task";
NSString *const STR_NEW_PROJECT_PROJECT     = @"Project";
NSString *const STR_NEW_PROJECT_CLIENT      = @"Client";

NSString *const FONT_HELVETICA_NEUE_LIGHT      = @"HelveticaNeue-Light";
NSString *const FONT_HELVETICA_NEUE_REGULAR    = @"HelveticaNeue-Regular";

+ (TTApplicationManager *)sharedApplicationManager
{
    static TTApplicationManager *sharedApplicationManager;
    
    @synchronized(self)
    {
        if (!sharedApplicationManager)
        {
            sharedApplicationManager = [[TTApplicationManager alloc] init];
        }
        return sharedApplicationManager;
    }
}


-(UIViewController*) getUIViewControllerFromString: (NSString*)strViewController
{

    UIViewController* targetViewController;
    
    if (strViewController == VIEW_CURRENT_TASKS)
    {
        NSLog(@"open  CurrentTasks view");
        targetViewController = [[TTTasksViewController alloc]
                                initWithNibName:@"TTTasksViewController" bundle:nil];
    }
    else if (strViewController == VIEW_STATISTICS)
    {
        NSLog(@"open  STATISTICS view");
        targetViewController = [[TTStatisticsViewController alloc]
                                initWithNibName:@"TTStatisticsViewController" bundle:nil];
    }
    else if (strViewController == VIEW_SETTINGS)
    {
        NSLog(@"open  VIEW_SETTINGS view");
        targetViewController = [[TTSettingsViewController alloc]
                                initWithNibName:@"TTSettingsViewController" bundle:nil];
    }
    else if (strViewController == VIEW_MAIN_CLOCK)
    {
        NSLog(@"open  VIEW_MAIN_CLOCK view");
        targetViewController = [[TTMainClockViewController alloc]
                                initWithNibName:@"TTMainClockViewController" bundle:nil];
    }
    else if (strViewController == VIEW_NEW_TASK)
    {
        NSLog(@"open  VIEW_NEW_TASK view");
        targetViewController = [[TTNewProjectViewController alloc]
                                initWithNibName:@"TTNewProjectViewController" bundle:nil];
    }
    else if (strViewController == VIEW_CREATE_PROPERTY)
    {
        NSLog(@"open  VIEW_CREATE_PROPERTY view");
        targetViewController = [[TTCreatePropertyViewController alloc]
                                initWithNibName:@"TTCreatePropertyViewController" bundle:nil];
    }
    else if (strViewController == VIEW_SELECT_PROPERTY)
    {
        NSLog(@"open  VIEW_SELECT_PROPERTY view ");
        targetViewController = [[TTSelectPropertyViewController alloc]
                                initWithNibName:@"TTSelectPropertyViewController" bundle:nil];
    }
    else if (strViewController == VIEW_PROFILE)
    {
        NSLog(@"open  VIEW_PROFILE view");
        //TODO add profile page
    }
    else if (strViewController == VIEW_CUSTOM_TRACKER)
    {
        NSLog(@"open  VIEW_CUSTOM_TRACKER view");
        targetViewController = [[TTCustomTrackerViewController alloc]
                                initWithNibName:@"TTCustomTrackerViewController" bundle:nil];
    }
    
    //Ставим стандартный background вьюшке
    targetViewController.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    UIView * backNavigate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    backNavigate.backgroundColor = [[TTAppDataManager sharedAppDataManager] colorWithHexString:@"#404a54"];
   // [backNavigate set[UINavigationBar appearance]:NO];
    backNavigate.alpha = 0.9f;
   // [targetViewController.view addSubview:backNavigate];
    return targetViewController;
    
}
-(void) pushViewTo:(NSString*) strNewView forNavigationController:(UINavigationController*) navController
{
    // определяем новый вью контроллер
    UIViewController* targetViewController  = [self getUIViewControllerFromString:strNewView];
    
    [navController pushViewController:targetViewController animated:YES];
    
}

-(void) switchViewTo:(NSString*) strNewView forNavigationController:(UINavigationController*) navController
{
    DDMenuController *menuController = (DDMenuController*)((TTAppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    // определяем новый вью контроллер
    UIViewController* targetViewController  = [self getUIViewControllerFromString:strNewView];

    
    // set the root controller
    UINavigationController *navControllerRRR = [[UINavigationController alloc] initWithRootViewController:targetViewController];
    
    [menuController setRootController:navControllerRRR animated:YES];

}

@end
