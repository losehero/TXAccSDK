//
//  TXHomeViewController.m
//  Pods
//
//  Created by jinlong9 on 2018/5/29.
//

#import "TXHomeViewController.h"
#import <TXAccountManager.h>
#import <JListHeadView.h>
#import <JBill.h>
#import <ListHeardView.h>
#import <BillListCell.h>
#import <TXTools.h>
@interface TXHomeViewController ()<NSFetchedResultsControllerDelegate>
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,weak) IBOutlet JListHeadView *headView;
@property (nonatomic,weak) IBOutlet UIView *footView;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIButton *yearMonthButton;
@property (nonatomic,strong) NSString *filterStr;
@end

@implementation TXHomeViewController

- (NSDateComponents *)dateComponent
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    return dateComponent;
}

- (NSString *)getCurrentYear
{
    NSInteger year = [[self dateComponent] year];
    NSString *yearStr = [NSString stringWithFormat:@"%d",(int)year];
    return yearStr;
}

- (NSString *)getCurrentMonth
{
    NSInteger month = [[self dateComponent] month];
    NSString *monthStr = [NSString stringWithFormat:@"%d",(int)month];
    if (month < 10)
    {
        monthStr = [NSString stringWithFormat:@"0%d",(int)month];
    }
    
    return monthStr;
}



