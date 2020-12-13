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


@end
