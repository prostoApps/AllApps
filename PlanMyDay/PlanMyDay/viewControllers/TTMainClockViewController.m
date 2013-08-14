//
//  TTMainClockViewController.m
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 7/4/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTMainClockViewController.h"

@interface TTMainClockViewController ()

@end

@implementation TTMainClockViewController

@synthesize btnNewTask,btnMenu;

@synthesize pageControl,svScrollView;
@synthesize customTrackerViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //вытаскиваем все таски, которые есть в localData
    NSArray *arrAllTasks = [[NSMutableArray alloc] initWithArray:[[TTAppDataManager sharedAppDataManager] getAllTasks]];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];

    // Do any additional setup after loading the view from its nib.
    pageControl.numberOfPages = 2; 
    [svScrollView setContentSize:CGSizeMake(svScrollView.frame.size.width * pageControl.numberOfPages, svScrollView.frame.size.height)];
    svScrollView.delegate = self;
    svScrollView.pagingEnabled = YES;
    svScrollView.showsHorizontalScrollIndicator = NO;
    svScrollView.showsVerticalScrollIndicator = NO;
    svScrollView.scrollsToTop = NO;
    pageControl.currentPage = 0;

    //добавляем основные часы
    ClockViewController *clock = [[ClockViewController alloc] initWithNibName:@"ClockViewController" bundle:nil];
    clock.view.frame = CGRectMake(0, 0, svScrollView.frame.size.width, svScrollView.frame.size.height);
    [svScrollView addSubview:clock.view];
    
    //добавляем индикатор под основные часы
    TTCurrentTaskNextTaskIndicatorViewController *indicator = [[TTCurrentTaskNextTaskIndicatorViewController alloc] initWithNibName:@"TTCurrentTaskNextTaskIndicatorViewController" bundle:nil];
    indicator.view.frame = CGRectMake(0, 320, svScrollView.frame.size.width, svScrollView.frame.size.height);
    [svScrollView addSubview:indicator.view];

    //добавляем трекер текущей задачи
    customTrackerViewController = [[TTCustomTrackerViewController alloc] initWithNibName:@"TTCustomTrackerViewController" bundle:nil];
    [svScrollView addSubview:customTrackerViewController.view];
    customTrackerViewController.view.frame = CGRectMake(svScrollView.frame.size.width, 0, svScrollView.frame.size.width, svScrollView.frame.size.height);
//    [self createPageWithColor:[UIColor redColor] forPage:0];
//    [self createPageWithColor:[UIColor blueColor] forPage:1];
}

-(void) createPageWithColor: (UIColor*) color forPage:(NSInteger) page
{
    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(svScrollView.frame.size.width * page, 0, svScrollView.frame.size.width, svScrollView.frame.size.height)];
    newView.backgroundColor = color;
    [svScrollView addSubview:newView];
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
    CGFloat pageWidth = CGRectGetWidth(svScrollView.frame);
    NSUInteger page = floor((svScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
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
    CGRect bounds = self.svScrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.svScrollView scrollRectToVisible:bounds animated:animated];
}

- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];    // YES = animate
}

@end
