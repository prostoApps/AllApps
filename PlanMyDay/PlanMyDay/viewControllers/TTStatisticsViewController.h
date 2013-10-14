//
//  TTStatisticsViewController.h
//  TimeTracker
//
//  Created by ProstoApps* on 6/29/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "DACircularProgressView.h"
#import "TTAppDataManager.h"
#import "TTTools.h"
#import <UIKit/UIKit.h>

@interface TTStatisticsViewController : UIViewController

@property (strong, nonatomic) IBOutlet DACircularProgressView *largeProgressView;

-(void)drawTasksToView:(NSMutableArray*)arrTasks;

@end
