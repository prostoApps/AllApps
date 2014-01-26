//
//  TTMainClockViewController.h
//  PlanMyDay
//
//  Created by ProstoApps* on 7/4/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTAppDataManager.h"
#import "ClockViewController.h"
#import "TTTasksIndicatorViewController.h"
#import "TTApplicationManager.h"


@interface TTMainClockViewController : UIViewController <ViewControllerWithAutoUpdate,UIScrollViewDelegate>
{
    IBOutlet UIButton *btnNextTask;
    IBOutlet UIButton *btnStartPlan;
    IBOutlet UIButton *btnCurrentTask;
    IBOutlet UIView * viewIndicator;
    IBOutlet UIView * viewWorksTask;
    IBOutlet UIView * viewStartPlan;
}


-(IBAction) changePage:(UIPageControl*) sender;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)gotoPage:(BOOL)animated;

@property (nonatomic,retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic,retain) UIScrollView  *svClockScrollView;

@property (nonatomic,retain) TTTasksIndicatorViewController *tasksIndicatorAM;
@property (nonatomic,retain) TTTasksIndicatorViewController *tasksIndicatorPM;

@property (nonatomic,retain) IBOutlet UIButton *btnNewTask;

@property (nonatomic,retain) UIViewController  *customTrackerViewController;

@property (nonatomic,retain) TTItem  *externalArgument;

-(void)updateData;

@end
