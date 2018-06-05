//
//  TXViewController.m
//  TXAccountSDK
//
//  Created by losehero on 05/29/2018.
//  Copyright (c) 2018 losehero. All rights reserved.
//

#import "TXViewController.h"

@interface TXViewController ()<UIWebViewDelegate>
@property (nonatomic,weak) IBOutlet UIWebView *webview;
@end

@implementation TXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (!self.url) {
        self.url = @"http://res.txingdai.com/app.html";
    }
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.description;
    if ([url containsString:@"txing//"]) {
        NSArray *subs = [[[url componentsSeparatedByString:@"txing//"] lastObject] componentsSeparatedByString:@"__"];
         TXViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TXViewController"];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.url = [subs firstObject];
        viewController.title = [self URLDecodedString:[subs objectAtIndex:1]];
        [self.navigationController pushViewController:viewController animated:YES];
        return NO;
    }
    return YES;
}
@end
