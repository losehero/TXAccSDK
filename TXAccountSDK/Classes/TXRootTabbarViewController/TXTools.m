//
//  TXTools.m
//  Pods
//
//  Created by jinlong9 on 2018/5/29.
//

#import "TXTools.h"
#import "INSPersistentContainer.h"
@implementation TXTools

+ (UIImage *)loadClassBundleImage:(NSString *)imageName
{
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    NSString *bundlePath = [bundle.bundlePath stringByAppendingString:@"/TXPodsImages.bundle"];
    UIImage *soundImage =[UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",bundlePath,imageName]];
    return soundImage;
}

+ (NSString *)iconNameWithType:(NSString *)btype {
    
    NSDictionary *iconDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"\U0000e678",@"chongwu",
                             @"\U0000e629",@"gouwu",
                             @"\U0000e61c",@"riyong",
                             @"\U0000e657",@"jiaotong",
                             @"\U0000e603",@"canying",
                             @"\U0000e650",@"caipiao",
                             @"\U0000e611",@"shucai",
                             @"\U0000e601",@"lingshi",
                             @"\U0000e608",@"yule",
                             @"\U0000e66f",@"tongxun",
                             @"\U0000e61b",@"fushi",
                             @"\U0000e633",@"shuiguo",
                             @"\U0000e602",@"yundong",
                             @"\U0000e918",@"meirong",
                             @"\U0000e67c",@"zhufang",
                             @"\U0000e620",@"jujia",
                             @"\U0000e655",@"haizi",
                             @"\U0000e67f",@"zhangbei",
                             @"\U0000e87e",@"shejiao",
                             @"\U0000e662",@"lvxing",
                             @"\U0000e623",@"yanjiu",
                             @"\U0000e64b",@"shuma",
                             @"\U0000e651",@"qiche",
                             @"\U0000e637",@"yiliao",
                             @"\U0000e615",@"shuji",
                             @"\U0000e600",@"xuexi",
                             @"\U0000e62d",@"lijin",
                             @"\U0000e658",@"liwu",
                             @"\U0000e604",@"bangong",
                             @"\U0000e67d",@"weixiu",
                             @"\U0000e65a",@"juanzeng",
                             @"\U0000e61a",@"shezhi",
                             @"\U0000e606",@"jianzhi",
                             @"\U0000e669",@"licai",
                             @"\U0000e616",@"gongzi",
                             @"\U0000e62d",@"lijin",
                             @"\U0000e64d",@"qita",
                             @"\U0000e61a",@"shezhi",
                             nil];
    
    NSString *iconName = [iconDic objectForKey:btype];
    
    if (!iconName)
    {
        iconName = @"\U0000e621";
    }
    
    return iconName;
}

+ (UIColor *)tinkColor {
    return [UIColor colorWithRed:254.0/255.0 green:212.0/255.0 blue:54.0/255.0 alpha:1];
}
@end
