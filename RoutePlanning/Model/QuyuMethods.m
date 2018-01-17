//
//  QuyuMethods.m
//  SwellPro
//
//  Created by MM on 2018/1/16.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "QuyuMethods.h"
#import "QuyuRoutesCalculateModel.h"
#import "LandPointArrayList.h"

@implementation QuyuMethods
//经纬度转墨卡托
+(CGPoint )lonLat2Mercator:(CGPoint ) lonLat
{
    CGPoint  mercator;
    double x = lonLat.x *20037508.34/180;
    double y = log(tan((90+lonLat.y)*M_PI/360))/(M_PI/180);
    y = y *20037508.34/180;
    mercator.x = x;
    mercator.y = y;
    return mercator ;
}
//墨卡托转经纬度
+(CGPoint )Mercator2lonLat:(CGPoint ) mercator
{
    CGPoint lonLat;
    double x = mercator.x/20037508.34*180;
    double y = mercator.y/20037508.34*180;
    y= 180/M_PI*(2*atan(exp(y*M_PI/180))-M_PI/2);
    lonLat.x = x;
    lonLat.y = y;
    return lonLat;
}
//A(X1,Y1),B(X2,Y2);
//A=Y2-Y1;
//B=X1-X2;
//C=Y1*X2-Y2*X1;
+ (QuyuRoutesCalculateModel *)calculateSignleSlopeOne:(CGPoint)one two:(CGPoint)two
{
    double A = two.y - one.y;
    double B = one.x - two.x;
    double C = one.y * two.x - one.x * two.y;
    QuyuRoutesCalculateModel *model = [[QuyuRoutesCalculateModel alloc] init];
    model.A = A;
    model.B = B;
    model.C = C;
    model.onePoint = one;
    model.twoPoint = two;
    return model;
}
/**
 * 获取平行线移动分割方向
 */
