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
    NSString * newProjectSelectedCategory;
    int segmentIndexNewProject;
}

@end

@implementation TTNewProjectViewController
@synthesize scTaskProjectClient;
@synthesize dataSource;
@synthesize delegate;
@synthesize externalArgument;
@synthesize tableViewNewProject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        newProjectTableController = [[TTFieldsTableViewController alloc] init];
        segmentIndexNewProject = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    newProjectSelectedCategory = STR_NEW_PROJECT_TASK;
    
    [newProjectTableController setDelegate:self];
    
    [tableViewNewProject setDelegate:newProjectTableController];
    [tableViewNewProject setDataSource:newProjectTableController];

    
    [TTTools makeButtonStyled:btnSave];

    headerNewProject.layer.borderColor = [TTTools colorWithHexString:@"#a8adb3"].CGColor;
    headerNewProject.layer.borderWidth = 1.0f;
    [tableViewNewProject setTableFooterView:footerTableViewNewProject];
    
    [btnSave setTitle:[NSString stringWithFormat:@"Save %@", newProjectSelectedCategory] forState:UIControlStateNormal];
    [self setTitle:[NSString stringWithFormat:@"Add %@", newProjectSelectedCategory]];
    [scTaskProjectClient setSelectedSegmentIndex:segmentIndexNewProject];
    
    //[scTaskProjectClient.tintColor ]
    [scTaskProjectClient setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor whiteColor], UITextAttributeTextColor,
                                          nil] forState:UIControlStateSelected];
    
	// Do any additional setup after loading the view.
   
   
    // задаем текущую дату для старт\финиш таска
    
    
    NSDate * dateStart = [NSDate date];

    NSTimeInterval secondsInEightHours = 1 * 60 * 60;
    NSDate * dateEnd = [dateStart dateByAddingTimeInterval:secondsInEightHours];
    
    [[TTAppDataManager sharedAppDataManager]  saveTableFieldsOptionValue:dateStart
                                                            byIndexPath:[[TTAppDataManager sharedAppDataManager]getTableFieldsOptionIndexPathByValue:STR_NEW_PROJECT_START_DATE onCategory:newProjectSelectedCategory]
                                                            onCategory:newProjectSelectedCategory];
    [[TTAppDataManager sharedAppDataManager]  saveTableFieldsOptionValue:dateEnd
                                                            byIndexPath:[[TTAppDataManager sharedAppDataManager]getTableFieldsOptionIndexPathByValue:STR_NEW_PROJECT_END_DATE onCategory:newProjectSelectedCategory]
                                                             onCategory:newProjectSelectedCategory];
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    if (tableViewNewProject != nil){
        [tableViewNewProject reloadData];
    }
}
- (void) loadPropertyForView {
    [tableViewNewProject reloadData];
    
    
}

#pragma mark segmentedControl methods
-(IBAction) segmentedControlIndexChanged
{
    [self.view endEditing:YES];
    segmentIndexNewProject = scTaskProjectClient.selectedSegmentIndex;
    
	switch (self.scTaskProjectClient.selectedSegmentIndex) {
		case 0:
             newProjectSelectedCategory = STR_NEW_PROJECT_TASK;
			break;
		case 1:
            newProjectSelectedCategory = STR_NEW_PROJECT_PROJECT;
			break;
		case 2:
            newProjectSelectedCategory = STR_NEW_PROJECT_CLIENT;
			break;
		default:
            break;
    }
    [btnSave setTitle:[NSString stringWithFormat:@"Save %@", newProjectSelectedCategory] forState:UIControlStateNormal];
    [self setTitle:[NSString stringWithFormat:@"Add %@", newProjectSelectedCategory]];
    
    [self loadPropertyForView];
}


