//
//  YCCoreDataManager.m
//  EveryDayComplete
//
//  Created by 谢志凯 on 16/9/8.
//  Copyright © 2016年 杨川. All rights reserved.
//

#import "YCCoreDataManager.h"

@implementation YCCoreDataManager

@synthesize objectContext = _objectContext;
@synthesize objectModel = _objectModel;
@synthesize storeCoordinator = _storeCoordinator;

static YCCoreDataManager *coreDataManager;

+(instancetype)sharedCoreDataManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreDataManager = [[self alloc] init];
    });
    return coreDataManager;
}

- (NSManagedObjectModel *)objectModel {
    if (_objectModel != nil) {
        return _objectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:ManagerObjectModelFileName withExtension:@"momd"];
    _objectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _objectModel;
}

- (NSManagedObjectContext *)objectContext {
    if (_objectModel != nil) {
        return _objectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self storeCoordinator];
    if (coordinator != nil) {
        _objectContext = [[NSManagedObjectContext alloc] init];
        [_objectContext setPersistentStoreCoordinator:coordinator];
    }
    return _objectContext;
}

- (NSPersistentStoreCoordinator *)storeCoordinator {
    if (_storeCoordinator != nil) {
        return _storeCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",ManagerObjectModelFileName]];
    NSLog(@"%@",storeURL.path);
    NSError *error = nil;
    _storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self objectModel]];
    if (![_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dic[NSLocalizedFailureReasonErrorKey] = @"There was an error creating or loading the application's saved data.";
        dic[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"your error domain" code:999 userInfo:dic];
        
        NSLog(@"error: %@,%@",error,[error userInfo]);
        abort();
    }
    return _storeCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.objectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"error%@,%@",error,[error userInfo]);
            abort();
        }
    }
}

@end
