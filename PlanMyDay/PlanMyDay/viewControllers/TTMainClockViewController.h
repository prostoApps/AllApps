//
//  TTMainClockViewController.h
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 7/4/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTAppDataManager.h"
#import "TTApplicationManager.h"

@interface TTMainClockViewController : UIViewController
{
    IBOutlet UIButton *btnSettings;
    IBOutlet UIButton *btnNewTask;
    IBOutlet UIButton *btnStatistics;
    IBOutlet UIButton *btnCustomTracker;
    IBOutlet UIButton *btnProfile;
    IBOutlet UIButton *btnCurrentTasks;
}

-(IBAction) btnSettingsTouchHandler:(id)sender;
-(IBAction) btnNewTaskTouchHandler:(id)sender;
-(IBAction) btnStatisticsTouchHandler:(id)sender;
-(IBAction) btnCustomTrackerTouchHandler:(id)sender;
-(IBAction) btnProfileTouchHandler:(id)sender;
-(IBAction) btnCurrentTasksTouchHandler:(id)sender;

-(IBAction) changePage:(UIPageControl*) sender;


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)gotoPage:(BOOL)animated;

@property (nonatomic,retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic,retain) IBOutlet UIScrollView  *svScrollView;

@property (nonatomic,retain) IBOutlet UIButton *btnSettings;
@property (nonatomic,retain) IBOutlet UIButton *btnNewTask;
@property (nonatomic,retain) IBOutlet UIButton *btnStatistics;
@property (nonatomic,retain) IBOutlet UIButton *btnCustomTracker;
@property (nonatomic,retain) IBOutlet UIButton *btnProfile;
@property (nonatomic,retain) IBOutlet UIButton *btnCurrentTasks;

@end
