//
//  JMSBaseHttpTool.h
//  jimustock
//
//  Created by jimubox on 15/4/22.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <Foundation/Foundation.h>


/************************基本的网络请求工具类************************/
@interface JMSBaseHttpTool : NSObject

typedef void (^HttpToolsSuccess)(id json);
typedef void (^HttpToolsFailure)(NSError *error);

/**
 * GET请求
 */
+ (void)getWithURL:(NSString *)url Params:(NSDictionary *)params Success:(HttpToolsSuccess)success Failure:(HttpToolsFailure)failure;

/**
 * POST请求
 */
+ (void)postWithURL:(NSString *)url Params:(NSDictionary *)params Success:(HttpToolsSuccess)success Failure:(HttpToolsFailure)failure;

/**
 * DELETE请求
 */
+ (void)deleteWithURL:(NSString *)url Params:(NSDictionary *)params Success:(HttpToolsSuccess)success Failure:(HttpToolsFailure)failure;

/**
 * PUT请求
 */
+ (void)putWithURL:(NSString *)url Params:(NSDictionary *)params Success:(HttpToolsSuccess)success Failure:(HttpToolsFailure)failure;

@end
