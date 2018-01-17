//
//  QuyuMethods.h
//  SwellPro
//
//  Created by MM on 2018/1/16.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
@class QuyuRoutesCalculateModel;
@interface QuyuMethods : NSObject
//经纬度转墨卡托
+(CGPoint )lonLat2Mercator:(CGPoint ) lonLat;
//墨卡托转经纬度
+(CGPoint )Mercator2lonLat:(CGPoint ) mercator;
//A(X1,Y1),B(X2,Y2);
//A=Y2-Y1;
//B=X1-X2;
//C=Y1*X2-Y2*X1;
+ (QuyuRoutesCalculateModel *)calculateSignleSlopeOne:(CGPoint)one two:(CGPoint)two;
/**
 * 获取平行线移动分割方向
 */
+ (int)getDirectionZero:(QuyuRoutesCalculateModel *)zero One:(QuyuRoutesCalculateModel *)one Two:(QuyuRoutesCalculateModel *)two distance:(double)distance;
/**
 * 获取所有的平行线端点
 */
+ (NSArray *)getAllLinePoints:(int)position array:(NSArray *)xielvs distance:(double)distance;
/**
 * @param landPointArrayLists 平行线的两个端点
 * @param lineLong            箭头长度
 * @return 箭头点
 */
- (NSArray *)getArrow:(NSArray *)landPointArrayLists lineLong:(int)lineLong;

@end
