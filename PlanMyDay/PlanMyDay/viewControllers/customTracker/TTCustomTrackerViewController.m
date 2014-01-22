//
//  TTCustomTrackerViewController.m
//  PlanMyDay
//
//  Created by ProstoApps* on 7/29/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTCustomTrackerViewController.h"

@interface TTCustomTrackerViewController ()

@end

@implementation TTCustomTrackerViewController

@synthesize timerTitleLabel;
@synthesize timerLabel;
@synthesize largeProgressView = _largeProgressView;
@synthesize playPauseButton;
@synthesize btnNewTask,btnMenu;
@synthesize externalArgument;
@synthesize unsavedTrackedTask;

- (void)viewDidLoad
{
    [super viewDidLoad];
  //  self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    
    [self.largeProgressView setTrackTintColor:[[UIColor alloc] initWithRed:0x3b/255.0 green:0x45/255.0 blue:0x4e/255.0 alpha:1]];
    [self.largeProgressView setProgressTintColor:[[UIColor alloc] initWithRed:0xfc/255.0 green:0x3e/255.0 blue:0x39/255.0 alpha:1]];
    self.largeProgressView.roundedCorners = NO;
    [self.view addSubview:self.largeProgressView];
    [self.largeProgressView setThicknessRatio:0.066];
    
    [TTTools makeButtonStyled:stopButton];
    [TTTools makeButtonStyled:playPauseButton];
    [TTTools makeButtonStyled:cancelButton];
    
    
    timeDifference = -1;
    duration = 0;
    [self.largeProgressView setProgress:1];
    // Запланированый старт (текущая дата - час)
    NSDate *taskStartTime1 = [NSDate dateWithTimeInterval:0 sinceDate:[NSDate date]];
    // Запланированый Финиш (текущая дата + час)
    NSDate *taskStartTime2 = [NSDate dateWithTimeIntervalSinceNow:0];
    timeDifference100 = [taskStartTime2 timeIntervalSinceDate:taskStartTime1];
    NSLog(@"timeDifference100:%f",timeDifference100);
    [self updateTimerStuff];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)startTrackingTime{
    [self.largeProgressView resumeAnimation];
    [self.largeProgressView setAnimatedProgress:0 withDuration:timeDifference100];
    //запускаем отсчет времени
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimerStuff) userInfo:nil repeats:YES];
}
-(void)pauseTrackingTime{
    duration += timeDifference;
    NSLog(@"Time:%d",duration);
    timeDifference = -1;
    [timer invalidate];
    timer = nil;
    if (overtime == false)
    {
        [self.largeProgressView stopAnimation];
    }
}
-(void)resumeTrackingTime{
    if (overtime == false)
    {
        [self.largeProgressView resumeAnimation];
        progressPercentage = 1-(duration/timeDifference100);
        NSLog(@"first:%f",progressPercentage);
        [self.largeProgressView setProgress:progressPercentage];
        [self.largeProgressView setAnimatedProgress:0 withDuration:timeDifference100-duration];
    }
    
    [self updateTimerStuff];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimerStuff) userInfo:nil repeats:YES];
}

- (NSString*)getTimeStringFrom:(int)seconds{
    
    hour = (seconds)/3600;
    
    if (hour < 10)
        timeString = [NSString stringWithFormat:@"0%i:",hour];
    else
        timeString = [NSString stringWithFormat:@"%i:",hour];
    
    minute = ((seconds)-(hour*3600))/60;
    if (minute < 10)
        timeString = [NSString stringWithFormat:@"%@0%i:",timeString,minute];
    else
        timeString = [NSString stringWithFormat:@"%@%i:",timeString,minute];
    
    sec = (seconds)-((hour*3600)+(minute*60));
    if (sec < 10)
        timeString = [NSString stringWithFormat:@"%@0%i",timeString,sec];
    else
        timeString = [NSString stringWithFormat:@"%@%i",timeString,sec];
    
    return timeString;
}

