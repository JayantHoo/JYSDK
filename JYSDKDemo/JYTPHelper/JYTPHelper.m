//
//  JYTPHelper.m
//  JYSDKDemo
//
//  Created by isenu on 2018/3/29.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYTPHelper.h"
#import "JYTPUserInfo.h"
#import <AlipaySDK/AlipaySDK.h>

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

@interface JYTPHelper ()<TencentSessionDelegate,QQApiInterfaceDelegate,WXApiDelegate,WeiboSDKDelegate>
{
    TencentOAuth *_oauth;
}

/*
 *  第三方登录的回调
 */
@property (nonatomic, copy) void(^loginFinished)(JYLoginResponse *response);

/*
 *  第三方支付的回调
 */
@property (nonatomic, copy) void(^payFinished)(JYPayResponse *response);
/*
 *  第三方分享的回调
 */
@property (nonatomic, copy) void(^shareFinished)(JYShareResponse *response);

@end

@implementation JYTPHelper

+(instancetype) defaultHelper
{
    static JYTPHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[JYTPHelper alloc] init];
    });
    return helper;
}

+ (void)registerQQApp:(NSString *)qqAppId secret:(NSString *)qqSecret
{
    // 2.注册QQ
#pragma clang diagnostic push
#pragma clang diagnostic ignored   "-Wunused-variable"
    id xx = [[TencentOAuth alloc] initWithAppId:qqAppId andDelegate:nil];
#pragma clang diagnostic pop
    
    [[NSUserDefaults standardUserDefaults] setObject:qqAppId forKey:@"qqAppId"];
    [[NSUserDefaults standardUserDefaults] setObject:qqSecret forKey:@"qqSecret"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)registerWeChatAppid:(NSString *)wxAppId secret:(NSString *)wxSecret {
    
    // 1.注册微信
    [WXApi registerApp:wxAppId];
    [[NSUserDefaults standardUserDefaults] setObject:wxAppId forKey:@"wxAppid"];
    [[NSUserDefaults standardUserDefaults] setObject:wxSecret forKey:@"wxSecret"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)registerWeiboApp:(NSString *)wbAppKey secret:(NSString *)wbSecret redirectURI:(NSString *)redirectURI {
    // 3.注册Weibo
    [WeiboSDK enableDebugMode:NO]; //开启调试模式
    [WeiboSDK registerApp:wbAppKey];
    [[NSUserDefaults standardUserDefaults] setObject:wbAppKey forKey:@"wbAppKey"];
    [[NSUserDefaults standardUserDefaults] setObject:wbSecret forKey:@"wbSecret"];
    [[NSUserDefaults standardUserDefaults] setObject:redirectURI forKey:@"redirectURI"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)registerAlipayScheme:(NSString *) appScheme
{
    [[NSUserDefaults standardUserDefaults] setObject:appScheme forKey:@"alipayScheme"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    
    return [[self defaultHelper] handleOpenURL:url];
}

-(BOOL)handleOpenURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付结果 = %@",resultDic);
            //            9000    订单支付成功
            //            8000    正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
            //            4000    订单支付失败
            //            5000    重复请求
            //            6001    用户中途取消
            //            6002    网络连接出错
            //            6004    支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
            //            其它    其它支付错误
            if (_payFinished) {
                BOOL result = NO;
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                    result = YES;
                }
                JYPayResponse *response = [JYPayResponse payResponseWithSucess:result errorString:resultDic[@"resultStatus"]];
                _payFinished(response);
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付结果 = %@",resultDic);
            if (_payFinished) {
                JYPayResponse *response = [JYPayResponse payResponseWithSucess:true errorString:nil];
                _payFinished(response);
            }
        }];
    }
    return [TencentOAuth HandleOpenURL:url] || [QQApiInterface handleOpenURL:url delegate:self] || [WXApi handleOpenURL:url delegate:self] || [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark - 微信回调
- (void)onResp:(id)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) { //微信支付 成功baseResp里面的errcode是0，支付失败是-2；
        
        BaseResp *reqs = (BaseResp *)resp;
        if (reqs.errCode == 0) { //支付成功
            
            if (_payFinished) {
                JYPayResponse *response = [JYPayResponse payResponseWithSucess:true errorString:nil];
                _payFinished(response);
            }
            
        }else { //支付失败 (errStr也是没有值的)
            
            if (_payFinished) {
                JYPayResponse *response = [JYPayResponse payResponseWithSucess:false errorString:reqs.errStr];
                _payFinished(response);
            }
        }
    }
    if ([resp isKindOfClass:[SendAuthResp class]]){ //微信登录
        
        SendAuthResp *authResp = (SendAuthResp *)resp;
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSString * wxAppid = [[NSUserDefaults standardUserDefaults] objectForKey:@"wxAppid"];
        NSString * wxSecret = [[NSUserDefaults standardUserDefaults] objectForKey:@"wxSecret"];
        
        NSString *urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", wxAppid, wxSecret, authResp.code];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (!error) {//判断是不是有错误，这里一般是网络原因
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSString *access_token = [dict objectForKey:@"access_token"];
                NSString *openid       = [dict objectForKey:@"openid"];
                //unionid
                NSString *unionid       = [dict objectForKey:@"unionid"];
                NSString *infoUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
                
                NSURL *infoUrl = [NSURL URLWithString:infoUrlStr];
                NSURLSessionTask *infoTask = [session dataTaskWithURL:infoUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    if (!error) { //判断是不是有错误，这里一般是网络原因
                        
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        
                        if (!dict[@"errcode"]) {//登录成功
                            
                            JYTPUserInfo *userInfo = [JYTPUserInfo userInfo];
                            userInfo.userName = dict[@"nickname"];
                            userInfo.imageUrl = dict[@"headimgurl"];
                            userInfo.province = dict[@"province"];
                            userInfo.city     = dict[@"city"];
                            userInfo.sex      = [dict[@"sex"] integerValue] - 1; //1代表男性，2代表女性
                            
                            if (_loginFinished) {
                                
                                JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:true userInfo:userInfo uid:unionid errorString:nil];
                                _loginFinished(response);
                            }
                        } else { // 取消登录
                            if (_loginFinished) {
                                JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:nil];
                                _loginFinished(response);
                            }
                            
                        }
                        
                    } else {
                        
                        if (_loginFinished) {
                            JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:nil];
                            _loginFinished(response);
                            
                        }
                    }
                    
                }];
                
                [infoTask resume];
                
            } else{
                
                if (_loginFinished) {
                    JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:nil];
                    _loginFinished(response);
                }
            }
            
        }];
        
        [task resume];
        
        
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) { // 微信分享
        SendMessageToWXResp *wxresp = (SendMessageToWXResp *)resp;
        //调用外部的block
        if (_shareFinished) {
            JYShareResponse *response = [JYShareResponse shareResponseWithSucess:(wxresp.errCode == 0) errorStr:wxresp.errStr];
            _shareFinished(response);
        }
        
    } else if ([resp isKindOfClass:[QQBaseResp class]]) { // QQ分享
        
        QQBaseResp *qqresp = (QQBaseResp *)resp;
        if (_shareFinished) {
            JYShareResponse *response = [JYShareResponse shareResponseWithSucess:([qqresp.result intValue] == 0) errorStr:qqresp.errorDescription];
            _shareFinished(response);
        }
    }
}

