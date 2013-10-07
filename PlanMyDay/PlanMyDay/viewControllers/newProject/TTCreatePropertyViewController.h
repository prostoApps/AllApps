//
//  TTCreatePropertyViewController.h
//  PlanMyDay
//
//  Created by ProstoApps* on 8/11/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTApplicationManager.h"

@interface TTCreatePropertyViewController : UIViewController
{
IBOutlet UIButton *btnBack;
}

-(IBAction)btnBackTouchHandler:(id)sender;

@property (retain,nonatomic) IBOutlet UIButton *btnBack;
@end
