//
//  MainView.m
//  RoutePlanning
//
//  Created by MM on 2018/1/17.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "MainView.h"
#import "MarkModel.h"
#import "LandPointArrayList.h"

@implementation MainView

- (void)drawRect:(CGRect)rect {
    UIBezierPath *polygon = [UIBezierPath bezierPath];
    [polygon moveToPoint:CGPointMake(20, 80)];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.points];
    [array removeObjectAtIndex:0];
    [array enumerateObjectsUsingBlock:^(MarkModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [polygon addLineToPoint:CGPointMake([obj.lat doubleValue], [obj.log doubleValue])];
    }];
    [[UIColor magentaColor] setFill];
    [polygon fill];
    
    [self.mark enumerateObjectsUsingBlock:^(LandPointArrayList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBezierPath *line = [[UIBezierPath alloc] init];
        //设置线宽
        line.lineWidth = 3;
        [line moveToPoint:obj.landPointStart];
        [line addLineToPoint:obj.landPointEnd];
        //设置绘制线条颜色，这个地方需要注意！UIBezierPath本身类中不包含设置颜色的属性，它是通过UIColor来直接设置。
        [[UIColor orangeColor] setStroke];
        /*
         *线条形状
         *kCGLineCapButt,   //不带端点
         *kCGLineCapRound,  //端点带圆角
         *kCGLineCapSquare  //端点是正方形
         */
        line.lineCapStyle = kCGLineCapRound;
        [line stroke];
        
        UILabel *start = [[UILabel alloc] initWithFrame:CGRectMake(obj.landPointStart.x, obj.landPointStart.y, 30, 30)];
        start.text = @"A";
        start.textColor = [UIColor whiteColor];
        start.backgroundColor = [UIColor colorWithRed:0 green:243/255 blue:167/255 alpha:1];
        start.textAlignment = NSTextAlignmentCenter;
        [self addSubview:start];
        UILabel *end = [[UILabel alloc] initWithFrame:CGRectMake(obj.landPointEnd.x, obj.landPointEnd.y, 30, 30)];
        end.text = @"B";
        end.textColor = [UIColor whiteColor];
        end.backgroundColor = [UIColor colorWithRed:0 green:243/255 blue:167/255 alpha:1];
        end.textAlignment = NSTextAlignmentCenter;
        [self addSubview:end];
    }];
}


@end
