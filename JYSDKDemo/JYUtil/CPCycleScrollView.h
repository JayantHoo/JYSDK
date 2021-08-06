//
//  CPCycleScrollView.h
//  CollectionPlates
//
//  Created by jayant hoo on 2019/11/20.
//  Copyright © 2019 jayant hoo. All rights reserved.
//

#import "CPView.h"
@class CPCycleScrollView;

typedef enum {
    CPCycleScrollViewPageContolAlimentBottom,
    CPCycleScrollViewPageContolAlimentTop,
} CPCycleScrollViewPageContolAliment;

@protocol CPCycleScrollViewDelegate <NSObject>

@optional
/** 点击图片回调 */
- (void)cycleScrollView:(CPCycleScrollView *_Nullable)cycleScrollView didSelectItemAtIndex:(NSInteger)index;


/** 图片滚动回调 */
- (void)cycleScrollView:(CPCycleScrollView *_Nullable)cycleScrollView didScrollToIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CPCycleScrollView : CPView

@property (nonatomic,assign) CPCycleScrollViewPageContolAliment pageControlAliment;///

@property (nonatomic,weak) id<CPCycleScrollViewDelegate> delegate;

/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

/** 每张图片对应要显示的文字数组 */
@property (nonatomic, strong) NSArray *titlesGroup;

/** 本地图片数组 */
@property (nonatomic, strong) NSArray *localizationImageNamesGroup;

@property (nonatomic,assign) UIEdgeInsets contentInset;

@property (nonatomic,assign) CGFloat cornerRadius;/// 轮播图圆角

@property (nonatomic,assign) BOOL showPageControl;/// 是否显示圆点

@property (nonatomic,assign) BOOL showPage;/// 是否显示页码

@property (nonatomic,assign) BOOL autoScroll;///  是否自动轮播，默认为no

@property (nonatomic,assign) NSInteger bannerImageViewContentMode;

-(instancetype)initWithFrame:(CGRect)frame placeholderImage:(UIImage * _Nullable)image;

@property(nonatomic,assign) CGFloat autoScrollTimeInterval;

-(void)configCustomBanner:(NSArray *)list;

@end

NS_ASSUME_NONNULL_END
