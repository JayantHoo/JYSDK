//
//  JYSegmentView.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2019/4/15.
//  Copyright © 2019 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYSegmentView;

@protocol JYSegmentViewDelegate <NSObject>

@optional
///点击标签回调
- (void)segmentView:(JYSegmentView *)segmentView didSelectedAtIndex:(NSInteger)index;

@end


@interface JYSegmentView : UIView

@property (nonatomic,weak) id<JYSegmentViewDelegate> delegate;

@property (nonatomic,copy) UIColor *sliderColor;//移动条颜色

@property (nonatomic,assign) CGSize sliderSize;//移动条大小

@property (nonatomic,copy) UIImage *sliderImage;//移动条背景图片

@property (nonatomic,assign) CGFloat sliderBottomInset;

@property (nonatomic,copy) UIColor *itemTitleNormalColor;

@property (nonatomic,copy) UIColor *itemTitleSelectedColor;

@property (nonatomic,strong) UIFont *itemFont;

@property (nonatomic,assign) BOOL hiddenSlider;//隐藏下面的移动条

/**
 初始化方法
 @param titles 标题数组
 @param frame frame
 @return LYSegmentView
 */
-(instancetype) initWithTitels:(NSArray *)titles frame:(CGRect)frame;

//手动刷新segment(设置item的属性后调用)
-(void)updateViewLayout;

@end

