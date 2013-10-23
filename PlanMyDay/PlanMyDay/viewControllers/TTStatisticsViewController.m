//
//  TTStatisticsViewController.m
//  TimeTracker
//
//  Created by ProstoApps* on 6/29/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTStatisticsViewController.h"

@interface TTStatisticsViewController ()

@end

@implementation TTStatisticsViewController

@synthesize largeProgressView = _largeProgressView;
//@synthesize tasksNavigator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    [self drawTasksToView:[[TTAppDataManager sharedAppDataManager] getAllTasks]];
//    [tasksNavigator initWithTasks];
}

-(void)drawTasksToView:(NSMutableArray*)arrTasks
{
    float numDuration = 0;
    float numTotalDuration = 0;
    float fDurationRatio = 0;
    float numRotationAngle = 0;
    NSDate *dtStartDate;
    NSDate *dtEndDate;
    NSString *strColor;
    
    NSMutableArray *arrProjectsToDraw = [[NSMutableArray alloc] init];
    
    //    NSString *strNewString = [strColor substringToIndex:2];
    //    flo *strNewString = [strColor substringWithRange:NSMakeRange(0, 2)];
    //    [strColor floatValue];
    
    for (NSMutableDictionary *dictTmpTask in arrTasks)
    {
        dtStartDate = [dictTmpTask objectForKey:STR_START_DATE];
        dtEndDate   = [dictTmpTask objectForKey:STR_END_DATE];
        numDuration = [dtEndDate timeIntervalSinceDate:dtStartDate]/3600;
        
        numTotalDuration += numDuration;
        
        if (arrProjectsToDraw.count == 0)
        {
            NSMutableDictionary *dictTmpProject = [[NSMutableDictionary alloc] init];
            [dictTmpProject setObject:[dictTmpTask objectForKey:STR_PROJECT_NAME] forKey:STR_PROJECT_NAME];
            [dictTmpProject setObject:[NSNumber numberWithFloat:0.0] forKey:STR_DURATION];
            [dictTmpProject setObject:[dictTmpTask objectForKey:STR_TASK_COLOR] forKey:STR_TASK_COLOR];
            
            float tmpProjectDuration = [[dictTmpProject objectForKey:STR_DURATION] floatValue];
            tmpProjectDuration += numDuration;
            NSNumber *tmpNumberDuration = [NSNumber numberWithFloat:tmpProjectDuration];
            [dictTmpProject setValue:tmpNumberDuration forKey:STR_DURATION];
            [arrProjectsToDraw addObject:dictTmpProject];
        }
        else
        {
            for (NSMutableDictionary * dictProject in arrProjectsToDraw) {
                if ([dictProject objectForKey:STR_PROJECT_NAME] != [dictTmpTask objectForKey:STR_PROJECT_NAME])
                {
                    NSMutableDictionary *dictTmpProject = [[NSMutableDictionary alloc] init];
                    [dictTmpProject setObject:[dictTmpTask objectForKey:STR_PROJECT_NAME] forKey:STR_PROJECT_NAME];
                    [dictTmpProject setObject:[NSNumber numberWithFloat:0.0] forKey:STR_DURATION];
                    [dictTmpProject setObject:[dictTmpTask objectForKey:STR_TASK_COLOR] forKey:STR_TASK_COLOR];
                    [arrProjectsToDraw addObject:dictTmpProject];
                    
                    float tmpProjectDuration = [[dictTmpProject objectForKey:STR_DURATION] floatValue];
                    tmpProjectDuration += numDuration;
                    NSNumber *tmpNumberDuration = [NSNumber numberWithFloat:tmpProjectDuration];
                    [dictTmpProject setValue:tmpNumberDuration forKey:STR_DURATION];
                }
                else
                {
                    float tmpProjectDuration = [[dictProject objectForKey:STR_DURATION] floatValue];
                    tmpProjectDuration += numDuration;
                    NSNumber *tmpNumberDuration = [NSNumber numberWithFloat:tmpProjectDuration];
                    [dictProject setValue:tmpNumberDuration forKey:STR_DURATION];
                }
               
            }
    
        }
    }
    
    for (NSMutableDictionary *dictTask in arrProjectsToDraw)
    {
        strColor    = [dictTask objectForKey:STR_TASK_COLOR];
        numDuration = [[dictTask objectForKey:STR_DURATION] floatValue];
        
        fDurationRatio = numDuration * 12 / numTotalDuration ;
        
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
        
        [largeProgressViewTMP setProgress:fDurationRatio*NUM_ONE_HOUR_DURATION];
        
        CABasicAnimation *rota = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rota.duration = 5;
        rota.autoreverses = NO;
        rota.removedOnCompletion = NO;
        rota.fillMode = kCAFillModeForwards;
        rota.fromValue = [NSNumber numberWithFloat: 0];
        rota.toValue = [NSNumber numberWithFloat:  numRotationAngle ];
        [largeProgressViewTMP.layer addAnimation: rota forKey: @"rotation"];
        numRotationAngle += fDurationRatio*NUM_ONE_HOUR_ROTATION;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