- (void)isOnlineResponse:(NSDictionary *)response {
    <#code#>
}


#pragma mark - WeiboSDKDelegate 微博分享、登录的回调
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {//微博登录
    
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        WBAuthorizeResponse *res = (WBAuthorizeResponse *)response;
        __block NSString *uid = res.userID;
        
        //拿到uid和accessToken发送请求获取用户信息
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",res.accessToken,res.userID];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if (!dict[@"error_code"]) { //登录成功
                    
                    JYTPUserInfo *infoDict = [JYTPUserInfo userInfo];
                    infoDict.userName = dict[@"name"];
                    infoDict.imageUrl = dict[@"avatar_hd"];
                    NSString *location = dict[@"location"];
                    
                    if (location.length) {
                        
                        if ([location rangeOfString:@" "].location == NSNotFound) {//不包含  地址为海外
                            
                            infoDict.province = location;
                        } else {
                            
                            NSArray *locArr = [location componentsSeparatedByString:@" "];
                            infoDict.province = locArr[0];
                            infoDict.city = locArr[1];
                            
                        }
                    }
                    
                    
                    
                    if ([dict[@"gender"] isEqualToString:@"m"]) { //0代表男性，1代表女性
                        infoDict.sex = 0;
                    }else{
                        infoDict.sex = 1;
                    }
                    
                    if (_loginFinished) {
                        JYLoginResponse *res = [JYLoginResponse loginResponseWithSucess:true userInfo:infoDict uid:uid errorString:nil];
                        _loginFinished(res);
                    }
                } else { //取消登录
                    
                    if (_loginFinished) {
                        JYLoginResponse *res = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:nil];
                        _loginFinished(res);
                    }
                    
                }
            }else{
                if (_loginFinished) {
                    JYLoginResponse *res = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:nil];
                    _loginFinished(res);
                }
            }
        }];
        // 启动任务
        [task resume];
    }
    
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {//分享信息到微博
        
        if (_shareFinished) {
            JYShareResponse *res = [JYShareResponse shareResponseWithSucess:(response.statusCode == 0) errorStr:@"微博分享错误"];
            _shareFinished(res);
        }
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    <#code#>
}



