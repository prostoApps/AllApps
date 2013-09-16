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
    // переопределяем значения для таблицы
   // currentFormDataArray = [[NSArray alloc] init];
//    currentFormDataArray = [appDataManager.addTTItemData objectForKey:nameStr];
   // currentFormPropertyArray = [NSArray arrayWithArray:[rootFormPropertyDictionary objectForKey:nameStr]];
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
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell.detailTextLabel setFrame:CGRectMake(80, 0, 180, 44)];
        cell.backgroundColor = [[TTAppDataManager sharedAppDataManager] colorWithHexString:@"#333b43"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else{
        //clear cell
        cell.accessoryType = UITableViewCellAccessoryNone;
        [[cell viewWithTag:1] removeFromSuperview];
        [[cell viewWithTag:2] removeFromSuperview];
        cell.detailTextLabel.text = nil;
        
    }
    
   
    switch ( typeCell ) {
        case 0:
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [[listData objectAtIndex:row] objectForKey:@"value"];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
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
    //cell.accessibilityValue = [[listData objectAtIndex:row] objectForKey:@"name"];
    
     return cell;
     }

// Apple's docs: To enable the swipe-to-delete feature of table views (wherein a user swipes horizontally across a row to display a Delete button), you must implement the tableView:commitEditingStyle:forRowAtIndexPath: method.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    [[TTAppDataManager sharedAppDataManager] setSelectPropertyIndexPath:indexPath];
    
    [[TTApplicationManager sharedApplicationManager] pushViewTo:VIEW_SELECT_PROPERTY forNavigationController:self.navigationController];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //we are using gestures, don't allow editing
    return NO;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,305,30)];
    tempView.backgroundColor=[UIColor clearColor];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,305,30)];
    tempLabel.textColor = [UIColor whiteColor];
   
    tempLabel.text = [[currentFormPropertyArray objectAtIndex:section] objectForKey:@"name"];
    tempLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:13];
    [tempView addSubview:tempLabel];
    return tempView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 30.f;
}
#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return TRUE;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
	 NSIndexPath *indexPath = [TaskTableView indexPathForCell:(UITableViewCell*)[[textField superview] superview]]; // this should return you your current indexPath
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    
    [appDataManager saveTTItemAddDataValue:textField.text valueSection:[indexPath section] valueRow:[indexPath row]];
    

   
    
   
    NSLog(@"index path: %@",indexPath);
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


////
////-(void)initTextFields
////{
////    //init clientName textfield
////    tfClientName = [[UITextField alloc]initWithFrame:CGRectMake(20, 50, 280, 31)];
////    tfClientName.borderStyle = UITextBorderStyleRoundedRect;
////    tfClientName.textColor = [UIColor whiteColor];
////    tfClientName.font = [UIFont systemFontOfSize:17.0];
////    tfClientName.placeholder = @"Client Name";
////    tfClientName.backgroundColor = [UIColor whiteColor];
////    tfClientName.autocorrectionType = UITextAutocorrectionTypeNo;
////    tfClientName.backgroundColor = [UIColor clearColor];
////    tfClientName.keyboardType = UIKeyboardTypeDefault;
////    tfClientName.returnKeyType = UIReturnKeyDone;
////    
////    tfClientName.clearButtonMode = UITextFieldViewModeWhileEditing;
////    [tfClientName addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpOutside];
////    [self.view addSubview:tfClientName];
////    
////    //init projectName textfield
////    tfProjectName = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, 280, 31)];
////    tfProjectName.borderStyle = UITextBorderStyleRoundedRect;
////    tfProjectName.textColor = [UIColor whiteColor];
////    tfProjectName.font = [UIFont systemFontOfSize:17.0];
////    tfProjectName.placeholder = @"Project Name";
////    tfProjectName.backgroundColor = [UIColor whiteColor];
////    tfProjectName.autocorrectionType = UITextAutocorrectionTypeNo;
////    tfProjectName.backgroundColor = [UIColor clearColor];
////    tfProjectName.keyboardType = UIKeyboardTypeDefault;
////    tfProjectName.returnKeyType = UIReturnKeyDone;
////    
////    tfProjectName.clearButtonMode = UITextFieldViewModeWhileEditing;
////    [tfProjectName addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpOutside];
////    [self.view addSubview:tfProjectName];
////    
////    //init TaskName textfield
////    tfTaskName = [[UITextField alloc]initWithFrame:CGRectMake(20, 110, 280, 31)];
////    tfTaskName.borderStyle = UITextBorderStyleRoundedRect;
////    tfTaskName.textColor = [UIColor whiteColor];
////    tfTaskName.font = [UIFont systemFontOfSize:17.0];
////    tfTaskName.placeholder = @"Task Name";
////    tfTaskName.backgroundColor = [UIColor whiteColor];
////    tfTaskName.autocorrectionType = UITextAutocorrectionTypeNo;
////    tfTaskName.backgroundColor = [UIColor clearColor];
////    tfTaskName.keyboardType = UIKeyboardTypeDefault;
////    tfTaskName.returnKeyType = UIReturnKeyDone;
////    
////    tfTaskName.clearButtonMode = UITextFieldViewModeWhileEditing;
////    [tfTaskName addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpOutside];
////    [self.view addSubview:tfTaskName];
////}
//
//-(IBAction)hideKeyboard:(id)sender
//{
//    [tfClientName resignFirstResponder];
//}
//
//-(IBAction)sliderValueChangedHandler:(id)sender
//{
//    imgImage.alpha = sldrSlider.value;
//}
//
//-(IBAction)btnSaveTouchHandler:(id)sender
//{
//    
//    [tfClientName resignFirstResponder]; //hide keyboard
//    [tfProjectName resignFirstResponder]; //hide keyboard
//    [tfTaskName resignFirstResponder]; //hide keyboard
//    [tfStartDate resignFirstResponder]; //hide keyboard
//    [tfStartTime resignFirstResponder]; //hide keyboard
//    [tfDuration resignFirstResponder]; //hide keyboard
//    [tfColor resignFirstResponder]; //hide keyboard
//    
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
//
//-(IBAction)btnSelectClientTouchHandler:(id)sender
//{
//    NSLog(@"btnSelectClientTouchHandler");
//    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_SELECT_PROPERTY forNavigationController:self.navigationController];
//    
//}
//
//-(IBAction)btnSelectProjectTouchHandler:(id)sender
//{
//    NSLog(@"btnSelectProjectTouchHandler");
//    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_SELECT_PROPERTY forNavigationController:self.navigationController];
//}
//
//-(IBAction)btnSelectColorTouchHandler:(id)sender
//{
//    NSLog(@"btnSelectColorTouchHandler");
//    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_SELECT_PROPERTY forNavigationController:self.navigationController];
//}
//-(IBAction)btnClearTouchHandler:(id)sender
//{
//    
//}
//-(void)collectDataToItem:(TTItem*)item
//{
//    item.strClientName = tfClientName.text;
//    item.strProjectName = tfProjectName.text;
//    item.strTaskName = tfTaskName.text;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
