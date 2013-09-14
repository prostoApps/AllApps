//
//  TTSelectPropertyViewController.m
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 8/11/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTSelectPropertyViewController.h"

@interface TTSelectPropertyViewController ()

@end

@implementation TTSelectPropertyViewController

@synthesize btnBack;
@synthesize propertyToSelect;

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
    propertyToSelect = [TTAppDataManager sharedAppDataManager].selectProperty;
   // self.title = [NSString stringWithFormat:(@"Choose '%@' "),propertyToSelect];
    titleLabel.text = [NSString stringWithFormat:(@"Select '%@' property View "),propertyToSelect];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)btnBackTouchHandler:(id)sender
{
    NSLog(@"CREATE_PROPERTY::btnBackTouchHandler");
    [[TTApplicationManager sharedApplicationManager] switchViewTo:VIEW_NEW_TASK
                                          forNavigationController:self.navigationController];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
