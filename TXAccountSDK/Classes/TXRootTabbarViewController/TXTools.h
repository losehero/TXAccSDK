//
//  TXTools.h
//  Pods
//
//  Created by jinlong9 on 2018/5/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TXTools : NSObject
+ (UIImage *)loadClassBundleImage:(NSString *)imageName;
+ (NSString *)iconNameWithType:(NSString *)btype;
+ (UIColor *)tinkColor;
@end
