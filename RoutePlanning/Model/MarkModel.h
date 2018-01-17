//
//  MarkModel.h
//  SwellPro
//
//  Created by MM on 2018/1/5.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkModel : NSObject
//标识
@property (nonatomic,assign) NSInteger index;
//经度
@property (nonatomic,strong) NSString *lat;
//纬度
@property (nonatomic,strong) NSString *log;
//共选中几个航点
@property (nonatomic,assign) NSInteger count;
@end
