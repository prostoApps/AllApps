//
//  TTSelectPropertyViewController.m
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 8/11/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTSelectPropertyViewController.h"

@interface TTSelectPropertyViewController ()

@end

@implementation TTSelectPropertyViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    
    selectIP = appDataManager.selectPropertyIndexPath;
    selectStr = [NSString stringWithFormat:@"%@",[appDataManager getValueFormData:@"name" ByIndexPath:selectIP]];
    [self setTitle:[NSString stringWithFormat:@"Choose %@",selectStr]];
    
    
  }

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath    *)indexPath {
    static NSString *CellIdentifier = @"selectCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        
    }
    
    cell.textLabel.text = selectStr;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
