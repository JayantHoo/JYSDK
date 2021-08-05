//
//  UIView+HUD.m
//  omgmall
//
//  Created by champ on 2018/9/21.
//  Copyright © 2018年 omgmall. All rights reserved.
//

#import "UIView+HUD.h"
#import <objc/runtime.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

static CGFloat durationTime = 1.5;  // 默认显示时长

@implementation UIView (HUD)
- (void)showLoadingHUD {
    
    [self showWithStatus:nil icon:nil dismissWithDelay:0 load:YES  completion:nil];
}

- (void)showHUDWithStatus:(NSString *)status {
    
    [self showWithStatus:status icon:nil dismissWithDelay:0 load:YES completion:nil];
}

- (void)showTextHUDWithStatus:(NSString *)status {
    
    [self showWithStatus:status icon:nil dismissWithDelay:durationTime load:NO completion:nil];
}

- (void)showSuccessHUDStatus:(NSString *)status {
    
    [self showSuccessHUDWithStatus:status dismissWithDelay:durationTime completion:nil];
}

- (void)showErrorHUDStatus:(NSString *)status {
    
    [self showErrorHUDWithStatus:status dismissWithDelay:durationTime completion:nil];
}

-(void)showInfoHUDWithStatus:(NSString *)status {
    
    [self showInfoHUDWithStatus:status dismissWithDelay:durationTime completion:nil];
    
}

- (void)showSuccessHUDWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay completion:(HUDDismissCompletion)completion {

    [self showWithStatus:status icon:@"hud_icon_success" dismissWithDelay:delay load:NO  completion:completion];
}

- (void)showErrorHUDWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay completion:(HUDDismissCompletion)completion {
    

    [self showWithStatus:status icon:@"hud_icon_error" dismissWithDelay:delay load:NO  completion:completion];
}

- (void)showInfoHUDWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay completion:(HUDDismissCompletion)completion {

    [self showWithStatus:status icon:@"hud_icon_info" dismissWithDelay:delay load:YES completion:completion];
    
}

- (void)showWithStatus:(NSString *)status icon:(NSString*)icon dismissWithDelay:(NSTimeInterval)delay load:(BOOL)loading completion:(HUDDismissCompletion)completion {
    
    // 在新创之前先删除之前的
    [MBProgressHUD hideHUDForView:self animated:NO];
    
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self];
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    hud.detailsLabelColor =  [UIColor whiteColor];
    [self addSubview:hud];
    
    [hud show:YES];
    hud.removeFromSuperViewOnHide=YES;
    
    if (loading == NO)
    {
        hud.mode = MBProgressHUDModeText;
    }
    
    if (icon)
    {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
        hud.mode = MBProgressHUDModeCustomView;
    }
    
    if (status)
    {
        hud.detailsLabelText = status;
    }
    
    if (delay)
    {
        [hud hide:YES afterDelay:delay];
    }
    
    hud.completionBlock = ^{
        
        if (completion) {
            completion();
        }
    };
    
}

- (void)dismissHUD {
    
    [MBProgressHUD hideHUDForView:self animated:YES];
    
}

- (void)showOpacityLoadingHUD {
    
    [self showOpacityHUDWithStatus:nil];
}

- (void)showOpacityHUDWithStatus:(NSString*)status {
    
    // 在新创之前先删除之前的
    [MBProgressHUD hideHUDForView:self animated:NO];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self];
    hud.backgroundColor = [UIColor whiteColor];
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    hud.detailsLabelColor =  [UIColor whiteColor];
    [self addSubview:hud];
    
    if (status){
           hud.detailsLabelText = status;
       }
    
    [hud show:NO];
    hud.removeFromSuperViewOnHide=YES;

}

 - (void)showProgress:(float)progress{
     [self showProgress:progress status:nil];
}

- (void)showProgress:(float)progress status:(NSString*)status {
    
    // 在新创之前先删除之前的
     [MBProgressHUD hideHUDForView:self animated:NO];
     
     MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self];
     hud.mode = MBProgressHUDModeAnnularDeterminate;
     hud.detailsLabelFont = [UIFont systemFontOfSize:16];
     hud.detailsLabelColor =  [UIColor whiteColor];
     hud.progress = progress;
     [self addSubview:hud];
     
     if (status){
            hud.detailsLabelText = status;
        }
     
     [hud show:NO];
     hud.removeFromSuperViewOnHide=YES;
}



- (void)showSystemAlertViewWithTilte:(NSString *)title secondTitle:(NSString *)secondTitle sureButtonTitle:(NSString *)sureButtonTitle {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:secondTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:sureButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelAction];
    [[self viewController] presentViewController:alert animated:YES completion:nil];
    
}

- (void)showSystemAlertViewWithTilte:(NSString *)title secondTitle:(NSString *)secondTitle sureButtonTitle:(NSString *)sureButtonTitle cancelButtonTitle:(NSString *)cancelBtnTitle sureCompletion:(HUDDismissCompletion)completion{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:secondTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (completion) {
            completion();
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [[self viewController] presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)showSystemActionSheetWithCameraCallBack:(HUDDismissCompletion)cameraCallBack photoCallBack:(HUDDismissCompletion)photoCallBack{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"打开相机"
                                                           style:(UIAlertActionStyleDefault)
                                                         handler:^(UIAlertAction *action) {
                                                             
                                                             [self verifyCameraCameraCallBack:cameraCallBack];
                                                             
                                                         }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册"
                                                          style:(UIAlertActionStyleDefault)
                                                        handler:^(UIAlertAction *action) {
                                                            
                                                            if (photoCallBack) {
                                                                photoCallBack();
                                                            }
                                                            
                                                        }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:cameraAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [[self viewController] showDetailViewController:alert sender:nil];
    
}

- (void)verifyCameraCameraCallBack:(HUDDismissCompletion)cameraCallBack {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
                            if (cameraCallBack) {
                                cameraCallBack();
                            }
                            
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                
                if (cameraCallBack) {
                    cameraCallBack();
                }
                break;
            }
            case AVAuthorizationStatusDenied: {
                
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
                NSString *adviceMsg =[NSString stringWithFormat:@"请去-> 【设置 - 隐私 - 相机 - %@】 打开访问开关",app_Name];
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:adviceMsg  preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [alertC addAction:alertB];
                [[self viewController] presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [[self viewController] presentViewController:alertC animated:YES completion:nil];
}


- (BOOL)authCamera {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *adviceMsg =[NSString stringWithFormat:@"请去-> 【设置 - 隐私 - 相机 - %@】 打开访问开关",app_Name];
    if (status == AVAuthorizationStatusDenied ) {
        [self showSystemAlertViewWithTilte:@"温馨提示" secondTitle:adviceMsg sureButtonTitle:@"确定" cancelButtonTitle:@"取消" sureCompletion:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        return NO;
    }
    
    return YES;
}



    
    


@end