#pragma mark - TencentSessionDelegate QQ登录的回调
/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response {
    
    JYTPUserInfo *userInfo = [JYTPUserInfo userInfo];
    
    userInfo.userName = response.jsonResponse[@"nickname"];
    userInfo.imageUrl = response.jsonResponse[@"figureurl_qq_2"];
    userInfo.province = response.jsonResponse[@"province"];
    userInfo.city     = response.jsonResponse[@"city"];
    
    if ([response.jsonResponse[@"gender"] isEqualToString:@"男"]) {//1代表男性，2代表女性
        userInfo.sex   = 0;
    }else{
        userInfo.sex   = 1;
    }
    
    if (_loginFinished) {
        NSString *openId = [[NSUserDefaults standardUserDefaults] objectForKey:@"qqOpenId"];
        JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:YES userInfo:userInfo uid:openId errorString:nil];
        _loginFinished(response);
    }
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    
    [[NSUserDefaults standardUserDefaults] setObject:_oauth.openId forKey:@"qqOpenId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //获取用户信息。 调用这个方法后，qq的sdk会自动调用
    //- (void)getUserInfoResponse:(APIResponse*) response
    //这个方法就是 用户信息的回调方法。
    
    [_oauth getUserInfo];
    
}
/**
 * 登录失败后的回调
 * param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    
    if (_loginFinished) {
        JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:@"主动退出登录"];
        _loginFinished(response);
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    if (_loginFinished) {
        JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:@"网络故障"];
        _loginFinished(response);
    }
}


/**
 * 因用户未授予相应权限而需要执行增量授权。在用户调用某个api接口时，如果服务器返回操作未被授权，则触发该回调协议接口，由第三方决定是否跳转到增量授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \param permissions 需增量授权的权限列表。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启增量授权流程。若需要增量授权请调用\ref TencentOAuth#incrAuthWithPermissions: \n注意：增量授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions{
    
    // incrAuthWithPermissions是增量授权时需要调用的登录接口
    // permissions是需要增量授权的权限列表
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}

/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth{
    return YES;
}

/**
 * 用户通过增量授权流程重新授权登录，token及有效期限等信息已被更新。
 * \param tencentOAuth token及有效期限等信息更新后的授权实例对象
 * \note 第三方应用需更新已保存的token及有效期限等信息。
 */
- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth{
    
    if (tencentOAuth.accessToken
        && 0 != [tencentOAuth.accessToken length])
    { // 在这里第三方应用需要更新自己维护的token及有效期限等信息
        // **务必在这里检查用户的openid是否有变更，变更需重新拉取用户的资料等信息** _labelAccessToken.text = tencentOAuth.accessToken;
    }
    else
    {
        
    }
    
}

/**
 * 用户增量授权过程中因取消或网络问题导致授权失败
 * \param reason 授权失败原因，具体失败原因参见sdkdef.h文件中\ref UpdateFailType
 */
- (void)tencentFailedUpdate:(UpdateFailType)reason{
    
    switch (reason)
    {
        case kUpdateFailNetwork:
        {
            //_labelTitle.text=@"增量授权失败，无网络连接，请设置网络";
            if (_loginFinished) {
                JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:@"增量授权失败，无网络连接，请设置网络"];
                _loginFinished(response);
            }
            break;
        }
        case kUpdateFailUserCancel:
        {
            //_labelTitle.text=@"增量授权失败，用户取消授权";
            break;
        }
        case kUpdateFailUnknown:
        default:
        {
            break;
        }
    }
    
    
}


#pragma mark 第三方登录
- (void)jy_LoginType:(LoginType)loginType finished:(void(^)(JYLoginResponse *response))finished
{
    if (loginType == qqLogin) {
        
        self.loginFinished = finished;
        NSArray *permissions= [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
        NSString *qqAppId = [[NSUserDefaults standardUserDefaults] objectForKey:@"qqAppId"];
        _oauth = [[TencentOAuth alloc] initWithAppId:qqAppId andDelegate:self];
        [_oauth authorize:permissions localAppId:qqAppId inSafari:NO];
        
    } else if (loginType == weChatLogin) {
        
        self.loginFinished = finished;
        if ([[self class] jy_isWXAppInstalled]) {
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"App";
            [WXApi sendReq:req];
        }else {
            SendAuthReq* req =[[SendAuthReq alloc ] init ];
            req.scope = @"snsapi_userinfo";
            req.state = @"weixinlogin" ;
            [WXApi sendAuthReq:req viewController:[UIApplication sharedApplication].delegate.window.rootViewController delegate:self];
        }
        
    } else {
        self.loginFinished = finished;
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        
        //回调地址与 新浪微博开放平台中 我的应用  --- 应用信息 -----高级应用    -----授权设置 ---应用回调中的url保持一致就好了
        NSString *redirectURI = [[NSUserDefaults standardUserDefaults] objectForKey:@"redirectURI"];
        request.redirectURI = redirectURI;
        
        request.scope = @"all";
        
        request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": @123,
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [WeiboSDK sendRequest:request];
    }
}

#pragma mark - 第三方支付
- (void)jy_PayInformation:(NSDictionary *)resultDict PayType:(PayType)payType finished:(void(^)(JYPayResponse *response))finished
{
    
    self.payFinished = finished;
    
    if (payType == weChatPay) { // 微信支付
        if (![[self class] jy_isWXAppInstalled]) {
            //@"未安装微信"
            return;
        }
        PayReq *request = [[PayReq alloc] init];
        if (![resultDict isKindOfClass:[NSNull class]]) {
            
            if (![resultDict[@"partnerId"] isKindOfClass:[NSNull class]]) {
                request.openID = resultDict[@"appId"];
                request.partnerId = resultDict[@"partnerId"];
                request.prepayId= resultDict[@"prepayId"];
                request.package = resultDict[@"packageId"];
                request.nonceStr= resultDict[@"nonceStr"];
                request.timeStamp= (UInt32)[resultDict[@"timeStamp"] intValue];
                request.sign= resultDict[@"sign"];
                [WXApi sendReq:request];
            } else {
                if (self.payFinished) {
                    JYPayResponse *response = [JYPayResponse payResponseWithSucess:false errorString:@"-2"];
                    self.payFinished(response);
                }
                return;
            }
        }
        
    } else { // 支付宝支付
        
        NSString *appScheme = [[NSUserDefaults standardUserDefaults] objectForKey:@"alipayScheme"];
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [resultDict objectForKey:@"orderString"];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"调用支付结果开始支付 = %@",resultDic);
        }];
    }
    
}

