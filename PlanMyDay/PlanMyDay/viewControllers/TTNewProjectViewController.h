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
    IBOutlet UITableView *TaskTableView;
    
    IBOutlet UISegmentedControl *scTaskProjectClient;
    
    IBOutlet UIButton    *btnSave;
    IBOutlet UIScrollView *scrvScrollView;
}
@property(nonatomic,retain) IBOutlet UISegmentedControl *scTaskProjectClient;
@property(nonatomic,retain) IBOutlet UIButton *btnSave;

-(IBAction) segmentedControlIndexChanged;
//-(IBAction) btnSaveTouchHandler:(id)sender;
@end

