//
//  JMSKLineGroupModel.m
//  jimustock
//
//  Created by jimubox on 15/5/7.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "JMSKLineGroupModel.h"
#import "JMSKLineModel.h"
#import "MJExtension.h"

@implementation JMSKLineGroupModel

+(NSDictionary *)objectClassInArray
{
    return @{@"GlobalQuotes":@"JMSKLineModel"};
}

@end
