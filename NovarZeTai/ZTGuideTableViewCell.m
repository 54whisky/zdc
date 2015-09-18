//
//  ZTGuideTableViewCell.m
//  NovarZeTai
//
//  Created by Golden-Tech on 14-10-8.
//  Copyright (c) 2014年 golden-tech. All rights reserved.
//

#import "ZTGuideTableViewCell.h"

@implementation ZTGuideTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
