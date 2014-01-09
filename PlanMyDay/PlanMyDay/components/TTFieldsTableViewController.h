//
//  TTFieldsTableViewController.h
//  PlanMyDay
//
//  Created by Torasike on 18.10.13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTApplicationManager.h"

@interface TTFieldsTableViewController : UITableViewController <UITextFieldDelegate>{
    
    id <TTFieldsTableDelegate> delegate;
    
}
@property (nonatomic,assign) id <TTFieldsTableDelegate>  delegate;

@property (retain,nonatomic) IBOutlet UIDatePicker * dpTaskDatePicker;
@property (retain,nonatomic) IBOutlet UIView * dpView;
@property (retain,nonatomic) UIViewController * parentViewController ;
@property (nonatomic,assign) NSArray * arrayTableViewData;
@property (nonatomic,assign) UITableView *tableViewParametrs;




@end
