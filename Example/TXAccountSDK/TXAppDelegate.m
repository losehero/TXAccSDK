//
//  TXAppDelegate.m
//  TXAccountSDK
//
//  Created by losehero on 05/29/2018.
//  Copyright (c) 2018 losehero. All rights reserved.
//

#import "TXAppDelegate.h"
#import "TXRootTabBarViewController.h"
#import "TXAccountManager.h"
#import "TXTabBarViewController.h"
#import "TXNetWorkFailViewController.h"
@interface TXAppDelegate()
@property (nonatomic,strong) TXNetWorkFailViewController  *netWorkViewController;
@end


@implementation TXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:254.0/255.0 green:212.0/255.0 blue:54.0/255.0 alpha:1]];
    UIStoryboard *mainstory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.netWorkViewController = [mainstory instantiateViewControllerWithIdentifier:@"TXNetWorkFailViewController"];
    
    
    [self setUpOriginCoreData];
    [TXAccountManager accountManager].persistentContainer = self.persistentContainer;
    NSBundle *bundle = [NSBundle bundleForClass:[TXRootTabBarViewController class]];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"AccountHome" bundle:bundle];
    UINavigationController *navigationController = [story instantiateViewControllerWithIdentifier:@"TXRootTabBarViewController"];
    self.window.rootViewController = navigationController;

    [self dataRequest];
    return YES;
}

- (void)dataRequest {
    
    NSString *bundleid = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *version  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString *url = [NSString stringWithFormat:@"http://res.txingdai.com/appinfo/newest?boundleId=%@&channel=AppStore&version=%@",bundleid,version];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    // Create url connection and fire request
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError){
                               if (data) {
                                   NSError *error = nil;
                                   NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                              options:NSJSONReadingMutableLeaves
                                                                                                error:&error];
                                   NSArray *tabs = jsonObject[@"data"];
                                   if (tabs && [tabs count]) {
                                       UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                        TXTabBarViewController *tabBarViewController =  [story instantiateViewControllerWithIdentifier:@"TXTabBarViewController"];
                                       [tabBarViewController setupViewContrllersURL:tabs];
                                       self.window.rootViewController = tabBarViewController;
                                   }
                               } else {
                                   self.window.rootViewController = self.netWorkViewController;
                                   [self.netWorkViewController.requestButton addTarget:self action:@selector(dataRequest) forControlEvents:UIControlEventTouchUpInside];
                               }
                           }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (INSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            
            _persistentContainer = [[INSDataStackContainer alloc] initWithName:@"INSPersistentContainer"];
            INSPersistentStoreDescription *desc = [_persistentContainer.persistentStoreDescriptions firstObject];
            desc.shouldAddStoreAsynchronously = NO;
            
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(INSPersistentStoreDescription *storeDescription, NSError *error) {
                
                
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


- (void)setUpOriginCoreData {
    NSFetchRequest *fetchRequest = [BillList fetchRequest];
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bname" ascending:NO];
    fetchRequest.sortDescriptors = @[dateDescriptor];
    NSFetchedResultsController  *fetchResult =  [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                    managedObjectContext:self.persistentContainer.viewContext
                                                                                      sectionNameKeyPath:nil
                                                                                               cacheName:nil];
    [fetchResult performFetch:nil];
    if (![fetchResult.fetchedObjects count])
    {
        [self.persistentContainer performBackgroundTask:^(NSManagedObjectContext * context)
         {
             NSString *path = [[NSBundle mainBundle] pathForResource:@"JAddBill" ofType:@"plist"];
             NSArray *billArray = [NSArray arrayWithContentsOfFile:path];
             
             for (int i = 0 ; i < [billArray count]; i++) {
                 BillList *billList = (BillList *)[NSEntityDescription insertNewObjectForEntityForName:@"BillList" inManagedObjectContext:context];
                 NSDictionary *dic = [billArray objectAtIndex:i];
                 billList.bname = [dic objectForKey:@"name"];
                 billList.biconname = [dic objectForKey:@"type"];
                 if ([billList.bname isEqualToString:@"设置"])
                 {
                     billList.bindex = 1000000;
                 }
                 else
                 {
                     billList.bindex = i;
                 }
                 billList.isdelete = NO;
                 billList.btype = @"out";
                 [context save:nil];
             }
             
             
             NSString *inComPath = [[NSBundle mainBundle] pathForResource:@"Income" ofType:@"plist"];
             NSArray *inComArray = [NSArray arrayWithContentsOfFile:inComPath];
             for (int i = 0 ; i < [inComArray count]; i++) {
                 BillList *billList = (BillList *)[NSEntityDescription insertNewObjectForEntityForName:@"BillList" inManagedObjectContext:context];
                 NSDictionary *dic = [inComArray objectAtIndex:i];
                 billList.bname = [dic objectForKey:@"name"];
                 billList.biconname = [dic objectForKey:@"type"];
                 if ([billList.bname isEqualToString:@"设置"])
                 {
                     billList.bindex = 1000000;
                 }
                 else
                 {
                     billList.bindex = i;
                 }
                 billList.isdelete = NO;
                 billList.btype = @"in";
                 [context save:nil];
             }
             
             
         }];
    }
}
@end
