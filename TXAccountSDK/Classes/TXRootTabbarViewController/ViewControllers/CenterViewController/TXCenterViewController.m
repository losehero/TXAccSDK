//
//  TXChartsViewController.m
//  Pods
//
//  Created by jinlong9 on 2018/5/29.
//

#import "TXCenterViewController.h"
#import "JSubmitBillViewController.h"
@interface TXCenterViewController ()<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSIndexPath *selectIndexPath;
@property (nonatomic,strong) NSArray *collectionArray;
@property (nonatomic,strong) NSArray *plistNameArray;
@property (nonatomic,strong) NSArray *iconFontArray;
@property (nonatomic,assign) int selectRow;
-(IBAction)dismisAction:(id)sender;
@end

@implementation TXCenterViewController
-(void)fetchedResultWithType:(NSString *)btype
{
    NSFetchRequest *fetchRequest = [BillList fetchRequest];
    NSPredicate *btypePre = [NSPredicate predicateWithFormat:@"btype == %@", btype];
    NSPredicate *noclude = [NSPredicate predicateWithFormat:@"isdelete == %d",NO];
    [fetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:btypePre,noclude,nil]]];
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bindex" ascending:YES];
    fetchRequest.sortDescriptors = @[dateDescriptor];
    _fetchedResultsController =  [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                     managedObjectContext:[TXAccountManager accountManager].persistentContainer.viewContext
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchedResultWithType:@"out"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [self.fetchedResultsController.fetchedObjects count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JAddBillCell  *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell"
                                                                              forIndexPath:indexPath];
    BillList *billList = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    collectionCell.billtypeLabel.text = billList.bname;
    UIFont *iconfont = [UIFont fontWithName:@"iconfont" size: 32];
    collectionCell.iconLabel.font = iconfont;
    collectionCell.iconLabel.text = [TXTools iconNameWithType:billList.biconname];
    collectionCell.iconLabel.textAlignment = NSTextAlignmentCenter;
    collectionCell.iconLabel.textColor = [UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
    return collectionCell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = self.view.frame.size.width/ 4.0f;
    return CGSizeMake(picDimension, picDimension + 15);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

#pragma  mark UICollectionViewDataDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JAddBillCell *jAddBillCell = (JAddBillCell *)[collectionView cellForItemAtIndexPath:indexPath];
    jAddBillCell.circleView.backgroundColor = [UIColor yellowColor];
    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JAddBillCell *jAddBillCell = (JAddBillCell *)[collectionView cellForItemAtIndexPath:indexPath];
    jAddBillCell.circleView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectIndexPath = [self.collectionView indexPathForCell:sender];
    BillList *billList = [self.fetchedResultsController objectAtIndexPath:selectIndexPath];
    JSubmitBillViewController *submitBillViewController = segue.destinationViewController;
    submitBillViewController.billList = billList;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView reloadData];
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
