//
//  TTNewProjectViewController.h
//  TimeTracker
//
//  Created by ProstoApps* on 6/21/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTAppDataManager.h"
#import "TTApplicationManager.h"
#import "TTCreatePropertyViewController.h"
#import "TTSelectPropertyViewController.h"
#import "TTSelectColorViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TTNewProjectViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITableView * TaskTableView;
    
    IBOutlet UITableView * tableViewNewProject;
    IBOutlet UIView * headerTableViewNewProject;
    IBOutlet UIView * footerTableViewNewProject;
    IBOutlet UISegmentedControl *scTaskProjectClient;
    IBOutlet UIButton * btnSave;
    IBOutlet UIScrollView * scrvScrollView;
    
    IBOutlet UIDatePicker * dpTaskDatePicker;
<<<<<<< HEAD

    UITextField * tfCurrentTextFieldUnderEdit;
=======
    IBOutlet UIView * dpView;
    
>>>>>>> bdca1212fec02fbe62b0b3cb9b6350d6dfc43175

}

-(IBAction) datePickerPickHandler:(id)sender;
-(IBAction) btnSaveTouchHandler:(id)sender;

@property (nonatomic,retain)     NSIndexPath *ipCurrentIndexPath;

@property(nonatomic,retain) IBOutlet UISegmentedControl *scTaskProjectClient;
@property(nonatomic,retain) IBOutlet UIDatePicker * dpTaskDatePicker;
-(IBAction) segmentedControlIndexChanged;

@end

