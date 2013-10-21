//
//  TTStatisticFilterViewController.m
//  PlanMyDay
//
//  Created by Torasike on 16.10.13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTStatisticFilterViewController.h"

@interface TTStatisticFilterViewController (){
     TTFieldsTableViewController * filterTableController;
}

@end

@implementation TTStatisticFilterViewController
@synthesize _dataSourceTableFilter;
@synthesize _delegateTableFilter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
            filterTableController = [[TTFieldsTableViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    

    [appDataManager loadFilterFormData];
    
    [filterTableController setArrayTableViewData:appDataManager.arrayFilterFormData];
    [filterTableController setParentViewController:self];
    [filterTableController setTableViewParametrs:tableFilter];
    
    _delegateTableFilter = filterTableController;
    _dataSourceTableFilter = filterTableController;
    
    [tableFilter setDelegate:_delegateTableFilter];
    [tableFilter setDataSource:_dataSourceTableFilter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
