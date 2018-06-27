//
//  JYWBHelper.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYWBHelper.h"

@interface JYWBHelper ()<WeiboSDKDelegate>

@end

@implementation JYWBHelper

+ (void)registerWeiboApp:(NSString *)wbAppKey secret:(NSString *)wbSecret redirectURI:(NSString *)redirectURI {
    // 3.注册Weibo
    [WeiboSDK enableDebugMode:NO]; //开启调试模式
    [WeiboSDK registerApp:wbAppKey];
    [[NSUserDefaults standardUserDefaults] setObject:wbAppKey forKey:@"wbAppKey"];
    [[NSUserDefaults standardUserDefaults] setObject:wbSecret forKey:@"wbSecret"];
    [[NSUserDefaults standardUserDefaults] setObject:redirectURI forKey:@"redirectURI"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)handleOpenURL:(NSURL *)url
{
    return [[self defaultHelper] handleOpenURL:url];
}

-(BOOL)handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

+(BOOL) jy_isWeiboAppInstalled
{
    return [WeiboSDK isWeiboAppInstalled];
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
                    
                    if (self.loginFinished) {
                        JYLoginResponse *res = [JYLoginResponse loginResponseWithSucess:true userInfo:infoDict uid:uid errorString:nil];
                        self.loginFinished(res);
                    }
                } else { //取消登录
                    
                    if (self.loginFinished) {
                        JYLoginResponse *res = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:nil];
                        self.loginFinished(res);
                    }
                    
                }
            }else{
                if (self.loginFinished) {
                    JYLoginResponse *res = [JYLoginResponse loginResponseWithSucess:false userInfo:nil uid:nil errorString:nil];
                    self.loginFinished(res);
                }
            }
        }];
        // 启动任务
        [task resume];
    }
    
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {//分享信息到微博
        
        if (self.shareFinished) {
            JYShareResponse *res = [JYShareResponse shareResponseWithSucess:(response.statusCode == 0) errorStr:@"微博分享错误"];
            self.shareFinished(res);
        }
    }
}

//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
//    
//}


#pragma mark - 微博登录
-(void)jy_LoginFinished:(void (^)(JYLoginResponse *))finished
{
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
