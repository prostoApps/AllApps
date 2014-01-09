//
//  TTApplicationManager
//  PlanMyDay
//
//  Created by ProstoApps* on 7/8/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTApplicationManager.h"


@implementation TTApplicationManager
NSString *const VIEW_TEST                   = @"test";
NSString *const VIEW_MENU                   = @"viewMenu";
NSString *const VIEW_STATISTICS             = @"viewStatistics";
NSString *const VIEW_STATISTICS_FILTER      = @"viewStatisticsFilter";
NSString *const VIEW_CURRENT_TASKS          = @"viewCurrentTasks";
NSString *const VIEW_NEW_TASK               = @"viewNewTask";
NSString *const VIEW_SELECT_PROPERTY        = @"viewSelectProperty";
NSString *const VIEW_SELECT_COLOR           = @"viewSelectColor";
NSString *const VIEW_CREATE_PROPERTY        = @"viewCreateProperty";
NSString *const VIEW_PROFILE                = @"viewProfile";
NSString *const VIEW_CUSTOM_TRACKER         = @"viewCustomTracker";
NSString *const VIEW_MAIN_CLOCK             = @"viewMainClock";
NSString *const VIEW_SETTINGS               = @"viewSettings";

NSString *const STR_NEW_PROJECT_CELLS               = @"cells";
NSString *const STR_NEW_PROJECT_VALUE               = @"value";
NSString *const STR_NEW_PROJECT_NAME                = @"name";
NSString *const STR_NEW_PROJECT_TYPE                = @"type";
NSString *const STR_NEW_PROJECT_TASK                = @"Task";
NSString *const STR_NEW_PROJECT_PROJECT             = @"Project";
NSString *const STR_NEW_PROJECT_CLIENT              = @"Client";
NSString *const STR_NEW_PROJECT_CLIENT_SKYPE        = @"Skype";
NSString *const STR_NEW_PROJECT_CLIENT_MAIL         = @"E-mail";
NSString *const STR_NEW_PROJECT_CLIENT_PHONE        = @"Phone";
NSString *const STR_NEW_PROJECT_CLIENT_NOTE         = @"Notes";
NSString *const STR_NEW_PROJECT_COLOR               = @"Color";
NSString *const STR_NEW_PROJECT_COLOR_NAME          = @"name";
NSString *const STR_NEW_PROJECT_COLOR_COLOR         = @"color";
NSString *const STR_NEW_PROJECT_START_DATE          = @"Start";
NSString *const STR_NEW_PROJECT_END_DATE            = @"End";

int const INT_NEW_PROJECT_TYPE_SELECT      = 0;
int const INT_NEW_PROJECT_TYPE_INPUT       = 1;
int const INT_NEW_PROJECT_TYPE_SWITCH      = 2;
int const INT_NEW_PROJECT_TYPE_COLOR       = 3;
int const INT_NEW_PROJECT_TYPE_PICKER      = 4;

int const NUM_NEW_PROJECT_SELECTED_SEGMENT_CLIENT  = 2;
int const NUM_NEW_PROJECT_SELECTED_SEGMENT_PROJECT = 1;
int const NUM_NEW_PROJECT_SELECTED_SEGMENT_TASK    = 0;

NSString *const FONT_HELVETICA_NEUE_LIGHT      = @"HelveticaNeue-Light";
NSString *const FONT_HELVETICA_NEUE_REGULAR    = @"HelveticaNeue-Regular";
NSString *const FONT_HELVETICA_NEUE_MEDIUM    = @"HelveticaNeue-Medium";

@synthesize ipNewProjectSelectedProperty,strNewProjectSelectedCategory,arrTaskColors;
@synthesize ipNewProjectSelectedColor;
@synthesize vcViewControllerToUpdate;
@synthesize vcPreviousViewController;
@synthesize vcCurrentViewController;


NSString * _menuRightViewController;

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


-(NSArray*)arrTaskColors{
    if (!arrTaskColors)
    {
        arrTaskColors = [[NSArray alloc] initWithObjects:
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Tomato",@"name",
                          @"e04217",@"color",
                          nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Plum",@"name",
                          @"1e7cf4",@"color",
                          nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Cucumber",@"name",
                          @"53d769",@"color",
                          nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Carrot",@"name",
                          @"fd9426",@"color",
                          nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Eggplant",@"name",
                          @"5d2878",@"color",
                          nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Persimmon",@"name",
                          @"e65702",@"color",
                          nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Apple",@"name",
                          @"90b837",@"color",
                          nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Raspberry",@"name",
                          @"ff3d5d",@"color",
                          nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Orange",@"name",
                          @"f8641e",@"color",
                          nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Strawberry",@"name",
                          @"fe3618",@"color",
                          nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Melon",@"name",
                          @"ffda58",@"color",
                          nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Cabbage",@"name",
                          @"b9dc68",@"color",
                          nil],
                         nil];
    }
    return arrTaskColors;
}

