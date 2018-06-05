//
//  TXRootTabBarViewController.m
//  Pods
//
//  Created by jinlong9 on 2018/5/29.
//

#import "TXRootTabBarViewController.h"
#import "TXHomeViewController.h"
#import "TXCenterViewController.h"
#import "TXMeViewController.h"
#import "TXTools.h"
@interface TXRootTabBarViewController ()

@end

@implementation TXRootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor yellowColor];
    [self addSubViewControlls];
}

- (void)addSubViewControlls {
    TXHomeViewController *home = (TXHomeViewController *)[self storyViewControllerWithControllerName:@"TXHomeViewController"];
    UIImage * normalImage = [[TXTools loadClassBundleImage:@"detail_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * selectImage = [[TXTools loadClassBundleImage:@"detail_highlight.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *homeItem =  [[UITabBarItem alloc] initWithTitle:@"首页" image:normalImage selectedImage:selectImage];
    [homeItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
    home.tabBarItem = homeItem;
    UINavigationController *homeNavigation = [[UINavigationController alloc] initWithRootViewController:home];
    
    
    
    TXCenterViewController *center = (TXCenterViewController *)[self storyViewControllerWithControllerName:@"TXCenterViewController"];
    UIImage *centernormalImage = [[TXTools loadClassBundleImage:@"post_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *centerselectImage = [[TXTools loadClassBundleImage:@"post_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *centerItem = [[UITabBarItem alloc] initWithTitle:nil image:centernormalImage selectedImage:centerselectImage];;
    [centerItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
    center.tabBarItem = centerItem;
    UINavigationController *centerNavigation = [[UINavigationController alloc] initWithRootViewController:center];
    
    
    TXMeViewController *me = (TXMeViewController *)[self storyViewControllerWithControllerName:@"TXMeViewController"];
    UIImage *menormalImage = [[TXTools loadClassBundleImage:@"install_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *meselectImage = [[TXTools loadClassBundleImage:@"install_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *meItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:menormalImage selectedImage:meselectImage];;
    [meItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
    me.tabBarItem = meItem;
    UINavigationController *meNavigation = [[UINavigationController alloc] initWithRootViewController:me];
    
    
    self.viewControllers = [NSArray arrayWithObjects:homeNavigation,centerNavigation,meNavigation,nil];
}

- (UIViewController *)storyViewControllerWithControllerName:(NSString *)controllName {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"AccountHome" bundle:bundle];
    return  [story instantiateViewControllerWithIdentifier:controllName];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
