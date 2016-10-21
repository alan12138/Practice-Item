//
//  ATNetworking.h
//  CBNetworking
//
//  Created by 谷士雄 on 16/9/26.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSURLSessionDataTask ATURLSessionDataTask;
typedef NSProgress ATProgress;
typedef NSError ATError;

@interface ATNetworking : NSObject
#pragma mark - POST
+ (ATURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(ATProgress *myProgress))myProgress
                       success:(void (^)(ATURLSessionDataTask *myTask, id myResponseObject))success
                       failure:(void (^)(ATURLSessionDataTask *myTask, ATError *myError))failure;
#pragma mark - GET
+ (ATURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(ATProgress *myProgress))myProgress
                      success:(void (^)(ATURLSessionDataTask *myTask, id myResponseObject))success
                      failure:(void (^)(ATURLSessionDataTask *myTask, ATError *myError))failure;
@end