+ (int)getDirectionZero:(QuyuRoutesCalculateModel *)zero One:(QuyuRoutesCalculateModel *)one Two:(QuyuRoutesCalculateModel *)two distance:(double)distance
{
    //初始化
    NSDecimalNumber *zeroA = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",zero.A]];
    NSDecimalNumber *zeroB = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",zero.B]];
    NSDecimalNumber *zeroC = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",zero.C]];
    NSDecimalNumber *oneA = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",one.A]];
    NSDecimalNumber *oneB = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",one.B]];
    NSDecimalNumber *oneC = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",one.C]];
    NSDecimalNumber *twoA = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",two.A]];
    NSDecimalNumber *twoB = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",two.B]];
    NSDecimalNumber *twoC = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",two.C]];
    NSDecimalNumber *distance_D = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",distance]];
    NSDecimalNumber *yi = [NSDecimalNumber decimalNumberWithString:@"1"];
    //开始
    NSDecimalNumber *A = [oneA decimalNumberByMultiplyingBy:oneA];
    NSDecimalNumber *B = [oneB decimalNumberByMultiplyingBy:oneB];
    NSDecimalNumber *add = [A decimalNumberByAdding:B];
    NSDecimalNumber *sqrtAdd = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",sqrt([add doubleValue])]];
    //(1C+(distance*1*(sqrt(add))
    NSDecimalNumber *c = [oneC decimalNumberByAdding:[[distance_D decimalNumberByMultiplyingBy:yi] decimalNumberByMultiplyingBy:sqrtAdd]];
    ;
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:20 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    //[(2C*1B)-(c*2B)]divide[(1A*2B)-(1B*2A)]
    NSDecimalNumber *xPoint = [[[twoC decimalNumberByMultiplyingBy:oneB] decimalNumberBySubtracting:[c decimalNumberByMultiplyingBy:twoB]] decimalNumberByDividingBy:[[oneA decimalNumberByMultiplyingBy:twoB] decimalNumberBySubtracting:[oneB decimalNumberByMultiplyingBy:twoA]] withBehavior:handler];
    //[(1A*2C)-(c*2A)]divide[(1B*2a)-(1A*2B)]
    NSDecimalNumber *yPoint = [[[oneA decimalNumberByMultiplyingBy:twoC] decimalNumberBySubtracting:[c decimalNumberByMultiplyingBy:twoA]] decimalNumberByDividingBy:[[oneB decimalNumberByMultiplyingBy:twoA] decimalNumberBySubtracting:[oneA decimalNumberByMultiplyingBy:twoB]] withBehavior:handler];
    
    CGPoint landPoint = CGPointMake([xPoint doubleValue], [yPoint doubleValue]);
    double a = two.onePoint.x > two.twoPoint.x ? two.onePoint.x : two.twoPoint.x;
    double a1 = two.onePoint.x < two.twoPoint.x ? two.onePoint.x : two.twoPoint.x;
    double b = two.onePoint.y > two.twoPoint.y ? two.onePoint.y : two.twoPoint.y;
    double b1 = two.onePoint.y < two.twoPoint.y ? two.onePoint.y : two.twoPoint.y;
    if (landPoint.x <= a && landPoint.x >= a1 && landPoint.y <= b && landPoint.y >= b1) {
        NSLog(@"%f__Point__%f",landPoint.x,landPoint.y);
        return 1;
    }else{
        //(1C+distance)*1*sqrt((1A*1A)+(1B*1B))
        NSDecimalNumber *sqrtC1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",sqrt([[[oneA decimalNumberByMultiplyingBy:oneA] decimalNumberByAdding:[oneB decimalNumberByMultiplyingBy:oneB]] doubleValue])]];
        NSDecimalNumber *c1 = [[[oneC decimalNumberByAdding:distance_D] decimalNumberByMultiplyingBy:yi] decimalNumberByMultiplyingBy:sqrtC1];
        //0C*1B-(c1*0B)
        NSDecimalNumber *xPoint1 = [[zeroC decimalNumberByMultiplyingBy:oneB] decimalNumberBySubtracting:[c1 decimalNumberByMultiplyingBy:zeroB]];
        //1A*0C-(c1*0A)devide1B*0A-(1A*0B)
        NSDecimalNumber *yPoint1 = [[[oneA decimalNumberByMultiplyingBy:zeroC] decimalNumberBySubtracting:[c1 decimalNumberByAdding:zeroA]] decimalNumberByDividingBy:[[oneB decimalNumberByMultiplyingBy:zeroA] decimalNumberBySubtracting:[oneA decimalNumberByMultiplyingBy:zeroB]] withBehavior:handler];
        CGPoint landPoint1 = CGPointMake([xPoint1 doubleValue], [yPoint1 doubleValue]);
        double a11 = zero.onePoint.x > zero.twoPoint.x ? zero.onePoint.x : zero.twoPoint.x;
        double a12 = zero.onePoint.x < zero.twoPoint.x ? zero.onePoint.x : zero.twoPoint.x;
        double b11 = zero.onePoint.y > zero.twoPoint.y ? zero.onePoint.y : zero.twoPoint.y;
        double b12 = zero.onePoint.y < zero.twoPoint.y ? zero.onePoint.y : zero.twoPoint.y;
        if (landPoint1.x <= a11 && landPoint1.x >= a12 && landPoint1.y <= b11 && landPoint1.y >= b12) {
            return 1;
        }else{
            return 0;
        }
    }
}
/**
 * 获取所有的平行线端点
 */
