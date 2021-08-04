//
//  CPEmptyView.h
//  CollectionPlates
//
//  Created by champ on 2019/12/26.
//  Copyright © 2019 jayant hoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EmptyType) {
    
    EmptyTypeNormal   = 1,    // 数据为空,通用
    EmptyTypeSearch   = 2,    // 搜索不到相关结果
    EmptyTypeNetWork  = 3,    // 暂无网络
    EmptyTypeService  = 4,    // 服务器崩溃

};

typedef void(^TouchCallBack)(void);



@interface CPEmptyView : UIView


/// 初始化
/// @param type 空视图类型
- (instancetype)initWihtType:(EmptyType)type;

/// 初始化
/// @param holder 空视图标题
/// @param imageName 空视图图片
- (instancetype)initWihtHoldertext:(NSString *)holder holderImage:(NSString*)imageName;

//******************************* 下面的是网络服务器错误专用 ***************************

/// 展示网络错误的视图
/// @param isNetworkError yes :网络不好 no:服务器出错了
/// @param callBack 点击刷新的回调
+ (void)showInView:(UIView *)superView isNetworkError:(BOOL)isNetworkError callback:(TouchCallBack)callBack;


/// 从父类移除， 如果网络请求失败调用了 showInTableView这方法，成功的时候必须调用此方法
+ (void)dissmissFromSuperView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
