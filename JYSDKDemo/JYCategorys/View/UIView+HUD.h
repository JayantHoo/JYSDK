//
//  UIView+HUD.h
//  omgmall
//
//  Created by champ on 2018/9/21.
//  Copyright © 2018年 omgmall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

typedef void (^HUDDismissCompletion)(void);


@interface UIView (HUD)
#pragma mark - MBProgressHUD

// 加载菊花 背景不透明
- (void)showOpacityLoadingHUD;

// 加载菊花 背景不透明
-  (void)showOpacityHUDWithStatus:(NSString*)status;

//  ********************** 已下背景全为透明 ***********

// 加载菊花 
- (void)showLoadingHUD;

// 仅仅加载文字
-  (void)showTextHUDWithStatus:(NSString*)status;

// 显示菊花 + 文字
- (void)showHUDWithStatus:(NSString*)status;

// 显示警示
- (void)showInfoHUDWithStatus:(NSString*)status;

// 显示成功
- (void)showSuccessHUDStatus:(NSString*)status;

// 显示失败
- (void)showErrorHUDStatus:(NSString*)status;

// 显示警示 可以设置时间 有完成回调
- (void)showInfoHUDWithStatus:(NSString*)status dismissWithDelay:(NSTimeInterval)delay completion:(HUDDismissCompletion)completion;

// 显示加载成功 可以设置时间 有完成回调
- (void)showSuccessHUDWithStatus:(NSString*)status dismissWithDelay:(NSTimeInterval)delay completion:(HUDDismissCompletion)completion;

// 显示加载错误 可以设置时间 有完成回调
- (void)showErrorHUDWithStatus:(NSString*)status dismissWithDelay:(NSTimeInterval)delay completion:(HUDDismissCompletion)completion;

// 立即消失
- (void)dismissHUD;

// 显示加载进度
- (void)showProgress:(float)progress;

// 显示进度 + 文字
- (void)showProgress:(float)progress status:(NSString*)status;

#pragma mark - 系统提示框
// 显示系统提示框,只有取消按键
- (void)showSystemAlertViewWithTilte:(NSString *)title secondTitle:(NSString *)secondTitle sureButtonTitle:(NSString *)sureButtonTitle;

// 显示系统提示框，有确认和取消按键
- (void)showSystemAlertViewWithTilte:(NSString *)title secondTitle:(NSString *)secondTitle sureButtonTitle:(NSString *)sureButtonTitle cancelButtonTitle:(NSString *)cancelBtnTitle sureCompletion:(HUDDismissCompletion)completion;

// 显示相册,图片选择的 actionSheet
- (void)showSystemActionSheetWithCameraCallBack:(HUDDismissCompletion)cameraCallBack photoCallBack:(HUDDismissCompletion)photoCallBack;


// 验证是否可以打开相机，如果不可以打开，则跳转到对应的设置界面
- (BOOL)authCamera;


@end
