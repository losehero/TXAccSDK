//
//  TimerAlertViewController.m
//  jizhang
//
//  Created by jinlong9 on 17/2/11.
//  Copyright © 2017年 losehero. All rights reserved.
//

#import "TimerAlertViewController.h"
#import "JSettingFootView.h"
#import "PickerControllView.h"
#import "JTimerCell.h"
#import "JTimer.h"
#import <TXAccountManager.h>
@interface TimerAlertViewController ()<DatePickerDelegate,NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,weak) IBOutlet JSettingFootView *jsettingFootView;
@property (strong, nonatomic) PickerControllView *pickerVC;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString *timeString;
@end

@implementation TimerAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.jsettingFootView.addButton addTarget:self
                                        action:@selector(addTimenofication)
                              forControlEvents:UIControlEventTouchUpInside];
    
    [self fetchData];
}

-(void)addLocalNotificationWithTime:(NSString *)time
{
    // 初始化本地通知
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar]; // gets default calendar
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit |
                                                         NSMonthCalendarUnit |
                                                         NSDayCalendarUnit |
                                                         NSHourCalendarUnit |
                                                         NSMinuteCalendarUnit)
                                               fromDate:[NSDate date]]; // gets the year, month, day,hour and minutesfor today's date
    [components setHour:[[[time componentsSeparatedByString:@":"] firstObject] integerValue]];
    [components setMinute:[[[time componentsSeparatedByString:@":"] lastObject] integerValue]];
    
    // 通知触发时间
    localNotification.fireDate = [calendar dateFromComponents:components];
    // 触发后，弹出警告框中显示的内容
    localNotification.alertBody = @"记账时间到了，赶快记一笔吧！";
    // 触发时的声音（这里选择的系统默认声音）
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    // 触发频率（repeatInterval是一个枚举值，可以选择每分、每小时、每天、每年等）
    localNotification.repeatInterval = NSCalendarUnitDay;
    // 需要在App icon上显示的未读通知数（设置为1时，多个通知未读，系统会自动加1，如果不需要显示未读数，这里可以设置0）
    localNotification.applicationIconBadgeNumber = 1;
    // 设置通知的id，可用于通知移除，也可以传递其他值，当通知触发时可以获取
    localNotification.userInfo = @{@"id" :time};
    // 注册本地通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)addTimenofication
{
    self.pickerVC = [[[NSBundle bundleForClass:self.classForCoder]   loadNibNamed:@"PickerControllView" owner:self options:nil]lastObject];
    [self.view addSubview:self.pickerVC];
    self.pickerVC.pickerDelegate = self;
}


- (void)fetchData
{
    NSFetchRequest *fetchRequest = [JTimer fetchRequest];
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timerdate" ascending:YES];
    fetchRequest.sortDescriptors = @[dateDescriptor];
    _fetchedResultsController =  [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                     managedObjectContext:[TXAccountManager accountManager].persistentContainer.viewContext
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

- (BOOL)ishaveData:(NSString *)time
{
    NSFetchRequest *fetchRequest = [JTimer fetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"timerdate == %@",time]];
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timerdate" ascending:YES];
    fetchRequest.sortDescriptors = @[dateDescriptor];
    _fetchedResultsController =  [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                     managedObjectContext:[TXAccountManager accountManager].persistentContainer.viewContext
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    return [_fetchedResultsController.fetchedObjects count];
}

#pragma mark DatePicker Delegate
-(void)datePickerRemove{
    [self.pickerVC removeFromSuperview];
}

-(void)datePickerReturn:(NSString *)dateString{
    NSLog(@"%@",dateString);
    
    if ([self ishaveData:dateString])
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil
                                                           message:@"你已经添加过该时间提醒"
                                                          delegate:nil
                                                 cancelButtonTitle:@"好的"
                                                 otherButtonTitles:nil, nil];
        [alerView show];
    }
    else
    {
        _timeString = dateString;
        
        //如果已经获得发送通知的授权则创建本地通知，否则请求授权(注意：如果不请求授权在设置中是没有对应的通知设置项的，也就是说如果从来没有发送过请求，即使通过设置也打不开消息允许设置)
        if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone)
        {
            [self addLocalNotificationWithTime:_timeString];
        }
        else
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                                 settingsForTypes:
                                                                                 UIUserNotificationTypeAlert|
                                                                                 UIUserNotificationTypeBadge|
                                                                                 UIUserNotificationTypeSound
                                                                                 categories:nil]];
        }
        
        [[TXAccountManager accountManager].persistentContainer performBackgroundTask:^(NSManagedObjectContext * context) {
            JTimer *jTimer = (JTimer *)[NSEntityDescription insertNewObjectForEntityForName:@"JTimer"
                                                                     inManagedObjectContext:context];
            jTimer.timerdate = dateString;
            [context save:nil];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self fetchData];
            });
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_fetchedResultsController.sections count];
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
    
    id <NSFetchedResultsSectionInfo> sectionInfo = (self.fetchedResultsController.sections)[section];
    return sectionInfo.numberOfObjects;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"timerCell";
    
    JTimerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JTimerCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JTimer *jtimer = [_fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    cell.timeLabel.text = [NSString stringWithFormat:@"每天 %@",jtimer.timerdate];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//设置tableview是否可编辑
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //这里是关键：这样写才能实现既能禁止滑动删除Cell，又允许在编辑状态下进行删除
    return UITableViewCellEditingStyleDelete;
}


//确定删除某一组的某一行
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        JTimer *jtimer = [_fetchedResultsController objectAtIndexPath:indexPath];
        
        // 取出全部本地通知
        NSArray *notifications = [UIApplication sharedApplication].scheduledLocalNotifications;
        // 遍历进行移除
        for (UILocalNotification *localNotification in notifications) {
            
            // 将每个通知的id取出来进行对比
            if ([[localNotification.userInfo objectForKey:@"id"] isEqualToString:jtimer.timerdate]) {
                // 移除某一个通知
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
        
        NSManagedObjectContext * context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        NSError * error;
        if (![context save:&error])
        {
            NSLog(@"Deletion Error");
        }
        else
        {
            [self fetchData];
        }
    }
}

#pragma mark 调用过用户注册通知方法之后执行（也就是调用完registerUserNotificationSettings:方法之后执行）
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    if (notificationSettings.types!=UIUserNotificationTypeNone) {
        [self addLocalNotificationWithTime:_timeString];
    }
}

@end
