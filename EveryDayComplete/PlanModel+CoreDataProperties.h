//
//  PlanModel+CoreDataProperties.h
//  EveryDayComplete
//
//  Created by 谢志凯 on 16/9/7.
//  Copyright © 2016年 杨川. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PlanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlanModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSDate *beginTime;
@property (nullable, nonatomic, retain) NSDate *endTime;

@end

NS_ASSUME_NONNULL_END
