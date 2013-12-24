//
//  TTNewProjectViewController.m
//  TimeTracker
//
//  Created by ProstoApps* on 6/21/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTNewProjectViewController.h"


@interface TTNewProjectViewController ()
{
    TTFieldsTableViewController * newProjectTableController;
}

@end

@implementation TTNewProjectViewController
@synthesize scTaskProjectClient;
@synthesize dataSource;
@synthesize delegate;
@synthesize externalArgument;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    
    if ([[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory] == nil)
    {
        [[TTApplicationManager sharedApplicationManager] setStrNewProjectSelectedCategory:STR_NEW_PROJECT_TASK];
    }
     [appDataManager loadNewProjectFields];
    
    newProjectTableController = [[TTFieldsTableViewController alloc] init];
    
    [newProjectTableController setArrayTableViewData:[appDataManager getNewProjectFields]];
    [newProjectTableController setParentViewController:self];
    [newProjectTableController setTableViewParametrs:tableViewNewProject];
    
    _delegate = newProjectTableController;
    _dataSource = newProjectTableController;
    
    [tableViewNewProject setDelegate:_delegate];
    [tableViewNewProject setDataSource:_dataSource];

    
    [appDataManager makeButtonStyled:btnSave];

    headerNewProject.layer.borderColor = [[TTAppDataManager sharedAppDataManager] colorWithHexString:@"#a8adb3"].CGColor;
    headerNewProject.layer.borderWidth = 1.0f;
    [tableViewNewProject setTableFooterView:footerTableViewNewProject];
  
    
    //[scTaskProjectClient.tintColor ]
    [scTaskProjectClient setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor whiteColor], UITextAttributeTextColor,
                                          nil] forState:UIControlStateSelected];
    
	// Do any additional setup after loading the view.
   
   
    
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    if (tableViewNewProject != nil){
        [self loadPropertyForView];
    }
}
- (void) loadPropertyForView {
    
    TTAppDataManager * appDataManager = [TTAppDataManager sharedAppDataManager];
    NSString * strName = [[TTApplicationManager sharedApplicationManager] strNewProjectSelectedCategory];
    NSString * strAddOrEdit ;
    if (externalArgument)
    {
        strAddOrEdit = @"Edit";
    }
    else
    {
        strAddOrEdit = @"Add";
    }
    [self setTitle:[NSString stringWithFormat:@"%@ %@",strAddOrEdit, strName]];
    [btnSave setTitle:[NSString stringWithFormat:@"%@ %@",strAddOrEdit, strName] forState:UIControlStateNormal];
    [scTaskProjectClient setSelectedSegmentIndex:appDataManager.segmentIndexNewProject];

    [newProjectTableController setArrayTableViewData:[appDataManager getNewProjectFields]];
    
    [tableViewNewProject reloadData];
    
}

#pragma mark segmentedControl methods
-(IBAction) segmentedControlIndexChanged
{
    [self.view endEditing:YES];
    [[TTAppDataManager sharedAppDataManager] setSegmentIndexNewProject:scTaskProjectClient.selectedSegmentIndex];
    
	switch (self.scTaskProjectClient.selectedSegmentIndex) {
		case 0:
            [[TTApplicationManager sharedApplicationManager] setStrNewProjectSelectedCategory:STR_NEW_PROJECT_TASK];
			break;
		case 1:
            [[TTApplicationManager sharedApplicationManager] setStrNewProjectSelectedCategory:STR_NEW_PROJECT_PROJECT];
			break;
		case 2:
            [[TTApplicationManager sharedApplicationManager] setStrNewProjectSelectedCategory:STR_NEW_PROJECT_CLIENT];
			break;
		default:
            break;
    }
    
    [self loadPropertyForView];
}


-(IBAction) btnSaveTouchHandler:(id)sender
{
    BOOL bSaveEditSuccess = NO;
    
    [self.view endEditing:YES];
    if (externalArgument)
    {
        bSaveEditSuccess = [[TTAppDataManager sharedAppDataManager] editTTItem:externalArgument];
    }
    else
    {
        bSaveEditSuccess = [[TTAppDataManager sharedAppDataManager] saveTTItem];
    }
    
   if (bSaveEditSuccess)
   {
       if (scTaskProjectClient.selectedSegmentIndex == NUM_NEW_PROJECT_SELECTED_SEGMENT_CLIENT)
       {
           scTaskProjectClient.selectedSegmentIndex = NUM_NEW_PROJECT_SELECTED_SEGMENT_PROJECT;
           [self segmentedControlIndexChanged];
       }
       else if (scTaskProjectClient.selectedSegmentIndex == NUM_NEW_PROJECT_SELECTED_SEGMENT_PROJECT)
       {
           scTaskProjectClient.selectedSegmentIndex = NUM_NEW_PROJECT_SELECTED_SEGMENT_TASK;
           [self segmentedControlIndexChanged];
       }
       else if (scTaskProjectClient.selectedSegmentIndex == NUM_NEW_PROJECT_SELECTED_SEGMENT_TASK)
       {
           [[TTAppDataManager sharedAppDataManager] clearNewProjectFields];
           [[TTAppDataManager sharedAppDataManager] updateData];
           [self.navigationController popViewControllerAnimated:YES];
       }
   }
}

-(void) updateViewWithNewData
{
    
    NSMutableArray * dictExistingTaskFields = [[TTAppDataManager sharedAppDataManager] updateNewTaskFormFieldsWithData:externalArgument];
    [newProjectTableController setArrayTableViewData:dictExistingTaskFields];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setExternalArgument:(NSObject*)argument
{
    externalArgument = argument;
    [self updateViewWithNewData];
}

- (NSObject*)getExternalArgument
{
    return externalArgument;
}


-(void)updateData
{
    
}

@end