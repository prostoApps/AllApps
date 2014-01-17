//
//  TTStatisticFilterViewController.h
//  PlanMyDay
//
//  Created by Torasike on 16.10.13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTAppDataManager.h"
#import "TTFieldsTableViewController.h"

@interface TTStatisticFilterViewController : UIViewController <TTFieldsTableDelegate>
{
    IBOutlet UITableView * tableFilter;
    IBOutlet UIView * footerTableViewFilter;
    IBOutlet UIButton * btnApply;
}

-(IBAction) btnApplyTouchHandler:(id)sender;
@end
