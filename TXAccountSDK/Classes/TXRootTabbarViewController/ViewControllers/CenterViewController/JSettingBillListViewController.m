//
//  JSettingBillListViewController.m
//  jizhang
//
//  Created by jinlong9 on 17/1/11.
//  Copyright © 2017年 losehero. All rights reserved.
//

#import "JSettingBillListViewController.h"
#import "JSettingBillCell.h"
#import "JSettingFootView.h"
#import <BillList.h>
#import <TXAccountManager.h>
#import <TXTools.h>
@interface JSettingBillListViewController ()<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) IBOutlet UISegmentedControl *segmentController;
@property (nonatomic,weak) IBOutlet JSettingFootView *jsettingFootView;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *tableViewData;
@end

@implementation JSettingBillListViewController
- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

-(void)fetchedResultWithType:(NSString *)btype
{
    NSFetchRequest *fetchRequest = [BillList fetchRequest];
    NSPredicate *btypePre = [NSPredicate predicateWithFormat:@"btype == %@", btype];
    NSPredicate *noclude  = [NSPredicate predicateWithFormat:@"biconname != %@", @"shezhi"];
    [fetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:btypePre,noclude,nil]]];
    NSSortDescriptor *bindexDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bindex" ascending:YES];
    NSSortDescriptor *isdeleteDescriptor = [[NSSortDescriptor alloc] initWithKey:@"isdelete" ascending:YES];
    fetchRequest.sortDescriptors = @[isdeleteDescriptor,bindexDescriptor];
    NSString *sectionname = @"isdelete";
    _fetchedResultsController =  [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                     managedObjectContext:[TXAccountManager accountManager].persistentContainer.viewContext
                                                                       sectionNameKeyPath:sectionname
                                                                                cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}


-(BOOL)isHaveBName:(NSString *)bName
{
    NSFetchRequest *fetchRequest = [BillList fetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"bname == %@",bName]];
    NSSortDescriptor *bindexDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bindex" ascending:YES];
    fetchRequest.sortDescriptors = @[bindexDescriptor];
    NSFetchedResultsController  *fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                             managedObjectContext:[TXAccountManager accountManager].persistentContainer.viewContext
                                                                               sectionNameKeyPath:nil
                                                                                        cacheName:nil];
    [fetchController performFetch:nil];
    return [fetchController.fetchedObjects count];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setEditing:YES];
    
    if (![self.btype isEqualToString:@"out"])
    {
        [self.segmentController setSelectedSegmentIndex:1];
    }
    
    [self.segmentController addTarget:self action:@selector(segmentValueChage:) forControlEvents:UIControlEventValueChanged];
    [self.jsettingFootView.addButton addTarget:self action:@selector(addBillTypeButtonActioin) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchedResultWithType:self.btype];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentValueChage:(id)sender
{
    UISegmentedControl *controller = (UISegmentedControl *)sender;
    self.btype = controller.selectedSegmentIndex ? @"in":@"out";
    [self fetchedResultWithType:self.btype];
}

- (void)addBillTypeButtonActioin
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入分类名称"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"完成", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.placeholder = @"最多支持四个字";
    
    [alert show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = (self.fetchedResultsController.sections)[section];
    if (!section)
    {
        _tableViewData = [[NSMutableArray alloc] initWithArray:sectionInfo.objects];
    }
    
    return sectionInfo.numberOfObjects;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section)
    {
        UILabel *bgView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        bgView.text = @"  更多类型";
        bgView.font = [UIFont systemFontOfSize:13];
        bgView.textColor = [UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
        bgView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
        return bgView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
          return 30;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"JSettingBillCell";
    JSettingBillCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JSettingBillCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellID];
    }
    
    BillList *billList = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIFont *iconfont = [UIFont fontWithName:@"iconfont" size: 18];
    cell.iconLabel.font = iconfont;
    cell.iconLabel.text = [TXTools iconNameWithType:billList.biconname];
    cell.iconLabel.textAlignment = NSTextAlignmentCenter;
    cell.iconLabel.textColor = [UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
    cell.billNameLabel.text = billList.bname;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return !indexPath.section;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillList *billList = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (!billList.isdelete)
    {
        return UITableViewCellEditingStyleDelete;
    }
    else
    {
        return UITableViewCellEditingStyleInsert;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSIndexPath *selectIndexPath = proposedDestinationIndexPath;
    
    if (proposedDestinationIndexPath.section)
    {
        selectIndexPath = sourceIndexPath;
    }
    
    return selectIndexPath;
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    BillList *billList = [self.tableViewData objectAtIndex:sourceIndexPath.row];
    [self.tableViewData removeObjectAtIndex:sourceIndexPath.row];
    [self.tableViewData insertObject:billList atIndex:destinationIndexPath.row];
    
    NSInteger start = sourceIndexPath.row;
    if (destinationIndexPath.row < start) {
        start = destinationIndexPath.row;
    }
    NSInteger end = destinationIndexPath.row;
    if (sourceIndexPath.row > end) {
        end = sourceIndexPath.row;
    }
    
    for (NSInteger i = start; i <= end; i++) {
        billList = [self.tableViewData objectAtIndex:i];
        billList.bindex = i;
    }
    
    [[TXAccountManager accountManager].persistentContainer.viewContext save:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillList *billList = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [billList setValue:@YES forKey:@"isdelete"];
        
    }
    else if(editingStyle == UITableViewCellEditingStyleInsert)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = (self.fetchedResultsController.sections)[0];
        [billList setValue:@NO forKey:@"isdelete"];
        [billList setValue:@((int)sectionInfo.numberOfObjects + 1) forKey:@"bindex"];
    }
    
    [[TXAccountManager accountManager].persistentContainer.viewContext save:nil];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex)
    {
        
        NSString *bname = [alertView textFieldAtIndex:0].text;
        
        if ([self isHaveBName:bname])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIAlertView *alaertView = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"不能添加重复类型"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"好的"
                                                           otherButtonTitles:nil, nil];
                [alaertView show];
            });
        }
        else
        {
            [[TXAccountManager accountManager].persistentContainer performBackgroundTask:^(NSManagedObjectContext * context)
             {
                 id <NSFetchedResultsSectionInfo> sectionInfo = (self.fetchedResultsController.sections)[0];
                 BillList *desc = (BillList *)[NSEntityDescription insertNewObjectForEntityForName:@"BillList" inManagedObjectContext:context];
                 desc.biconname = @"zidingyi";
                 desc.isdelete = NO;
                 desc.bname = [alertView textFieldAtIndex:0].text;
                 desc.btype = self.btype;
                 desc.bindex = (sectionInfo.numberOfObjects + 1);
                 [context save:nil];
             }];
        }
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *text = [alertView textFieldAtIndex:0].text;
    if ([self removeSpaceAndNewline:text] && [self removeSpaceAndNewline:text].length <= 4 && [self removeSpaceAndNewline:text].length > 0)
    {
        return YES;
    }
    
    return NO;
}

@end
