//
//  TTSettingsViewController.h
//  TimeTracker
//
//  Created by ProstoApps* on 6/29/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTApplicationManager.h"
#import "TTFieldsTableViewController.h"

@interface TTSettingsViewController : UIViewController{
    IBOutlet UITableView * tableSettings;
    id <UITableViewDelegate>  _delegateTableSettings;
    id <UITableViewDataSource>  _dataSourceTableSettings;
}
@property(nonatomic,retain) id <UITableViewDelegate>  _delegateTableSettings;
@property(nonatomic,retain) id <UITableViewDataSource>  _dataSourceTableSettings;
@end
