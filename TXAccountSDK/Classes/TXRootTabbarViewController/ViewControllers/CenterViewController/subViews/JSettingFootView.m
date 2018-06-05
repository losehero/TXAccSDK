//
//  JSettingFootView.m
//  jizhang
//
//  Created by jinlong9 on 17/1/11.
//  Copyright © 2017年 losehero. All rights reserved.
//

#import "JSettingFootView.h"

@implementation JSettingFootView

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIFont *iconfont = [UIFont fontWithName:@"iconfont" size: 16];
    self.iconLabel.font = iconfont;
    self.iconLabel.text = @"\U0000e638";
    self.iconLabel.textAlignment = NSTextAlignmentCenter;
    self.iconLabel.textColor = [UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
}

@end
