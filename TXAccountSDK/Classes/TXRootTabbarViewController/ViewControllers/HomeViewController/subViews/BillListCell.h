//
//  BillListCell.h
//  jizhang
//
//  Created by jinlong9 on 17/1/19.
//  Copyright © 2017年 losehero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillListCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *iconNameLabel;
@property (nonatomic,weak) IBOutlet UILabel *billDesLabel;
@property (nonatomic,weak) IBOutlet UILabel *billMoneyLabel;
@property (nonatomic,weak) IBOutlet UILabel *lineLabel;
@property (nonatomic,weak) IBOutlet UIImageView *grabgImageView;
@end
