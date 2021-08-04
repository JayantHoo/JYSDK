//
//  JYHttpResponse.m
//  JTLive
//
//  Created by jayant hoo on 2019/4/28.
//  Copyright © 2019 jayant hoo. All rights reserved.
//

#import "JYHttpResponse.h"

@interface JYHttpResponse ()

@property (nonatomic,readwrite,assign) BOOL success;

@property (nonatomic,readwrite,assign) JYHTTPResponseCode code;

@property (nonatomic,readwrite,strong) id parsedResult;

@end

@implementation JYHttpResponse

+(instancetype)response:(NSDictionary *) responseObject
{
    return [[JYHttpResponse alloc] initWithResponseObject:responseObject];
}

-(instancetype)initWithResponseObject:(NSDictionary *) responseObject
{
    if (self = [super init]) {
        self.parsedResult = responseObject[JYHTTPServiceResponseDataKey];
        self.code = [responseObject[JYHTTPServiceResponseCodeKey] integerValue];
        self.success = self.code == 200 ? YES:NO;
        self.msg = responseObject[JYHTTPServiceResponseMsgKey];
    }
    return self;
}



@end
