//
//  TTAppDelegate.h
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 7/3/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMainClockViewController.h"
@class TTMainClockViewController;

@interface TTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TTMainClockViewController *viewController;

@end
