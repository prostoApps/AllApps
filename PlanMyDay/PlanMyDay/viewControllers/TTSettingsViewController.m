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
    NSString * settingsSelectedCategory;
}

@end

@implementation TTSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        settingsTableController = [[TTFieldsTableViewController alloc] init];
        settingsSelectedCategory = @"Settings";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [settingsTableController setDelegate:self];
    
    [tableSettings setDelegate:settingsTableController];
    [tableSettings setDataSource:settingsTableController];
    [TTTools makeButtonStyled:btnApply];
    [tableSettings setTableFooterView:footerTableView];
}
//

-(void) viewWillAppear:(BOOL)animated{
    if (tableSettings != nil){
        [tableSettings reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)btnApplyTouchHandler:(id)sender{
    
}
#pragma mark TTFieldsTableDelegate metods
-(NSArray *)getTableViewData{
    return [[TTAppDataManager sharedAppDataManager] getTableFieldsOptionsByCategory:settingsSelectedCategory];
}
-(UIViewController *)getParentController{
    return self;
}
-(UITableView *)getTableView{
    return tableSettings;
}
-(void) saveValue:(id)value byIndexPath:(NSIndexPath*)indexPath{
    [[TTAppDataManager sharedAppDataManager] saveTableFieldsOptionValue:value byIndexPath:indexPath onCategory:settingsSelectedCategory];
    [tableSettings reloadData];
}
-(id)getValuebyIndexPath:(NSIndexPath*)indexPath{
    return [[TTAppDataManager sharedAppDataManager] getTableFieldsOptionValueByIndexPath:indexPath onCategory:settingsSelectedCategory];
}
@end
