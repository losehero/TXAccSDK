//
//  JAddBillCell.m
//  jizhang
//
//  Created by jinlong9 on 17/1/9.
//  Copyright © 2017年 losehero. All rights reserved.
//

#import "JAddBillCell.h"
#import <TXTools.h>
@implementation JAddBillCell
-(void)layoutSubviews {
    [super layoutSubviews];
    [self.grabgView setImage:[TXTools loadClassBundleImage:@"bg_gray"]];
    
}
@end
