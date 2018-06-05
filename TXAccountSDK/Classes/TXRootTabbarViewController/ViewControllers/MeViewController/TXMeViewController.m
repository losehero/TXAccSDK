//
//  TXMeViewController.m
//  Pods
//
//  Created by jinlong9 on 2018/5/29.
//

#import "TXMeViewController.h"
#import <JSettingCell.h>
#import <JAboutViewController.h>
#import <TimerAlertViewController.h>
#import <JSettingBillListViewController.h>
@interface TXMeViewController ()
@property (nonatomic,strong) NSMutableArray *tableDataSource;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@end

@implementation TXMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    // Do any additional setup after loading the view.
    NSString *fileName = [[NSBundle bundleForClass:self.classForCoder] pathForResource:@"setting" ofType:@"plist"];
    _tableDataSource = [NSMutableArray arrayWithContentsOfFile:fileName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_tableDataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    bgView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    return bgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_tableDataSource objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"JSettingCell";
    
    JSettingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JSettingCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellID];
    }
    NSString *title = [[self.tableDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    UIView *selectBgView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView = selectBgView;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = [[self.tableDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([title isEqualToString:@"类型设置"])
    {
        JSettingBillListViewController  *jSettingBillListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"JSettingBillListViewController"];
        jSettingBillListViewController.hidesBottomBarWhenPushed = YES;
        jSettingBillListViewController.btype = @"out";
        [self.navigationController pushViewController:jSettingBillListViewController animated:YES];
    }
    else if ([title isEqualToString:@"定时提醒"])
    {
        TimerAlertViewController *timerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TimerAlertViewController"];
        timerViewController.hidesBottomBarWhenPushed = YES;
        timerViewController.title = title;
        [self.navigationController pushViewController:timerViewController animated:YES];
    }
    else if ([title isEqualToString:@"意见反馈"] || [title isEqualToString:@"版本"])
    {
        JAboutViewController  *jAboutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"JAboutViewController"];
        jAboutViewController.title = title;
        [self.navigationController pushViewController:jAboutViewController animated:YES];
    }
    else if([title isEqualToString:@"给App评论鼓励"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1207186659"]];
    }
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
