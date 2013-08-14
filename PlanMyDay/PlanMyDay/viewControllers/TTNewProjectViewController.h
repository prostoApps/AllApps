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

@interface TTNewProjectViewController : UIViewController
{    
    IBOutlet UITextField *tfClientName;
    IBOutlet UITextField *tfProjectName;
    IBOutlet UITextField *tfTaskName;
    IBOutlet UITextField *tfStartDate;
    IBOutlet UITextField *tfStartTime;
    IBOutlet UITextField *tfDuration;
    IBOutlet UITextField *tfColor;
    
    IBOutlet UISegmentedControl *scTaskProjectClient;
    
    IBOutlet UIButton    *btnSave;
    IBOutlet UIButton    *btnClear;
    
    IBOutlet UIScrollView *scrvScrollView;
    
    UILabel *lblLabel;
    UIImageView *imgImage;
    UISlider *sldrSlider;
}

-(IBAction) btnSaveTouchHandler:(id)sender;
-(IBAction) btnClearTouchHandler:(id)sender;

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
@property(nonatomic,retain) IBOutlet UIButton *btnSelectClient;
@property(nonatomic,retain) IBOutlet UIButton *btnSelectProject;
@property(nonatomic,retain) IBOutlet UIButton *btnSelectColor;

@property(nonatomic,retain) UILabel     *lblLabel;
@property(nonatomic,retain) UIImageView *imgImage;
@property(nonatomic,retain) UISlider    *sldrSlider;

-(IBAction) segmentedControlIndexChanged;
-(IBAction)btnSelectProjectTouchHandler:(id)sender;
-(IBAction)btnSelectColorTouchHandler:(id)sender;
-(IBAction)btnSelectClientTouchHandler:(id)sender;

@end

