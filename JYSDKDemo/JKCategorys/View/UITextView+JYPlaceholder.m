//
//  UITextView+JYPlaceholder.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/18.
//  Copyright © 2020 isenu. All rights reserved.
//

#import "UITextView+JYPlaceholder.h"
#import <objc/runtime.h>
#import "NSObject+JYRuntime.h"

@interface UITextView ()
@property (nonatomic, strong) UILabel *jy_placeholderLabel;
@end

@implementation UITextView (JYPlaceholder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSClassFromString(@"UITextView") swapMethod:@selector(setText:) currentMethod:@selector(jy_setText:)];
        [NSClassFromString(@"UITextView") swapMethod:@selector(layoutSubviews) currentMethod:@selector(jy_layoutSubviews)];
        [NSClassFromString(@"UITextView") swapMethod:NSSelectorFromString(@"dealloc") currentMethod:@selector(jy_dealloc)];
    });
}

- (void)jy_dealloc {
    [self jy_dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)jy_setText:(NSString *)jy_text {
    [self jy_setText:jy_text];
    self.jy_placeholderLabel.hidden = jy_text.length;
}

- (void)jy_layoutSubviews {
    [self jy_layoutSubviews];
    UIEdgeInsets insets = self.textContainerInset;
    CGRect placeholderRect = CGRectMake(insets.left+3, insets.top-3, CGRectGetWidth(self.frame)-insets.left-insets.right, self.jy_placeholderFont.lineHeight+3);
    self.jy_placeholderLabel.frame = placeholderRect;
    [self bringSubviewToFront:self.jy_placeholderLabel];
}

- (void)jy_textDidChange {
    self.jy_placeholderLabel.hidden = self.text.length;
}

- (void)setJy_placeholder:(NSString *)placeholder {
    self.jy_placeholderLabel.text = placeholder;
}
 
- (NSString *)jy_placeholder {
    return self.jy_placeholderLabel.text;
}

- (void)setJy_placeholderFont:(UIFont *)placeholderFont {
    self.jy_placeholderLabel.font = placeholderFont;
}

- (UIFont *)jy_placeholderFont {
    return self.jy_placeholderLabel.font;
}

- (void)setJy_placeholderColor:(UIColor *)placeholderColor {
    self.jy_placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)jy_placeholderColor {
    return self.jy_placeholderLabel.textColor;
}

- (UILabel *)jy_placeholderLabel {
    UILabel *placeholderLabel = objc_getAssociatedObject(self, _cmd);
    if (!placeholderLabel) {
        
        placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 0, 0)];
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.font = self.font;
        objc_setAssociatedObject(self,
                                 _cmd,
                                 placeholderLabel,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:placeholderLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jy_textDidChange) name:UITextViewTextDidChangeNotification object:nil];
        [self bringSubviewToFront:placeholderLabel];
        
    }
    return placeholderLabel;
}

- (void)setJy_placeholderLabel:(UILabel *)jy_placeholderLabel {
    objc_setAssociatedObject(self,
                             @selector(jy_placeholderLabel),
                             jy_placeholderLabel,
                             OBJC_ASSOCIATION_RETAIN);
}




@end
