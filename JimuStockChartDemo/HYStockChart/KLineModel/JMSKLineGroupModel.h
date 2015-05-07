//
//  JMSKLineGroupModel.h
//  jimustock
//
//  Created by jimubox on 15/5/7.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSKLineGroupModel : NSObject

@property(nonatomic,copy) NSString *StartDate;

@property(nonatomic,copy) NSString *EndDate;

/**
 *  K线的数组
 */
@property(nonatomic,strong) NSArray *GlobalQuotes;

@end
