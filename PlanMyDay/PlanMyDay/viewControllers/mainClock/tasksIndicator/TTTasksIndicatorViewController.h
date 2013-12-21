//
//  TTTasksIndicatorViewController.h
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 10/8/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
#import "TTTools.h"
#import "TTItem.h"

@interface TTTasksIndicatorViewController : UIViewController
{
    NSMutableArray * arrTasksForToday;
}

extern const CGFloat NUM_ONE_HOUR_ROTATION;
extern const CGFloat NUM_ONE_HOUR_DURATION;

-(id)initWithTasks:(NSMutableArray*)arrTasks;
-(void)drawTasksToView;
-(void)updateWithTasks:(NSMutableArray*) arrTasks;

@property (strong, nonatomic) IBOutlet DACircularProgressView *largeProgressView;
@property (strong, nonatomic) UIView *tasksHolderView;

@end
