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
    NSArray *formDataDictionary;
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
    [self setTitle:@"Add New Task"];
   // [self initVisibleComponents];
    [self loadPropertyForView];
}

- (void) loadPropertyForView {
    NSString * nameStr =[[TTAppDataManager sharedAppDataManager] addNewStr];
    [self setTitle:[NSString stringWithFormat:@"Add %@",nameStr]];
    [btnSave setTitle:[NSString stringWithFormat:@"Add %@",nameStr] forState:UIControlStateNormal];
    
    // загружаем стили ячеек для формы
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"PropertyListOfViewForms" ofType:@"plist"];
    NSDictionary * rootDictionary =[NSDictionary dictionaryWithContentsOfFile:plistPath];
    formDataDictionary = [NSArray arrayWithArray:[rootDictionary objectForKey:nameStr]];
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
    NSArray *listData =[[formDataDictionary objectAtIndex:section] objectForKey:@"cells"];
    return [listData count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [formDataDictionary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath    *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    NSArray *listData = [[formDataDictionary objectAtIndex:[indexPath section]] objectForKey:@"cells"];
    
    UITextField *inputField;
    UISwitch *swithField;
    NSUInteger row = [indexPath row];
    int typeCell = [[[listData objectAtIndex:row] objectForKey:@"type"] intValue];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
   // if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        switch ( typeCell ) {
            case 0:
                
               cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                 break;
            case 1:
                inputField = [[UITextField alloc] initWithFrame:CGRectMake(80,0,220,44)];
                inputField.adjustsFontSizeToFitWidth = YES;
                inputField.textColor = [UIColor whiteColor];
                [cell addSubview:inputField];
                break;
            case 2:
                
                swithField = [[UISwitch alloc] initWithFrame:CGRectMake(255, 6, 40,30)];
                
                [cell addSubview:swithField];
                break;
                
            default:
                break;
        }

   // }
    
    cell.backgroundColor = [self colorWithHexString:@"#333b43"];
    cell.textLabel.textColor = [UIColor whiteColor];

    cell.textLabel.text = [[listData objectAtIndex:row] objectForKey:@"name"];
       cell.accessibilityValue = [[listData objectAtIndex:row] objectForKey:@"name"];
    
     return cell;
     }

// Apple's docs: To enable the swipe-to-delete feature of table views (wherein a user swipes horizontally across a row to display a Delete button), you must implement the tableView:commitEditingStyle:forRowAtIndexPath: method.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"commitEditingStyle");
}
// Tap on table Row
- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath {
    NSArray *listData = [[formDataDictionary objectAtIndex:[indexPath section]] objectForKey:@"cells"];
    NSUInteger row = [indexPath row];
    [[TTAppDataManager sharedAppDataManager] setSelectProperty:[[listData objectAtIndex:row] objectForKey:@"name"]];
    
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
   
    tempLabel.text = [[formDataDictionary objectAtIndex:section] objectForKey:@"name"];
    tempLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:13];
    [tempView addSubview:tempLabel];
    return tempView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 30.f;
}

-(IBAction) segmentedControlIndexChanged
{
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
