//
//  JYNetworkingManager.m
//  JTLive
//
//  Created by jayant hoo on 2019/4/28.
//  Copyright © 2019 jayant hoo. All rights reserved.
//

#import "JYNetworkingManager.h"
#import <AFNetworking.h>
#import <Reachability.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

NSString *const JYHTTPServiceErrorDomain = @"JYHTTPServiceErrorDomain";

/// 连接服务器失败 default
NSInteger const JYHTTPServiceErrorConnectionFailed = 668;
NSInteger const JYHTTPServiceErrorJSONParsingFailed = 669;
NSInteger const JYHTTPServiceErrorBadRequest = 670;
NSInteger const JYHTTPServiceErrorRequestForbidden = 671;
/// 服务器请求失败
NSInteger const JYHTTPServiceErrorServiceRequestFailed = 672;
///
NSInteger const JYHTTPServiceErrorSecureConnectionFailed = 673;

/// URL key
NSString * const JYHTTPServiceErrorRequestURLKey = @"JYHTTPServiceErrorRequestURLKey";
/// HttpStatusCode key
NSString * const JYHTTPServiceErrorHTTPStatusCodeKey = @"JYHTTPServiceErrorHTTPStatusCodeKey";
/// error desc key
NSString * const JYHTTPServiceErrorDescriptionKey = @"JYHTTPServiceErrorDescriptionKey";

/// error desc key
NSString * const JYHTTPServiceErrorNetworkKey = @"JYHTTPServiceErrorNetworkKey";

@interface JYNetworkingManager ()

@property (nonatomic,strong) AFHTTPSessionManager *manager;


@end

@implementation JYNetworkingManager

+ (JYNetworkingManager *)sharedManager{
    
    static JYNetworkingManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[JYNetworkingManager alloc] init];
    });
    return _manager;
}

-(AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        //        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        //        securityPolicy.validatesDomainName = NO;
        //        securityPolicy.allowInvalidCertificates = YES;
        //        _manager.securityPolicy = securityPolicy;
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        // 设置超时时间
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 10.f;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        _manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                              @"text/json",
                                                              @"text/javascript",
                                                              @"text/html",
                                                              @"text/xml",
                                                              @"text/plain",
                                                              @"text/html;charset=UTF-8",
                                                              @"image/jpeg",
                                                              @"image/png",
                                                              @"application/octet-stream",
                                                              @"multipart/form-data",
                                                              @"application/json;charset=UTF-8",
                                                              nil];
        
        [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
    }
    //设置header
    [_manager.requestSerializer setValue:[CPUserManager share].token forHTTPHeaderField:@"Authorization"];
    [_manager.requestSerializer setValue:@"test" forHTTPHeaderField:@"versionValidate"];
    
    //设置cookies
    //     _manager.requestSerializer.HTTPShouldHandleCookies = YES;
    //        if ([CookiesTool getCookies]) {
    //            [_manager.requestSerializer setValue:[CookiesTool getCookies] forHTTPHeaderField:@"Cookie"];
    //        }
    return _manager;
}



- (NSURLSessionDataTask *)GetWithURL:(NSString *)url
                              params:(id)params
                             success:(void(^)(JYHttpResponse *response))success
                             failure:(void(^)(NSDictionary *errorInfo))failure {
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    return [self.manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CPLog(@"---token:%@\n---url:%@\n---params:%@\n---response:%@",[CPUserManager share].token,url,params,responseObject);
        
        JYHttpResponse *response = [JYHttpResponse response:responseObject];
        
        if (response.code == 401) {
            [CPKEYWINDOW showErrorHUDWithStatus:@"登录失效，重新登录" dismissWithDelay:2 completion:^{
                [[CPUserManager share] logout]; // 删除账号信息
                [CPLoginTool login];            // 重新登录
            }];
            return ;
        }
        
        if (success) {
            success(response);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSDictionary *info = [self parsedErrorWithTask:task error:error];
        if (failure) {
            failure(info);
        }
    }];
}

- (NSURLSessionDataTask *)PostWithURL:(NSString *)url
                               params:(id)params
                               isform:(BOOL)isform
                              success:(void (^)(JYHttpResponse *response))success
                              failure:(void (^)(NSDictionary *errorInfo))failure {
    
    if (isform == YES) {
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }else {
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
    }
    
    return [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CPLog(@"----token:%@\n---url:%@\n---params:%@\n---response:%@",[CPUserManager share].token, url,params,responseObject);
        
        JYHttpResponse *response = [JYHttpResponse response:responseObject];
        
        if (response.code == 401) {
            [CPKEYWINDOW showErrorHUDWithStatus:@"登录失效，重新登录" dismissWithDelay:2 completion:^{
                [[CPUserManager share] logout]; // 删除账号信息
                [CPLoginTool login];            // 重新登录
            }];
            return ;
        }
        
        if (success) {
            success(response);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSDictionary *info = [self parsedErrorWithTask:task error:error];
        if (failure) {
            failure(info);
        }
    }];
}

