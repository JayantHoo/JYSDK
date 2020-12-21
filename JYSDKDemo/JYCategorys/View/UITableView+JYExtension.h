//
//  UITableView+JYExtension.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (JYExtension)

/**
 * 使用以下两个方法注册的cell，identifier和类名保持一致
 * 推荐使用类名做cell的标识符
 * 使用该方法获取identifier字符串：
 * NSString *identifier = NSStringFromClass([UITableViewCell class])
 */
- (void)jy_registerCell:(Class)cls;
- (void)jy_registerNibCell:(Class)cls;

- (void)jy_registerCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier;
- (void)jy_registerNibCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier;

@end
