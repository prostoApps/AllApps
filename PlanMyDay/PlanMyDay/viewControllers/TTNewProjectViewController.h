//
//  TTNewProjectViewController.h
//  TimeTracker
//
//  Created by Yegor Karpechenkov on 6/21/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTAppDataManager.h"
#import "TTApplicationManager.h"
#import "TTCreatePropertyViewController.h"
#import "TTSelectPropertyViewController.h"


@interface TTNewProjectViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITableView * TaskTableView;
    
    IBOutlet UITableView * tableViewNewProject;
    IBOutlet UIView * headerTableViewNewProject;
    IBOutlet UIView * footerTableViewNewProject;
    IBOutlet UISegmentedControl *scTaskProjectClient;
    IBOutlet UIButton * btnSave;
    IBOutlet UIScrollView * scrvScrollView;
    
}

-(IBAction) btnSaveTouchHandler:(id)sender;


@property(nonatomic,retain) IBOutlet UISegmentedControl *scTaskProjectClient;

-(IBAction) segmentedControlIndexChanged;

@end

