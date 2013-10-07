//
//  TTCreatePropertyViewController.m
//  PlanMyDay
//
//  Created by ProstoApps* on 8/11/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTCreatePropertyViewController.h"

@interface TTCreatePropertyViewController ()

@end

@implementation TTCreatePropertyViewController

@synthesize btnBack;

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
