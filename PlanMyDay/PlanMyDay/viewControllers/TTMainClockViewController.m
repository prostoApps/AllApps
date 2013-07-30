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

@synthesize btnCurrentTasks,btnCustomTracker,btnNewTask,btnProfile,btnSettings,btnStatistics;

@synthesize pageControl,svScrollView;

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
    // Do any additional setup after loading the view from its nib.
    pageControl.numberOfPages = 2; 
    [svScrollView setContentSize:CGSizeMake(svScrollView.frame.size.width * pageControl.numberOfPages, svScrollView.frame.size.height)];
    svScrollView.delegate = self;
    svScrollView.pagingEnabled = YES;
    pageControl.currentPage = 0;
    [self createPageWithColor:[UIColor redColor] forPage:0];
    [self createPageWithColor:[UIColor blueColor] forPage:1];
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

-(IBAction) btnSettingsTouchHandler:(id)sender
{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_SETTINGS forNavigationController:self.navigationController];
}

-(IBAction) btnNewTaskTouchHandler:(id)sender
{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_NEW_TASK forNavigationController:self.navigationController];
}

-(IBAction) btnStatisticsTouchHandler:(id)sender
{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_STATISTICS forNavigationController:self.navigationController];
}

-(IBAction) btnCustomTrackerTouchHandler:(id)sender
{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_CUSTOM_TRACKER forNavigationController:self.navigationController];
}

-(IBAction) btnProfileTouchHandler:(id)sender
{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_PROFILE forNavigationController:self.navigationController];
}

-(IBAction) btnCurrentTasksTouchHandler:(id)sender
{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_CURRENT_TASKS forNavigationController:self.navigationController];
}
//
//- (void)loadScrollViewWithPage:(NSUInteger)page
//{
//    if (page >= self.contentList.count)
//        return;
//    
//    // replace the placeholder if necessary
//    MyViewController *controller = [self.viewControllers objectAtIndex:page];
//    if ((NSNull *)controller == [NSNull null])
//    {
//        controller = [[MyViewController alloc] initWithPageNumber:page];
//        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
//    }
//    
//    // add the controller's view to the scroll view
//    if (controller.view.superview == nil)
//    {
//        CGRect frame = self.scrollView.frame;
//        frame.origin.x = CGRectGetWidth(frame) * page;
//        frame.origin.y = 0;
//        controller.view.frame = frame;
//        
//        [self addChildViewController:controller];
//        [self.scrollView addSubview:controller.view];
//        [controller didMoveToParentViewController:self];
//        
//        NSDictionary *numberItem = [self.contentList objectAtIndex:page];
//        controller.numberImage.image = [UIImage imageNamed:[numberItem valueForKey:kImageKey]];
//        controller.numberTitle.text = [numberItem valueForKey:kNameKey];
//    }
//}



// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(svScrollView.frame);
    NSUInteger page = floor((svScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self createPageWithColor:[UIColor redColor] forPage:0];
    [self createPageWithColor:[UIColor blueColor] forPage:1];

    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self createPageWithColor:[UIColor redColor] forPage:0];
    [self createPageWithColor:[UIColor blueColor] forPage:1];
    
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
