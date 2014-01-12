//
//  TTFieldsTableViewController.h
//  PlanMyDay
//
//  Created by Torasike on 18.10.13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTApplicationManager.h"
#import "TTSelectColorViewController.h"
#import "TTSelectPropertyViewController.h"

@interface TTFieldsTableViewController : UITableViewController <UITextFieldDelegate,TTSelectedFieldTableDelegate>{
    
    id <TTFieldsTableDelegate> delegate;
    NSIndexPath * indexCurrentSelectedItem;
    
}
@property (nonatomic,retain) id <TTFieldsTableDelegate>  delegate;

@property (retain,nonatomic) IBOutlet UIDatePicker * dpTaskDatePicker;
@property (retain,nonatomic) IBOutlet UIView * dpView;
@property (nonatomic,assign) UITableView *tableViewParametrs;




@end
