//
//  TTNewProjectViewController.m
//  TimeTracker
//
//  Created by Yegor Karpechenkov on 6/21/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTNewProjectViewController.h"


@interface TTNewProjectViewController ()

@end

@implementation TTNewProjectViewController

@synthesize tfClientName,tfColor,tfDuration,tfStartTime,tfStartDate,tfTaskName,tfProjectName,btnClear,btnSave,sldrSlider,imgImage,lblLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initVisibleComponents];
}

-(void)initVisibleComponents
{
    [scrvScrollView setScrollEnabled:YES];
    [scrvScrollView setContentSize:CGSizeMake(320, 650)];    
    
    //[self initTextFields];
    
    //init button Save
  /*  UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnSave addTarget:self action:@selector(buttonSaveTouchHandler:) forControlEvents:UIControlEventTouchDown];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    btnSave.frame = CGRectMake(20, 140, 97, 37);
    [self.view addSubview:btnSave];
   */
    
    lblLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 370, 300, 21)];
    lblLabel.backgroundColor = [UIColor clearColor];
    lblLabel.font = [UIFont systemFontOfSize:15.0];
    lblLabel.textAlignment = NSTextAlignmentCenter;
    lblLabel.text = @"Please enter the Client Name";
    [self.view addSubview:lblLabel];
    
    CGRect rctImageRect = CGRectMake(40.0f, 190.0f, 240.0f, 190.0f);
    imgImage = [[UIImageView alloc] initWithFrame:rctImageRect ];
    [imgImage setImage:[UIImage imageNamed:@"dots.png"]];
    imgImage.backgroundColor = [UIColor clearColor];
    imgImage.opaque = YES;
    imgImage.alpha = 0;
    [self.view addSubview:imgImage];
    
    CGRect rctSliderFrame = CGRectMake(18.0, 348.0, 284.0, 23.0);
    sldrSlider = [[UISlider alloc] initWithFrame:rctSliderFrame];
    [sldrSlider addTarget:self action:@selector(sliderValueChangedHandler:) forControlEvents:UIControlEventValueChanged];
    [sldrSlider setBackgroundColor:[UIColor clearColor]];
    sldrSlider.continuous = YES;
    sldrSlider.value = 0;
    sldrSlider.alpha = 0;
    [self.view addSubview:sldrSlider];
}
-(void)initTextFields
{
    //init clientName textfield
    tfClientName = [[UITextField alloc]initWithFrame:CGRectMake(20, 50, 280, 31)];
    tfClientName.borderStyle = UITextBorderStyleRoundedRect;
    tfClientName.textColor = [UIColor whiteColor];
    tfClientName.font = [UIFont systemFontOfSize:17.0];
    tfClientName.placeholder = @"Client Name";
    tfClientName.backgroundColor = [UIColor whiteColor];
    tfClientName.autocorrectionType = UITextAutocorrectionTypeNo;
    tfClientName.backgroundColor = [UIColor clearColor];
    tfClientName.keyboardType = UIKeyboardTypeDefault;
    tfClientName.returnKeyType = UIReturnKeyDone;
    
    tfClientName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [tfClientName addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:tfClientName];
    
    //init projectName textfield
    tfProjectName = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, 280, 31)];
    tfProjectName.borderStyle = UITextBorderStyleRoundedRect;
    tfProjectName.textColor = [UIColor whiteColor];
    tfProjectName.font = [UIFont systemFontOfSize:17.0];
    tfProjectName.placeholder = @"Project Name";
    tfProjectName.backgroundColor = [UIColor whiteColor];
    tfProjectName.autocorrectionType = UITextAutocorrectionTypeNo;
    tfProjectName.backgroundColor = [UIColor clearColor];
    tfProjectName.keyboardType = UIKeyboardTypeDefault;
    tfProjectName.returnKeyType = UIReturnKeyDone;
    
    tfProjectName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [tfProjectName addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:tfProjectName];
    
    //init TaskName textfield
    tfTaskName = [[UITextField alloc]initWithFrame:CGRectMake(20, 110, 280, 31)];
    tfTaskName.borderStyle = UITextBorderStyleRoundedRect;
    tfTaskName.textColor = [UIColor whiteColor];
    tfTaskName.font = [UIFont systemFontOfSize:17.0];
    tfTaskName.placeholder = @"Task Name";
    tfTaskName.backgroundColor = [UIColor whiteColor];
    tfTaskName.autocorrectionType = UITextAutocorrectionTypeNo;
    tfTaskName.backgroundColor = [UIColor clearColor];
    tfTaskName.keyboardType = UIKeyboardTypeDefault;
    tfTaskName.returnKeyType = UIReturnKeyDone;
    
    tfTaskName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [tfTaskName addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:tfTaskName];
}

-(IBAction)hideKeyboard:(id)sender
{
    [tfClientName resignFirstResponder];
}

-(IBAction)sliderValueChangedHandler:(id)sender
{
    imgImage.alpha = sldrSlider.value;
}

-(IBAction)btnSaveTouchHandler:(id)sender
{
 
    [tfClientName resignFirstResponder]; //hide keyboard
    [tfProjectName resignFirstResponder]; //hide keyboard
    [tfTaskName resignFirstResponder]; //hide keyboard
    [tfStartDate resignFirstResponder]; //hide keyboard
    [tfStartTime resignFirstResponder]; //hide keyboard
    [tfDuration resignFirstResponder]; //hide keyboard
    [tfColor resignFirstResponder]; //hide keyboard
    
    //read data from device
/*    NSString *filePathToProjectData = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"projectData.plist"];
    
    NSDictionary *dictCustomProject = [NSDictionary dictionaryWithContentsOfFile:filePathToProjectData];*/
    
    TTItem *item = [[TTItem alloc] init];
    
    [self collectDataToItem:item];
    
    lblLabel.text = [@"Client Name defined successfully!" stringByAppendingString:tfClientName.text];
    
    //    NSDictionary *dictProjectData = [[NSDictionary alloc] initWithObjectsAndKeys:
    //                                     lblLabel.text, @"clientName",
    //                                     @"projectName1", @"projectName",
    //                                     @"05.06.2013", @"startDate",
    //                                     @"12.55"     , @"startTime",
    //                                     @"05.06.2013", @"endDate",
    //                                     @"13.00"     , @"endTime",
    //                                     @"300"       , @"durationPlan",
    //                                     @"300"       , @"durationFact",
    //                                     @"FFFFFF"    , @"color", nil];
    //
    NSLog(@"clinetName: %@",item.strClientName);
    
    [[TTAppDataManager sharedAppDataManager] saveTTItem:item];
//    [[TTAppDataManager sharedAppDataManager] saveTTItem:item];
    //    [dictProjectData writeToFile:filePathToProjectData atomically:YES];
}

-(IBAction)btnClearTouchHandler:(id)sender
{
    tfClientName.text   = @"";
    tfProjectName.text  = @"";
    tfTaskName.text     = @"";
    tfStartDate.text    = @"";
    tfStartTime.text    = @"";
    tfDuration.text     = @"";
    tfColor.text        = @"";
}

-(void)collectDataToItem:(TTItem*)item
{
    item.strClientName = tfClientName.text;
    item.strProjectName = tfProjectName.text;
    item.strTaskName = tfTaskName.text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
