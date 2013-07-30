//
//  TTTasksTableViewController.m
//  TimeTrackerApp
//
//  Created by Torasike on 06.06.13.
//  Copyright (c) 2013 Torasike. All rights reserved.
//

#import "TTTasksViewController.h"
@implementation TTTasksViewController
@synthesize tasksView, tasksTableView, tasksTableViewCell;

- (void)viewDidLoad

{
    [super viewDidLoad];
    
    tasksTableView.backgroundColor = [[UIColor alloc] initWithRed:0x3b/255.0 green:0x46/255.0 blue:0x50/255.0 alpha:1];
    tasksTableView.separatorColor = [[UIColor alloc] initWithRed:0xa8/255.0 green:0xad/255.0 blue:0xb3/255.0 alpha:1];
    
    self.tasksView = [[UIView alloc] initWithFrame:CGRectMake(tasksTableView.frame.origin.x, tasksTableView.frame.origin.y, tasksTableView.frame.size.width, tasksTableView.rowHeight)];
    
    
    //    tableCellsData = [AppDataManager getCellsData];
    NSDictionary *tmpTask1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"Pavel Sorochkin" , 	@"clientName",
                              @"Insurance Company" , 	@"projectName",
                              @"Home Page Design" , 	@"taskName",
                              @"20.06.20013" , 	@"dateStart",
                              @"3600" , 			@"durationPlan",
                              @"3800" ,			@"durationReal",
                              @"20" ,			@"rate",
                              @"fc3e39" , 		@"color",
                              nil];
    
    NSDictionary *tmpTask2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"ProstoApps" ,       @"clientName",
                              @"ELLE Time App" ,      @"projectName",
                              @"Find Store Page" , 		@"taskName",
                              @"2220.06.20013" , 	@"dateStart",
                              @"362200" , 			@"durationPlan",
                              @"382200" ,			@"durationReal",
                              @"202" ,			    @"rate",
                              @"1c7efb" ,            @"color",
                              nil];
    NSDictionary *tmpTask3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"Al Racine" , 	@"clientName",
                              @"DayPad.org" , 	@"projectName",
                              @"Slider" , 	@"taskName",
                              @"20.06.20013" , 	@"dateStart",
                              @"3600" , 			@"durationPlan",
                              @"3800" ,			@"durationReal",
                              @"20" ,			@"rate",
                              @"fd9426" , 		@"color",
                              
                              nil];
    
    NSDictionary *tmpTask4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"ProstoApps" ,       @"clientName",
                              @"Tracker" ,      @"projectName",
                              @"Custom Tracker Screen" , 		@"taskName",
                              @"06.06.2006" , 	@"dateStart",
                              @"333333" , 			@"durationPlan",
                              @"333399" ,			@"durationReal",
                              @"202" ,			    @"rate",
                              @"53d769" ,            @"color",
                              nil];
    NSDictionary *tmpTask5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"Pavel Sorochkin" , 	@"clientName",
                              @"Insurance Company" , 	@"projectName",
                              @"Next Page" , 	@"taskName",
                              @"20.06.20013" , 	@"dateStart",
                              @"3600" , 		@"durationPlan",
                              @"3800" ,			@"durationReal",
                              @"20" ,			@"rate",
                              @"fc3e39" , 		@"color",
                              nil];
    
    NSDictionary *tmpTask6 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"ProstoApps" ,       @"clientName",
                              @"NY Philharmonic App" ,      @"projectName",
                              @"New Stage Design" , 		@"taskName",
                              @"2220.06.20013" , 	@"dateStart",
                              @"362200" , 			@"durationPlan",
                              @"382200" ,			@"durationReal",
                              @"202" ,			    @"rate",
                              @"53d769" ,            @"color",
                              nil];
    
    
    cellsDataArray = [[NSMutableArray alloc] initWithObjects:tmpTask1,tmpTask2,tmpTask3,tmpTask4,tmpTask5,tmpTask6,tmpTask3,tmpTask5,tmpTask6, nil];
    // [tasksTableView setTableCellsData:tmpArr];
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"1");
}

#pragma mark TTTasksTableViewCellDelegate
-(void)allowTTTasksTableViewScroll:(BOOL)variable{
    [tasksTableView setScrollEnabled:variable];
}
-(void)deleteCellFromTTTasksTableView:(TTTasksTableViewCell*)cell{
    // найти какую ячейку удалить из списка
    // cell.taskName
    [cellsDataArray removeLastObject];
    
    
    [tasksTableView deleteRowsAtIndexPaths:[[NSArray alloc]
                                            initWithObjects:[tasksTableView indexPathForCell:cell], nil]
                          withRowAnimation:UITableViewRowAnimationFade];
    
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
    if ([cell respondsToSelector:@selector(setTableCellData:)])
    {
        NSLog(@"responds");
    }
    else
    {
        NSLog(@"not responds");
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
