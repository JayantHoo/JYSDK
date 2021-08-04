//
//  JYWebViewController.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/8/14.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYBaseViewController.h"
#import <WebKit/WebKit.h>

@interface JYWebViewController : JYBaseViewController<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

/// webView
@property (nonatomic, weak) WKWebView *webView;

/// web url quest
@property (nonatomic, copy) NSURLRequest *request;


@property (nonatomic,copy) NSString *htmlText;///

@property (nonatomic,copy) NSString *link;///  H5链接


//默认为YES
@property (nonatomic, assign) BOOL shouldAutoLoad;

/// 是否取消导航栏的title等于webView的title。默认是不取消，default is NO
@property (nonatomic, readwrite, assign) BOOL shouldDisableWebViewTitle;

-(NSArray *)jsFuncList;

@end
