//
//  UIViewController+SHPhoto.m
//  ShellProject
//
//  Created by jayant hoo on 2018/8/24.
//  Copyright © 2018年 jayant hoo. All rights reserved.
//

#import "UIViewController+SHPhoto.h"
#import "objc/runtime.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CPAlertSheet.h"

static  BOOL canEdit = NO;
static  char blockKey;

@interface UIViewController()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,copy)photoBlock photoBlock;

@end

@implementation UIViewController (SHPhoto)

#pragma mark-set
-(void)setPhotoBlock:(photoBlock)photoBlock
{
    objc_setAssociatedObject(self, &blockKey, photoBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark-get
- (photoBlock )photoBlock
{
    return objc_getAssociatedObject(self, &blockKey);
}
-(void)showCanEdit:(BOOL)edit photo:(photoBlock)block
{
    if(edit) canEdit = edit;
    
    self.photoBlock = [block copy];
    //自定义sheet
    [CPAlertSheet showSheetWithActionTitles:@[@"拍照",@"我的相册"] atView:self.view handler:^(NSInteger index) {
        if ([self isOpenedPhotosAuthority:index]) {
            [self presentToPhotoPicker:index];
        }
    }];
    
//    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    
//    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if ([self isOpenedPhotosAuthority:0]) {
//            [self presentToPhotoPicker:0];
//        }
//    }];
//    [cameraAction setValue:CP40Color forKey:@"titleTextColor"];
//    [alertVc addAction:cameraAction];
//
//    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册中获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if ([self isOpenedPhotosAuthority:1]) {
//            [self presentToPhotoPicker:1];
//        }
//    }];
//    [photoAction setValue:CP40Color forKey:@"titleTextColor"];
//    [alertVc addAction:photoAction];
//
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [cancelAction setValue:CP40Color forKey:@"titleTextColor"];
//    [alertVc addAction:cancelAction];
//
//    [self presentViewController:alertVc animated:YES completion:nil];
}


#pragma mark-跳到相机或相册 0：相机 1：相册
-(void)showPhotoPicker:(NSInteger)buttonIndex photo:(photoBlock)block
{
    self.photoBlock = [block copy];
    if ([self isOpenedPhotosAuthority:buttonIndex]) {
        [self presentToPhotoPicker:buttonIndex];
    }
}
#pragma mark - 权限
//跳转到设置修改权限 0:相机 1:相册
-(void)pushToSetting:(NSInteger)type
{
    NSString *title = nil;
    NSString *photoType = type ==0?@"相机":@"相册";
    NSString *msg = [NSString stringWithFormat:@"还没有开启%@权限,请在系统设置中开启",photoType];
    NSString *cancelTitle = @"暂不";
    NSString *otherButtonTitles = @"去设置";
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:CP40Color forKey:@"titleTextColor"];
    [alertVc addAction:cancelAction];
    
    UIAlertAction *goAction = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CGFloat kSystemMainVersion = [UIDevice currentDevice].systemVersion.floatValue;
        if (kSystemMainVersion >= 8.0) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }];
    [goAction setValue:CP40Color forKey:@"titleTextColor"];
    [alertVc addAction:goAction];
    
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

//是否已开启相册相机权限 0:相机 1:相册
-(BOOL)isOpenedPhotosAuthority:(NSInteger)type
{
    //权限
    if (type == 0) {
        return [self cameraPemission];
    }
    
    if (type == 1) {
        return [self photoPermission];
    }
    
    return YES;
}

- (BOOL)cameraPemission
{
    BOOL isHavePemission = YES;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                isHavePemission = NO;
                break;
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = YES;
                break;
        }
    }
    
    if (!isHavePemission) {
        [self pushToSetting:0];
    }
    
    return isHavePemission;
}


- (void)requestCameraPemissionWithResult:(void(^)( BOOL granted))completion
{
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                completion(YES);
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                completion(NO);
                break;
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                         completionHandler:^(BOOL granted) {
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if (granted) {
                                                     completion(true);
                                                 } else {
                                                     completion(false);
                                                 }
                                             });
                                             
                                         }];
            }
                break;
                
        }
    }
    
    
}


- (BOOL)photoPermission
{
    BOOL isHavePemission = YES;
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusDenied ) {
        
        isHavePemission = NO;
    }
    
    if (!isHavePemission) {
        [self pushToSetting:1];
    }
    
    return YES;
}

#pragma mark-跳到相机或相册
-(void)presentToPhotoPicker:(NSInteger)buttonIndex
{
    //跳转到相机/相册页面
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    imagePickerController.mediaTypes = mediaTypes;
    imagePickerController.navigationBar.translucent = NO;//这句话设置导航栏不透明(!!!!!!!!!!!!!!!!!!!!!!!!! )
    //设置返回按钮字体颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    switch (buttonIndex)
    {
        case 0:
            //拍照
            //是否支持相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePickerController animated:YES completion:NULL];
            }
            else
            {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该设备不支持相机" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [cancelAction setValue:CP40Color forKey:@"titleTextColor"];
                [alertVc addAction:cancelAction];
            
                
                [self presentViewController:alertVc animated:YES completion:nil];
                
            }
            break;
        case 1:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                //相册
                imagePickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该设备相册不可用" preferredStyle:UIAlertControllerStyleAlert];
                    
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [cancelAction setValue:CP40Color forKey:@"titleTextColor"];
                [alertVc addAction:cancelAction];
            
                [self presentViewController:alertVc animated:YES completion:nil];

            }
            
        default:
            break;
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //是否要裁剪
    if ([picker allowsEditing]){

        //编辑之后的图像
        image = [info objectForKey:UIImagePickerControllerEditedImage];

    } else {

        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if(self.photoBlock)
    {
        self.photoBlock(image);
    }
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
