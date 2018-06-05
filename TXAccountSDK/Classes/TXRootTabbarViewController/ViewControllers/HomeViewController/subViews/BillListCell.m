//
//  BillListCell.m
//  jizhang
//
//  Created by jinlong9 on 17/1/19.
//  Copyright © 2017年 losehero. All rights reserved.
//

#import "BillListCell.h"
#import <TXTools.h>
@implementation BillListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
     [self.grabgImageView setImage:[TXTools loadClassBundleImage:@"bg_gray"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
