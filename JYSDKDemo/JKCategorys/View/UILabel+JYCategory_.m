//
//  UILabel+JYCategory_.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/13.
//  Copyright © 2020 isenu. All rights reserved.
//

#import "UILabel+JYCategory_.h"

@implementation UILabel (JYCategory_)

+ (instancetype)labelWithFont:(NSInteger)fontSize
                    textColor:(UIColor *)textColor
{
    return [UILabel labelWithFont:fontSize textColor:textColor textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)labelWithFont:(NSInteger)fontSize
                    textColor:(UIColor *)textColor
                textAlignment:(NSTextAlignment)textAlignment
{
    
    UILabel *label = [[UILabel alloc] init];
    label.font = JYRegularFont(fontSize);
    label.textColor = textColor;
    if (textAlignment) {
        label.textAlignment = textAlignment;
    }
    label.numberOfLines = 0;
    return label;
}

@end
