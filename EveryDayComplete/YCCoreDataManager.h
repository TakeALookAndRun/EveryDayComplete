//
//  YCCoreDataManager.h
//  EveryDayComplete
//
//  Created by 谢志凯 on 16/9/8.
//  Copyright © 2016年 杨川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define ManagerObjectModelFileName @"PlanModel"

@interface YCCoreDataManager : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *objectContext;
@property (strong, nonatomic, readonly) NSManagedObjectModel *objectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *storeCoordinator;

+(instancetype)sharedCoreDataManager;
-(void)saveContext;

@end
