//
//  TXAccountManager.m
//  Pods
//
//  Created by jinlong9 on 2018/5/30.
//

#import "TXAccountManager.h"

@implementation TXAccountManager
static TXAccountManager *accountManager = nil;
+ (TXAccountManager*)accountManager
{
    if (accountManager == nil)
    {
        accountManager = [[TXAccountManager alloc] init];
    }
    return accountManager;
}
@end
