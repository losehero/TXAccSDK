//
//  TXTabBarViewController.m
//  TXAccountSDK_Example
//
//  Created by jinlong9 on 2018/6/1.
//  Copyright © 2018年 losehero. All rights reserved.
//

#import "TXTabBarViewController.h"
#import "TXViewController.h"
@interface TXTabBarViewController ()

@end

@implementation TXTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupViewContrllersURL:(NSArray *)data {
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    NSArray *tabTitles = [NSArray arrayWithObjects:@"首页",@"信用卡",@"工具",@"我的",nil];
    for (int i = 0 ; i < [data count] ; i++)
    {
        TXViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TXViewController"];
        viewController.url = data[i];
        UIImage * normalImage = [[UIImage imageNamed:[NSString stringWithFormat:@"image_%d",i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * selectImage = [[UIImage imageNamed:[NSString stringWithFormat:@"imageselect_%d",i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *homeItem =  [[UITabBarItem alloc] initWithTitle:tabTitles[i] image:normalImage selectedImage:selectImage];
        [homeItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
        viewController.tabBarItem = homeItem;
        UINavigationController *subNavigation = [[UINavigationController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:subNavigation];
    }
    
    self.viewControllers = viewControllers;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
