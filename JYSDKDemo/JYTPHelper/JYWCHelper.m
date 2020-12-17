//
//  JYWCHelper.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYWCHelper.h"

@interface JYWCHelper ()<WXApiDelegate>


@end

@implementation JYWCHelper

//注册微信
+ (void)registerWeChatAppid:(NSString *)wxAppId secret:(NSString *)wxSecret {
    // 1.注册微信
    [WXApi registerApp:wxAppId];
    [[NSUserDefaults standardUserDefaults] setObject:wxAppId forKey:@"wxAppid"];
    [[NSUserDefaults standardUserDefaults] setObject:wxSecret forKey:@"wxSecret"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)handleOpenURL:(NSURL *)url
{
    return [[self defaultHelper] handleOpenURL:url];
}

-(BOOL)handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

//是否安装微信
+(BOOL) jy_isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}

#pragma mark 登录
- (void)jy_LoginFinished:(void(^)(JYLoginResponse *response))finished
{
    self.loginFinished = finished;
    if (![[self class] jy_isWXAppInstalled]) {
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
}

#pragma mark - 微信支付
- (void)jy_PayInformation:(NSDictionary *)resultDict finished:(void(^)(JYPayResponse *response))finished
{
    
    self.payFinished = finished;
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
}

#pragma mark - 微信回调
- (void) onResp:(id)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) { //微信支付 成功baseResp里面的errcode是0，支付失败是-2；
        
        BaseResp *reqs = (BaseResp *)resp;
        if (reqs.errCode == 0) { //支付成功
            if (self.payFinished) {
                JYPayResponse *response = [JYPayResponse payResponseWithSucess:true errorString:nil];
                self.payFinished(response);
            }
            
        }else { //支付失败 (errStr也是没有值的)
            
            if (self.payFinished) {
                JYPayResponse *response = [JYPayResponse payResponseWithSucess:false errorString:reqs.errStr];
                self.payFinished(response);
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
                            
                            if (self.loginFinished) {
                                
                                JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:true userInfo:userInfo uid:unionid errorString:nil];
                                self.loginFinished(response);
                            }
                        } else { // 取消登录
                            if (self.loginFinished) {
                                JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:nil];
                                self.loginFinished(response);
                            }
                            
                        }
                        
                    } else {
                        
                        if (self.loginFinished) {
                            JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:nil];
                            self.loginFinished(response);
                            
                        }
                    }
                    
                }];
                
                [infoTask resume];
                
            } else{
                
                if (self.loginFinished) {
                    JYLoginResponse *response = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:nil];
                    self.loginFinished(response);
                }
            }
            
        }];
        
        [task resume];
        
        
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) { // 微信分享
        SendMessageToWXResp *wxresp = (SendMessageToWXResp *)resp;
        //调用外部的block
        if (self.shareFinished) {
            JYShareResponse *response = [JYShareResponse shareResponseWithSucess:(wxresp.errCode == 0) errorStr:wxresp.errStr];
            self.shareFinished(response);
        }
    }
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

//分享小程序
- (void)weChatShareMiniProgramWithURL:(NSString *)url
                                 path:(NSString *)path
                             userName:(NSString *)userName
                          description:(NSString *)description
                            miniImage:(UIImage *)miniImage
                           thumbImage:(UIImage *)thumbImage
                                title:(NSString *)title
                             finished:(void(^)(JYShareResponse *response))finished
{
    self.shareFinished = finished;
    WXMiniProgramObject *object = [WXMiniProgramObject object];
    object.webpageUrl = url;
    object.userName = userName;
    object.path = path;
    UIImage *newImage = [UIImage jy_compressImage:miniImage toByte:6000];
    object.hdImageData =  UIImageJPEGRepresentation(newImage,1.0);
    object.withShareTicket = YES;
    object.miniProgramType =  WXMiniProgramTypeRelease;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    message.mediaObject = object;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;  //目前只支持会话
    [WXApi sendReq:req];
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

@end
