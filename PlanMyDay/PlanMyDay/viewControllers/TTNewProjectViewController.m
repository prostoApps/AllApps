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

@synthesize btnSave,scTaskProjectClient;


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

-(void)initVisibleComponents
{
    [scrvScrollView setScrollEnabled:YES];
    [scrvScrollView setContentSize:CGSizeMake(320, 1000)];
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

- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}
#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //init clientName textfield
    tfClientName = [[UITextField alloc]initWithFrame:CGRectMake(20, 50, 280, 31)];
    tfClientName.borderStyle = UITextBorderStyleRoundedRect;
    tfClientName.textColor = [UIColor whiteColor];
    tfClientName.font = [UIFont systemFontOfSize:17.0];
    tfClientName.placeholder = @"Client Name";
    tfClientName.backgroundColor = [UIColor whiteColor];
    tfClientName.autocorrectionType = UITextAutocorrectionTypeNo;
    tfClientName.backgroundColor = [UIColor clearColor];
    tfClientName.keyboardType = UIKeyboardTypeDefault;
    tfClientName.returnKeyType = UIReturnKeyDone;
    
    tfClientName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [tfClientName addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:tfClientName];
}

-(IBAction)hideKeyboard:(id)sender
{
    [tfClientName resignFirstResponder];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
	 NSIndexPath *indexPath = [TaskTableView indexPathForCell:(UITableViewCell*)[[textField superview] superview]]; // this should return you your current indexPath
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    
    //read data from device
/*    NSString *filePathToProjectData = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"projectData.plist"];
    
    NSDictionary *dictCustomProject = [NSDictionary dictionaryWithContentsOfFile:filePathToProjectData];*/
    
    TTItem *item = [[TTItem alloc] init];
    
    [self collectDataToItem:item];
    
//    lblLabel.text = [@"Client Name defined successfully!" stringByAppendingString:tfClientName.text];
    
    //    NSDictionary *dictProjectData = [[NSDictionary alloc] initWithObjectsAndKeys:
    //                                     lblLabel.text, @"clientName",
    //                                     @"projectName1", @"projectName",
    //                                     @"05.06.2013", @"startDate",
    //                                     @"12.55"     , @"startTime",
    //                                     @"05.06.2013", @"endDate",
    //                                     @"13.00"     , @"endTime",
    //                                     @"300"       , @"durationPlan",
    //                                     @"300"       , @"durationFact",
    //                                     @"FFFFFF"    , @"color", nil];
    //
    NSLog(@"clinetName: %@",item.strClientName);
    
    [[TTAppDataManager sharedAppDataManager] saveTTItem:item];
//    [[TTAppDataManager sharedAppDataManager] saveTTItem:item];
    //    [dictProjectData writeToFile:filePathToProjectData atomically:YES];
}

-(IBAction)btnSelectClientTouchHandler:(id)sender
{
    NSLog(@"btnSelectClientTouchHandler");
    NSMutableArray *arrClients = [[NSMutableArray alloc] initWithArray:[[TTAppDataManager sharedAppDataManager] getAllClients]];
    //еcли есть клиенты - переходим на вью выбора клиента
    //если нету клиентов - переходим на вью создания нового клиента
    if (arrClients.count > 0)
    {
        NSMutableDictionary *dictData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:arrClients, STR_ALL_CLIENTS, nil];
        [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_SELECT_PROPERTY
                                              forNavigationController:self.navigationController
                                                           withParams:dictData];
    }
    else
    {
        [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_CREATE_PROPERTY forNavigationController:self.navigationController];
    }
}

-(IBAction)btnSelectProjectTouchHandler:(id)sender
{
    NSLog(@"btnSelectProjectTouchHandler");
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_SELECT_PROPERTY forNavigationController:self.navigationController];
}

-(IBAction)btnSelectColorTouchHandler:(id)sender
{
    NSLog(@"btnSelectColorTouchHandler");
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_SELECT_PROPERTY forNavigationController:self.navigationController];
}
-(void)collectDataToItem:(TTItem*)item
{
    item.strClientName = tfClientName.text;
    item.strProjectName = tfProjectName.text;
    item.strTaskName = tfTaskName.text;
    item.dtStartDate = [NSDate date];
//    item.dtEndDate = [item.dtStartDate dateByAddingTimeInterval:60*60*2]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
			NSLog(@"SegmentedControlCleint");
            [[TTAppDataManager sharedAppDataManager] setAddNewStr:@"Client"];
            [self loadPropertyForView];
			break;
            
		default:
            break;
    }
}


//-(IBAction)btnSaveTouchHandler:(id)sender
//{

//    //read data from device
//    /*    NSString *filePathToProjectData = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"projectData.plist"];
//     
//     NSDictionary *dictCustomProject = [NSDictionary dictionaryWithContentsOfFile:filePathToProjectData];*/
//    
//    TTItem *item = [[TTItem alloc] init];
//    
//    [self collectDataToItem:item];
//    
//    //    lblLabel.text = [@"Client Name defined successfully!" stringByAppendingString:tfClientName.text];
//    
//    //    NSDictionary *dictProjectData = [[NSDictionary alloc] initWithObjectsAndKeys:
//    //                                     lblLabel.text, @"clientName",
//    //                                     @"projectName1", @"projectName",
//    //                                     @"05.06.2013", @"startDate",
//    //                                     @"12.55"     , @"startTime",
//    //                                     @"05.06.2013", @"endDate",
//    //                                     @"13.00"     , @"endTime",
//    //                                     @"300"       , @"durationPlan",
//    //                                     @"300"       , @"durationFact",
//    //                                     @"FFFFFF"    , @"color", nil];
//    //
//    NSLog(@"clinetName: %@",item.strClientName);
//    
//    [[TTAppDataManager sharedAppDataManager] saveTTItem:item];
//    //    [[TTAppDataManager sharedAppDataManager] saveTTItem:item];
//    //    [dictProjectData writeToFile:filePathToProjectData atomically:YES];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