#pragma  mark- 判断是否有安装第三方应用
+(BOOL) jy_isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}
+(BOOL) jy_isQQAppInstalled
{
    return [TencentOAuth iphoneQQInstalled];
}

+(BOOL) jy_isWeiboAppInstalled
{
    return [WeiboSDK isWeiboAppInstalled];
}

#pragma mark - /////////////第三方分享///////////////

#pragma mark - QQ分享
//纯文本分享
- (void)qqShareText:(NSString *)text
            finshed:(void(^)(JYShareResponse *response))finished
{
    
    self.shareFinished = finished;
    QQApiTextObject *textObj = [QQApiTextObject objectWithText:text];
    SendMessageToQQReq *textReq = [SendMessageToQQReq reqWithContent:textObj];
    
    [QQApiInterface sendReq:textReq];
}
//纯图片分享
- (void)qqShareImage:(NSData *)previewImageData
       originalImage:(NSData *)originalImageData
               title:(NSString *)title
         description:(NSString *)description
            finished:(void(^)(JYShareResponse *response))finished
{
    
    self.shareFinished = finished;
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:previewImageData
                                               previewImageData:originalImageData
                                                          title:title
                                                   description :description];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    
    [QQApiInterface sendReq:req];
}
//新闻分享（链接分享）
- (void)qqShareWebURL:(NSString *)url
                title:(NSString *)title
          description:(NSString *)description
           thumbImage:(UIImage *)thumbImage
                scene:(QQShareScene)scene
             finished:(void(^)(JYShareResponse *response))finished
{
    self.shareFinished = finished;
    NSData *imageData = UIImagePNGRepresentation(thumbImage);
    QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:description previewImageData:imageData targetContentType:QQApiURLTargetTypeNews];
    
    SendMessageToQQReq *newsReq = [SendMessageToQQReq reqWithContent:newsObject];
    
    [self qqSendRequest:newsReq scene:scene];
}
//音乐分享
- (void)qqShareMusicURL:(NSString *)flashUrl  // 音乐播放的网络流媒体地址
                jumpURL:(NSString *)jumpUrl
        previewImageURL:(NSString *)previewImageUrl
       previewImageData:(NSData *)previewImageData
                  title:(NSString *)title
            description:(NSString *)description
                  scene:(QQShareScene)scene
               finished:(void(^)(JYShareResponse *response))finished
{
    
    self.shareFinished = finished;
    QQApiAudioObject *audioObject;
    if (previewImageUrl) {
        // 2.分享预览图URL地址 / 也可以是NSData
        audioObject = [QQApiAudioObject objectWithURL:[NSURL URLWithString:jumpUrl] title:title description:description previewImageURL:[NSURL URLWithString:previewImageUrl]];
    } else if (previewImageData) {
        audioObject = [QQApiAudioObject objectWithURL:[NSURL URLWithString:jumpUrl] title:title description:description previewImageData:previewImageData];
    }
    
    // 4.设置播放流媒体地址
    [audioObject setFlashURL:[NSURL URLWithString:flashUrl]];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:audioObject];
    [self qqSendRequest:req scene:scene];
}

- (void)qqSendRequest:(QQBaseReq *)req scene:(QQShareScene)scene
{
    if (scene == QQShareSceneSession) { // 会话
        [QQApiInterface sendReq:req];
        return;
    }
    // 朋友圈
    [QQApiInterface SendReqToQZone:req];
}

