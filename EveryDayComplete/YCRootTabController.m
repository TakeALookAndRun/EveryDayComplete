//
//  YCRootTabController.m
//  EveryDayComplete
//
//  Created by 谢志凯 on 16/9/7.
//  Copyright © 2016年 杨川. All rights reserved.
//

#import "YCRootTabController.h"
#import "YCCurrentPlanController.h"

@interface YCRootTabController ()

@end

@implementation YCRootTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *backview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [backview setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:backview];
    [self.view sendSubviewToBack:backview];
    UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
    [self.view addGestureRecognizer:ges];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test:(UIPanGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateChanged) {
        CGPoint move = [ges translationInView:self.view];
        [self.view setFrame:CGRectMake(move.x, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
