//
//  JYTPHelperConfig.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYTPHelperConfig.h"


////////////////////////////////////////  JYLoginResponse  /////////////////////////////////////////////
@implementation JYLoginResponse

+ (instancetype)loginResponseWithSucess:(BOOL)success userInfo:(JYTPUserInfo *)userInfo uid:(NSString *)uid errorString:(NSString *)errorString{
    
    JYLoginResponse *respose = [[JYLoginResponse alloc] init];
    respose->_success = success;
    respose->_userInfo = userInfo;
    respose->_uid = uid;
    respose->_errorString = errorString;
    return respose;
}

@end

////////////////////////////////////////  JYPayResponse  /////////////////////////////////////////////
@implementation JYPayResponse

+ (instancetype)payResponseWithSucess:(BOOL)success errorString:(NSString *)errorString{
    
    JYPayResponse *respose = [[JYPayResponse alloc] init];
    respose->_success = success;
    respose->_errorString = errorString;
    return respose;
}

@end

@implementation JYShareResponse

+ (instancetype)shareResponseWithSucess:(BOOL)success errorStr:(NSString *)errorStr {
    JYShareResponse *response = [[JYShareResponse alloc] init];
    response->_success = success;
    response->_errorStr = errorStr;
    return response;
}

@end


@implementation JYTPHelperConfig

@end
