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


@interface TTMainClockViewController : UIViewController <ViewControllerWithAutoUpdate>
{
    IBOutlet UIButton *btnMenu;
    IBOutlet UIButton *btnNewTask;
    IBOutlet UIView * viewIndicator;
}

-(IBAction) btnNewTaskTouchHandler:(id)sender;
-(IBAction) btnMenuTouchHandler:(id)sender;

-(IBAction) changePage:(UIPageControl*) sender;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)gotoPage:(BOOL)animated;

@property (nonatomic,retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic,retain) IBOutlet UIScrollView  *svScrollView;

@property (nonatomic,retain) TTTasksIndicatorViewController *tasksIndicator;

@property (nonatomic,retain) IBOutlet UIButton *btnMenu;
@property (nonatomic,retain) IBOutlet UIButton *btnNewTask;

@property (nonatomic,retain) UIViewController  *customTrackerViewController;

@property (nonatomic,retain) NSObject  *externalArgument;

-(void)updateData;

@end
