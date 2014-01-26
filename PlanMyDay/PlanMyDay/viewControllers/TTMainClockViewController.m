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

@implementation TTMainClockViewController{
    int intCurrentClockOffsset;
}

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
    [TTTools makeButtonStyled:btnStartPlan];
    //вытаскиваем все таски, которые есть в localData

    
    UIColor * back = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.view.backgroundColor = back;
    
    CGRect scrollViewFrame = CGRectMake(0, 0, 320, 404);
    svClockScrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    [self.view addSubview:svClockScrollView];

    //добавляем основные часы
    ClockViewController *clockAM = [[ClockViewController alloc] initWithNibName:@"ClockViewController" bundle:nil];
    ClockViewController *clockPM = [[ClockViewController alloc] initWithNibName:@"ClockViewController" bundle:nil];
    clockAM.view.frame = CGRectMake(0, 0, svClockScrollView.frame.size.width, svClockScrollView.frame.size.height);
    clockPM.view.frame = CGRectMake(svClockScrollView.frame.size.width, 0, svClockScrollView.frame.size.width, svClockScrollView.frame.size.height);
    [svClockScrollView addSubview:clockAM.view];
    [svClockScrollView addSubview:clockPM.view];
    
    CGSize scrollViewContentSize = CGSizeMake(640, 404);
    [svClockScrollView setContentSize:scrollViewContentSize];
    
    //добавляем цветной индикатор тасков вокруг часов
    
    tasksIndicatorAM = [[TTTasksIndicatorViewController alloc] init];
    [svClockScrollView addSubview:tasksIndicatorAM.view];
    tasksIndicatorPM = [[TTTasksIndicatorViewController alloc] init];
    [svClockScrollView addSubview:tasksIndicatorPM.view];
    
    [self updateData];

//    svClockScrollView.scrollEnabled = false;
    svClockScrollView.showsHorizontalScrollIndicator = false;
    svClockScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    [svClockScrollView setDelegate:self];
    
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
         [[TTApplicationManager sharedApplicationManager] pushViewTo:VIEW_NEW_TASK forNavigationController:self.navigationController];
}



-(IBAction) btnMenuTouchHandler:(id)sender
{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_MENU forNavigationController:self.navigationController];
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
-(void)centerCurrentView{
    //
    int xhalf = svClockScrollView.frame.size.width/2;
    int xcurrnet = svClockScrollView.contentOffset.x;
    if (xcurrnet <= xhalf & xcurrnet > 0) {
        [svClockScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if(xcurrnet > xhalf & xcurrnet <= 320){
        [svClockScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self centerCurrentView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self centerCurrentView];
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
    
    //добавляем кнопку "Начать планировать" есть нету тасков на сегодня
    if ([[TTAppDataManager sharedAppDataManager] getAllTasksForToday].count == 0) {
        viewWorksTask.hidden = true;
        viewStartPlan.hidden = false;
    }
    else{
        viewWorksTask.hidden = false;
        viewStartPlan.hidden = true;
    }
    
    // определяем am/pm и ставим текущие часы
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"HH"];
    NSInteger intCurentHour = [[DateFormatter stringFromDate:[NSDate date]] intValue];
    if(intCurentHour >=0 & intCurentHour <=11 ){
        tasksIndicatorAM.view.frame = CGRectMake(0,0,svClockScrollView.frame.size.width, svClockScrollView.frame.size.height);
        tasksIndicatorPM.view.frame = CGRectMake(svClockScrollView.frame.size.width,0,svClockScrollView.frame.size.width, svClockScrollView.frame.size.height);
    }
    else
    {
        tasksIndicatorAM.view.frame = CGRectMake(svClockScrollView.frame.size.width,0,svClockScrollView.frame.size.width, svClockScrollView.frame.size.height);
        tasksIndicatorPM.view.frame = CGRectMake(0,0,svClockScrollView.frame.size.width, svClockScrollView.frame.size.height);
    }
    

    
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
        
       // определяем текущий проект
      
        if([[dictTaskData objectForKey:STR_END_DATE] timeIntervalSinceNow] > 0 & [[dictTaskData objectForKey:STR_START_DATE] timeIntervalSinceNow] < 0)
        {
            self.title = [NSString stringWithFormat:@"%@",[dictTaskData objectForKey:STR_TASK_NAME]];
        }
        
    }

    [tasksIndicatorAM updateWithTasks:arrTasksAM];
    [tasksIndicatorPM updateWithTasks:arrTasksPM];
}

@end
