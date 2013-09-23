//
//  TTMenuViewController.m
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 8/6/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTMenuViewController.h"

@interface TTMenuViewController ()

@end

@implementation TTMenuViewController

@synthesize btnCurrentTasks,btnCustomTracker,btnMainClock,btnNewTask,btnProfile,btnSettings,btnStatistics;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
          self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Menu"];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) btnMainClockTouchHandler:(id)sender
{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_MAIN_CLOCK forNavigationController:self.navigationController];
}

-(IBAction) btnSettingsTouchHandler:(id)sender
{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_SETTINGS forNavigationController:self.navigationController];
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


@end
