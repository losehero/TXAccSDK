//
//  TXAccountManager.h
//  Pods
//
//  Created by jinlong9 on 2018/5/30.
//

#import <Foundation/Foundation.h>
#import "INSPersistentContainer.h"
@interface TXAccountManager : NSObject
@property (nonatomic,strong) INSPersistentContainer *persistentContainer;
+ (TXAccountManager*)accountManager;
@end
