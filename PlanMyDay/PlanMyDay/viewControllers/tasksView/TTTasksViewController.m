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
    BOOL bIsSuccess = [[TTAppDataManager sharedAppDataManager] removeTask:[cellsDataArray objectAtIndex:[[tasksTableView indexPathForCell:cell] row]]];
    
    if (bIsSuccess)
    {
        cellsDataArray = [[TTAppDataManager sharedAppDataManager] getAllTasks];
        
        [tasksTableView deleteRowsAtIndexPaths:[[NSArray alloc]
                                                initWithObjects:[tasksTableView indexPathForCell:cell], nil]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
}
-(void)checkCellFromTTTasksTableView:(TTTasksTableViewCell*)cell{
    
    // определяем индекс ячейки и забираем все ее данные из массива
    NSIndexPath * indexPath = [tasksTableView indexPathForCell:cell];
    NSMutableDictionary *dictSelectedTaskData = [cellsDataArray objectAtIndex:indexPath.row];
    NSMutableDictionary *dictUpdatedTaskData = [[NSMutableDictionary alloc] initWithDictionary:dictSelectedTaskData copyItems:YES];
    [dictUpdatedTaskData setValue:@"1" forKey:STR_THIS_TASK_IS_CHECKED];
    
    [[TTAppDataManager sharedAppDataManager] editTask:dictSelectedTaskData withNewData:dictUpdatedTaskData];
    [tasksTableView reloadData];
}

#pragma mark Edit task table
-(void)editCellFromTTTasksTableView:(TTTasksTableViewCell*)cell
{
    // определяем индекс ячейки и забираем все ее данные из массива
    NSIndexPath * indexPath = [tasksTableView indexPathForCell:cell];
    NSDictionary *dictSelectedTaskData = [cellsDataArray objectAtIndex:indexPath.row];

    [[TTApplicationManager sharedApplicationManager] pushViewTo:VIEW_NEW_TASK forNavigationController:self.navigationController withArgument:[[TTItem alloc] initWithDictionary:[dictSelectedTaskData copy] ]];
}

-(void)iconTaskWasTaped:(TTTasksTableViewCell*)cell
{
    // определяем индекс ячейки и забираем все ее данные из массива
    NSIndexPath * indexPath = [tasksTableView indexPathForCell:cell];
    NSDictionary *dictSelectedTaskData = [cellsDataArray objectAtIndex:indexPath.row];
   
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_CUSTOM_TRACKER
                                          forNavigationController:self.navigationController
                                                     withArgument:[[TTAppDataManager sharedAppDataManager] deserializeData:dictSelectedTaskData]];
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
