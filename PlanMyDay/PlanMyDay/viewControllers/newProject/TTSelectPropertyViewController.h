//
//  TTSelectPropertyViewController.h
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 8/11/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTApplicationManager.h"

@interface TTSelectPropertyViewController : UIViewController
{
    IBOutlet UIButton *btnBack;
    IBOutlet UILabel * titleLabel;
}

-(IBAction)btnBackTouchHandler:(id)sender;

@property (retain,nonatomic) IBOutlet UIButton *btnBack;
@property(retain,nonatomic) NSString * propertyToSelect;

@end
