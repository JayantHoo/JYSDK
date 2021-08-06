//
//  UIButton+JYOptions.m
//  JYSDKDemo
//
//  Created by isenu on 2018/4/26.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "UIButton+JYOptions.h"
#import <objc/runtime.h>

static NSString *action_key = @"buttonActionBlockKey";

@implementation UIButton (JYOptions)


+ (instancetype)buttonWithTitle:(NSString *_Nullable) title
                     titleColor:(UIColor *_Nullable)  titleColor
                   disableTitle:(NSString *_Nullable) disableTitle
              disableTitleColor:(UIColor *_Nullable)  disableTitleColor {
    
    return [UIButton buttonWithTitle:title
                          titleColor:titleColor
                        disableTitle:disableTitle
                   disableTitleColor:disableTitleColor
                     backgroundImage:nil
              disableBackgroundImage:nil];
}

+ (instancetype)buttonWithTitle:(NSString *_Nullable) title
                     titleColor:(UIColor *_Nullable)  titleColor
                   disableTitle:(NSString *_Nullable) disableTitle
              disableTitleColor:(UIColor *_Nullable)  disableTitleColor
                backgroundImage:(UIImage *_Nullable) backgroundImage
         disableBackgroundImage:(UIImage *_Nullable) disableBackgroundImage {
    
    return [UIButton buttonWithTitle:title
                          titleColor:titleColor
                          stateTitle:disableTitle
                     stateTitleColor:disableTitleColor
                   titleControlState:UIControlStateDisabled
                         normalImage:nil
                          stateImage:nil
                   imageControlState:0
                     backgroundImage:backgroundImage
                stateBackgroundImage:disableBackgroundImage
              backgroundControlState:UIControlStateDisabled];
    
}

+(instancetype)buttonWithTitle:(NSString *_Nullable) title
                    titleColor:(UIColor *_Nullable)  titleColor
                   selectTitle:(NSString *_Nullable) selectTitle
              selectTitleColor:(UIColor *_Nullable)  selectTitleColor {
    
    return [UIButton buttonWithTitle:title
                          titleColor:titleColor
                         selectTitle:selectTitle
                    selectTitleColor:selectTitleColor
                     normalImageName:nil
                     selectImageName:nil];
    
}

+ (instancetype)buttonWithTitle:(NSString *_Nullable) title
                     titleColor:(UIColor *_Nullable)  titleColor
                    selectTitle:(NSString *_Nullable) selectTitle
               selectTitleColor:(UIColor *_Nullable)  selectTitleColor
                normalImageName:(UIImage *_Nullable) image
                selectImageName:(UIImage *_Nullable) selectImage {
    
    return [UIButton buttonWithTitle:title
                          titleColor:titleColor
                          stateTitle:selectTitle
                     stateTitleColor:selectTitleColor
                   titleControlState:UIControlStateSelected
                         normalImage:image
                          stateImage:selectImage
                   imageControlState:UIControlStateSelected
                     backgroundImage:nil
                stateBackgroundImage:nil
              backgroundControlState:0];
    
}


+ (instancetype)buttonWithTitle:(NSString *_Nullable) title
                     titleColor:(UIColor *_Nullable)  titleColor
                     stateTitle:(NSString *_Nullable) stateTitle
                stateTitleColor:(UIColor *_Nullable)  stateTitleColor
              titleControlState:(UIControlState)      titleControlState
                    normalImage:(UIImage *_Nullable)  image
                     stateImage:(UIImage *_Nullable)  stateImage
              imageControlState:(UIControlState)      imageControlState
                backgroundImage:(UIImage *_Nullable)  backgroundImage
           stateBackgroundImage:(UIImage *_Nullable)  stateBackgroundImage
         backgroundControlState:(UIControlState)      backgroundControlState {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (stateTitle) {
        [button setTitle:stateTitle forState:titleControlState];
    }
    if (stateTitleColor) {
        [button setTitleColor:stateTitleColor forState:titleControlState];
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (stateImage) {
        [button setImage:stateImage forState:imageControlState];
    }
    if (backgroundImage) {
        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    if (stateBackgroundImage) {
        [button setBackgroundImage:stateBackgroundImage forState:backgroundControlState];
    }
    return button;
    
}





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

-(void)hightDelete:(UIButton *)sender
{
    sender.highlighted = NO;
}

- (void)cp_buttonAction:(UIButton *)sender{
    
    self.userInteractionEnabled = NO;
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.userInteractionEnabled = YES;
    });
    ButtonActionCallBack block = (ButtonActionCallBack)objc_getAssociatedObject(self, &action_key);
    if (block) {
        block(sender);
    }
}

-(void)addCallBackAction:(ButtonActionCallBack)action
        forControlEvents:(UIControlEvents)controlEvents
{
    objc_setAssociatedObject(self, &action_key, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(hightDelete:) forControlEvents:UIControlEventAllEvents];
    [self addTarget:self action:@selector(cp_buttonAction:) forControlEvents:controlEvents];
}

-(void)addCallBackAction:(ButtonActionCallBack)action
{
    [self addCallBackAction:action forControlEvents:UIControlEventTouchUpInside];
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
