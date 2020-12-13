//
//  UILabel+JYCategory_.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/13.
//  Copyright © 2020 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (JYCategory_)


+ (instancetype)labelWithFont:(NSInteger)fontSize
                    textColor:(UIColor *)textColor;

+ (instancetype)labelWithFont:(NSInteger)fontSize
                    textColor:(UIColor *)textColor
                textAlignment:(NSTextAlignment)textAlignment;

@end

NS_ASSUME_NONNULL_END
