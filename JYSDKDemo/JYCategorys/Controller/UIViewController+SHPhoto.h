//
//  UIViewController+SHPhoto.h
//  ShellProject
//
//  Created by jayant hoo on 2018/8/24.
//  Copyright © 2018年 jayant hoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^photoBlock)(UIImage *photo);

@interface UIViewController (SHPhoto)

/**
 *  照片选择->图库/相机
 *
 *  @param edit  照片是否需要裁剪,默认NO
 *  @param block 照片回调
 */
-(void)showCanEdit:(BOOL)edit photo:(photoBlock)block;

#pragma mark-跳到相机或相册 0：相机 1：相册
-(void)showPhotoPicker:(NSInteger)buttonIndex photo:(photoBlock)block;

- (BOOL)cameraPemission;

- (void)requestCameraPemissionWithResult:(void(^)( BOOL granted))completion;

- (BOOL)photoPermission;

@end
