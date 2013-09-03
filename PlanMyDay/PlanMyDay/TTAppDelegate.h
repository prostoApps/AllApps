//
//  TTAppDelegate.h
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 7/3/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMainClockViewController.h"
#import "TTApplicationManager.h"
#import "DDMenuController.h"
#import "TTMenuViewController.h"

@class TTMainClockViewController;

@interface TTAppDelegate : UIResponder <UIApplicationDelegate , UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DDMenuController *menuController;
@property (strong, nonatomic) TTMainClockViewController *viewController;

@end
