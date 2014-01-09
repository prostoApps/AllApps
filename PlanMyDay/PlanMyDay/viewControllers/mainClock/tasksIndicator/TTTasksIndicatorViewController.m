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
@synthesize tasksHolderView;

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
    arrTasksForToday = [[NSMutableArray alloc] initWithArray:arrTasks ];
    [self drawTasksToView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tasksHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [self.view addSubview:tasksHolderView];

    [self.largeProgressView setTrackTintColor:[[UIColor alloc] initWithRed:0x3b/255.0 green:0x45/255.0 blue:0x4e/255.0 alpha:1]];
    [self.largeProgressView setProgressTintColor:[[UIColor alloc] initWithRed:0xfc/255.0 green:0x3e/255.0 blue:0x39/255.0 alpha:0]];
    self.largeProgressView.roundedCorners = NO;
    
    [self.tasksHolderView addSubview:self.largeProgressView];
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
    NSDate *dtStartDate;
    NSDate *dtEndDate;
    NSString *strColor;
    
    self.tasksHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [self.view addSubview:tasksHolderView];
    
    [self.largeProgressView setTrackTintColor:[[UIColor alloc] initWithRed:0x3b/255.0 green:0x45/255.0 blue:0x4e/255.0 alpha:1]];
    [self.largeProgressView setProgressTintColor:[[UIColor alloc] initWithRed:0xfc/255.0 green:0x3e/255.0 blue:0x39/255.0 alpha:0]];
    self.largeProgressView.roundedCorners = NO;
    
    [self.tasksHolderView addSubview:self.largeProgressView];
    [self.largeProgressView setThicknessRatio:0.066];
    
    [self.largeProgressView setProgress:0.75f];


//    tasksHolderView = nil;


    for (UIView *tmpView in [self.tasksHolderView subviews]) {
        if ([[self.tasksHolderView subviews] objectAtIndex:0] != [self.tasksHolderView.subviews lastObject])
        {
            [tmpView removeFromSuperview];
        }
//        if (tmpView != [[self.tasksHolderView subviews] lastObject])
//        {
//            [tmpView removeFromSuperview];
//        }
    }
//    [tasksHolderView addSubview:self.largeProgressView];

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
        
        NSDateComponents *tmpDateComponents = [calendar components:(NSHourCalendarUnit) fromDate:dtStartDate];
        NSInteger numHourOfTaskStarts = [tmpDateComponents hour];
        
        DACircularProgressView *largeProgressViewTMP = [[DACircularProgressView alloc] initWithFrame:CGRectMake(28, 74, 265, 265)];
        largeProgressViewTMP.layer.anchorPoint = CGPointMake(0.5, 0.5);
        [largeProgressViewTMP setTrackTintColor:[[UIColor alloc] initWithRed:0xfc/255.0 green:0x3e/255.0 blue:0xff/255.0 alpha:0]];
        [largeProgressViewTMP setProgressTintColor:[TTTools colorWithHexString:strColor]];
        
        
        largeProgressViewTMP.roundedCorners = NO;
        [tasksHolderView addSubview:largeProgressViewTMP];
        
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
