//
//  TTSelectPropertyViewController.m
//  PlanMyDay
//
//  Created by ProstoApps* on 8/11/13.
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
    
    [tablePropertiesList setTableFooterView:viewTableFooter];
    
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    
    selectStr = [NSString stringWithFormat:@"%@",[appDataManager getNewProjectFieldsValue:STR_NEW_PROJECT_NAME
                                                                                byIndexPath:[[TTApplicationManager sharedApplicationManager] ipNewProjectSelectedProperty]]];
    [self setTitle:[NSString stringWithFormat:@"Choose %@",selectStr]];
    btnAddSelection.titleLabel.text = [NSString stringWithFormat:@"Add %@",selectStr];
    [[TTAppDataManager sharedAppDataManager] makeButtonStyled:btnAddSelection];
    
    if ([selectStr isEqualToString:STR_NEW_PROJECT_CLIENT]){
       arrProperties = [appDataManager getAllClients];
    }
    else if ([selectStr isEqualToString:STR_NEW_PROJECT_PROJECT]){
         arrProperties = [appDataManager getAllProjects];
    }
    
    if (arrProperties.count <= 0)
    {
        tablePropertiesList.hidden = true;
        btnAddFirst.hidden = false;
        [btnAddFirst setTitle:[NSString stringWithFormat:@"Add First %@",selectStr] forState:UIControlStateNormal];
        lbAddFirst.hidden = false;
        lbAddFirst.text = [NSString stringWithFormat:@"There are no any %@s yet",selectStr];
        [[TTAppDataManager sharedAppDataManager] makeButtonStyled:btnAddFirst];
    }
    
    //Внешний вид
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"bgUiSearch.png"] forState:UIControlStateNormal];
   // [tablePropertiesList setBackgroundColor:[[TTAppDataManager sharedAppDataManager] colorWithHexString:@"#54616f"]];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [arrProperties count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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

    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"tableView didSelectRowAtIndexPath:: indexPath %@, with text: %@",indexPath,cell.textLabel.text);
        NSLog(@"tableView didSelectRowAtIndexPath:: ipNewProjectSelectedProperty %@,",[[TTApplicationManager sharedApplicationManager] ipNewProjectSelectedProperty]);
    [[TTAppDataManager sharedAppDataManager] saveNewProjectFieldsValue:cell.textLabel.text
                                                             byIndexPath:[[TTApplicationManager sharedApplicationManager] ipNewProjectSelectedProperty]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(IBAction)AddNewSelectionItemHehdler:(id)sender{
    
    [[TTApplicationManager sharedApplicationManager] setStrNewProjectSelectedCategory:selectStr];
    
    if ([selectStr isEqualToString:STR_NEW_PROJECT_PROJECT]){
        [[TTAppDataManager sharedAppDataManager] setSegmentIndexNewProject:NUM_NEW_PROJECT_SELECTED_SEGMENT_PROJECT];
    }
    else if([selectStr isEqualToString:STR_NEW_PROJECT_CLIENT]){
         [[TTAppDataManager sharedAppDataManager] setSegmentIndexNewProject:NUM_NEW_PROJECT_SELECTED_SEGMENT_CLIENT];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
