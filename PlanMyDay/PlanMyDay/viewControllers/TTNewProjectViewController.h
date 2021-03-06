//
//  TTNewProjectViewController.h
//  TimeTracker
//
//  Created by ProstoApps* on 6/21/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTAppDataManager.h"
#import "TTApplicationManager.h"
#import "TTFieldsTableViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface TTNewProjectViewController : UIViewController <UITextFieldDelegate,TTFieldsTableDelegate,ViewControllerWithArgument,ViewControllerWithAutoUpdate>
{
  //  IBOutlet UITableView * tableViewNewProject;
    IBOutlet UIView * headerNewProject;
    IBOutlet UIView * footerTableViewNewProject;
    IBOutlet UISegmentedControl *scTaskProjectClient;
    IBOutlet UIButton * btnSave;
    
   id <UITableViewDelegate>  _delegate;
   id <UITableViewDataSource>  _dataSource;

}
@property(nonatomic,assign) id <UITableViewDelegate>  delegate;
@property(nonatomic, assign) id <UITableViewDataSource>  dataSource;
@property(nonatomic,retain) IBOutlet UISegmentedControl *scTaskProjectClient;
@property(nonatomic ,retain) IBOutlet UITableView * tableViewNewProject;

@property (nonatomic,retain) TTItem  *externalArgument;

- (void)setExternalArgument:(TTItem*)argument;
- (TTItem*)getExternalArgument;

-(IBAction) segmentedControlIndexChanged;
-(IBAction) btnSaveTouchHandler:(id)sender;

-(void)updateData;
@end

