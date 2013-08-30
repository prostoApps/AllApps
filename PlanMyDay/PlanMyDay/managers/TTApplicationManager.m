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

-(void) switchViewTo:(NSString*) strNewView forNavigationController:(UINavigationController*) navController
{
    UIViewController *targetViewController;

    if (strNewView == VIEW_CURRENT_TASKS)
    {
        NSLog(@"open  CurrentTasks view");
        targetViewController = [[TTTasksViewController alloc]
                                initWithNibName:@"TTTasksViewController" bundle:nil];

    }
    else if (strNewView == VIEW_STATISTICS)
    {
        NSLog(@"open  STATISTICS view");
        targetViewController = [[TTStatisticsViewController alloc]
                                initWithNibName:@"TTStatisticsViewController" bundle:nil];
    }
    else if (strNewView == VIEW_SETTINGS)
    {
        NSLog(@"open  VIEW_SETTINGS view");
        targetViewController = [[TTSettingsViewController alloc]
                                initWithNibName:@"TTSettingsViewController" bundle:nil];
    }
    else if (strNewView == VIEW_MAIN_CLOCK)
    {
        NSLog(@"open  VIEW_MAIN_CLOCK view");
        targetViewController = [[TTMainClockViewController alloc]
                                initWithNibName:@"TTMainClockViewController" bundle:nil];
    }
    else if (strNewView == VIEW_NEW_TASK)
    {
        NSLog(@"open  VIEW_NEW_TASK view");
        targetViewController = [[TTNewProjectViewController alloc]
                                initWithNibName:@"TTNewProjectViewController" bundle:nil];
    }
    else if (strNewView == VIEW_CREATE_PROPERTY)
    {
        NSLog(@"open  VIEW_CREATE_PROPERTY view");
        targetViewController = [[TTCreatePropertyViewController alloc]
                                initWithNibName:@"TTCreatePropertyViewController" bundle:nil];
    }
    else if (strNewView == VIEW_SELECT_PROPERTY)
    {
        NSLog(@"open  VIEW_SELECT_PROPERTY view");
        targetViewController = [[TTSelectPropertyViewController alloc]
                                initWithNibName:@"TTSelectPropertyViewController" bundle:nil];
    }
    else if (strNewView == VIEW_PROFILE)
    {
        NSLog(@"open  VIEW_PROFILE view");
        //TODO add profile page
    }
    else if (strNewView == VIEW_CUSTOM_TRACKER)
    {
        NSLog(@"open  VIEW_CUSTOM_TRACKER view");
        targetViewController = [[TTCustomTrackerViewController alloc]
                                initWithNibName:@"TTCustomTrackerViewController" bundle:nil];
    }
    else if (strNewView == VIEW_MENU)
    {
        NSLog(@"open  VIEW_MENU view");
        targetViewController = [[TTMenuViewController alloc]
                                initWithNibName:@"TTMenuViewController" bundle:nil];
    }
    //Ставим стандартный background вьюшке
    targetViewController.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    //показываем вьюшку
    
    // set the root controller
    DDMenuController *menuController = (DDMenuController*)((TTAppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    
    UIBarButtonItem *infoButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"=" style:UIBarButtonItemStyleBordered  target:self action:@selector(LeftBarButtonItemAction)];
    UIBarButtonItem *infoButtonItem2=[[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStyleBordered  target:self action:@selector(RightBarButtonItemAction)];
    [targetViewController.navigationItem setLeftBarButtonItem:infoButtonItem];
    [targetViewController.navigationItem setRightBarButtonItem:infoButtonItem2];


    UINavigationController *navControllerRRR = [[UINavigationController alloc] initWithRootViewController:targetViewController];
    
    
    
    
    [menuController setRootController:navControllerRRR animated:YES];
    
   // [navController pushViewController:targetViewController animated:YES];
}

-(void)LeftBarButtonItemAction{
    DDMenuController *menuController = (DDMenuController*)((TTAppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
    //[[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_MENU forNavigationController:self.navigationController];
}
-(void)RightBarButtonItemAction{
  //  [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_NEW_TASK forNavigationController:self.navigationController];
}

@end
