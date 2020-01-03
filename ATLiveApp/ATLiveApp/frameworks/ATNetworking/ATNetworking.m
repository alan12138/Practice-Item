//
//  ATNetworking.m
//  CBNetworking
//
//  Created by 谷士雄 on 16/9/26.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "ATNetworking.h"
#import "AFNetworking.h"

@implementation ATNetworking
+ (ATURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(ATProgress *myProgress))myProgress
                       success:(void (^)(ATURLSessionDataTask *myTask, id myResponseObject))success
                       failure:(void (^)(ATURLSessionDataTask *myTask, ATError *myError))failure
{
    ATURLSessionDataTask *dataTask = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //返回数据的序列化器
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

     dataTask = [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
         myProgress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
    
    return dataTask;

}
+ (ATURLSessionDataTask *)GET:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(ATProgress *myProgress))myProgress
                       success:(void (^)(ATURLSessionDataTask *myTask, id myResponseObject))success
                       failure:(void (^)(ATURLSessionDataTask *myTask, ATError *myError))failure
{
    ATURLSessionDataTask *dataTask = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    dataTask = [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        myProgress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
    
    return dataTask;
    
}

@end

