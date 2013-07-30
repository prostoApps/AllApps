//
//  TTTasksTableViewCell.h
//  TimeTrackerApp
//
//  Created by Torasike on 06.06.13.
//  Copyright (c) 2013 Torasike. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TTTasksTableViewCellDelegate <NSObject>

-(void)allowTTTasksTableViewScroll:(BOOL)variable;
-(void)deleteCellFromTTTasksTableView:(id)cell;

@end

@interface TTTasksTableViewCell : UITableViewCell {
    IBOutlet UIImageView *taskCheckBackground;
    IBOutlet UIImageView *taskIcon;
    IBOutlet UILabel *curentTaskTime;
    IBOutlet UIImageView *taskColor;
    IBOutlet UIView *taskContentView;
    BOOL isCheck;
    BOOL isOvertime;
    id<TTTasksTableViewCellDelegate> delegate;
    
}
@property (retain, nonatomic) IBOutlet UILabel *clientName;
@property (retain, nonatomic) IBOutlet UILabel *taskName;
@property (nonatomic,retain) id<TTTasksTableViewCellDelegate> delegate;

-(void)setTableCellData:(NSDictionary*)data;

@end
