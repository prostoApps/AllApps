//
//  TTTasksNavigatorCell.m
//  PlanMyDay
//
//  Created by Torasike on 28.10.13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTTasksNavigatorCell.h"

@implementation TTTasksNavigatorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray * nibbArray = [[NSBundle mainBundle] loadNibNamed:@"TTTasksNavigatorCell" owner:self options:nil];
        self = [nibbArray objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
