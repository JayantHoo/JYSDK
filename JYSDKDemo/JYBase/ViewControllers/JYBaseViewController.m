//
//  JYBaseViewController.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/28.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYBaseViewController.h"
#import "JYNavigationController.h"

@interface JYBaseViewController ()



@end

@implementation JYBaseViewController

- (instancetype)initWithParams:(NSDictionary *)params{
    if (self = [self init]) {
        _params = params;
    }
    return self;
}

/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 基础配置
        /// 默认在viewDidLoad里面服务器的数据
        _shouldRequestRemoteDataOnViewDidLoad = YES;
        
        /// FDFullscreenPopGesture
        _interactivePopDisabled = NO;
        _prefersNavigationBarHidden = NO;
        
        /// custom
        _prefersNavigationBarBottomLineHidden = NO;
        
        /// 允许IQKeyboardMananger接管键盘弹出事件
        _keyboardEnable = YES;
        _shouldResignOnTouchOutside = YES;
        _keyboardDistanceFromTextField = 10.0f;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /// 隐藏导航栏细线
    JYNavigationController *nav = (JYNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[JYNavigationController class]]) { /// 容错
        /// 显示或隐藏
        self.prefersNavigationBarBottomLineHidden?[nav hideNavigationBottomLine]:[nav showNavigationBottomLine];
    }

//    // 配置键盘
//    IQKeyboardManager.sharedManager.enable = self.keyboardEnable;
//    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = self.shouldResignOnTouchOutside;
//    IQKeyboardManager.sharedManager.keyboardDistanceFromTextField = self.keyboardDistanceFromTextField;

    if (nav) {
        /**
         原因：
         viewController.navigationItem.backBarButtonItem = nil;
         [viewController.navigationItem setHidesBackButton:YES];
         CoderMikeHe: Fixed Bug 上面这个方法，会导致侧滑取消时，导航栏出现三个蓝点，系统层面的BUg
         这种方法也不是最完美的，第一次侧滑取消 也会复现
         */
        for (UIView *subView in nav.navigationBar.subviews) {
            /// 隐藏掉蓝点
            if ([subView isKindOfClass:NSClassFromString(@"_UINavigationItemButtonView")]) {
                subView.jy_size = CGSizeZero;
                subView.hidden = YES;
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Being popped, take a snapshot
    if (self.navigationController) {
        /**
         viewController.navigationItem.backBarButtonItem = nil;
         [viewController.navigationItem setHidesBackButton:YES];
         CoderMikeHe: Fixed Bug 上面这个方法，会导致侧滑取消时，导航栏出现三个蓝点，系统层面的BUg
         */
        for (UIView *subView in self.navigationController.navigationBar.subviews) {
            /// 隐藏掉蓝点
            if ([subView isKindOfClass:NSClassFromString(@"_UINavigationItemButtonView")]) {
                subView.jy_size = CGSizeZero;
                subView.hidden = YES;
            }
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    /// backgroundColor
    self.view.backgroundColor = [UIColor colorFromHexString:@"#EFEFF4"];
    
    /// 导航栏隐藏 只能在ViewDidLoad里面加载，无法动态
    self.fd_prefersNavigationBarHidden = self.prefersNavigationBarHidden;
    
    /// pop手势
    self.fd_interactivePopDisabled = self.interactivePopDisabled;
    
    [self configure];
    /// 请求数据
    if (self.shouldRequestRemoteDataOnViewDidLoad) {
        [self requestRemoteData];
    }
}

#pragma mark - Public Method
- (void)configure{

}

- (void)requestRemoteData{
    /// ... subclass override
    
}

#pragma mark - Orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {return UIInterfaceOrientationMaskPortrait;}
- (BOOL)shouldAutorotate {return YES;}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {return UIInterfaceOrientationPortrait;}

#pragma mark - Status bar
- (BOOL)prefersStatusBarHidden { return NO; }
- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleDefault; }
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation { return UIStatusBarAnimationFade; }

@end
