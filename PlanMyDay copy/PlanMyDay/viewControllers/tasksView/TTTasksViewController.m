//
//  TTTasksTableViewController.m
//  TimeTrackerApp
//
//  Created by Torasike on 06.06.13.
//  Copyright (c) 2013 Torasike. All rights reserved.
//

#import "TTTasksViewController.h"
#import "TTAppDataManager.h"
#import "TTApplicationManager.h"
@implementation TTTasksViewController
@synthesize tasksView, tasksTableView, tasksTableViewCell;
@synthesize cellsDataArray, btnMenu,btnNewTask;

- (void)viewDidLoad

{
    [super viewDidLoad];
    
    self.title = @"Tasks for Today";
    tasksTableView.backgroundColor = [[UIColor alloc] initWithRed:0x3b/255.0 green:0x46/255.0 blue:0x50/255.0 alpha:1];
  //  tasksTableView.separatorColor = [[UIColor alloc] initWithRed:0xa8/255.0 green:0xad/255.0 blue:0xb3/255.0 alpha:1];
    
    self.tasksView = [[UIView alloc] initWithFrame:CGRectMake(tasksTableView.frame.origin.x, tasksTableView.frame.origin.y, tasksTableView.frame.size.width, tasksTableView.rowHeight)];
    
    // загружаем дату
    cellsDataArray = [[TTAppDataManager sharedAppDataManager] getAllTasks];
    
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
}

-(void) viewWillAppear:(BOOL)animated{
    
    if (tasksTableView != nil){
         cellsDataArray = [[TTAppDataManager sharedAppDataManager] getAllTasks];
        [tasksTableView reloadData];
    }
}

#pragma mark TTTasksTableViewCellDelegate
-(void)allowTTTasksTableViewScroll:(BOOL)variable
{
    [tasksTableView setScrollEnabled:variable];
}

-(void)deleteCellFromTTTasksTableView:(TTTasksTableViewCell*)cell{
    // найти какую ячейку удалить из списка
    
    [[TTAppDataManager sharedAppDataManager] removeTask:[cellsDataArray objectAtIndex:[[tasksTableView indexPathForCell:cell] row]]];
    
    cellsDataArray = [[TTAppDataManager sharedAppDataManager] getAllTasks];
    
    [tasksTableView deleteRowsAtIndexPaths:[[NSArray alloc]
                                            initWithObjects:[tasksTableView indexPathForCell:cell], nil]
                          withRowAnimation:UITableViewRowAnimationFade];
    
}
-(void)checkCellFromTTTasksTableView:(TTTasksTableViewCell*)cell{
    
    TTItem * itemToSave = [[TTItem alloc] init];
    [itemToSave setStrCheck:[cell.getTableCellData objectForKey:STR_TASK_CHECK]];
    [itemToSave setStrClientName:[cell.getTableCellData objectForKey:STR_CLIENT_NAME]];
    [itemToSave setStrProjectName:[cell.getTableCellData objectForKey:STR_PROJECT_NAME]];
    [itemToSave setStrTaskName:[cell.getTableCellData objectForKey:STR_TASK_NAME]];
    NSLog(@"isCheck: %@",[cell.getTableCellData objectForKey:STR_TASK_CHECK]);
  //  [[TTAppDataManager sharedAppDataManager] saveTTItem:itemToSave];
    
    TTAppDataManager * Mydata = [TTAppDataManager sharedAppDataManager];
    cellsDataArray = [Mydata getAllTasks];
    
    [tasksTableView reloadData];
}

#pragma mark Edit task table
-(void)editCellFromTTTasksTableView:(TTTasksTableViewCell*)cell
{
    NSDictionary *dictSelectedTaskData = [[NSDictionary alloc] initWithDictionary:cell.getTableCellData];
    for (NSMutableDictionary *dictTaskData in cellsDataArray)
    {
        if ([[dictTaskData objectForKey:STR_TASK_NAME] isEqualToString: [dictSelectedTaskData objectForKey:STR_TASK_NAME]]  &&
            [[dictTaskData objectForKey:STR_PROJECT_NAME] isEqualToString: [dictSelectedTaskData objectForKey:STR_PROJECT_NAME]] &&
            [[dictTaskData objectForKey:STR_CLIENT_NAME] isEqualToString: [dictSelectedTaskData objectForKey:STR_CLIENT_NAME] ])
        {
            
            [[TTApplicationManager sharedApplicationManager] pushViewTo:VIEW_NEW_TASK forNavigationController:self.navigationController withArgument:dictTaskData];
        }
    }
//    [[TTApplicationManager sharedApplicationManager] pushViewTo:VIEW_NEW_TASK forNavigationController:self.navigationController];
}

-(void)iconTaskWasTaped:(UITableViewCell*)cell{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_CUSTOM_TRACKER forNavigationController:self.navigationController];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellsDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TTTasksTableViewCell";

    TTTasksTableViewCell *cell = (TTTasksTableViewCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[TTTasksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    [cell setTableCellData:[cellsDataArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    return cell;
}
                                                         
// Apple's docs: To enable the swipe-to-delete feature of table views (wherein a user swipes horizontally across a row to display a Delete button), you must implement the tableView:commitEditingStyle:forRowAtIndexPath: method.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
        
}
                                                         
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //we are using gestures, don't allow editing
    return NO;
}
                                                         
                                                         
#pragma mark Removing the side swipe view
// UITableViewDelegate
// When a row is selected, animate the removal of the side swipe view
-(NSIndexPath *)tableView:(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}
                                                         
- (void)viewDidUnload
{
    self.tasksTableView = nil;
    self.tasksView = nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}                                                         

-(IBAction) btnNewTaskTouchHandler:(id)sender
{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_NEW_TASK forNavigationController:self.navigationController];
}

-(IBAction) btnMenuTouchHandler:(id)sender
{
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_MENU forNavigationController:self.navigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
