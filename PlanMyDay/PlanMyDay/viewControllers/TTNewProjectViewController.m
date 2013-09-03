//
//  TTNewProjectViewController.m
//  TimeTracker
//
//  Created by Yegor Karpechenkov on 6/21/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTNewProjectViewController.h"


@interface TTNewProjectViewController ()

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
    
    NSArray *arrTemp1 = [[NSArray alloc]
                         initWithObjects:@"Task",@"Project",@"Client",@"Color",@"Billable",nil];
    NSArray *arrTemp2 = [[NSArray alloc]
                         initWithObjects:@"Date",@"Start",@"Finish",nil];
    NSDictionary *temp =[[NSDictionary alloc]
                         initWithObjectsAndKeys:arrTemp1,@"Task Info",arrTemp2,@"Planning Time",nil];
    tableContents = temp;
    sortedKeys = [[NSArray alloc]
                  initWithObjects:@"Task Info",@"Planning Time",nil];

    
    
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
    NSArray *listData =[tableContents objectForKey:[sortedKeys objectAtIndex:section]];
    return [listData count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [sortedKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath    *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    NSArray *listData =[tableContents objectForKey:
                        [sortedKeys objectAtIndex:[indexPath section]]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor = [self colorWithHexString:@"#333b43"];

    cell.textLabel.textColor = [UIColor whiteColor];
 
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [listData objectAtIndex:row];
       cell.accessibilityValue = [listData objectAtIndex:row];
    
     return cell;
     }

// Apple's docs: To enable the swipe-to-delete feature of table views (wherein a user swipes horizontally across a row to display a Delete button), you must implement the tableView:commitEditingStyle:forRowAtIndexPath: method.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    lblLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 370, 300, 21)];
    lblLabel.backgroundColor = [UIColor clearColor];
    lblLabel.font = [UIFont systemFontOfSize:15.0];
    lblLabel.textAlignment = NSTextAlignmentCenter;
    lblLabel.text = @"Please enter the Client Name";
    [self.view addSubview:lblLabel];
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
}

-(IBAction)hideKeyboard:(id)sender
{
    [tfClientName resignFirstResponder];
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
