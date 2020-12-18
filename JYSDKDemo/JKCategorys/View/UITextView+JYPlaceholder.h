//
//  UITextView+JYPlaceholder.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/18.
//  Copyright © 2020 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JYTextView <NSObject>

@required
@property (nonatomic, strong) UIColor *jy_placeholderColor;
@property (nonatomic, copy) NSString *jy_placeholder;
@property (nonatomic, strong) UIFont *jy_placeholderFont;//默认为textView的font

@end

@interface UITextView (JYPlaceholder)<JYTextView>



@end

NS_ASSUME_NONNULL_END
