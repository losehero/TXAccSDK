//
//  JBill+CoreDataProperties.h
//  
//
//  Created by jinlong9 on 17/1/19.
//
//

#import "JBill.h"


NS_ASSUME_NONNULL_BEGIN

@interface JBill (CoreDataProperties)

+ (NSFetchRequest<JBill *> *)fetchRequest;

@property (nonatomic) float bmoney;
@property (nullable, nonatomic, copy) NSString *bdate;
@property (nullable, nonatomic, copy) NSString *bdes;
@property (nullable, nonatomic, copy) NSString *btype;
@property (nullable, nonatomic, copy) NSString *bname;
@property (nullable, nonatomic, copy) NSString *biconname;

@end

NS_ASSUME_NONNULL_END
