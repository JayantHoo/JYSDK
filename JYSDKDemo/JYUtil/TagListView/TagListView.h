//
//  TagListView.h
//  TagObjc
//
//  Created by Javi Pulido on 16/7/15.
//  Copyright (c) 2015 Javi Pulido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagView;

IB_DESIGNABLE

@interface TagListView : UIView

typedef NS_ENUM(NSUInteger, TagListAlignment) {
    alignLeft = 0,
    alignCenter,
    alignRight
};

@property (nonatomic) IBInspectable UIColor *textColor;
@property (nonatomic) IBInspectable UIColor *selectedTextColor;
@property (nonatomic) IBInspectable UIColor *tagBackgroundColor;
@property (nonatomic) IBInspectable UIColor *selectedBackgroundColor;
@property (nonatomic) IBInspectable UIImage *tagBackgroundImage;//图片设置优先级高于颜色设置
@property (nonatomic) IBInspectable UIImage *selectedBackgroundImage;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable UIColor *selectedBorderColor;
@property (nonatomic) IBInspectable CGFloat paddingY;
@property (nonatomic) IBInspectable CGFloat paddingX;
@property (nonatomic) IBInspectable CGFloat marginY;
@property (nonatomic) IBInspectable CGFloat marginX;
@property (nonatomic) TagListAlignment alignment;
@property (nonatomic) UIFont *textFont;


// Delegate variables
@property (nonatomic) CGFloat tagViewHeight;
@property (nonatomic) NSMutableArray *tagViews;
@property (nonatomic) NSInteger rows;


@property (nonatomic, copy) void (^onTapTagAtTitle)(NSString *title);
@property (nonatomic, copy) void (^onTapTagAtIndex)(NSInteger index);


- (TagView *)addTag:(NSString *)title;
- (TagView *)insertTag:(NSString *)title atIndex:(NSInteger) index;
- (void)addTags:(NSArray<NSString *> *)titles;
- (void)setSelectedTagAtIndex:(NSInteger) index;
- (void)removeTag:(NSString *)title;
- (void)removeAllTags;

@end
