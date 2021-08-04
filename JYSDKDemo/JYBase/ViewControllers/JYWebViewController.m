//
//  JYWebViewController.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/8/14.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYWebViewController.h"
#import "FBKVOController+JYExtension.h"
//#import <YBImageBrowser.h>

/// KVO 监听的属性
/// 加载情况
static NSString * const WebViewKVOLoading = @"loading";
/// 文章标题
static NSString * const WebViewKVOTitle = @"title";
/// 进度
static NSString * const WebViewKVOEstimatedProgress = @"estimatedProgress";

@interface JYWebViewController ()
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}
/// 进度条
@property (nonatomic, readwrite, strong) UIProgressView *progressView;

@end

@implementation JYWebViewController

-(void)dealloc
{
    [_webView stopLoading];
}

-(instancetype)init
{
    if (self = [super init]) {
        self.shouldAutoLoad = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
    if (self.shouldAutoLoad) {
        if (self.request) {
            /// 加载请求数据
            [self.webView loadRequest:self.request];
        }
        
        if (JYStringIsNotEmpty(self.htmlText)) {
            [self.webView loadHTMLString:self.htmlText baseURL:nil];
        }
        
        if (JYStringIsNotEmpty(self.link)) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.link]]];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWebView];
}

-(void)setupWebView
{
    ///切记 lightempty_ios 是前端跟H5商量的结果。
    //    NSString *userAgent = @"wechat_ios";
    //
    //    if (!(SHIOSVersion>=9.0)) [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"userAgent":userAgent}];
    
    /// 注册JS
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    /// 这里可以注册JS的处理
    NSArray *jsFuncList = [self jsFuncList];
    for (NSString *jsFunc in jsFuncList) {
        [userContentController addScriptMessageHandler:self name:jsFunc];
    }
    [userContentController addScriptMessageHandler:self name:@"OpenImage"];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    // CoderMikeHe Fixed : 自适应屏幕宽度js
      NSString *jsString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.body.style.overflow='hidden'; document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 添加自适应屏幕宽度js调用的方法
    [userContentController addUserScript:userScript];
    /// 赋值userContentController
    configuration.userContentController = userContentController;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    webView.userInteractionEnabled = YES;
    
    self.webView = webView;
    [self.view addSubview:webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    /// oc调用js
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        JYLog(@"navigator.userAgent.result is ++++ %@", result);
    }];
    
    /// 监听数据
    _KVOController = [FBKVOController controllerWithObserver:self];
    @weakify(self);
    /// binding self.avatarUrlString
    [_KVOController jy_observe:self.webView keyPath:WebViewKVOTitle block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        /// 这里只设置导航栏的title 以免self.title 设置了tabBarItem.title
        if (!self.shouldDisableWebViewTitle) self.navigationItem.title = self.webView.title;
    }];
    [_KVOController jy_observe:self.webView keyPath:WebViewKVOLoading block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        JYLog(@"--- webView is loading ---");
    }];
    
    [_KVOController jy_observe:self.webView keyPath:WebViewKVOEstimatedProgress block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }];
}

-(NSArray *)jsFuncList
{
    return @[];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    /// js call OC function
    if ([message.name isEqualToString:@"OpenImage"]) {
//        YBIBImageData *img = [YBIBImageData new];
//        img.imageURL = message.body;
//        YBImageBrowser *browser = [YBImageBrowser new];
//        browser.dataSourceArray = @[img];
//        [browser show];
        return;
    }
    
}

#pragma mark - WKNavigationDelegate
/// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    JYLog(@"navigationAction.request.URL:   %@", navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)navigationResponse.response;
//    NSInteger HTTPCode = httpResponse.statusCode;

    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    // 判断服务器采用的验证方法
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
         // 如果没有错误的情况下 创建一个凭证，并使用证书
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }else {
        // 验证失败，取消本次验证
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
//    NSURLCredential *cred = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
//    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}

#pragma mark - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    /// CoderMike Fixed : 解决点击网页的链接 不跳转的Bug。
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


#pragma mark runJavaScript
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    //alert

    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    completionHandler(YES);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    completionHandler(defaultText);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0){
    
}

#pragma mark -懒加载
- (UIProgressView *)progressView {
    if (!_progressView) {
        CGFloat progressViewW = JYSCREENWIDTH;
        CGFloat progressViewH = 3;
        CGFloat progressViewX = 0;
        CGFloat progressViewY = CGRectGetHeight(self.navigationController.navigationBar.frame) - progressViewH + 1;
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH)];
        progressView.progressTintColor = [UIColor blueColor];
        progressView.trackTintColor = [UIColor clearColor];
        [self.view addSubview:progressView];
        self.progressView = progressView;
    }
    return _progressView;
}

@end
