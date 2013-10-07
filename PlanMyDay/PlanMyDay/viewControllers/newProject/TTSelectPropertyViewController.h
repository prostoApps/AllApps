//
//  TTSelectPropertyViewController.h
//  PlanMyDay
//
//  Created by ProstoApps* on 8/11/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTApplicationManager.h"

@interface TTSelectPropertyViewController : UIViewController
{
    NSString * selectStr;
    IBOutlet UISearchBar * searchBar;
    IBOutlet UIButton * btnAddFirst;
    IBOutlet UILabel * lbAddFirst;
}

@property (nonatomic, retain) NSMutableArray *arrProperties;
@property (nonatomic, retain) IBOutlet UITableView *tablePropertiesList;

@end
