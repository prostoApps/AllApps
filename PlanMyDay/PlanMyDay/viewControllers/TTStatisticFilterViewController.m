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
    NSString * filterSelectedCategory;
}

@end

@implementation TTStatisticFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
            filterTableController = [[TTFieldsTableViewController alloc] init];
            filterSelectedCategory = @"Filter";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [filterTableController setDelegate:self];
    
    [tableFilter setDelegate:filterTableController];
    [tableFilter setDataSource:filterTableController];
    [TTTools makeButtonStyled:btnApply];
    [tableFilter setTableFooterView:footerTableViewFilter];
}
//

-(void) viewWillAppear:(BOOL)animated{
    if (tableFilter != nil){
         [tableFilter reloadData];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) btnApplyTouchHandler:(id)sender{
    
}
#pragma mark TTFieldsTableDelegate metods
-(NSArray *)getTableViewData{
    return [[TTAppDataManager sharedAppDataManager] getTableFieldsOptionsByCategory:filterSelectedCategory];
}
-(UIViewController *)getParentController{
    return self;
}
-(UITableView *)getTableView{
    return tableFilter;
}
-(void) saveValue:(id)value byIndexPath:(NSIndexPath*)indexPath{
    [[TTAppDataManager sharedAppDataManager] saveTableFieldsOptionValue:value byIndexPath:indexPath onCategory:filterSelectedCategory];
    [tableFilter reloadData];
}
-(id)getValuebyIndexPath:(NSIndexPath*)indexPath{
    return [[TTAppDataManager sharedAppDataManager] getTableFieldsOptionValueByIndexPath:indexPath onCategory:filterSelectedCategory];
}

@end
