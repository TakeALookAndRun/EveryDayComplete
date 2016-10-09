//
//  NewPlanController.h
//  EveryDayComplete
//
//  Created by 谢志凯 on 16/9/7.
//  Copyright © 2016年 杨川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCCoreDataManager.h"
#import "PlanModel.h"

@interface NewPlanController : UIViewController

typedef enum : NSUInteger {
    TimeBegin,
    TimeEnd
} Type;

typedef enum : NSUInteger {
    NewComeIn,
    OldComeIn
} ComeIn;

@property (strong, nonatomic) PlanModel *planModel;
@property (assign, nonatomic) ComeIn comeIn;

- (instancetype)initWithDataModel:(PlanModel *)model;

@end
