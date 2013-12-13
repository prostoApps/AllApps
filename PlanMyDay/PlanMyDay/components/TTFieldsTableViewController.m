//
//  TTParametrsTableViewController.m
//  PlanMyDay
//
//  Created by Torasike on 18.10.13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTFieldsTableViewController.h"

@interface TTFieldsTableViewController ()

@end

@implementation TTFieldsTableViewController
@synthesize parentViewController;
@synthesize arrayTableViewData;
@synthesize tableViewParametrs;
@synthesize dpTaskDatePicker;
@synthesize dpView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self.view addSubview:dpView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrayTableViewData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *listData =[[arrayTableViewData objectAtIndex:section] objectForKey:STR_NEW_PROJECT_CELLS];
    return [listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    NSArray *listData = [[arrayTableViewData objectAtIndex:[indexPath section]] objectForKey:STR_NEW_PROJECT_CELLS];
    NSUInteger row = [indexPath row];
    int typeCell = [[[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_TYPE] intValue];
    
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    //сохраняем в Дикшионари Дата менеджера  Индекс ячейки. с ключем -> Названиe ячейки
    [[appDataManager.dictNewProjectIndexPaths objectForKey:[[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory]] setObject:indexPath forKey:[[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_NAME]];
    
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
        [[cell viewWithTag:INT_NEW_PROJECT_TYPE_INPUT] removeFromSuperview];
        [[cell viewWithTag:INT_NEW_PROJECT_TYPE_COLOR] removeFromSuperview];
        [[cell viewWithTag:INT_NEW_PROJECT_TYPE_PICKER] removeFromSuperview];
        
    }
    
    // если ячейчка с выбором
    if (typeCell == INT_NEW_PROJECT_TYPE_SELECT)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = [[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_VALUE];
    }
    // если ячейчка с инпутом
    else if (typeCell == INT_NEW_PROJECT_TYPE_INPUT)
    {
        UITextField * inputField = [[UITextField alloc] initWithFrame:CGRectMake(100,0,220,44)];
        inputField.adjustsFontSizeToFitWidth = YES;
        inputField.textColor = [UIColor whiteColor];
        inputField.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:17];
        inputField.tag = INT_NEW_PROJECT_TYPE_INPUT;
        inputField.delegate = self;
        inputField.text = [[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_VALUE];
        
        [cell addSubview:inputField];
    }
    // если ячейчка с переключателем
    else if (typeCell == INT_NEW_PROJECT_TYPE_SWITCH)
    {
        UISwitch * swithField = [[UISwitch alloc] initWithFrame:CGRectZero];
        [swithField addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [swithField setOn:[[[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_VALUE] boolValue]];
        [cell setAccessoryView:swithField];
    }
    // если ячейчка выбора цвета
    else if (typeCell == INT_NEW_PROJECT_TYPE_COLOR)
    {
        TTApplicationManager * aplicationDM = [TTApplicationManager sharedApplicationManager];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (aplicationDM.ipNewProjectSelectedColor)
        {
            NSString * colorName = [[aplicationDM.arrTaskColors objectAtIndex:aplicationDM.ipNewProjectSelectedColor.row] objectForKey:STR_NEW_PROJECT_COLOR_NAME];
            cell.detailTextLabel.text = colorName;
            UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(100, 8, 2 * 12.5, 2 * 12.5)] ;
            circle.layer.borderColor = [appDataManager colorWithHexString:[[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_VALUE]].CGColor;
            circle.layer.borderWidth = 1.f;
            circle.layer.cornerRadius = 12.5;
            circle.layer.masksToBounds = YES;
            circle.tag = INT_NEW_PROJECT_TYPE_COLOR;
            [cell addSubview:circle];
        }
    }
    // если ячейчка выбора даты
    else if (typeCell == INT_NEW_PROJECT_TYPE_PICKER)
    {
        UITextField * inputField = [[UITextField alloc] initWithFrame:CGRectMake(80,0,240,44)];
        inputField.adjustsFontSizeToFitWidth = YES;
        inputField.textColor = [UIColor whiteColor];
        inputField.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_LIGHT size:17];
        inputField.tag = INT_NEW_PROJECT_TYPE_PICKER;
        inputField.delegate = self;
        inputField.inputView = dpView;
        NSDate * date;
        date = [[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_VALUE];
        if (!date) {
            date = [NSDate date];
            if ([[[listData objectAtIndex:row] objectForKey:STR_NEW_PROJECT_NAME] isEqualToString:STR_NEW_PROJECT_END_DATE]) {
                NSTimeInterval secondsInEightHours = 1 * 60 * 60;
                NSDate *dateEightHoursAhead = [date dateByAddingTimeInterval:secondsInEightHours];
                date = dateEightHoursAhead;
            }
        }
        inputField.text = [[TTAppDataManager sharedAppDataManager] convertDate:date withFormat:@"EEEE, MMMM dd,yyyy hh:mm a"];
        [cell addSubview:inputField];
        
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
    
    tempLabel.text = [[arrayTableViewData objectAtIndex:section] objectForKey:STR_NEW_PROJECT_NAME];
    tempLabel.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_REGULAR size:14];
    [tempView addSubview:tempLabel];
    return tempView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

// Tap on table Row
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    // ipCurrentIndexPath = indexPath;
    
    [[TTApplicationManager sharedApplicationManager] setIpNewProjectSelectedProperty:indexPath];
    NSArray *listData = [[arrayTableViewData objectAtIndex:[indexPath section]] objectForKey:STR_NEW_PROJECT_CELLS];
    int typeCell = [[[listData objectAtIndex:indexPath.row] objectForKey:STR_NEW_PROJECT_TYPE] intValue];
    
    if (typeCell == INT_NEW_PROJECT_TYPE_SELECT)
    {
        [[TTApplicationManager sharedApplicationManager] pushViewTo:VIEW_SELECT_PROPERTY forNavigationController:parentViewController.navigationController];
    }
    else if (typeCell == INT_NEW_PROJECT_TYPE_COLOR)
    {
        [[TTApplicationManager sharedApplicationManager] pushViewTo:VIEW_SELECT_COLOR forNavigationController:parentViewController.navigationController];
    }
}

#pragma mark -
#pragma mark UISwitch methods

- (void) switchChanged:(id)sender
{
    UISwitch* switchControl = sender;
    NSIndexPath *indexPath = [tableViewParametrs indexPathForCell:(UITableViewCell*)[[switchControl superview] superview]]; // this should return you
    [[TTAppDataManager sharedAppDataManager] saveNewProjectFieldsValue:switchControl.on ? @"YES" : @"NO" byIndexPath:indexPath];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}
// когда Текстовое поле завершило редакирование
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // индекс ячейки в котором вызвали Инпут
    NSIndexPath *indexPath = [tableViewParametrs indexPathForCell:(UITableViewCell*)[[textField superview] superview]]; // this should return you your current indexPath
    
    // индекс ячейки в котором вызвали Инпут
    NSArray *listData = [[arrayTableViewData objectAtIndex:[indexPath section]] objectForKey:STR_NEW_PROJECT_CELLS];
    //тип ячеки
    int typeCell = [[[listData objectAtIndex:indexPath.row] objectForKey:STR_NEW_PROJECT_TYPE] intValue];
    if (typeCell == INT_NEW_PROJECT_TYPE_INPUT)
    {
        [[TTAppDataManager sharedAppDataManager] saveNewProjectFieldsValue:textField.text byIndexPath:indexPath];
        
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    // индекс ячейки в котором вызвали Инпут
    NSLog(@"startEditing trace");
    

    NSIndexPath *indexPath = [tableViewParametrs indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
    
    NSArray *listData = [[arrayTableViewData objectAtIndex:[indexPath section]] objectForKey:STR_NEW_PROJECT_CELLS];
    //тип ячеки
    int typeCell = [[[listData objectAtIndex:indexPath.row] objectForKey:STR_NEW_PROJECT_TYPE] intValue];
    if (typeCell == INT_NEW_PROJECT_TYPE_PICKER)
    {
        [[TTApplicationManager sharedApplicationManager] setIpNewProjectSelectedProperty:indexPath];
        NSDate * date = [[TTAppDataManager sharedAppDataManager] getNewProjectFieldsValue:STR_NEW_PROJECT_VALUE byIndexPath:indexPath];
        if (date != nil) {
            [dpTaskDatePicker setDate:date];
        }
        else{
            [dpTaskDatePicker setDate:[NSDate date]];
        }
    }
}


-(IBAction) datePickerPickHandlerDone:(id)sender
{
    NSLog(@"datePickerPickHandlerDone::ipNewProjectSelectedProperty: %d ",[[[TTApplicationManager sharedApplicationManager] ipNewProjectSelectedProperty] section] );
    
    [[TTAppDataManager sharedAppDataManager] saveNewProjectFieldsValue:[dpTaskDatePicker date] byIndexPath:[[TTApplicationManager sharedApplicationManager] ipNewProjectSelectedProperty] ];
    [tableViewParametrs reloadData];
}
-(IBAction) datePickerPickHandlerCancel:(id)sender
{
    [parentViewController.view endEditing:YES];
}


@end
