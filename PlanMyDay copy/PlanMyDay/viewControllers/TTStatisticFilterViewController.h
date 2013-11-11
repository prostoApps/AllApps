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

@interface TTStatisticFilterViewController : UIViewController
{
    IBOutlet UITableView * tableFilter;
    id <UITableViewDelegate>  _delegateTableFilter;
    id <UITableViewDataSource>  _dataSourceTableFilter;
 //   IBOutlet UIView * footerTableViewFilter;
  //  IBOutlet UIButton * btnApply;
}
@property(nonatomic,retain) id <UITableViewDelegate>  _delegateTableFilter;
@property(nonatomic,retain) id <UITableViewDataSource>  _dataSourceTableFilter;
@end
