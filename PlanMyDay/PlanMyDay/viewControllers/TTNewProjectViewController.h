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
    IBOutlet UITableView *taskTableView;
    NSDictionary *tableContents;
    NSArray *sortedKeys;
    
    IBOutlet UIView * bgProjectInfo;
    IBOutlet UITextField *tfClientName;
    IBOutlet UITextField *tfProjectName;
    IBOutlet UITextField *tfTaskName;
    IBOutlet UITextField *tfStartDate;
    IBOutlet UITextField *tfStartTime;
    IBOutlet UITextField *tfDuration;
    IBOutlet UITextField *tfColor;
    IBOutlet UILabel *lbTask;
    
    IBOutlet UISegmentedControl *scTaskProjectClient;
    
    IBOutlet UIButton    *btnSave;
    
    IBOutlet UIScrollView *scrvScrollView;
}

-(IBAction) btnSaveTouchHandler:(id)sender;

-(void)collectDataToItem:(TTItem*)item;
-(void)initVisibleComponents;
-(void)initTextFields;

@property(nonatomic,retain) IBOutlet UITextField *tfClientName;
@property(nonatomic,retain) IBOutlet UITextField *tfProjectName;
@property(nonatomic,retain) IBOutlet UITextField *tfTaskName;
@property(nonatomic,retain) IBOutlet UITextField *tfStartDate;
@property(nonatomic,retain) IBOutlet UITextField *tfStartTime;
@property(nonatomic,retain) IBOutlet UITextField *tfDuration;
@property(nonatomic,retain) IBOutlet UITextField *tfColor;

@property(nonatomic,retain) IBOutlet UISegmentedControl *scTaskProjectClient;
@property(nonatomic,retain) IBOutlet UIButton *btnSave;

-(IBAction) segmentedControlIndexChanged;
//-(IBAction) btnSaveTouchHandler:(id)sender;
@end

