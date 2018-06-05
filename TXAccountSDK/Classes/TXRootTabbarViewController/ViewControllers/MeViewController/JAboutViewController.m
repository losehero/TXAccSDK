//
//  JAboutViewController.m
//  jizhang
//
//  Created by jinlong9 on 17/2/12.
//  Copyright © 2017年 losehero. All rights reserved.
//

#import "JAboutViewController.h"

@interface JAboutViewController ()
@property (nonatomic,weak) IBOutlet UILabel *versionLabel;
@end

@implementation JAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"版本号：%@",version];
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
