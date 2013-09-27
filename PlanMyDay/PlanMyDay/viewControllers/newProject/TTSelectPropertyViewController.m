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

@synthesize tablePropertiesList,arrProperties;

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
    // Do any additional setup after loading the view from its nib.
    
 
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    
    selectIP = appDataManager.ipNewProjectSelectProperty;
    selectStr = [NSString stringWithFormat:@"%@",[appDataManager getNewProjectFormDataValue:STR_NEW_PROJECT_NAME byIndexPath:selectIP]];
    [self setTitle:[NSString stringWithFormat:@"Choose %@",selectStr]];
    
    if ([selectStr isEqualToString:STR_NEW_PROJECT_CLIENT]){
       arrProperties = [appDataManager getAllClients];
    }
    else if ([selectStr isEqualToString:STR_NEW_PROJECT_PROJECT]){
         arrProperties = [appDataManager getAllProjects];
    }
    
    
    //Внешний вид
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"bgUiSearch.png"] forState:UIControlStateNormal];
   // [tablePropertiesList setBackgroundColor:[[TTAppDataManager sharedAppDataManager] colorWithHexString:@"#54616f"]];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [arrProperties count];
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
    if ([selectStr isEqualToString:STR_NEW_PROJECT_CLIENT]){
        cell.textLabel.text = [[arrProperties objectAtIndex:[indexPath row]] objectForKey:STR_CLIENT_NAME];
    }
    else if ([selectStr isEqualToString:STR_NEW_PROJECT_PROJECT]){
        cell.textLabel.text = [[arrProperties objectAtIndex:[indexPath row]] objectForKey:STR_PROJECT_NAME];
    }
    
    
    return cell;
}
// Tap on table Row
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
      TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [appDataManager saveNewProjectFormDataValue:cell.textLabel.text byIndexPath:appDataManager.ipNewProjectSelectProperty];
    [self.navigationController popViewControllerAnimated:YES];
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
