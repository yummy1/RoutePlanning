//
//  QuyuRoutesCalculateModel.h
//  SwellPro
//
//  Created by MM on 2018/1/16.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface QuyuRoutesCalculateModel : NSObject
//A=Y2-Y1;
@property (nonatomic,assign) double A;
//B=X1-X2;
@property (nonatomic,assign) double B;
//C=Y1*X2-Y2*X1;
@property (nonatomic,assign) double C;
//1点
@property (nonatomic,assign) CGPoint onePoint;
//2点
@property (nonatomic,assign) CGPoint twoPoint;
@end
