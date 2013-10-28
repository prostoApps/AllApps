//
//  TTStatisticsViewController.m
//  TimeTracker
//
//  Created by ProstoApps* on 6/29/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//
#define DEFAULT_ROW_HEIGHT 78
#define HEADER_HEIGHT 70

#import "TTStatisticsViewController.h"

@interface TTStatisticsViewController ()

@end

@implementation TTStatisticsViewController

@synthesize largeProgressView = _largeProgressView;
@synthesize tasksNavigatorTable;
@synthesize sectionArray;
@synthesize openSectionIndex;

//@synthesize tasksNavigator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.sectionArray=[[NSMutableArray alloc]init];
        for (int i=0; i<=10; i++) {
            Section *section=[[Section alloc]init];
            section.sectionHeader=[NSString stringWithFormat:@"Header %d",i];
            section.sectionRows=[[NSMutableArray alloc]init];
            for (int i=0; i<=10; i++) {
                [section.sectionRows addObject:[NSString stringWithFormat:@"Row %d",i]];
            }
            [self.sectionArray addObject:section];
        }

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.largeProgressView setTrackTintColor:[[UIColor alloc] initWithRed:0x3b/255.0 green:0x45/255.0 blue:0x4e/255.0 alpha:1]];
    [self.largeProgressView setProgressTintColor:[[UIColor alloc] initWithRed:0xfc/255.0 green:0x3e/255.0 blue:0x39/255.0 alpha:0]];
    self.largeProgressView.roundedCorners = NO;
    [self.view addSubview:self.largeProgressView];
    [self.largeProgressView setThicknessRatio:0.066];
    
    [self drawTasksToView:[[TTAppDataManager sharedAppDataManager] getAllTasks]];
    
    self.tasksNavigatorTable.sectionHeaderHeight = HEADER_HEIGHT;
    self.openSectionIndex = NSNotFound;

//    [tasksNavigator initWithTasks];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    /*
     Create the section header views lazily.
     */
	Section *aSection=[sectionArray objectAtIndex:section];
    if (!aSection.sectionHeaderView) {
        aSection.sectionHeaderView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tasksNavigatorTable.bounds.size.width, HEADER_HEIGHT) title:aSection.sectionHeader section:section delegate:self];
        
    }
    
    
    return aSection.sectionHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    
    return [self.sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Section *aSection=[sectionArray objectAtIndex:section];
    // Return the number of rows in the section.
    return aSection.open ? [aSection.sectionRows count]:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%@",indexPath);
    Section *aSection=[sectionArray objectAtIndex:indexPath.section];
    static NSString *CellIdentifier = @"Cell";
    
    TTTasksNavigatorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TTTasksNavigatorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text=[aSection.sectionRows objectAtIndex:indexPath.row];
    return cell;
}

