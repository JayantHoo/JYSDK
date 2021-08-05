//
//  JYNetworkingManager.h
//  JTLive
//
//  Created by jayant hoo on 2019/4/28.
//  Copyright © 2019 jayant hoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYHttpResponse.h"

FOUNDATION_EXTERN NSString *const JYHTTPServiceErrorDomain ;
/// 连接服务器失败 default
FOUNDATION_EXTERN NSInteger const JYHTTPServiceErrorConnectionFailed ;
/// 解析数据出错
FOUNDATION_EXTERN NSInteger const JYHTTPServiceErrorJSONParsingFailed ;
// The request was invalid (HTTP error 400).
FOUNDATION_EXTERN NSInteger const JYHTTPServiceErrorBadRequest;

FOUNDATION_EXTERN NSInteger const JYHTTPServiceErrorRequestForbidden ;
// The server refused to process the request (HTTP error 422)
FOUNDATION_EXTERN NSInteger const JYHTTPServiceErrorServiceRequestFailed ;
// There was a problem establishing a secure connection, although the server is
// reachable.
FOUNDATION_EXTERN NSInteger const JYHTTPServiceErrorSecureConnectionFailed;

typedef void(^Success)(id data,NSString *msg);
typedef void(^Failure)(NSString *msg, bool netWorkError);

@interface JYNetworkingManager : NSObject

+ (JYNetworkingManager *)sharedManager;

//GET
- (NSURLSessionDataTask *)GetWithURL:(NSString *)url
                              params:(id)params
                             success:(void(^)(JYHttpResponse *response))success
                             failure:(void (^)(NSDictionary *errorInfo))failure;

// GET 便利器
+ (NSURLSessionDataTask*)CV_GetWithURL:(NSString *)url
                                params:(NSDictionary*)params
                               success:(Success)success
                               failure:(Failure)failure;


//POST(默认表单)
- (NSURLSessionDataTask *)PostWithURL:(NSString *)url
                               params:(id)params
                              success:(void (^)(JYHttpResponse *response))success
                              failure:(void (^)(NSDictionary *errorInfo))failure;

//POST   便利器 (默认表单)
+ (NSURLSessionDataTask *)CV_PostWithURL:(NSString *)url
                                  params:(NSDictionary*)params
                                 success:(Success)success
                                 failure:(Failure)failure;

//POST  json 形式
+ (void)CV_PostJsonWithURL:(NSString *)url
                params:(id)params
               success:(Success)success
               failure:(Failure)failure;

//PATCH
- (NSURLSessionDataTask *)PATCHWithURL:(NSString *)url
                                params:(id)params
                               success:(void (^)(JYHttpResponse *))success
                               failure:(void (^)(NSDictionary *errorInfo))failure;
//Delete
- (NSURLSessionDataTask *)DeleteWithURL:(NSString *)url
                                 params:(id)params
                                success:(void (^)(JYHttpResponse *))success
                                failure:(void (^)(NSDictionary *errorInfo))failure;
//上传图片
- (NSURLSessionDataTask *)uploadImageWithURL:(NSString *)url
                                    imageArr:(NSArray *)imageArr
                                   fileNames:(NSArray *)files
                                      params:(id)params
                                     success:(void (^)(JYHttpResponse * response))success
                                     failure:(void (^)(NSError * error))failure;

-(BOOL)isViaWWAN;

@end