#pragma mark - 微信分享
//文字类型分享
- (void)weChatShareText:(NSString *)text
               finished:(void(^)(JYShareResponse *response))finished {
    
    self.shareFinished = finished;
    SendMessageToWXReq *textReq = [[SendMessageToWXReq alloc] init];
    
    textReq.bText = YES;
    textReq.text = text;
    textReq.scene = WXSceneSession;
    
    [WXApi sendReq:textReq];
}
//图片类型分享
- (void)weChatShareThumbImage:(UIImage *)thumbImage
                originalImage:(NSData *)originalImageData
                        scene:(WXShareScene)scene
                     finished:(void(^)(JYShareResponse *response))finished {
    
    self.shareFinished = finished;
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:thumbImage];
    
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = originalImageData;
    
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *imageReq = [[SendMessageToWXReq alloc] init];
    imageReq.bText = NO;
    imageReq.message = message;
    imageReq.scene = scene;
    [WXApi sendReq:imageReq];
}
//链接类型分享//缩略图不能大于32k
- (void)weChatShareWebURL:(NSString *)url
              description:(NSString *)description
               thumbImage:(UIImage *)thumbImage
                    title:(NSString *)title
                    scene:(WXShareScene)scene
                 finished:(void(^)(JYShareResponse *response))finished {
    
    self.shareFinished = finished;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = url;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *webReq = [[SendMessageToWXReq alloc] init];
    webReq.bText = NO;
    webReq.message = message;
    webReq.scene = scene;
    [WXApi sendReq:webReq];
}
//音乐类型分享
- (void)weChatShareMusicURL:(NSString *)musicUrl
               musicDataURL:(NSString *)musicDataUrl
                 thumbImage:(UIImage *)thumbImage
                      title:(NSString *)title
                description:(NSString *)description
                      scene:(WXShareScene)scene
                   finished:(void(^)(JYShareResponse *response))finished {
    
    self.shareFinished = finished;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    
    WXMusicObject *musicObj = [WXMusicObject object];
    musicObj.musicUrl = musicUrl;  // 音乐url
    musicObj.musicDataUrl = musicDataUrl;  // 音乐数据url
    message.mediaObject = musicObj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
    
}
//视频类型分享
- (void)weChatShareVideoURL:(NSString *)videoUrl
                 thumbImage:(UIImage *)thumbImage
                      title:(NSString *)title
                description:(NSString *)description
                      scene:(WXShareScene)scene
                   finished:(void(^)(JYShareResponse *response))finished {
    
    self.shareFinished = finished;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    
    WXVideoObject *videoObj = [WXVideoObject object];
    videoObj.videoUrl = videoUrl;
    message.mediaObject = videoObj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

#pragma mark - 微博分享
- (void)weiboShareText:(NSString *)text
              finished:(void(^)(JYShareResponse *response))finished {
    
    self.shareFinished = finished;
    WBMessageObject *message = [WBMessageObject message];
    message.text = text;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:request];
}

- (void)weiboShareImage:(UIImage *)image
                   text:(NSString *)text
                finshed:(void(^)(JYShareResponse *response))finished {
    
    self.shareFinished = finished;
    WBMessageObject *message = [WBMessageObject message];
    message.text = text;
    
    // 消息的图片内容中，图片数据不能为空并且大小不能超过10M
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image, 1.0);
    message.imageObject = imageObject;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:request];
}

-(void)weiboShareUrl:(NSString *)url
               title:(NSString *)title
         description:(NSString *)description
               image:(UIImage *)image
            finished:(void(^)(JYShareResponse *response))finished
{
    self.shareFinished = finished;
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"%@\n%@\n %@",title,description,url];
    
    // 消息的图片内容中，图片数据不能为空并且大小不能超过10M
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image, 1.0);
    message.imageObject = imageObject;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:request];
    
}

@end
