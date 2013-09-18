//
//  TTSelectPropertyViewController.h
//  PlanMyDay
//
//  Created by Yegor Karpechenkov on 8/11/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTApplicationManager.h"

@interface TTSelectPropertyViewController : UIViewController
{
    NSIndexPath * selectIP;
    NSString * selectStr;
    IBOutlet UISearchBar * searchBar;
}

@property (nonatomic, retain) NSMutableArray *arrProperties;

-(IBAction)btnBackTouchHandler:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *tablePropertiesList;

@property (retain,nonatomic) IBOutlet UIButton *btnBack;

@end
