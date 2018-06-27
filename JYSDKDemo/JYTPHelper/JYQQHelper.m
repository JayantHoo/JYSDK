//
//  JYQQHelper.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYQQHelper.h"

@interface JYQQHelper ()<TencentSessionDelegate,QQApiInterfaceDelegate>
{
    TencentOAuth *_oauth;
}

@end

@implementation JYQQHelper


+ (void)registerQQApp:(NSString *)qqAppId secret:(NSString *)qqSecret
{
// 2.注册QQ
#pragma clang diagnostic push // 消除警告
#pragma clang diagnostic ignored   "-Wunused-variable"
    id xx = [[TencentOAuth alloc] initWithAppId:qqAppId andDelegate:nil];
#pragma clang diagnostic pop
    
    [[NSUserDefaults standardUserDefaults] setObject:qqAppId forKey:@"qqAppId"];
    [[NSUserDefaults standardUserDefaults] setObject:qqSecret forKey:@"qqSecret"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL) jy_isQQAppInstalled
{
    return [TencentOAuth iphoneQQInstalled];
}

+(BOOL)handleOpenURL:(NSURL *)url
{
    return [[self defaultHelper] handleOpenURL:url];
}

-(BOOL)handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url] || [QQApiInterface handleOpenURL:url delegate:self];
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
    
    if (self.loginFinished) {
        NSString *openId = [[NSUserDefaults standardUserDefaults] objectForKey:@"qqOpenId"];
        JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:YES userInfo:userInfo uid:openId errorString:nil];
        self.loginFinished(response);
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
    
    if (self.loginFinished) {
        JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:@"主动退出登录"];
        self.loginFinished(response);
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    if (self.loginFinished) {
        JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:@"网络故障"];
        self.loginFinished(response);
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
            if (self.loginFinished) {
                JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:@"增量授权失败，无网络连接，请设置网络"];
                self.loginFinished(response);
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

#pragma mark -QQ登录
-(void)jy_LoginFinished:(void (^)(JYLoginResponse *))finished
{
    self.loginFinished = finished;
    NSArray *permissions= [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
    NSString *qqAppId = [[NSUserDefaults standardUserDefaults] objectForKey:@"qqAppId"];
    _oauth = [[TencentOAuth alloc] initWithAppId:qqAppId andDelegate:self];
    [_oauth authorize:permissions localAppId:qqAppId inSafari:NO];
}

#pragma mark - QQ分享回调
-(void)onResp:(QQBaseResp *)resp
{
    // QQ分享
    QQBaseResp *qqresp = (QQBaseResp *)resp;
    if (self.shareFinished) {
        JYShareResponse *response = [JYShareResponse shareResponseWithSucess:([qqresp.result intValue] == 0) errorStr:qqresp.errorDescription];
        self.shareFinished(response);
    }
}

//- (void)isOnlineResponse:(NSDictionary *)response {
//    
//}
//
//
//- (void)onReq:(QQBaseReq *)req {
//    
//}


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
    // QQ空间
    [QQApiInterface SendReqToQZone:req];
}

@end