-(UIViewController*) getUIViewControllerFromString: (NSString*)strViewController
{
    _menuRightViewController = VIEW_NEW_TASK;
    
    UIViewController* targetViewController;
    
    if (strViewController == VIEW_CURRENT_TASKS)
    {
        NSLog(@"open  CurrentTasks view");
        targetViewController = [[TTTasksViewController alloc]
                                initWithNibName:@"TTTasksViewController" bundle:nil];
    }
    else if (strViewController == VIEW_TEST)
    {
        NSLog(@"open  VIEW_TEST view");
        targetViewController = [[TTFieldsTableViewController alloc]
                                initWithNibName:@"TTFieldsTableViewController" bundle:nil];
    }
    else if (strViewController == VIEW_STATISTICS)
    {
        NSLog(@"open  STATISTICS view");
        targetViewController = [[TTStatisticsViewController alloc]
                                initWithNibName:@"TTStatisticsViewController" bundle:nil];
        _menuRightViewController = VIEW_STATISTICS_FILTER;
       
    }
    else if (strViewController == VIEW_STATISTICS_FILTER)
    {
        NSLog(@"open  STATISTICS_FILTER view");
        targetViewController = [[TTStatisticFilterViewController alloc]
                                initWithNibName:@"TTStatisticFilterViewController" bundle:nil];
        
        
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
    else if (strViewController == VIEW_SELECT_COLOR)
    {
        NSLog(@"open  VIEW_SELECT_COLOR view ");
        targetViewController = [[TTSelectColorViewController alloc]
                                initWithNibName:@"TTSelectColorViewController" bundle:nil];
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
    backNavigate.backgroundColor = [TTTools colorWithHexString:@"#404a54"];
   // [backNavigate set[UINavigationBar appearance]:NO];
    backNavigate.alpha = 0.9f;
   // [targetViewController.view addSubview:backNavigate];
    return targetViewController;
    
}
-(void) pushViewTo:(NSString*) strNewView forNavigationController:(UINavigationController*) navController withArgument:(TTItem*)argument
{
    // определяем новый вью контроллер
    UIViewController <ViewControllerWithArgument,ViewControllerWithAutoUpdate> *targetViewController  = [self getUIViewControllerFromString:strNewView];
    
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered  target:self action:nil];
    [targetViewController.navigationItem setBackBarButtonItem:backButton];
    
    if (argument && [targetViewController respondsToSelector:@selector(setExternalArgument:)])
    {
        [targetViewController setExternalArgument:argument] ;
    }
    
    if (vcViewControllerToUpdate)
        [vcViewControllerToUpdate updateData];
    
    [navController pushViewController:targetViewController animated:YES];

}

-(void) pushViewTo:(NSString*) strNewView forNavigationController:(UINavigationController*) navController
{
    [self pushViewTo:strNewView forNavigationController:navController withArgument:nil];
}

-(void) switchViewTo:(NSString*) strNewView forNavigationController:(UINavigationController*) navController withArgument:(TTItem*) argument
{
    DDMenuController *menuController = (DDMenuController*)((TTAppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;

    // определяем новый вью контроллер
    UIViewController <ViewControllerWithArgument,ViewControllerWithAutoUpdate> *targetViewController  = [self getUIViewControllerFromString:strNewView];

    if (vcCurrentViewController)
        vcPreviousViewController = vcCurrentViewController;

        vcCurrentViewController = targetViewController;
    
    [menuController setRightViewController:_menuRightViewController];
    
    // set the root controller
    UINavigationController *navControllerRRR = [[UINavigationController alloc] initWithRootViewController:targetViewController];
    
    if (argument && [targetViewController respondsToSelector:@selector(setExternalArgument:)])
    {
        [targetViewController setExternalArgument:argument] ;
    }
    
    if (vcViewControllerToUpdate)
        [vcViewControllerToUpdate updateData];
    
    
    [menuController setRootController:navControllerRRR animated:YES];
}

-(void) switchViewTo:(NSString*) strNewView forNavigationController:(UINavigationController*) navController
{
    [self switchViewTo:strNewView forNavigationController:navController withArgument:nil];
}

-(void) updateCurrentViewController
{
    if (vcCurrentViewController)
        [vcCurrentViewController updateData];
}

@end