- (NSURLSessionDataTask *)PostWithURL:(NSString *)url
                               params:(id)params
                              success:(void (^)(JYHttpResponse *response))success
                              failure:(void (^)(NSDictionary *errorInfo))failure {
    return   [[JYNetworkingManager sharedManager] PostWithURL:url params:params isform:YES success:success failure:failure];
}


+ (NSURLSessionDataTask *)CV_GetWithURL:(NSString *)url
                                 params:(NSDictionary*)params
                                success:(Success)success
                                failure:(Failure)failure
{
    
    return [[JYNetworkingManager sharedManager] GetWithURL:url params:params success:^(JYHttpResponse *response) {
        
        if (response.success) {
            if (success) {
                success(response.parsedResult,response.msg);
            }
        }else{
            if (failure) {
                failure(response.msg,NO);
            }
        }
        
    } failure:^(NSDictionary *errorInfo) {
        
        BOOL isnetworkError = [errorInfo[JYHTTPServiceErrorNetworkKey] boolValue];
        NSString *msg =  errorInfo[JYHTTPServiceErrorDescriptionKey];
        if (failure) {
            failure(msg,isnetworkError);
        }
    }];
}



+ (NSURLSessionDataTask *)CV_PostWithURL:(NSString *)url
                                  params:(NSDictionary*)params
                                 success:(Success)success
                                 failure:(Failure)failure
{
     return [[JYNetworkingManager sharedManager] PostWithURL:url params:params isform:YES success:^(JYHttpResponse *response) {
        
        if (response.success) {
            if (success) {
                success(response.parsedResult,response.msg);
            }
        }else{
            if (failure) {
                failure(response.msg, NO);
            }
        }
        
    } failure:^(NSDictionary *errorInfo) {
        
        BOOL isnetworkError = [errorInfo[JYHTTPServiceErrorNetworkKey] boolValue];
        NSString *msg =  errorInfo[JYHTTPServiceErrorDescriptionKey];
        if (failure) {
            failure(msg,isnetworkError);
        }
    }];
}


//POST  json 形式
+ (void)CV_PostJsonWithURL:(NSString *)url
                    params:(id)params
                   success:(Success)success
                   failure:(Failure)failure {
    
    [[JYNetworkingManager sharedManager] PostWithURL:url params:params isform:NO success:^(JYHttpResponse *response) {
        
        if (response.success) {
            if (success) {
                success(response.parsedResult,response.msg);
            }
        }else{
            
            if (failure) {
                failure(response.msg, NO);
            }
        }
        
    } failure:^(NSDictionary *errorInfo) {
        
        BOOL isnetworkError = [errorInfo[JYHTTPServiceErrorNetworkKey] boolValue];
        NSString *msg =  errorInfo[JYHTTPServiceErrorDescriptionKey];
        if (failure) {
            failure(msg,isnetworkError);
        }
    }];
    
}



- (NSURLSessionDataTask *)PATCHWithURL:(NSString *)url
                                params:(id)params
                               success:(void (^)(JYHttpResponse *))success
                               failure:(void (^)(NSDictionary *errorInfo))failure {
    return [self.manager PATCH:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CPLog(@"---url:%@\n---params:%@\n---response:%@",url,params,responseObject);
        
        JYHttpResponse *response = [JYHttpResponse response:responseObject];
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSDictionary *info = [self parsedErrorWithTask:task error:error];
        if (failure) {
            failure(info);
        }
    }];
}

- (NSURLSessionDataTask *)DeleteWithURL:(NSString *)url
                                 params:(id)params
                                success:(void (^)(JYHttpResponse *))success
                                failure:(void (^)(NSDictionary *errorInfo))failure {
    return [self.manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CPLog(@"---url:%@\n---params:%@\n---response:%@",url,params,responseObject);
        
        JYHttpResponse *response = [JYHttpResponse response:responseObject];
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSDictionary *info = [self parsedErrorWithTask:task error:error];
        if (failure) {
            failure(info);
        }
    }];
}

