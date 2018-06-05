//
//  JBill+CoreDataProperties.m
//  
//
//  Created by jinlong9 on 17/1/19.
//
//

#import "JBill+CoreDataProperties.h"

@implementation JBill (CoreDataProperties)

+ (NSFetchRequest<JBill *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"JBill"];
}

@dynamic bdate;
@dynamic bdes;
@dynamic bmoney;
@dynamic btype;
@dynamic biconname;
@end
