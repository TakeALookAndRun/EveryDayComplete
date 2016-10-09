//
//  NewPlanController.m
//  EveryDayComplete
//
//  Created by 谢志凯 on 16/9/7.
//  Copyright © 2016年 杨川. All rights reserved.
//

#import "NewPlanController.h"
#import <CoreData/CoreData.h>

@interface NewPlanController () <UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic) UITextField *titleText;
@property (strong, nonatomic) UITextView *contentText;
@property (strong, nonatomic) UIDatePicker *beginDate;
@property (strong, nonatomic) UIView *pickView;
@property (strong, nonatomic) UIButton *Btn;
@property (strong, nonatomic) UIView *temp;
@property (strong, nonatomic) UILabel *beginTime;
@property (strong, nonatomic) UILabel *endTime;
@property (assign, nonatomic) Type type;

@end

@implementation NewPlanController

- (instancetype)initWithDataModel:(PlanModel *)model {
    self = [super init];
    if (self) {
        _planModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setToolbarHidden:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    [self.view addSubview:toolBar];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *cancleBtnCustome = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [cancleBtnCustome addTarget:self action:@selector(dismissPlanView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc] initWithCustomView:cancleBtnCustome];
    UIButton *saveBtnCustom = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [saveBtnCustom addTarget:self action:@selector(addNewPlan) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithCustomView:saveBtnCustom];
    [toolBar setItems:@[cancleBtn,space,saveBtn]];
    
    [self layoutUI];
}

- (void)layoutUI {
    _titleText = [[UITextField alloc] initWithFrame:CGRectMake(40, 100, 100, 40)];
    [_titleText setBackgroundColor:[UIColor grayColor]];
    _titleText.delegate = self;
    [self.view addSubview:_titleText];
    _contentText = [[UITextView alloc] initWithFrame:CGRectMake(40, 160, 100, 80)];
    [_contentText setBackgroundColor:[UIColor grayColor]];
    _contentText.delegate = self;
    [self.view addSubview:_contentText];
    
    
    UIButton *selectBegin = [[UIButton alloc] initWithFrame:CGRectMake(40, 300, 80, 40)];
    selectBegin.tag = 1;
    [selectBegin setTitle:@"开始时间" forState:UIControlStateNormal];
    [selectBegin setBackgroundColor:[UIColor grayColor]];
    [selectBegin addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBegin];
    _beginTime = [[UILabel alloc] initWithFrame:CGRectMake(140, 300, 120, 40)];
    [self.view addSubview:_beginTime];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    _beginTime.text = dateString;
    
    
    
    UIButton *selectEnd = [[UIButton alloc] initWithFrame:CGRectMake(40, 370, 80, 40)];
    selectEnd.tag = 2;
    [selectEnd setTitle:@"结束时间" forState:UIControlStateNormal];
    [selectEnd setBackgroundColor:[UIColor grayColor]];
    [selectEnd addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectEnd];
    _endTime = [[UILabel alloc] initWithFrame:CGRectMake(140, 370, 120, 40)];
    [self.view addSubview:_endTime];
    _endTime.text = dateString;
    
    _pickView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200)];
    
    _beginDate = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    [_beginDate setDatePickerMode:UIDatePickerModeDate];
    [_beginDate setMinimumDate:[NSDate date]];
    _beginDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    _Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 170, 40, 30)];
    [_Btn setBackgroundColor:[UIColor blueColor]];
    [_Btn addTarget:self action:@selector(hasChooseTime) forControlEvents:UIControlEventTouchUpInside];
    [_pickView addSubview:_beginDate];
    [_pickView addSubview:_Btn];
    [_pickView setBackgroundColor:[UIColor grayColor]];
    
    _temp = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_temp setBackgroundColor:[UIColor colorWithRed:128.0/150 green:128.0/150 blue:128.0/150 alpha:0.5]];
    
    if (_planModel != nil) {
        _titleText.text = _planModel.title;
        _contentText.text = _planModel.content;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *tempdate = [formatter stringFromDate:_planModel.beginTime];
        _beginTime.text = tempdate;
        tempdate = [formatter stringFromDate:_planModel.endTime];
        _endTime.text = tempdate;
    }
}



- (void)dismissPlanView {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)chooseTime:(UIButton *)btn {
    
    [_titleText resignFirstResponder];
    [_contentText resignFirstResponder];
    
    if (btn.tag == 1) {
        _type = TimeBegin;
        [_beginDate setMinimumDate:[NSDate date]];
    } else {
        _type = TimeEnd;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *date = [formatter dateFromString:_beginTime.text];
        [_beginDate setMinimumDate:date];
    }
    [self.view addSubview:_temp];
    [self.view addSubview:_pickView];
    [UIView animateWithDuration:0.4 animations:^{
        [_pickView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-200, [UIScreen mainScreen].bounds.size.width, 200)];
    }];
}

- (void)hasChooseTime {
    [UIView animateWithDuration:0.4 animations:^{
        [_pickView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200)];
    } completion:^(BOOL finished) {
        NSDate *date = [_beginDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        if (_type == TimeBegin) {
            _beginDate.minimumDate = date;
            _beginTime.text = dateString;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            [formatter setDateFormat:@"YYYY-MM-dd"];
            NSDate *temp = [formatter dateFromString:_endTime.text];
            if ([temp timeIntervalSinceDate:date] < 0.0) {
                _endTime.text = dateString;
            }
        }else {
            _endTime.text = dateString;
        }
        [_pickView removeFromSuperview];
        [_temp removeFromSuperview];
    }];
    
}

- (void)addNewPlan {
    if ([_titleText.text isEqualToString:@""]||[_contentText.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"不能有留空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        _planModel = [NSEntityDescription insertNewObjectForEntityForName:@"PlanModel" inManagedObjectContext:[YCCoreDataManager sharedCoreDataManager].objectContext];
        [_planModel setTitle:_titleText.text];
        [_planModel setContent:_contentText.text];
        
        NSDate *date = [formatter dateFromString:_beginTime.text];
        [_planModel setBeginTime:date];
        date = [formatter dateFromString:_endTime.text];
        [_planModel setEndTime:date];
        
        
        NSError *error = nil;
        
        BOOL isSaved = [[YCCoreDataManager sharedCoreDataManager].objectContext save:&error];
        if (!isSaved) {
            NSLog(@"Faile");
        }else {
            NSLog(@"success");
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_titleText resignFirstResponder];
    [_contentText resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
