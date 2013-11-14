//
//  TTTasksIndicatorViewController.m
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 10/8/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTTasksIndicatorViewController.h"

@interface TTTasksIndicatorViewController ()

@end

float const NUM_ONE_HOUR_DURATION = 0.08333f;
float const NUM_ONE_HOUR_ROTATION = 0.523f;

@implementation TTTasksIndicatorViewController

@synthesize largeProgressView = _largeProgressView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithTasks:(NSMutableArray*)arrTasks;
{
    self = [super init];
    if (self) {
        arrTasksForToday = [[NSMutableArray alloc] initWithArray:arrTasks];
    }
    return self;
}

-(void)updateWithTasks:(NSMutableArray*) arrTasks
{
    arrTasksForToday = [arrTasks copy];
    [self drawTasksToView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.largeProgressView setTrackTintColor:[[UIColor alloc] initWithRed:0x3b/255.0 green:0x45/255.0 blue:0x4e/255.0 alpha:1]];
    [self.largeProgressView setProgressTintColor:[[UIColor alloc] initWithRed:0xfc/255.0 green:0x3e/255.0 blue:0x39/255.0 alpha:0]];
    self.largeProgressView.roundedCorners = NO;
    [self.view addSubview:self.largeProgressView];
    [self.largeProgressView setThicknessRatio:0.066];
    
    [self.largeProgressView setProgress:0.75f];
    [self drawTasksToView];
    // Запланированый старт (текущая дата - час)
    NSDate *taskStartTime1 = [NSDate dateWithTimeInterval:-2 sinceDate:[NSDate date]];
    // Запланированый Финиш (текущая дата + час)
    NSDate *taskStartTime2 = [NSDate dateWithTimeInterval:2 sinceDate:[NSDate date]];
    float timeDifference100 = [taskStartTime2 timeIntervalSinceDate:taskStartTime1];
    NSLog(@"timeDifference100:%f",timeDifference100);
}

-(void)drawTasksToView
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    float numDuration = 0;
    float numTotalDuration = 0;
    float fDurationRatio = 0;
    NSDate *dtStartDate;
    NSDate *dtEndDate;
    NSString *strColor;
    
    //    NSString *strNewString = [strColor substringToIndex:2];
    //    flo *strNewString = [strColor substringWithRange:NSMakeRange(0, 2)];
    //    [strColor floatValue];
    
    for (NSMutableDictionary *dictTmpTask in arrTasksForToday)
    {
        dtStartDate = [dictTmpTask objectForKey:STR_START_DATE];
        dtEndDate   = [dictTmpTask objectForKey:STR_END_DATE];
        numDuration = [dtEndDate timeIntervalSinceDate:dtStartDate]/3600;
        
        numTotalDuration += numDuration;
    }
    
    for (NSMutableDictionary *dictTask in arrTasksForToday)
    {
        strColor    = [dictTask objectForKey:STR_TASK_COLOR];
        
        dtStartDate = [dictTask objectForKey:STR_START_DATE];
        dtEndDate   = [dictTask objectForKey:STR_END_DATE];
        numDuration = [dtEndDate timeIntervalSinceDate:dtStartDate]/3600;
        
        fDurationRatio = numDuration / numTotalDuration;
        
        NSDateComponents *tmpDateComponents = [calendar components:(NSHourCalendarUnit) fromDate:dtStartDate];
        NSInteger numHourOfTaskStarts = [tmpDateComponents hour];
        
        NSString *strRedString = [NSString stringWithFormat:@"%@", [strColor substringWithRange:NSMakeRange(0, 2)]];
        float fRed = [[TTTools hexFromStr:strRedString] floatValue];
        NSString *strGreenString = [NSString stringWithFormat:@"%@", [strColor substringWithRange:NSMakeRange(2, 2)]];
        float fGreen = [[TTTools hexFromStr:strGreenString] floatValue];
        NSString *strBlueString = [NSString stringWithFormat:@"%@", [strColor substringWithRange:NSMakeRange(4, 2)]];
        float fBlue = [[TTTools hexFromStr:strBlueString] floatValue];
        
        DACircularProgressView *largeProgressViewTMP = [[DACircularProgressView alloc] initWithFrame:CGRectMake(28, 74, 265, 265)];
        largeProgressViewTMP.layer.anchorPoint = CGPointMake(0.5, 0.5);
        [largeProgressViewTMP setTrackTintColor:[[UIColor alloc] initWithRed:0xfc/255.0 green:0x3e/255.0 blue:0xff/255.0 alpha:0]];
        [largeProgressViewTMP setProgressTintColor:[[UIColor alloc] initWithRed:fRed/6666.0 green:fGreen/6666.0 blue:fBlue/6666.0 alpha:1]];
        
        largeProgressViewTMP.roundedCorners = NO;
        [self.view addSubview:largeProgressViewTMP];
        [largeProgressViewTMP setThicknessRatio:0.066];
        
        [largeProgressViewTMP setProgress:numDuration*NUM_ONE_HOUR_DURATION];
        
        CABasicAnimation *rota = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rota.duration = 5;
        rota.autoreverses = NO;
        rota.removedOnCompletion = NO;
        rota.fillMode = kCAFillModeForwards;
        rota.fromValue = [NSNumber numberWithFloat: 0];
        rota.toValue = [NSNumber numberWithFloat:  numHourOfTaskStarts*NUM_ONE_HOUR_ROTATION ];
        [largeProgressViewTMP.layer addAnimation: rota forKey: @"rotation"];
        //        return;
        //        [dictTask setObject:largeProgressViewTMP forKey:STR_ARC];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
