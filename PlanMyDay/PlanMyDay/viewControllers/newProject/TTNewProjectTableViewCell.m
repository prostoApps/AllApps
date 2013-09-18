//
//  TTNewProjectTableViewCell.m
//  PlanMyDay
//
//  Created by Torasike on 18.09.13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTNewProjectTableViewCell.h"

@implementation TTNewProjectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
   // [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [super setHighlighted:highlighted animated:animated];
}

@end
