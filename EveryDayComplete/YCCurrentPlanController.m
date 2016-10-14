//
//  YCCurrentPlanController.m
//  EveryDayComplete
//
//  Created by 谢志凯 on 16/9/7.
//  Copyright © 2016年 杨川. All rights reserved.
//

#import "YCCurrentPlanController.h"
#import "NewPlanController.h"
#import <CoreData/CoreData.h>

@interface YCCurrentPlanController () <UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
}

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) YCCoreDataManager *manager;
@property (strong, nonatomic) NSMutableArray *contentArray;

@end

@implementation YCCurrentPlanController

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
        _manager = [YCCoreDataManager sharedCoreDataManager];
        _contentArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
    //[self.view addGestureRecognizer:ges];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIButton *addButtonCustom = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addButtonCustom addTarget:self action:@selector(presentAddView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:addButtonCustom];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSFetchRequest *requst = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PlanModel" inManagedObjectContext:_manager.objectContext];
    [requst setEntity:entity];
    
    NSError *error = nil;
    
    NSArray *result = [_manager.objectContext executeFetchRequest:requst error:&error];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:result];
    [self.contentArray removeAllObjects];
    
    for (NSManagedObject *temp in _dataArray) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *dateString = [formatter stringFromDate:(NSDate *)[temp valueForKey:@"beginTime"]];
        NSDate *beginDate = [formatter dateFromString:dateString];
        dateString = [formatter stringFromDate:(NSDate *)[temp valueForKey:@"endTime"]];
        NSDate *endTime = [formatter dateFromString:dateString];
        
        NSString *simpleString = [formatter stringFromDate:[NSDate date]];
        NSDate *simple = [formatter dateFromString:simpleString];
        
        if (self.type == Current && [beginDate timeIntervalSinceDate:simple] <= 0.0 && [endTime timeIntervalSinceDate:simple] >= 0.0) {
            [self.contentArray addObject:temp];
        } else if (self.type == Will && [beginDate timeIntervalSinceDate:simple] > 0.0) {
            [self.contentArray addObject:temp];
        } else if (self.type == Done && [endTime timeIntervalSinceDate:simple] < 0.0){
            [self.contentArray addObject:temp];
        }
    }
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cellKey";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = [[_contentArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    return cell;
}

- (void)presentAddView {
    [self presentViewController:[[NewPlanController alloc] init] animated:YES completion:^{
        
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PlanModel *plan = [_contentArray objectAtIndex:indexPath.row];
        [_manager.objectContext deleteObject:plan];
        NSError *error = nil;
        BOOL isSaved = [_manager.objectContext save:&error];
        if (!isSaved) {
            NSLog(@"error");
        }else {
            NSLog(@"success");
        }
        [self.contentArray removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setHidesBottomBarWhenPushed:YES];
    NewPlanController *planController = [[NewPlanController alloc] initWithDataModel:(PlanModel *)[_contentArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:planController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
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
