//
//  TTNewProjectViewController.m
//  TimeTracker
//
//  Created by Yegor Karpechenkov on 6/21/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTNewProjectViewController.h"


@interface TTNewProjectViewController ()
{
   
    NSDictionary * rootFormPropertyDictionary;
    NSArray *currentFormPropertyArray;
    NSArray * currentFormDataArray;
    
    
}

@end

@implementation TTNewProjectViewController

@synthesize scTaskProjectClient;


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
	// Do any additional setup after loading the view.
    [[TTAppDataManager sharedAppDataManager] setAddNewStr:@"Task"];
    [[TTAppDataManager sharedAppDataManager] loadTTItemFormData];
    
    //rootFormPropertyDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
   // rootFormPropertyDictionary
    [self setTitle:@"Add New Task"];
   // [self initVisibleComponents];
    [self loadPropertyForView];
}

- (void) loadPropertyForView {
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    NSString * nameStr = appDataManager.addNewStr;
    
    [self setTitle:[NSString stringWithFormat:@"Add %@",nameStr]];
    [btnSave setTitle:[NSString stringWithFormat:@"Add %@",nameStr] forState:UIControlStateNormal];

    currentFormPropertyArray = [appDataManager getAddTTItemFormData];
    [TaskTableView reloadData];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)table
 numberOfRowsInSection:(NSInteger)section {
    NSArray *listData =[[currentFormPropertyArray objectAtIndex:section] objectForKey:@"cells"];
    return [listData count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [currentFormPropertyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath    *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    NSArray *listData = [[currentFormPropertyArray objectAtIndex:[indexPath section]] objectForKey:@"cells"];
    
    UITextField *inputField;
    UISwitch *swithField;
    NSUInteger row = [indexPath row];
    int typeCell = [[[listData objectAtIndex:row] objectForKey:@"type"] intValue];

    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell.detailTextLabel setFrame:CGRectMake(80, 0, 180, 44)];
        cell.backgroundColor = [[TTAppDataManager sharedAppDataManager] colorWithHexString:@"#333b43"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        //clear cell
        cell.accessoryType = UITableViewCellAccessoryNone;
        [[cell viewWithTag:1] removeFromSuperview];
        [[cell viewWithTag:2] removeFromSuperview];
        cell.detailTextLabel.text = nil;
    }

   
    switch ( typeCell )
    {
        case 0:
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [[listData objectAtIndex:row] objectForKey:@"value"];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
           // cell.selectedBackgroundView = []
            break;
        case 1:
            inputField = [[UITextField alloc] initWithFrame:CGRectMake(80,0,220,44)];
            inputField.adjustsFontSizeToFitWidth = YES;
            inputField.textColor = [UIColor whiteColor];
            inputField.tag = 1;
            inputField.delegate = self;
            inputField.text = [[listData objectAtIndex:row] objectForKey:@"value"];
           
            [cell addSubview:inputField];
            break;
        case 2:
            swithField = [[UISwitch alloc] initWithFrame:CGRectMake(255, 6, 30,30)];
            swithField.tag = 2;
            
            
            [cell addSubview:swithField];
            break;
            
        default:
            break;
    }
    
     NSLog(@"Selection style: %d",cell.selectionStyle);
    
    cell.textLabel.text = [[listData objectAtIndex:row] objectForKey:@"name"];
    
     return cell;
     }

// Apple's docs: To enable the swipe-to-delete feature of table views (wherein a user swipes horizontally across a row to display a Delete button), you must implement the tableView:commitEditingStyle:forRowAtIndexPath: method.
/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"commitEditingStyle");
}

// Tap on table Row
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    [[TTAppDataManager sharedAppDataManager] setSelectPropertyIndexPath:indexPath];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%d",cell.selectionStyle);
    if (cell.selectionStyle == 3){
         [[TTApplicationManager sharedApplicationManager] pushViewTo:VIEW_SELECT_PROPERTY forNavigationController:self.navigationController];
    }
    else
    {
        
    }
    
}

// Tap on table Row
- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath {
    
    lblLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 370, 300, 21)];
    lblLabel.backgroundColor = [UIColor clearColor];
    lblLabel.font = [UIFont systemFontOfSize:15.0];
    lblLabel.textAlignment = NSTextAlignmentCenter;
    lblLabel.text = @"Please enter the Client Name";
    [self.view addSubview:lblLabel];
}
 */

// Tap on table Row
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    [[TTAppDataManager sharedAppDataManager] setSelectPropertyIndexPath:indexPath];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%d",cell.selectionStyle);
    if (cell.selectionStyle == 3){
        [[TTApplicationManager sharedApplicationManager] pushViewTo:VIEW_SELECT_PROPERTY forNavigationController:self.navigationController];
    }
    
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	 NSIndexPath *indexPath = [TaskTableView indexPathForCell:(UITableViewCell*)[[textField superview] superview]]; // this should return you your current indexPath
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    
    [appDataManager saveTTItemAddDataValue:textField.text valueSection:[indexPath section] valueRow:[indexPath row]];
    
 }

//
//-(IBAction)btnSelectClientTouchHandler:(id)sender
//{
//    NSLog(@"btnSelectClientTouchHandler");
//    NSMutableArray *arrClients = [[NSMutableArray alloc] initWithArray:[[TTAppDataManager sharedAppDataManager] getAllClients]];
//    //еcли есть клиенты - переходим на вью выбора клиента
//    //если нету клиентов - переходим на вью создания нового клиента
//    if (arrClients.count > 0)
//    {
//        NSMutableDictionary *dictData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:arrClients, STR_ALL_CLIENTS, nil];
//        [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_SELECT_PROPERTY
//                                              forNavigationController:self.navigationController
//                                                           withParams:dictData];
//    }
//    else
//    {
//        [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_CREATE_PROPERTY forNavigationController:self.navigationController];
//    }
//}

#pragma mark -
#pragma mark segmentedControl methods
-(IBAction) segmentedControlIndexChanged
{
    [self.view endEditing:YES];
	switch (self.scTaskProjectClient.selectedSegmentIndex) {
		case 0:
            [[TTAppDataManager sharedAppDataManager] setAddNewStr:@"Task"];
            [self loadPropertyForView];
			break;
            
		case 1:
            [[TTAppDataManager sharedAppDataManager] setAddNewStr:@"Project"];
            [self loadPropertyForView];
			break;
            
		case 2:
            [[TTAppDataManager sharedAppDataManager] setAddNewStr:@"Client"];
            [self loadPropertyForView];
			break;
            
		default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
