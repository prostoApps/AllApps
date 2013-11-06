//
//  TTTasksTableViewController.h
//  TimeTrackerApp
//
//  Created by Torasike on 06.06.13.
//  Copyright (c) 2013 Torasike. All rights reserved.
//

#import "TTTasksTableViewCell.h"
#import <UIKit/UIKit.h>

@interface TTTasksViewController : UIViewController <TTTasksTableViewCellDelegate>
{
    IBOutlet UIButton *btnMenu;
    IBOutlet UIButton *btnNewTask;
    
    NSMutableArray* cellsDataArray;
    
    IBOutlet UITableView * tasksTableView;
    IBOutlet UIView      * tasksView;
    UITableViewCell      * tasksTableViewCell;
}

@property (nonatomic, retain) NSMutableArray* cellsDataArray;
@property (nonatomic, retain) IBOutlet UITableView* tasksTableView;
@property (nonatomic, retain) IBOutlet UIView* tasksView;
@property (nonatomic, retain) UITableViewCell* tasksTableViewCell;

-(IBAction) btnNewTaskTouchHandler:(id)sender;
-(IBAction) btnMenuTouchHandler:(id)sender;

@property (nonatomic,retain) IBOutlet UIButton *btnMenu;
@property (nonatomic,retain) IBOutlet UIButton *btnNewTask;

@end
