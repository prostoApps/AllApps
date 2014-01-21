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
@synthesize delegate;

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
    
    arrProperties = [delegate getSelectedFieldData];
    btnAddSelection.titleLabel.text = [NSString stringWithFormat:@"Add %@",[delegate getSelectedFieldName]];
    if (arrProperties.count <= 0)
    {
        tablePropertiesList.hidden = true;
        btnAddFirst.hidden = false;
        [btnAddFirst setTitle:[NSString stringWithFormat:@"Add First %@",selectStr] forState:UIControlStateNormal];
        lbAddFirst.hidden = false;
        lbAddFirst.text = [NSString stringWithFormat:@"There are no any %@s yet",selectStr];
        [TTTools makeButtonStyled:btnAddFirst];
    }
    
    //Внешний вид
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"bgUiSearch.png"] forState:UIControlStateNormal];
   // [tablePropertiesList setBackgroundColor:[TTTools colorWithHexString:@"#54616f"]];
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
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    NSString * strCurrentFieldValue = [[arrProperties objectAtIndex:[indexPath row]] objectForKey:[NSString stringWithFormat:@"%@Name",[[delegate getSelectedFieldName] lowercaseString]]];
    NSString * strSelectedFieldValue = [NSString stringWithFormat:@"%@",[delegate getSelectedFieldTableValue]];
    
    NSString * strSelectedFieldName =[ NSString stringWithFormat:@"%@",[delegate getSelectedFieldName]];
   
    
    if ([strSelectedFieldName isEqualToString:STR_NEW_PROJECT_PROJECT]) {
        strCurrentFieldValue = [ NSString stringWithFormat:@"%@ (%@)",strCurrentFieldValue,[[arrProperties objectAtIndex:[indexPath row]] objectForKey:STR_CLIENT_NAME]];
    }
    else if ([strSelectedFieldName isEqualToString:STR_NEW_PROJECT_TASK]){
        strCurrentFieldValue = [ NSString stringWithFormat:@"%@ (%@)",strCurrentFieldValue,[[arrProperties objectAtIndex:[indexPath row]] objectForKey:STR_PROJECT_NAME]];
    }
    
    cell.textLabel.text = strCurrentFieldValue;
    
    if ([strCurrentFieldValue isEqualToString:strSelectedFieldValue]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return cell;
}
// Tap on table Row
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [delegate saveSelectedFieldTableValue:cell.textLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(IBAction)AddNewSelectionItemHehdler:(id)sender{
    [delegate addNewSelectedFieldItem];
   
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
