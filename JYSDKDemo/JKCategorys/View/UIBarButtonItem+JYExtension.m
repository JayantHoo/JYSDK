//
//  UIBarButtonItem+JYExtension.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/6/28.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "UIBarButtonItem+JYExtension.h"
#import "JYBackButton.h"

@implementation UIBarButtonItem (JYExtension)

+ (UIBarButtonItem *)jy_itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    JYBackButton*button = [[JYBackButton alloc] init];
    
    if(imageName) [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if(highImageName) [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 100, 44);
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

+ (UIBarButtonItem *)jy_itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    return [UIBarButtonItem jy_itemWithImageName:imageName highImageName:nil target:target action:action];
}







+ (UIBarButtonItem *)jy_systemItemWithTitle:(NSString *)title
                                 titleColor:(UIColor *)titleColor
                                  imageName:(NSString *)imageName
                                     target:(id)target
                                   selector:(SEL)selector
                                   textType:(BOOL)textType {
    UIBarButtonItem *item = textType ?
    ({
        /// 设置普通状态的文字属性
        item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
        titleColor = titleColor?titleColor:[UIColor whiteColor];
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName] = titleColor;
        textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16.0f];
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset =  CGSizeZero;
        textAttrs[NSShadowAttributeName] = shadow;
        [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
        
        // 设置高亮状态的文字属性
        NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
        highTextAttrs[NSForegroundColorAttributeName] = [titleColor colorWithAlphaComponent:.5f];
        [item setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
        
        // 设置不可用状态(disable)的文字属性
        NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
        disableTextAttrs[NSForegroundColorAttributeName] = [titleColor colorWithAlphaComponent:.5f];
        [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
        
        item;
    }) : ({
        item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:target action:selector];
        item;
    });
    return item;
}

+ (UIBarButtonItem *)jy_customItemWithTitle:(NSString *)title
                                 titleColor:(UIColor *)titleColor
                                  imageName:(NSString *)imageName
                                     target:(id)target
                                   selector:(SEL)selector
                 contentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment{
    UIButton *item = [[UIButton alloc] init];
    titleColor = titleColor?titleColor:[UIColor whiteColor];
    if (JYStringIsNotEmpty(title)) {
        [item setTitle:title forState:UIControlStateNormal];
    }
    
    if (JYStringIsNotEmpty(imageName)) {
        [item setImage:[UIImage jy_imageAlwaysShowOriginalImageWithImageName:imageName] forState:UIControlStateNormal];
    }
    [item.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [item setTitleColor:titleColor forState:UIControlStateNormal];
    [item setTitleColor:[titleColor colorWithAlphaComponent:.5f] forState:UIControlStateHighlighted];
    [item setTitleColor:[titleColor colorWithAlphaComponent:.5f] forState:UIControlStateDisabled];
    [item sizeToFit];
    item.jy_size = CGSizeMake(44, 44);
    item.contentHorizontalAlignment = contentHorizontalAlignment;
    [item addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:item];
}


/// 返回按钮 带箭头的
+ (UIBarButtonItem *)jy_backItemWithTitle:(NSString *)title
                                imageName:(NSString *)imageName
                                   target:(id)target
                                   action:(SEL)action
{
    return [self jy_customItemWithTitle:title titleColor:nil imageName:imageName target:target selector:action contentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
}

@end
