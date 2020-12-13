//
//  UIButton+JYOptions.m
//  JYSDKDemo
//
//  Created by isenu on 2018/4/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "UIButton+JYOptions.h"
#import <objc/runtime.h>

@implementation UIButton (JYOptions)

#pragma mark -setter / getter
-(void)setTitleFont:(UIFont *)titleFont
{
    self.titleLabel.font = titleFont;
}

-(UIFont *)titleFont
{
    return self.titleLabel.font;
}


-(void)jy_setNormalTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

-(void)jy_setHighlightedTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitleColor:titleColor forState:UIControlStateHighlighted];
}

-(void)jy_setSelectedTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitleColor:titleColor forState:UIControlStateSelected];
}

-(void)jy_setDisabledTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
    [self setTitle:title forState:UIControlStateDisabled];
    [self setTitleColor:titleColor forState:UIControlStateDisabled];
}

-(void)jy_setNormalImage:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

-(void)jy_setHighlightedImage:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
}

-(void)jy_setSelectedImage:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
}

-(void)jy_setDisabledImage:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
}

-(void)jy_setNormalBackgroundImage:(NSString *)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

-(void)jy_setSelectedBackgroundImage:(NSString *)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
}

-(void)jy_setHighlightedBackgroundImage:(NSString *)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
}

-(void)jy_setDisabledBackgroundImage:(NSString *)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
}

-(void)jy_makeButtonEdgeInsetType:(JYButtonEdgeInsetType )type WithSpace:(CGFloat) space
{
    switch (type) {
        case JYTitleBottonImageUpType:
        {
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0 ,-self.imageView.frame.size.width, -self.imageView.frame.size.height - space/2.0,0.0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height - space/2.0, 0.0,0.0, -self.titleLabel.intrinsicContentSize.width)];
            
        }
            break;
        case JYTitleUpImageBottonType:
        {
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0 ,-self.imageView.frame.size.width, self.imageView.frame.size.height + space/2.0,0.0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(self.titleLabel.intrinsicContentSize.height + space/2.0, 0.0,0.0, -self.titleLabel.intrinsicContentSize.width)];
            
        }
            break;
        case JYTitleLeftImageRightType:
        {
            self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0 ,-self.imageView.frame.size.width-space/2.0, 0.0,self.imageView.frame.size.width)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, self.titleLabel.intrinsicContentSize.width,0.0, -self.titleLabel.intrinsicContentSize.width-space/2.0)];
        }
            break;
        case JYTitleRightImageLeftType:
        {
            self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0 ,0.0, 0.0, - space/2.0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,  - space/2.0,0.0, 0.0)];
        }
            break;
        default:
            break;
    }
}

@end



@implementation UIButton (EnlargeTouchArea)

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}


@end
