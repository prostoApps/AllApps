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
    NSArray * currentFormPropertyArray;
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
      //  NSArray * nibbArray = [[NSBundle mainBundle] loadNibNamed:@"TTNewProjectViewController" owner:self options:nil];
      //  self = [nibbArray objectAtIndex:0];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    
    [appDataManager makeButtonStyled:btnSave];

    headerTableViewNewProject.layer.borderColor = [[TTAppDataManager sharedAppDataManager] colorWithHexString:@"#a8adb3"].CGColor;
    headerTableViewNewProject.layer.borderWidth = 1.0f;
    [tableViewNewProject setTableFooterView:footerTableViewNewProject];
    
    //[scTaskProjectClient.tintColor ]
    [scTaskProjectClient setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor whiteColor], UITextAttributeTextColor,
                                          nil] forState:UIControlStateSelected];
    
	// Do any additional setup after loading the view.
    if (appDataManager.nameNewProject == nil)
    {
        appDataManager.nameNewProject = STR_NEW_PROJECT_TASK;
    }
    [appDataManager loadNewProjectFormData];
    
    [self loadPropertyForView];
}

-(void) viewWillAppear:(BOOL)animated{
    
    if (tableViewNewProject != nil){
        [tableViewNewProject reloadData];
    }
}
- (void) loadPropertyForView {
    
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    NSString * nameStr = appDataManager.nameNewProject;
    
    [self setTitle:[NSString stringWithFormat:@"Add %@",nameStr]];
    [btnSave setTitle:[NSString stringWithFormat:@"Add %@",nameStr] forState:UIControlStateNormal];
    [scTaskProjectClient setSelectedSegmentIndex:appDataManager.segmentIndexNewProject];
    
    currentFormPropertyArray = [appDataManager getNewProjectFormData];
    [tableViewNewProject reloadData];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)table
 numberOfRowsInSection:(NSInteger)section {
    NSArray *listData =[[currentFormPropertyArray objectAtIndex:section] objectForKey:STR_NEW_PROJECT_CELLS];
    return [listData count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [currentFormPropertyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath    *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    NSArray *listData = [[currentFormPropertyArray objectAtIndex:[indexPath section]] objectForKey:STR_NEW_PROJECT_CELLS];
    NSUInteger row = [indexPath row];
    int typeCell = [[[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_TYPE] intValue];
    
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    //сохраняем в Дикшионари Дата менеджера  Индекс ячейки. с ключем -> Названиe ячейки
    [[appDataManager.dictNewProjectIndexPaths objectForKey:appDataManager.nameNewProject] setObject:indexPath forKey:[[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_NAME]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell.detailTextLabel setFrame:CGRectMake(80, 0, 180, 44)];
        cell.backgroundColor = [[TTAppDataManager sharedAppDataManager] colorWithHexString:@"#333b43"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:17];
        cell.textLabel.textColor = [[TTAppDataManager sharedAppDataManager] colorWithHexString:@"#a7acb2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:17];
    }
    else
    {
        //Очищаем ячейку
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
        cell.detailTextLabel.text = nil;
        [[cell viewWithTag:1] removeFromSuperview];
        [[cell viewWithTag:3] removeFromSuperview];
        
    }
    
    // если ячейчка с выбором
   if (typeCell == 0)
   {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_VALUE];
   }
    // если ячейчка с инпутом
   else if (typeCell == 1)
   {
            UITextField * inputField = [[UITextField alloc] initWithFrame:CGRectMake(100,0,220,44)];
            inputField.adjustsFontSizeToFitWidth = YES;
            inputField.textColor = [UIColor whiteColor];
            inputField.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:17];
            inputField.tag = 1;
            inputField.delegate = self;
            inputField.text = [[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_VALUE];
            [cell addSubview:inputField];
    }
    // если ячейчка с переключателем
    else if (typeCell == 2)
    {
            UISwitch * swithField = [[UISwitch alloc] initWithFrame:CGRectZero];
            [swithField addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [swithField setOn:[[[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_VALUE] boolValue]];
            [cell setAccessoryView:swithField];
    }
    // если ячейчка выбора цвета
    else if (typeCell == 3)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView * imageColor = [[UIImageView alloc] initWithFrame:CGRectMake(100, 8, 25, 25)];
        UIColor * color = [appDataManager colorWithHexString:[[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_VALUE]];
        imageColor.backgroundColor = color;
        imageColor.tag = 3;
        [cell addSubview:imageColor];
    }
    
    cell.textLabel.text = [[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_NAME];
   
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,305,30)];
    tempView.backgroundColor=[UIColor clearColor];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,305,30)];
    tempLabel.textColor = [UIColor whiteColor];
    
    tempLabel.text = [[currentFormPropertyArray objectAtIndex:section] objectForKey:STR_NEW_PROJECT_NAME];
    tempLabel.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_REGULAR size:14];
    [tempView addSubview:tempLabel];
    return tempView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

// Tap on table Row
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    [[TTAppDataManager sharedAppDataManager] setIpNewProjectSelectProperty:indexPath];
    
    NSString * selectStr = [NSString stringWithFormat:@"%@",[[TTAppDataManager sharedAppDataManager] getNewProjectFormDataValue:STR_NEW_PROJECT_NAME byIndexPath:indexPath]];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%d",cell.accessoryType);
    if (cell.accessoryType == 1){
        
        if( [selectStr isEqualToString:STR_NEW_PROJECT_COLOR])
        {
            [[TTApplicationManager sharedApplicationManager] pushViewTo:VIEW_SELECT_COLOR forNavigationController:self.navigationController];
        }
        else
        {
          [[TTApplicationManager sharedApplicationManager] pushViewTo:VIEW_SELECT_PROPERTY forNavigationController:self.navigationController];
        }
    }
}

#pragma mark -
#pragma mark UISwitch methods

- (void) switchChanged:(id)sender
{
    UISwitch* switchControl = sender;
    NSIndexPath *indexPath = [tableViewNewProject indexPathForCell:(UITableViewCell*)[[switchControl superview] superview]]; // this should return you
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    [appDataManager saveNewProjectFormDataValue:switchControl.on ? @"YES" : @"NO" byIndexPath:indexPath];
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
	 NSIndexPath *indexPath = [tableViewNewProject indexPathForCell:(UITableViewCell*)[[textField superview] superview]]; // this should return you your current indexPath
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    
    [appDataManager saveNewProjectFormDataValue:textField.text byIndexPath:indexPath];
    
 }

#pragma mark -
#pragma mark segmentedControl methods
-(IBAction) segmentedControlIndexChanged
{
    [self.view endEditing:YES];
    [[TTAppDataManager sharedAppDataManager] setSegmentIndexNewProject:scTaskProjectClient.selectedSegmentIndex];
    
	switch (self.scTaskProjectClient.selectedSegmentIndex) {
		case 0:
            [[TTAppDataManager sharedAppDataManager] setNameNewProject:STR_NEW_PROJECT_TASK];
			break;
		case 1:
            [[TTAppDataManager sharedAppDataManager] setNameNewProject:STR_NEW_PROJECT_PROJECT];
			break;
		case 2:
            [[TTAppDataManager sharedAppDataManager] setNameNewProject:STR_NEW_PROJECT_CLIENT];
			break;
		default:
            break;
    }
    
    [self loadPropertyForView];
}


-(IBAction) btnSaveTouchHandler:(id)sender{
    
   [[TTAppDataManager sharedAppDataManager] saveTTItem];
    [[TTAppDataManager sharedAppDataManager] clearNewProjectFormData];
   [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
