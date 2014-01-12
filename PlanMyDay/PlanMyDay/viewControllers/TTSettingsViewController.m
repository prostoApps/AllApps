//
//  TTSettingsViewController.m
//  TimeTracker
//
//  Created by ProstoApps* on 6/29/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTSettingsViewController.h"

@interface TTSettingsViewController (){
    TTFieldsTableViewController * settingsTableController;
}

@end

@implementation TTSettingsViewController
@synthesize _dataSourceTableSettings;
@synthesize _delegateTableSettings;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        settingsTableController = [[TTFieldsTableViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    
    [appDataManager loadSettingsFields];
    
    
    [settingsTableController setTableViewParametrs:tableSettings];
    
    _delegateTableSettings = settingsTableController;
    _dataSourceTableSettings = settingsTableController;
    
    [tableSettings setDelegate:_delegateTableSettings];
    [tableSettings setDataSource:_dataSourceTableSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
