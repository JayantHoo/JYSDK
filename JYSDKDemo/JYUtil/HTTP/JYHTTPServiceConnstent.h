//
//  JYHTTPServiceConnstent.h
//  JTLive
//
//  Created by jayant hoo on 2019/4/28.
//  Copyright © 2019 jayant hoo. All rights reserved.
//

#ifndef JYHTTPServiceConnstent_h
#define JYHTTPServiceConnstent_h

/// 服务器返回的三个固定字段 根据后台返回定制
/// 状态码key
#define JYHTTPServiceResponseCodeKey        @"code"
/// 消息key
#define JYHTTPServiceResponseMsgKey          @"msg"
///是否请求成功key
#define JYHTTPServiceResponseSuccessKey      @"success"
/// 数据data
#define JYHTTPServiceResponseDataKey         @"data"

#import "JYNetworkingManager.h"

#endif /* JYHTTPServiceConnstent_h */