-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
    
    Section *aSection=[sectionArray objectAtIndex:sectionOpened];
    aSection.open=YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [aSection.sectionRows count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        Section *previousOpenSection=[sectionArray objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open=NO;
        [previousOpenSection.sectionHeaderView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.sectionRows count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
        
        
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.tasksNavigatorTable beginUpdates];
    [self.tasksNavigatorTable insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tasksNavigatorTable deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tasksNavigatorTable endUpdates];
    self.openSectionIndex = sectionOpened;
    
    
}
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	Section *aSection = [self.sectionArray objectAtIndex:sectionClosed];
	
    aSection.open = NO;
    
    NSInteger countOfRowsToDelete = [self.tasksNavigatorTable numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tasksNavigatorTable deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}



-(void)drawTasksToView:(NSMutableArray*)arrTasks
{
    float numDuration = 0;
    float numTotalDuration = 0;
    float fDurationRatio = 0;
    float numRotationAngle = 0;
    NSDate *dtStartDate;
    NSDate *dtEndDate;
    NSString *strColor;
    
    NSMutableArray *arrProjectsToDraw = [[NSMutableArray alloc] init];
    
    //    NSString *strNewString = [strColor substringToIndex:2];
    //    flo *strNewString = [strColor substringWithRange:NSMakeRange(0, 2)];
    //    [strColor floatValue];
    
    for (NSMutableDictionary *dictTmpTask in arrTasks)
    {
        dtStartDate = [dictTmpTask objectForKey:STR_START_DATE];
        dtEndDate   = [dictTmpTask objectForKey:STR_END_DATE];
        numDuration = [dtEndDate timeIntervalSinceDate:dtStartDate]/3600;
        
        numTotalDuration += numDuration;
        
        if (arrProjectsToDraw.count == 0)
        {
            NSMutableDictionary *dictTmpProject = [[NSMutableDictionary alloc] init];
            [dictTmpProject setObject:[dictTmpTask objectForKey:STR_PROJECT_NAME] forKey:STR_PROJECT_NAME];
            [dictTmpProject setObject:[NSNumber numberWithFloat:0.0] forKey:STR_DURATION];
            [dictTmpProject setObject:[dictTmpTask objectForKey:STR_TASK_COLOR] forKey:STR_TASK_COLOR];
            
            float tmpProjectDuration = [[dictTmpProject objectForKey:STR_DURATION] floatValue];
            tmpProjectDuration += numDuration;
            NSNumber *tmpNumberDuration = [NSNumber numberWithFloat:tmpProjectDuration];
            [dictTmpProject setValue:tmpNumberDuration forKey:STR_DURATION];
            [arrProjectsToDraw addObject:dictTmpProject];
        }
        else
        {
            for (NSMutableDictionary * dictProject in arrProjectsToDraw) {
                if ([dictProject objectForKey:STR_PROJECT_NAME] != [dictTmpTask objectForKey:STR_PROJECT_NAME])
                {
                    NSMutableDictionary *dictTmpProject = [[NSMutableDictionary alloc] init];
                    [dictTmpProject setObject:[dictTmpTask objectForKey:STR_PROJECT_NAME] forKey:STR_PROJECT_NAME];
                    [dictTmpProject setObject:[NSNumber numberWithFloat:0.0] forKey:STR_DURATION];
                    [dictTmpProject setObject:[dictTmpTask objectForKey:STR_TASK_COLOR] forKey:STR_TASK_COLOR];
                    [arrProjectsToDraw addObject:dictTmpProject];
                    
                    float tmpProjectDuration = [[dictTmpProject objectForKey:STR_DURATION] floatValue];
                    tmpProjectDuration += numDuration;
                    NSNumber *tmpNumberDuration = [NSNumber numberWithFloat:tmpProjectDuration];
                    [dictTmpProject setValue:tmpNumberDuration forKey:STR_DURATION];
                }
                else
                {
                    float tmpProjectDuration = [[dictProject objectForKey:STR_DURATION] floatValue];
                    tmpProjectDuration += numDuration;
                    NSNumber *tmpNumberDuration = [NSNumber numberWithFloat:tmpProjectDuration];
                    [dictProject setValue:tmpNumberDuration forKey:STR_DURATION];
                }
               
            }
    
        }
    }
    
    for (NSMutableDictionary *dictTask in arrProjectsToDraw)
    {
        strColor    = [dictTask objectForKey:STR_TASK_COLOR];
        numDuration = [[dictTask objectForKey:STR_DURATION] floatValue];
        
        fDurationRatio = numDuration * 12 / numTotalDuration ;
        
        NSString *strRedString = [NSString stringWithFormat:@"%@", [strColor substringWithRange:NSMakeRange(0, 2)]];
        float fRed = [[TTTools hexFromStr:strRedString] floatValue];
        NSString *strGreenString = [NSString stringWithFormat:@"%@", [strColor substringWithRange:NSMakeRange(2, 2)]];
        float fGreen = [[TTTools hexFromStr:strGreenString] floatValue];
        NSString *strBlueString = [NSString stringWithFormat:@"%@", [strColor substringWithRange:NSMakeRange(4, 2)]];
        float fBlue = [[TTTools hexFromStr:strBlueString] floatValue];
        
        DACircularProgressView *largeProgressViewTMP = [[DACircularProgressView alloc] initWithFrame:CGRectMake(28, 74, 265, 265)];
        largeProgressViewTMP.layer.anchorPoint = CGPointMake(0.5, 0.5);
        [largeProgressViewTMP setTrackTintColor:[[UIColor alloc] initWithRed:0xfc/255.0 green:0x3e/255.0 blue:0xff/255.0 alpha:0]];
        [largeProgressViewTMP setProgressTintColor:[[UIColor alloc] initWithRed:fRed/6666.0 green:fGreen/6666.0 blue:fBlue/6666.0 alpha:1]];
        
        largeProgressViewTMP.roundedCorners = NO;
        [self.view addSubview:largeProgressViewTMP];
        [largeProgressViewTMP setThicknessRatio:0.066];
        
        [largeProgressViewTMP setProgress:fDurationRatio*NUM_ONE_HOUR_DURATION];
        
        CABasicAnimation *rota = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rota.duration = 5;
        rota.autoreverses = NO;
        rota.removedOnCompletion = NO;
        rota.fillMode = kCAFillModeForwards;
        rota.fromValue = [NSNumber numberWithFloat: 0];
        rota.toValue = [NSNumber numberWithFloat:  numRotationAngle ];
        [largeProgressViewTMP.layer addAnimation: rota forKey: @"rotation"];
        numRotationAngle += fDurationRatio*NUM_ONE_HOUR_ROTATION;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
