//
//  TTCustomTrackerViewController.m
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 7/29/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTCustomTrackerViewController.h"

@interface TTCustomTrackerViewController ()

@end

@implementation TTCustomTrackerViewController

@synthesize timerTitleLabel;
@synthesize timerLabel;
@synthesize largeProgressView = _largeProgressView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    
    [self.largeProgressView setTrackTintColor:[[UIColor alloc] initWithRed:0x3b/255.0 green:0x45/255.0 blue:0x4e/255.0 alpha:1]];
    [self.largeProgressView setProgressTintColor:[[UIColor alloc] initWithRed:0xfc/255.0 green:0x3e/255.0 blue:0x39/255.0 alpha:1]];
    self.largeProgressView.roundedCorners = NO;
    [self.view addSubview:self.largeProgressView];
    [self.largeProgressView setThicknessRatio:0.066];
    
    stopButton.layer.cornerRadius = 3;
    playPauseButton.layer.cornerRadius = 3;
    cancelButton.layer.cornerRadius = 3;
    stopButton.layer.masksToBounds = YES;
    playPauseButton.layer.masksToBounds = YES;
    cancelButton.layer.masksToBounds = YES;
    
    
    timeDifference = -1;
    duration = 0;
    [self.largeProgressView setProgress:1];
    // Запланированый старт (текущая дата - час)
    NSDate *taskStartTime1 = [NSDate dateWithTimeInterval:-2 sinceDate:[NSDate date]];
    // Запланированый Финиш (текущая дата + час)
    NSDate *taskStartTime2 = [NSDate dateWithTimeInterval:2 sinceDate:[NSDate date]];
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
-(IBAction)playPayseButtonPressed{
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
    
}
-(IBAction)cancelButtonPressed{
    [playPauseButton setTitle:@"Start" forState:UIControlStateNormal];
    duration = 0;
    timeDifference = -1;
    [timer invalidate];
    timer = nil;
    [self.largeProgressView setProgress:1];
    [self updateTimerStuff];
    overtime = false;
    timerTitleLabel.text = @"Time ramaining";
}
@end
