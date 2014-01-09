//
//  TTMainClockViewController.m
//  PlanMyDay
//
//  Created by ProstoApps* on 7/4/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTMainClockViewController.h"

@interface TTMainClockViewController ()

@end

@implementation TTMainClockViewController

@synthesize btnNewTask;

@synthesize pageControl,svClockScrollView,tasksIndicatorAM,tasksIndicatorPM;
@synthesize customTrackerViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self setNeedsStatusBarAppearanceUpdate];
    
    //вытаскиваем все таски, которые есть в localData
    NSMutableArray *arrAllTasks = [[NSMutableArray alloc] initWithArray:[[TTAppDataManager sharedAppDataManager] getAllTasksForToday]];
    //добавляем кнопку "Начать планировать" есть нету тасков на сегодня
    if (arrAllTasks.count == 0) {
        [viewWorksTask addSubview:viewStartPlan];
    }
    else{
        
    }
    UIColor * back = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.view.backgroundColor = back;
    
    CGRect scrollViewFrame = CGRectMake(0, 0, 320, 404);
    svClockScrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    [self.view addSubview:svClockScrollView];

    //добавляем основные часы
    ClockViewController *clockAM = [[ClockViewController alloc] initWithNibName:@"ClockViewController" bundle:nil];
    clockAM.view.frame = CGRectMake(0, 0, svClockScrollView.frame.size.width, svClockScrollView.frame.size.height);
    [svClockScrollView addSubview:clockAM.view];

    ClockViewController *clockPM = [[ClockViewController alloc] initWithNibName:@"ClockViewController" bundle:nil];
    clockPM.view.frame = CGRectMake(svClockScrollView.frame.size.width, 0, svClockScrollView.frame.size.width, svClockScrollView.frame.size.height);
    [svClockScrollView addSubview:clockPM.view];

    
    CGSize scrollViewContentSize = CGSizeMake(640, 404);
    [svClockScrollView setContentSize:scrollViewContentSize];
    
    //добавляем цветной индикатор тасков вокруг часов
//    tasksIndicatorAM = [[TTTasksIndicatorViewController alloc] initWithTasks:arrAllTasks];
    tasksIndicatorAM = [[TTTasksIndicatorViewController alloc] init];
    [svClockScrollView addSubview:tasksIndicatorAM.view];
    
//    tasksIndicatorPM = [[TTTasksIndicatorViewController alloc] initWithTasks:arrAllTasks];
    tasksIndicatorPM = [[TTTasksIndicatorViewController alloc] init];
    [svClockScrollView addSubview:tasksIndicatorPM.view];
    tasksIndicatorPM.view.frame = CGRectMake(svClockScrollView.frame.size.width,0,svClockScrollView.frame.size.width, svClockScrollView.frame.size.height);
    
    [self updateData];

//    svClockScrollView.scrollEnabled = false;
    svClockScrollView.showsHorizontalScrollIndicator = false;
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(110,5,100,100);
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    [self.view addSubview:pageControl];
//    pageControl.backgroundColor = [UIColor redColor];
    
     [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
//        [self.view addSubview:svScrollView];
    
    //добавляем индикатор под основные часы
   // TTCurrentTaskNextTaskIndicatorViewController *indicator = [[TTCurrentTaskNextTaskIndicatorViewController alloc] initWithNibName:@"TTCurrentTaskNextTaskIndicatorViewController" bundle:nil];
  //  indicator.view.frame = CGRectMake(0, 0, svScrollView.frame.size.width, svScrollView.frame.size.height);
   // [svScrollView addSubview:indicator.view];
   
    //добавляем трекер текущей задачи
   /* customTrackerViewController = [[TTCustomTrackerViewController alloc] initWithNibName:@"TTCustomTrackerViewController" bundle:nil];
    [svScrollView addSubview:customTrackerViewController.view];
    customTrackerViewController.view.frame = CGRectMake(svScrollView.frame.size.width, 0, svScrollView.frame.size.width, svScrollView.frame.size.height);
    */
    
    self.title = @"Current Project";

    
 //   self.navigationController.navigationController.v view.backgroundColor = [UIColor clearColor];

}
-(void) createPageWithColor: (UIColor*) color forPage:(NSInteger) page
{
    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(svClockScrollView.frame.size.width * page, 0, svClockScrollView.frame.size.width, svClockScrollView.frame.size.height)];
    newView.backgroundColor = color;
    [svClockScrollView addSubview:newView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) btnNewTaskTouchHandler:(id)sender
{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_NEW_TASK forNavigationController:self.navigationController];
}

-(IBAction) btnMenuTouchHandler:(id)sender
{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_MENU forNavigationController:self.navigationController];
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(svClockScrollView.frame);
    NSUInteger page = floor((svClockScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
//    [self createPageWithColor:[UIColor redColor] forPage:0];
//    [self createPageWithColor:[UIColor blueColor] forPage:1];

    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
//    [self createPageWithColor:[UIColor redColor] forPage:0];
//    [self createPageWithColor:[UIColor blueColor] forPage:1];
    
	// update the scroll view to the appropriate page
    CGRect bounds = self.svClockScrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.svClockScrollView scrollRectToVisible:bounds animated:animated];
}

- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];    // YES = animate
}

-(void)updateData
{
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSMutableArray *arrTasksAM = [[NSMutableArray alloc] init];
    NSMutableArray *arrTasksPM = [[NSMutableArray alloc] init];

    for (NSMutableDictionary *dictTaskData in [[TTAppDataManager sharedAppDataManager] getAllTasksForToday])
    {

        NSDateComponents *tmpComponents = [cal components:( NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[dictTaskData objectForKey:STR_START_DATE]];
            
            //[NSDate timeIntervalSinceReferenceDate]
        if(tmpComponents.hour < 12)
            [arrTasksAM addObject:dictTaskData ];
        else
            [arrTasksPM addObject:dictTaskData ];
    }

    [tasksIndicatorAM updateWithTasks:arrTasksAM];
    [tasksIndicatorPM updateWithTasks:arrTasksPM];
}

@end
