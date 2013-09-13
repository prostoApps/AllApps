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

@synthesize tfClientName,tfColor,tfDuration,tfStartTime,tfStartDate,tfTaskName,tfProjectName,btnSave,sldrSlider,imgImage,lblLabel,scTaskProjectClient,btnSelectClient,btnSelectColor,btnSelectProject;


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
    
    [self initVisibleComponents];
}

-(void)initVisibleComponents
{
    [scrvScrollView setScrollEnabled:YES];
    [scrvScrollView setContentSize:CGSizeMake(320, 650)];
    
    // загружаем ячейки формы
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"PropertyListOfViewForms" ofType:@"plist"];
    NSDictionary * rootDictionary =[NSDictionary dictionaryWithContentsOfFile:plistPath];
    formDataDictionary = [NSArray arrayWithArray:[rootDictionary objectForKey:@"newProject"]];

    
    
    /* Блок Project info внешний вид
    bgProjectInfo.layer.borderColor = [self colorWithHexString:@"#a8adb3"].CGColor;
    bgProjectInfo.layer.borderWidth = 1.0f;
    
    tfTaskName.layer.borderColor = [self colorWithHexString:@"#333b43"].CGColor;
    
    lbTask.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TTTasksTableViewCell.png"]];
    */
    
   


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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        switch ( typeCell ) {
            case 0:
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                break;
            case 1:
                inputField = [[UITextField alloc] initWithFrame:CGRectMake(80,12,160,20)];
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

        
    }
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

    NSLog(@"tap on accessoryButton");

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //we are using gestures, don't allow editing
    return NO;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,305,32)];
    tempView.backgroundColor=[UIColor clearColor];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,305,32)];
    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    tempLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:16];
   
    tempLabel.text = [[formDataDictionary objectAtIndex:section] objectForKey:@"name"];
    
    [tempView addSubview:tempLabel];
    
    return tempView;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return @"Task Info";
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

-(void)initTextFields
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
    
    //init projectName textfield
    tfProjectName = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, 280, 31)];
    tfProjectName.borderStyle = UITextBorderStyleRoundedRect;
    tfProjectName.textColor = [UIColor whiteColor];
    tfProjectName.font = [UIFont systemFontOfSize:17.0];
    tfProjectName.placeholder = @"Project Name";
    tfProjectName.backgroundColor = [UIColor whiteColor];
    tfProjectName.autocorrectionType = UITextAutocorrectionTypeNo;
    tfProjectName.backgroundColor = [UIColor clearColor];
    tfProjectName.keyboardType = UIKeyboardTypeDefault;
    tfProjectName.returnKeyType = UIReturnKeyDone;
    
    tfProjectName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [tfProjectName addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:tfProjectName];
    
    //init TaskName textfield
    tfTaskName = [[UITextField alloc]initWithFrame:CGRectMake(20, 110, 280, 31)];
    tfTaskName.borderStyle = UITextBorderStyleRoundedRect;
    tfTaskName.textColor = [UIColor whiteColor];
    tfTaskName.font = [UIFont systemFontOfSize:17.0];
    tfTaskName.placeholder = @"Task Name";
    tfTaskName.backgroundColor = [UIColor whiteColor];
    tfTaskName.autocorrectionType = UITextAutocorrectionTypeNo;
    tfTaskName.backgroundColor = [UIColor clearColor];
    tfTaskName.keyboardType = UIKeyboardTypeDefault;
    tfTaskName.returnKeyType = UIReturnKeyDone;
    
    tfTaskName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [tfTaskName addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:tfTaskName];
}

-(IBAction)hideKeyboard:(id)sender
{
    [tfClientName resignFirstResponder];
}

-(IBAction)sliderValueChangedHandler:(id)sender
{
    imgImage.alpha = sldrSlider.value;
}

-(IBAction)btnSaveTouchHandler:(id)sender
{
 
    [tfClientName resignFirstResponder]; //hide keyboard
    [tfProjectName resignFirstResponder]; //hide keyboard
    [tfTaskName resignFirstResponder]; //hide keyboard
    [tfStartDate resignFirstResponder]; //hide keyboard
    [tfStartTime resignFirstResponder]; //hide keyboard
    [tfDuration resignFirstResponder]; //hide keyboard
    [tfColor resignFirstResponder]; //hide keyboard
    
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
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_SELECT_PROPERTY forNavigationController:self.navigationController];

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) segmentedControlIndexChanged
{
	switch (self.scTaskProjectClient.selectedSegmentIndex) {
		case 0:
			NSLog(@"SegmentedControlTask");
            [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_NEW_TASK forNavigationController:self.navigationController];

			break;
		case 1:
			NSLog(@"SegmentedControlProject");
           [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_SELECT_PROPERTY forNavigationController:self.navigationController];
			break;
		case 2:
			NSLog(@"SegmentedControlCleint");
            [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_CREATE_PROPERTY forNavigationController:self.navigationController];
			break;
            
		default:
            break;
    }
}

-(IBAction) btnMenuTouchHandler:(id)sender
{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_MENU forNavigationController:self.navigationController];
}



@end