+ (NSArray *)getAllLinePoints:(int)position array:(NSArray *)xielvssss distance:(double)distance
{
    NSMutableArray *landPointArrayLists = [NSMutableArray array];
    NSMutableArray *yuanArr = [xielvssss mutableCopy];
    int direction;
    QuyuRoutesCalculateModel *model = yuanArr[position];
    double D = model.C;
    double C = model.C;
    int j = 1;
    bool isComputeing = true;
    if (position == yuanArr.count - 1) {
        direction = [QuyuMethods getDirectionZero:yuanArr[position-1] One:yuanArr[position] Two:yuanArr[0] distance:distance];
    } else if (position == 0) {
        direction = [QuyuMethods getDirectionZero:yuanArr[yuanArr.count-1] One:yuanArr[position] Two:yuanArr[position+1] distance:distance];
    } else {
        direction = [QuyuMethods getDirectionZero:yuanArr[position-1] One:yuanArr[position] Two:yuanArr[position+1] distance:distance];
    }
    QuyuRoutesCalculateModel *xielvOld = model;
    
    
    [yuanArr removeObjectAtIndex:position];
    while (isComputeing) {
        
        LandPointArrayList *landPointArray = [[LandPointArrayList alloc] init];
        
        NSDecimalNumber *D_D = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",D]];
        NSDecimalNumber *D_distance = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",distance]];
        NSDecimalNumber *D_J = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d",j]];
        NSDecimalNumber *D_OldA = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",xielvOld.A]];
        NSDecimalNumber *D_OldB = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",xielvOld.B]];
        NSDecimalNumber *D_OldC = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",xielvOld.C]];
        NSDecimalNumber *D_sqrt = [[D_OldA decimalNumberByMultiplyingBy:D_OldA] decimalNumberByAdding:[D_OldB decimalNumberByMultiplyingBy:D_OldB]];
        
        switch (direction) {
            case 0:
                //D-(distance*j)*(sqrt(oldA*oldA+oldB*oldB))
                C =  [[D_D decimalNumberBySubtracting:[[D_distance decimalNumberByMultiplyingBy:D_J] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",sqrt(D_sqrt.doubleValue)]]]] doubleValue];
                break;
            case 1:
                //D+(distance*j)*(sqrt(oldA*oldA+oldB*oldB))
                C =  [[D_D decimalNumberByAdding:[[D_distance decimalNumberByMultiplyingBy:D_J] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",sqrt(D_sqrt.doubleValue)]]]] doubleValue];
                break;
        }
        xielvOld.C = C;
        for (int i = 0; i < yuanArr.count; i++) {
            NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:20 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
            QuyuRoutesCalculateModel *model_i = yuanArr[i];
            NSDecimalNumber *iA = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",model_i.A]];
            NSDecimalNumber *iB = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",model_i.B]];
            NSDecimalNumber *iC = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",model_i.C]];
            //iC*oldB-oldC*iB divide oldA*iB-oldB*iA
            double xPoint = [[[[iC decimalNumberByMultiplyingBy:D_OldB] decimalNumberBySubtracting:[D_OldC decimalNumberByMultiplyingBy:iB]] decimalNumberByDividingBy:[[D_OldA decimalNumberByMultiplyingBy:iB] decimalNumberBySubtracting:[D_OldB decimalNumberByMultiplyingBy:iA]] withBehavior:handler] doubleValue];
            //oldA*iC-oldC*iA divide oldB*iA-oldA*iB
            double yPoint = [[[[D_OldA decimalNumberByMultiplyingBy:iC] decimalNumberBySubtracting:[D_OldC decimalNumberByMultiplyingBy:iA]] decimalNumberByDividingBy:[[D_OldB decimalNumberByMultiplyingBy:iA] decimalNumberBySubtracting:[D_OldA decimalNumberByMultiplyingBy:iB]] withBehavior:handler] doubleValue];
            CGPoint landPoint = CGPointMake(xPoint, yPoint);
            double a = model_i.onePoint.x > model_i.twoPoint.x ? model_i.onePoint.x : model_i.twoPoint.x;
            double a1 = model_i.onePoint.x < model_i.twoPoint.x ? model_i.onePoint.x : model_i.twoPoint.x;
            double b = model_i.onePoint.y > model_i.twoPoint.y ? model_i.onePoint.y : model_i.twoPoint.y;
            double b1 = model_i.onePoint.y < model_i.twoPoint.y ? model_i.onePoint.y : model_i.twoPoint.y;
            
            if (landPoint.x <= a && landPoint.x >= a1 && landPoint.y <= b && landPoint.y >= b1) {
                NSLog(@"%f__Point__%f",landPoint.x,landPoint.y);
                if (landPointArray.landPointStart.x == 0 && landPointArray.landPointStart.y == 0)  {
                    landPointArray.landPointStart = landPoint;
                } else {
                    landPointArray.landPointEnd = landPoint;
                }
                
            }
            
        }
        BOOL start = landPointArray.landPointStart.x == 0 && landPointArray.landPointStart.y == 0;
        BOOL end = landPointArray.landPointEnd.x == 0 && landPointArray.landPointEnd.y == 0;
        if (start || end) {
            isComputeing = false;
        } else {
            [landPointArrayLists addObject:landPointArray];
        }
        j = j + 1;
    }
    return landPointArrayLists;
}
@end
