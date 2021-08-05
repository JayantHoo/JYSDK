//
//  JYBaseViewController.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/28.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYBaseViewController : UIViewController

/// ------------ Property ------------
/// The `params` parameter in `-initWithParams:` method.
/// The `params` Key's `CMHViewControllerIDKey`
@property (nonatomic, readonly, copy) NSDictionary *params;

/// 
/// (是否取消掉左滑(侧滑)pop到上一层的功能（栈底控制器无效），默认为NO，不取消)
@property (nonatomic, readwrite, assign) BOOL interactivePopDisabled;
/// 是否隐藏该控制器的导航栏 默认是不隐藏 (default is NO)
@property (nonatomic, readwrite, assign) BOOL prefersNavigationBarHidden;
/// 是否隐藏该控制器的导航栏底部的分割线 默认不隐藏 （NO）
@property (nonatomic, readwrite, assign) BOOL prefersNavigationBarBottomLineHidden;
///导航栏颜色
@property (nonatomic, readwrite, strong) UIColor *prefersNavigationBarTintColor;

/// IQKeyboardManager
/// 是否让IQKeyboardManager的管理键盘的事件 默认是YES（键盘管理）
@property (nonatomic, readwrite, assign) BOOL keyboardEnable;
/// 是否键盘弹起的时候，点击其他区域键盘掉下 默认是 YES
@property (nonatomic, readwrite, assign) BOOL shouldResignOnTouchOutside;
/// To set keyboard distance from textField. can't be less than zero. Default is 10.0.
/// 键盘顶部距离当前响应的textField的底部的距离，默认是10.0f，前提得 `keyboardEnable = YES` 且数值不得小于 0。
@property (nonatomic, readwrite, assign) CGFloat keyboardDistanceFromTextField;

/** 是否需要在控制器viewDidLoad后调用`requestRemoteData` default is YES*/
@property (nonatomic, readwrite, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;

/// The callback block. 当Push/Present时，通过block反向传值
@property (nonatomic, readwrite, copy) void (^callback)(id);

//Method
/// Returns a new Controller.
- (instancetype)initWithParams:(NSDictionary *)params;
/// 基础配置 （PS：子类可以重写，但不需要在ViewDidLoad中手动调用，但是子类重写必须要调用 [super configure]）
- (void)configure;
/// 请求远程数据
/// sub class can override ， 但不需要在ViewDidLoad中手动调用 ，依赖`shouldRequestRemoteDataOnViewDidLoad = YES` 且不用调用 super， 直接重写覆盖
- (void)requestRemoteData;

#pragma mark- 提示信息弹窗
///** 显示成功HUD */
//- (void)showSuccessMessage:(NSString *)message
//                completion:(void (^)(void))completion;
//
///** 显示失败HUD */
//- (void)showFailedMessage:(NSString *)message
//               completion:(void (^)(void))completion;

/** view中部显示toast */
- (void)showCenterToastWithMessage:(NSString *)message
                        completion:(void(^)(void))completion;

/** view底部显示toast */
- (void)showBottomToastWithMessage:(NSString *)message
                        completion:(void(^)(void))completion;


@end
