//
//  TXAppDelegate.h
//  TXAccountSDK
//
//  Created by losehero on 05/29/2018.
//  Copyright (c) 2018 losehero. All rights reserved.
//

@import UIKit;
#import <CoreData/CoreData.h>
#import "INSPersistentContainer.h"
#import "INSDataStackContainer.h"
#import "BillList.h"
@interface TXAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) INSPersistentContainer *persistentContainer;
@end
