//
//  TTAppDelegate.h
//  PlanMyDay
//
//  Created by ProstoApps* on 7/3/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTApplicationManager.h"
#import "DDMenuController.h"

@class DDMenuController;
@interface TTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) DDMenuController *menuController;
@property (strong, nonatomic) UIWindow *window;

@end
