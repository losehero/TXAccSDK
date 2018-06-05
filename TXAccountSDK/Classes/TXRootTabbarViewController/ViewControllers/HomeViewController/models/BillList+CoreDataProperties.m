//
//  BillList+CoreDataProperties.m
//  
//
//  Created by jinlong9 on 17/1/16.
//
//  This file was automatically generated and should not be edited.
//

#import "BillList+CoreDataProperties.h"

@implementation BillList (CoreDataProperties)

+ (NSFetchRequest<BillList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BillList"];
}

@dynamic bname;
@dynamic bindex;
@dynamic isdelete;
@dynamic biconname;
@dynamic btype;
@end
