//
//  TTMenuViewController.h
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 8/6/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTApplicationManager.h"

@interface TTMenuViewController : UIViewController
{
    IBOutlet UIButton *btnMainClock;
    IBOutlet UIButton *btnSettings;
    IBOutlet UIButton *btnNewTask;
    IBOutlet UIButton *btnStatistics;
    IBOutlet UIButton *btnCustomTracker;
    IBOutlet UIButton *btnProfile;
    IBOutlet UIButton *btnCurrentTasks;

}

-(IBAction) btnMainClockTouchHandler:(id)sender;
-(IBAction) btnSettingsTouchHandler:(id)sender;
-(IBAction) btnStatisticsTouchHandler:(id)sender;
-(IBAction) btnCustomTrackerTouchHandler:(id)sender;
-(IBAction) btnProfileTouchHandler:(id)sender;
-(IBAction) btnCurrentTasksTouchHandler:(id)sender;

@property (nonatomic,retain) IBOutlet UIButton *btnMainClock;
@property (nonatomic,retain) IBOutlet UIButton *btnSettings;
@property (nonatomic,retain) IBOutlet UIButton *btnNewTask;
@property (nonatomic,retain) IBOutlet UIButton *btnStatistics;
@property (nonatomic,retain) IBOutlet UIButton *btnCustomTracker;
@property (nonatomic,retain) IBOutlet UIButton *btnProfile;
@property (nonatomic,retain) IBOutlet UIButton *btnCurrentTasks;

@end
