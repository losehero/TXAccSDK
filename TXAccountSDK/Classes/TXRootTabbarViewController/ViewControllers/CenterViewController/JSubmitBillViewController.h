//
//  JSubmitBillViewController.h
//  jizhang
//
//  Created by jinlong9 on 17/1/10.
//  Copyright © 2017年 losehero. All rights reserved.
//


#import <XLForm/XLForm.h>
#import "BillList.h"
#import "JBill.h"
@interface JSubmitBillViewController : XLFormViewController
@property (nonatomic,strong) BillList *billList;
@property (nonatomic,strong) JBill    *jbill;
@end
