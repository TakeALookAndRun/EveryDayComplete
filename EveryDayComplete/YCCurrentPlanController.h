//
//  YCCurrentPlanController.h
//  EveryDayComplete
//
//  Created by 谢志凯 on 16/9/7.
//  Copyright © 2016年 杨川. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCCurrentPlanController : UIViewController

typedef enum : NSUInteger {
    Current,
    Will,
    Done
} TypeOfPage;

@property (assign, nonatomic) TypeOfPage type;

@end