-(IBAction) btnSaveTouchHandler:(id)sender
{
    BOOL bSaveEditSuccess = NO;
    
    [self.view endEditing:YES];
    // проверка на заполненость имени
    NSString * validateName = [NSString stringWithFormat:@"%@",[[TTAppDataManager sharedAppDataManager]getTableFieldsOptionValueByIndexPath:[[[[TTAppDataManager sharedAppDataManager] dictOfTableFieldIndexPaths]objectForKey:newProjectSelectedCategory] objectForKey:STR_NEW_PROJECT_NAME]
                                  onCategory:newProjectSelectedCategory]];
    
    if ( [validateName isEqualToString:@"(null)"] || [validateName isEqualToString:@""] )
    {
        [TTTools showPopUpOk:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error",@"title",
                              @"Ok",@"titleButton",
                              @"Поле имя не заполнено",@"message",
                              nil]];
        return;
    }
    
    if (externalArgument)
    {
        bSaveEditSuccess = [[TTAppDataManager sharedAppDataManager] editTTItem:[[TTAppDataManager sharedAppDataManager] serializeTaskData:externalArgument] onCategory:newProjectSelectedCategory];
        [[TTAppDataManager sharedAppDataManager] clearTableFieldsOptionsByCategory:newProjectSelectedCategory];
    }
    else
    {
        bSaveEditSuccess = [[TTAppDataManager sharedAppDataManager] saveTTItemOnCategory:newProjectSelectedCategory];
        [[TTAppDataManager sharedAppDataManager] clearTableFieldsOptionsByCategory:newProjectSelectedCategory];
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
          
        //   [[TTApplicationManager sharedApplicationManager]  updateCurrentViewController];
           [self.navigationController popViewControllerAnimated:YES];
           [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_MAIN_CLOCK forNavigationController:self.navigationController];
       }
   }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setExternalArgument:(TTItem*)argument
{
    externalArgument = argument;
    
    newProjectSelectedCategory = STR_NEW_PROJECT_TASK_EDIT;
    scTaskProjectClient.hidden = true;
    [self setTitle:[NSString stringWithFormat:@"Edit \"%@\"",externalArgument.strTaskName]];
  
    
    [[TTAppDataManager sharedAppDataManager] updateNewTaskFormFieldsWithData:externalArgument onCategory:newProjectSelectedCategory];
    [self loadPropertyForView];
}

- (TTItem*)getExternalArgument
{
    return externalArgument;
}


-(void)updateData
{
    NSLog(@"-(void)updateData");
}

#pragma mark TTFieldsTableDelegate metods
-(NSArray *)getTableViewData{
    return [[TTAppDataManager sharedAppDataManager] getTableFieldsOptionsByCategory:newProjectSelectedCategory];
}
-(UIViewController *)getParentController{
    return self;
}
-(UITableView *)getTableView{
    return tableViewNewProject;
}
-(void) saveValue:(id)value byIndexPath:(NSIndexPath*)indexPath{
    [[TTAppDataManager sharedAppDataManager] saveTableFieldsOptionValue:value byIndexPath:indexPath onCategory:newProjectSelectedCategory];
    [tableViewNewProject reloadData];
}
-(void) saveValue:(id)value byName:(NSString*)name{
    NSIndexPath * indexFieldToSave = [[TTAppDataManager sharedAppDataManager] getTableFieldsOptionIndexPathByValue:name onCategory:newProjectSelectedCategory];
    if (indexFieldToSave) {
        [[TTAppDataManager sharedAppDataManager] saveTableFieldsOptionValue:value byIndexPath:indexFieldToSave onCategory:newProjectSelectedCategory];
        [tableViewNewProject reloadData];
    }
    
}
-(id)getValuebyIndexPath:(NSIndexPath*)indexPath{
    return [[TTAppDataManager sharedAppDataManager] getTableFieldsOptionValueByIndexPath:indexPath onCategory:newProjectSelectedCategory];
}
-(void) setFieldsCategory:(NSString*)swichCategoryName{

    if ([swichCategoryName isEqualToString:STR_NEW_PROJECT_PROJECT]) {
        segmentIndexNewProject = 1;
    }
    else if ([swichCategoryName isEqualToString:STR_NEW_PROJECT_CLIENT]) {
        segmentIndexNewProject = 2;
    }
    
    newProjectSelectedCategory = swichCategoryName;
    [self loadPropertyForView];
}
@end
