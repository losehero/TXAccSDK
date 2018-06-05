//
//  BillList+CoreDataProperties.h
//  
//
//  Created by jinlong9 on 17/1/16.
//
//  This file was automatically generated and should not be edited.
//

#import "BillList.h"


NS_ASSUME_NONNULL_BEGIN

@interface BillList (CoreDataProperties)

+ (NSFetchRequest<BillList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bname;
@property (nonatomic) int16_t bindex;
@property (nonatomic) BOOL isdelete;
@property (nullable, nonatomic, copy) NSString *biconname;
@property (nullable, nonatomic, copy) NSString *btype;
@end

NS_ASSUME_NONNULL_END
