//
//  JMSBaseHttpTool.m
//  jimustock
//
//  Created by jimubox on 15/4/22.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "JMSBaseHttpTool.h"
#import "AFNetworking.h"

static NSString* const kBaseUrl = @"http://ichart.yahoo.com/table.csv";

@implementation JMSBaseHttpTool


+ (AFHTTPRequestOperationManager *)manager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    return manager;
}


/**
 *  完整的url
 */
+(NSString *)intactUrlWithUrl:(NSString *)url
{
   NSString *urlStr = [NSString stringWithFormat:@"%@%@",kBaseUrl,url];
    return [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/**
 * GET请求
 */
+ (void)getWithURL:(NSString *)url Params:(NSDictionary *)params Success:(HttpToolsSuccess)success Failure:(HttpToolsFailure)failure{
    
    [[self manager] GET:[self intactUrlWithUrl:url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success){
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
            failure(error);
        }
    }];
}

/**
 * POST请求
 */
+ (void)postWithURL:(NSString *)url Params:(NSDictionary *)params Success:(HttpToolsSuccess)success Failure:(HttpToolsFailure)failure{
    [[self manager] POST:[self intactUrlWithUrl:url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success){
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
            failure(error);
        }
    }];
}

/**
 * DELETE请求
 */
+ (void)deleteWithURL:(NSString *)url Params:(NSDictionary *)params Success:(HttpToolsSuccess)success Failure:(HttpToolsFailure)failure{
    
    //大多接口成功不返回数据，但部分接口有返回非json格式的数据，这里是为了避免解析时报错。
    AFHTTPRequestOperationManager *manager = [self manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager DELETE:[self intactUrlWithUrl:url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success){
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
            failure(error);
        }
    }];
}

/**
 * PUT请求
 */
+ (void)putWithURL:(NSString *)url Params:(NSDictionary *)params Success:(HttpToolsSuccess)success Failure:(HttpToolsFailure)failure{
    
    [[self manager] PUT:[self intactUrlWithUrl:url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success){
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
            failure(error);
        }
    }];
}

@end
