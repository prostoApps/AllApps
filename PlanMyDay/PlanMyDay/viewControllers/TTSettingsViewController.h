//
//  TTSettingsViewController.h
//  TimeTracker
//
//  Created by ProstoApps* on 6/29/13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTApplicationManager.h"
#import "TTFieldsTableViewController.h"

@interface TTSettingsViewController : UIViewController<TTFieldsTableDelegate>{
    IBOutlet UITableView * tableSettings;
    IBOutlet UIView * footerTableView;
    IBOutlet UIButton * btnApply;
}
-(IBAction) btnApplyTouchHandler:(id)sender;
@end
