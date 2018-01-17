//
//  ViewController.m
//  RoutePlanning
//
//  Created by MM on 2018/1/17.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "ViewController.h"
#import "MarkModel.h"
#import "MJExtension.h"
#import "MainView.h"
#import "QuyuRoutesCalculateModel.h"
#import "QuyuMethods.h"

@interface ViewController ()
@property (nonatomic,strong) NSArray *points;
@property (nonatomic,strong) MainView *mainView;
@end

@implementation ViewController
- (NSArray *)points
{
    if (!_points) {
        NSArray *array = @[@{@"index":@"0",@"lat":@"20",@"log":@"80"},@{@"index":@"1",@"lat":@"200",@"log":@"80"},@{@"index":@"2",@"lat":@"350",@"log":@"260"},@{@"index":@"3",@"lat":@"70",@"log":@"560"}];
        _points = [MarkModel mj_objectArrayWithKeyValuesArray:array];
    }
    return _points;
}
- (MainView *)mainView
{
    if (!_mainView) {
        _mainView = [[MainView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        _mainView.points = [self.points mutableCopy];
        _mainView.backgroundColor = [UIColor whiteColor];
    }
    return _mainView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mainView];
    
    [self hangxian];
}

- (void)hangxian
{
    NSMutableArray *googleWaiArr = [[MarkModel mj_keyValuesArrayWithObjectArray:self.points] mutableCopy];
    
    NSMutableArray *fenzuArr = [NSMutableArray array];
    [googleWaiArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != googleWaiArr.count-1) {
            [fenzuArr addObject:@[obj,googleWaiArr[idx+1]]];
        }else{
            [fenzuArr addObject:@[obj,googleWaiArr[0]]];
        }
    }];
    //2、所有边转模型
    NSMutableArray *modelArr = [NSMutableArray array];
    [fenzuArr enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        double ax = [obj[0][@"lat"] floatValue];
        double ay = [obj[0][@"log"] floatValue];
        double bx = [obj[1][@"lat"] floatValue];
        double by = [obj[1][@"log"] floatValue];
        QuyuRoutesCalculateModel *bianModel = [QuyuMethods calculateSignleSlopeOne:CGPointMake(ax, ay) two:CGPointMake(bx, by)];
        [modelArr addObject:bianModel];
    }];
    //3、获取平行线与边相交的所有点
    NSArray *jiaoDianArr = [QuyuMethods getAllLinePoints:0 array:modelArr distance:40];
    NSLog(@"%@",jiaoDianArr);
    self.mainView.mark = jiaoDianArr;
}

@end