- (NSURLSessionDataTask *)uploadImageWithURL:(NSString *)url
                                    imageArr:(NSArray *)imageArr
                                   fileNames:(NSArray *)files
                                      params:(id)params
                                     success:(void (^)(JYHttpResponse * response))success
                                     failure:(void (^)(NSError * error))failure {
    return [self PostWithURL:url params:params constructingBodyWithBlock:^(id formData) {
        int num = 0;
        for (UIImage *image in imageArr) {
            NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png", str,num];
            // 特别注意，这里的图片的名字不要写错，必须是你接口的图片的参数名字如我这里默认是file
            NSString *name = @"file";//默认file
            if (files.count == 1) {
                name = files.firstObject;
            }else if(files.count>1) {
                name = [files objectAtIndex:num];
            }
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpg/png/jpeg"];
            num++;
        }
    } success:^(JYHttpResponse * response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (NSURLSessionDataTask *)PostWithURL:(NSString *)url
                               params:(id)params
            constructingBodyWithBlock:(void (^)(id))block
                              success:(void (^)(JYHttpResponse *))success
                              failure:(void (^)(NSError *error))failure {
    
    
    return [self.manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (formData) {
            block(formData);
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CPLog(@"---url:%@\n---params:%@\n---response:%@",url,params,responseObject);
        
        JYHttpResponse *response = [JYHttpResponse response:responseObject];
        
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self parsedErrorWithTask:task error:error];
        if (failure) {
            failure(error);
        }
    }];
}



#pragma mark - private
/// 请求错误解析处理
- (NSDictionary *)parsedErrorWithTask:(NSURLSessionDataTask *)task
                                error:(NSError *)error{
    CPLog(@"networkError:%@",error);
    /// 不一定有值，则HttpCode = 0;
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)task.response;
    NSInteger HTTPCode = httpResponse.statusCode;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    /// default errorCode is JYHTTPServiceErrorConnectionFailed，意味着连接不上服务器
    NSInteger errorCode = JYHTTPServiceErrorConnectionFailed;
    NSString *errorDesc = [NSString stringWithFormat:@"呜呜，服务器崩溃了哟(%zd)~",errorCode];
    
    /// 其实这里需要处理后台数据错误，一般包在 responseObject
    /// HttpCode错误码解析 https://www.guhei.net/post/jb1153
    /// 1xx : 请求消息 [100  102]
    /// 2xx : 请求成功 [200  206]
    /// 3xx : 请求重定向[300  307]
    /// 4xx : 请求错误  [400  417] 、[422 426] 、449、451
    /// 5xx 、600: 服务器错误 [500 510] 、600
    
    bool isNetWorkError = NO;
    
    switch (HTTPCode) {
        case 400:
            errorCode = JYHTTPServiceErrorBadRequest;           /// 请求失败
            break;
        case 401:  //账号下线
            
            [CPKEYWINDOW showErrorHUDWithStatus:@"登录失效，重新登录" dismissWithDelay:1.5 completion:^{
                [[CPUserManager share] logout]; // 删除账号信息
                [CPLoginTool login];            // 重新登录
            }];
            
            break;
        case 403:
            errorCode = JYHTTPServiceErrorRequestForbidden;     /// 服务器拒绝请求
            break;
        case 422:
            errorCode = JYHTTPServiceErrorServiceRequestFailed; /// 请求出错
            break;
        default:{
            /// 从error中解析
            if ([error.domain isEqual:NSURLErrorDomain]) {
                errorDesc = [NSString stringWithFormat:@"呜呜，服务器崩溃了哟(%zd)~",error.code];                   /// 调试模式
                
                switch (error.code) {
                    case NSURLErrorSecureConnectionFailed:
                    case NSURLErrorServerCertificateHasBadDate:
                    case NSURLErrorServerCertificateHasUnknownRoot:
                    case NSURLErrorServerCertificateUntrusted:
                    case NSURLErrorServerCertificateNotYetValid:
                    case NSURLErrorClientCertificateRejected:
                    case NSURLErrorClientCertificateRequired:{
                        errorCode = JYHTTPServiceErrorSecureConnectionFailed; /// 建立安全连接出错了
                        errorDesc = [NSString stringWithFormat:@"呜呜，服务器建立安全连接出错了(%zd)~",JYHTTPServiceErrorSecureConnectionFailed];
                        break;
                    }
                    case NSURLErrorTimedOut:
                        errorDesc = @"请求超时，请稍后再试(-1001)~"; /// 调试模式
                        isNetWorkError = YES;
                        
                        break;
                    case NSURLErrorNotConnectedToInternet:
                        errorDesc = @"呀！网络正在开小差(-1009)~";  /// 调试模式
                        isNetWorkError = YES;
                        break;
                    default:{
                        if (!self.manager.reachabilityManager.isReachable){
                            /// 网络不给力，请检查网络
                            errorDesc = @"呜呜，网络正在开小差~";
                            isNetWorkError = YES;
                        }
                        break;
                    }
                }
            }else if (!self.manager.reachabilityManager.isReachable){
                /// 网络不给力，请检查网络
                //                errorDesc = @"呜呜，网络正在开小差~";
                //                isNetWorkError = YES;
            }
            break;
        }
    }
    
    userInfo[JYHTTPServiceErrorHTTPStatusCodeKey] = @(HTTPCode);
    userInfo[JYHTTPServiceErrorNetworkKey] = @(isNetWorkError);
    userInfo[JYHTTPServiceErrorDescriptionKey] = errorDesc;
    if (task.currentRequest.URL != nil) userInfo[JYHTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
    if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
    // 展示网络错误和服务器错误弹窗
    //    for (UIView *view in CPKEYWINDOW.subviews) {
    //
    //        if ([view isKindOfClass:MBProgressHUD.class]) {
    //            [MBProgressHUD hideHUDForView:view.superview animated:NO];
    //        }
    //    }
    
    return userInfo;
}

-(BOOL)isViaWWAN {
    
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    switch (internetStatus) {
        case ReachableViaWiFi:
            return NO;
            break;
            
        case ReachableViaWWAN:
            return YES;
            break;
            
        case NotReachable:
            return YES;
            
        default:
            break;
    }
    return NO;
}

@end
