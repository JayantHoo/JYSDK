//
//  JYBaseViewController.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/28.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYBaseViewController.h"
#import "JYNavigationController.h"
#import "UIViewController+PureTransition.h"

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
        
        ///
        _interactivePopDisabled = NO;
        _prefersNavigationBarHidden = NO;
        
        /// custom
        _prefersNavigationBarBottomLineHidden = NO;
        _prefersNavigationBarTintColor = [UIColor redColor];
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



}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBarTintColor:self.prefersNavigationBarTintColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self.navigationController.navigationBar setBarTintColor:self.prefersNavigationBarTintColor];
    /// backgroundColor
    self.view.backgroundColor = [UIColor colorFromHexString:@"#EFEFF4"];
    
    /// 导航栏隐藏 只能在ViewDidLoad里面加载，无法动态
    self.yr_prefersNavigationBarHidden = self.prefersNavigationBarHidden;
    
    /// pop手势
    self.yr_interactivePopDisabled = self.interactivePopDisabled;
    
//         //配置键盘
//        IQKeyboardManager.sharedManager.enable = self.keyboardEnable;
//        IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = self.shouldResignOnTouchOutside;
//        IQKeyboardManager.sharedManager.keyboardDistanceFromTextField = self.keyboardDistanceFromTextField;
    
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
