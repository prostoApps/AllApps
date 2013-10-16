//
//  TTCustomTrackerViewController.h
//  PlanMyDay
//
//  Created by ProstoApps* on 7/29/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "DACircularProgressView.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "TTApplicationManager.h"

@interface TTCustomTrackerViewController : UIViewController
{
    IBOutlet UIButton *playPauseButton;
    IBOutlet UIButton *stopButton;
    IBOutlet UIButton *cancelButton;
    NSTimer *timer;
    int hour,minute,sec,time;
    NSString* timeString;
    float progressPercentage;
    BOOL overtime;
    
    int duration;
    NSDate *taskStartTime;
    NSDate *taskStartTimeNow;
    NSTimeInterval timeDifference,timeDifference100;
}

-(IBAction) btnNewTaskTouchHandler:(id)sender;
-(IBAction) btnMenuTouchHandler:(id)sender;

@property (nonatomic,retain) IBOutlet UIButton *btnMenu;
@property (nonatomic,retain) IBOutlet UIButton *btnNewTask;

@property (retain, nonatomic) IBOutlet UIButton *playPauseButton;

@property (retain, nonatomic) IBOutlet UILabel *timerTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet DACircularProgressView *largeProgressView;

-(IBAction)playPauseButtonPressed;
-(IBAction)stopButtonPressed;
-(IBAction)completeButtonPressed;
-(IBAction)cancelButtonPressed;

@end
