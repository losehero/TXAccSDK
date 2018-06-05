//
//  JTimer+CoreDataProperties.m
//  
//
//  Created by jinlong9 on 17/2/11.
//
//  This file was automatically generated and should not be edited.
//

#import "JTimer+CoreDataProperties.h"

@implementation JTimer (CoreDataProperties)

+ (NSFetchRequest<JTimer *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"JTimer"];
}

@dynamic timerdate;

@end
