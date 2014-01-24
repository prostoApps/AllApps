//
//  TTStatisticsViewController.h
//  TimeTracker
//
//  Created by ProstoApps* on 6/29/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "DACircularProgressView.h"
#import "TTAppDataManager.h"
#import "SectionHeaderView.h"
#import "Section.h"
#import <UIKit/UIKit.h>

@interface TTStatisticsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,SectionHeaderViewDelegate>{
    IBOutlet UILabel * lbTimeTracked;
    IBOutlet UISegmentedControl * scTaskedPlaned;
    BOOL bShowTrackedTime;
}

@property (strong, nonatomic) IBOutlet UIView *largeProgressView;
@property (nonatomic,retain) IBOutlet UITableView * tasksNavigatorTable;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, retain) NSMutableArray *arrTasksToDraw;
@property (nonatomic, retain) NSMutableArray *arrDrawedTasksHolder;

//@property (strong, nonatomic) TTTasksNavigator *tasksNavigator;

-(void)drawTasksToView:(NSArray*)arrTasks;

@end