- (void)fetchedResultWithYearMonth:(NSString *)yearMonth
{
    NSFetchRequest *fetchRequest = [JBill fetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat: @"bdate contains %@", yearMonth]];
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bdate" ascending:NO];
    fetchRequest.sortDescriptors = @[dateDescriptor];
    NSString *sectionname = @"bdate";
    _fetchedResultsController =  [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                     managedObjectContext:[TXAccountManager accountManager].persistentContainer.viewContext
                                                                       sectionNameKeyPath:sectionname
                                                                                cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

- (void)inoutData:(NSString *)type withLabel:(UILabel *)label
{
    NSFetchRequest *fetchRequest = [JBill fetchRequest];
    NSString *dateString = [NSString stringWithFormat:@"%@-%@",[self getCurrentYear],[self getCurrentMonth]];
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat: @"bdate contains %@", dateString];
    NSPredicate *inoutTypePredicate = [NSPredicate predicateWithFormat: @"btype == %@", type];
    [fetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:datePredicate,inoutTypePredicate,nil]]];
    [fetchRequest setResultType:NSDictionaryResultType];
    // Create an expression for the key path.
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"bmoney"];
    // Create an expression to represent the sum of marks
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"sum:"    arguments:@[keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"bmoneySum"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSFloatAttributeType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    NSError *error = nil;
    NSArray *result = [[TXAccountManager accountManager].persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
    label.text = [NSString stringWithFormat:@"¥ %.2f",[[[result firstObject] objectForKey:@"bmoneySum"] floatValue]];
    NSLog(@"result  %@", result);
}

//收入支出总和
-(double)fetchinMoneyWithDate:(NSString *)date  btype:(NSString *)btype
{
    NSFetchRequest *fetchRequest = [JBill fetchRequest];
    NSPredicate  *dataPredicate = [NSPredicate predicateWithFormat: @"bdate contains %@", date];
    NSPredicate  *typePredicate = [NSPredicate predicateWithFormat: @"btype==%@",btype];
    [fetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:dataPredicate,typePredicate,nil]]];
    
    
    [fetchRequest setResultType:NSDictionaryResultType];
    // Create an expression for the key path.
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"bmoney"];
    // Create an expression to represent the sum of marks
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"sum:"
                                                            arguments:@[keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"marksSum"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSFloatAttributeType];
    
    // Set the request's properties to fetch just the property represented by the expressions.
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    NSError *error = nil;
    NSArray *array = [[TXAccountManager accountManager].persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
    return [[[array lastObject] objectForKey:@"marksSum"] doubleValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    
    self.filterStr = [NSString stringWithFormat:@"%@-%@",[self getCurrentYear],[self getCurrentMonth]];
    UIFont *font = [UIFont systemFontOfSize:20.f];
    _yearMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_yearMonthButton setFrame:CGRectMake(self.headView.center.x - 68, 0, 136, 50)];
    [_yearMonthButton.titleLabel setFont:font];
    _yearMonthButton.backgroundColor = [UIColor clearColor];
    [_yearMonthButton setTitleColor:[UIColor colorWithRed:165.0/255.0 green:54.0/255.0 blue:19.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_yearMonthButton addTarget:self action:@selector(pickerViewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:_yearMonthButton];
}

- (void)pickerViewAction {
   
}

- (void)setUpHeadData
{
    [self inoutData:@"out" withLabel:_headView.outLabel];
    [self inoutData:@"in" withLabel:_headView.inLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSArray *dateArray = [self.filterStr componentsSeparatedByString:@"-"];
    NSString *dateFormate = [NSString stringWithFormat:@"%@年%@月",dateArray[0],dateArray[1]];;
//    [_yearMonthButton setTitle:[NSString stringWithFormat:@"%@ %@",dateFormate,@"fa-arrow-down".bs_awesomeIconRepresentation] forState:UIControlStateNormal];
    [self fetchedResultWithYearMonth:self.filterStr];
    self.footView.hidden = [_fetchedResultsController.sections count];
    [self setUpHeadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = (self.fetchedResultsController.sections)[section];
    return sectionInfo.numberOfObjects;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JBill *bill = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    ListHeardView *listHeardView = [[[NSBundle bundleForClass:self.classForCoder] loadNibNamed:@"ListHeardView"
                                                                  owner:self
                                                                options:nil] objectAtIndex:0];
    listHeardView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    listHeardView.dateLabel.text = [NSString stringWithFormat:@"%@",bill.bdate];
    listHeardView.dateLabel.textColor = [UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
    listHeardView.inoutLabel.textColor = [UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
    NSString *inoutInfo = @"";
    
    if ([self fetchinMoneyWithDate:bill.bdate btype:@"out"] > 0)
    {
        inoutInfo = [NSString stringWithFormat:@"支出:%.2f",[self fetchinMoneyWithDate:bill.bdate btype:@"out"]];
    }
    
    if ([self fetchinMoneyWithDate:bill.bdate btype:@"in"] > 0)
    {
        NSString *inText = [NSString stringWithFormat:@"  收入:%.2f",[self fetchinMoneyWithDate:bill.bdate btype:@"in"]];
        inoutInfo = [inoutInfo stringByAppendingString:inText];
    }
    
    [listHeardView.inoutLabel setText:inoutInfo];
    return listHeardView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"BillListCell";
    BillListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[BillListCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellID];
    }
    
    cell.lineLabel.hidden = NO;
    id <NSFetchedResultsSectionInfo> sectionInfo = (self.fetchedResultsController.sections)[indexPath.section];
    if ((sectionInfo.numberOfObjects - 1) == indexPath.row && indexPath.section != [_fetchedResultsController.sections count] - 1) {
        cell.lineLabel.hidden = YES;
    }
    
    JBill *bill = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIFont *iconfont = [UIFont fontWithName:@"iconfont" size: 25];
    cell.iconNameLabel.font = iconfont;
    cell.iconNameLabel.text = [TXTools iconNameWithType:bill.biconname];
    cell.iconNameLabel.textColor = [UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
    cell.billDesLabel.text = bill.bdes ? bill.bdes:bill.bname;
    if ([bill.btype isEqualToString:@"out"]){
        cell.billMoneyLabel.text = [NSString stringWithFormat:@"-%.2f",bill.bmoney];
    }
    else
    {
        cell.billMoneyLabel.text = [NSString stringWithFormat:@"+%.2f",bill.bmoney];
    }
    
    UIView *selectBgView = [[UIView alloc] initWithFrame:cell.bounds];
    selectBgView.backgroundColor = [TXTools tinkColor];
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
        
        [tableView beginUpdates];
        //使用某种动画效果来删除特定的Cell
        id <NSFetchedResultsSectionInfo> sectionInfo = (self.fetchedResultsController.sections)[indexPath.section];
        BOOL isRemoveSection = NO;
        if (sectionInfo.numberOfObjects == 1)
        {
            isRemoveSection = YES;
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
            if (!isRemoveSection)
            {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationTop];
            }
            else
            {
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                         withRowAnimation:UITableViewRowAnimationTop];
            }
        }
        
        [tableView endUpdates];
        
        [self setUpHeadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return !indexPath.section;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *selectIndexPath = [self.tableView indexPathForCell:sender];
    JBill *jbill = [self.fetchedResultsController objectAtIndexPath:selectIndexPath];
//    JSubmitBillViewController *submitBillViewController = segue.destinationViewController;
//    submitBillViewController.jbill = jbill;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    self.footView.hidden = [_fetchedResultsController.sections count];
}

@end