-(void)updateTimerStuff{
    
    timeDifference++;
    if (timeDifference+duration < timeDifference100 )
    {
        time = timeDifference100-(timeDifference+duration);
        timerLabel.text = [self getTimeStringFrom:time];
    }
    else
    {
        if (overtime == false)
        {
            overtime = true;
            duration += timeDifference;
            timeDifference = 1;
            
        }
        
        timerLabel.text = [self getTimeStringFrom:(duration-timeDifference100)+timeDifference];
        timerTitleLabel.text = @"Overtime";
        
        
        /*   [timer invalidate];
         timer = nil;
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Times up" message:@"Your project \n Project title \n times up \n\n" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         
         UITextView *someTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 35, 250, 100)];
         someTextView.backgroundColor = [UIColor clearColor];
         someTextView.textColor = [UIColor whiteColor];
         someTextView.editable = NO;
         someTextView.font = [UIFont systemFontOfSize:15];
         // someTextView.text = @"Enter Text Here";
         [alert addSubview:someTextView];
         [alert show];
         [someTextView release];
         [alert release];
         */
    }
    NSLog(@"%f",timeDifference);
    
    
    
}
-(IBAction)playPauseButtonPressed{
    if(unsavedTrackedTask == nil)
    {
        unsavedTrackedTask = [[TTItem alloc] initWithEmptyFields];
        unsavedTrackedTask.dtStartDate = [NSDate date];
    }
    
    if([playPauseButton.titleLabel.text isEqualToString:@"Pause"])
    {
        [playPauseButton setTitle:@"Resume" forState:UIControlStateNormal];
        [self pauseTrackingTime];
    }
    else if([playPauseButton.titleLabel.text isEqualToString:@"Resume"])
    {
        [playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self resumeTrackingTime];
    }
    else if ([playPauseButton.titleLabel.text isEqualToString:@"Start"])
    {
        [playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self startTrackingTime];
    }
}
-(IBAction)stopButtonPressed{
    //    if ()®
    //    {}
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)completeButtonPressed{
    
    playPauseButton.hidden = TRUE;
    cancelButton.hidden = TRUE;
    stopButton.hidden = TRUE;
    [timer invalidate];
    timer = nil;
    [self.largeProgressView setProgress:0];
    self.timerLabel.text = @"00:00:00";
    timerTitleLabel.text = @"Time ramaining";

    float tmpTime = (duration-timeDifference100)+timeDifference;
    NSLog(@"completeButtonPressed::tracked time: %f",tmpTime);
    
    if (!externalArgument)
    {
        if (unsavedTrackedTask  == nil)
        {
            unsavedTrackedTask = [[TTItem alloc] initWithEmptyFields];
        }

        unsavedTrackedTask.numRealDuration = &(tmpTime);
        unsavedTrackedTask.dtEndDate = [NSDate date];

        [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_NEW_TASK forNavigationController:self.navigationController withArgument:unsavedTrackedTask];
    }
    else
    {
        externalArgument.numRealDuration = &(tmpTime);
        externalArgument.strIsChecked = @"1";
     
        
        [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_CURRENT_TASKS forNavigationController:self.navigationController];
    }

}
-(IBAction)cancelButtonPressed{
    [playPauseButton setTitle:@"Start" forState:UIControlStateNormal];
    duration = 0;
    timeDifference = 0;
    [timer invalidate];
    timer = nil;
    [self.largeProgressView setProgress:1];
    [self updateTimerStuff];
    overtime = false;
    timerTitleLabel.text = @"Time ramaining";
    unsavedTrackedTask = nil;
}

-(void)calculateRemainingTaskDurationOfTask: (TTItem*)taskItem
{
 //       NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
  //                                                                     fromDate:taskItem.dtStartDate];
//	NSInteger seconds = [dateComponents second];
//	NSInteger minutes = [dateComponents minute];
//	NSInteger hours = [dateComponents hour];

  //  [self.largeProgressView setTrackTintColor:[[UIColor alloc] initWithRed:0x3b/255.0 green:0x45/255.0 blue:0x4e/255.0 alpha:1]];

    [_largeProgressView setProgressTintColor:[TTTools colorWithHexString:taskItem.strColor]];
    
    NSDate *taskStartTime = [taskItem.dtStartDate copy];
    NSDate *taskEndTime = taskItem.dtEndDate;
    timeDifference100 = [taskEndTime timeIntervalSinceDate:taskStartTime]+1;
    NSLog(@"timeDifference100:%f",timeDifference100);
    [self updateTimerStuff];

}

-(void)setExternalArgument:(TTItem*)argument
{
    externalArgument = argument;
    [self updateViewWithNewData];
}

- (TTItem*)getExternalArgument
{
    return externalArgument;
}


-(void) updateViewWithNewData
{
    [self calculateRemainingTaskDurationOfTask:externalArgument];
//    NSMutableArray * dictExistingTaskFields = [[TTAppDataManager sharedAppDataManager] updateNewTaskFormFieldsWithData:externalArgument];
//      [newProjectTableController setArrayTableViewData:dictExistingTaskFields];
}

@end
