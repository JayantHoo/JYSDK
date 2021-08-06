//
//  CPCycleScrollView.m
//  CollectionPlates
//
//  Created by jayant hoo on 2019/11/20.
//  Copyright © 2019 jayant hoo. All rights reserved.
//

#import "CPCycleScrollView.h"
#import <SDCycleScrollView.h>
#import "CPPageControl.h"

@interface CPCycleScrollView ()<SDCycleScrollViewDelegate,CPPageControlDelegate>

@property (nonatomic,strong) SDCycleScrollView *cycleView;

@property (nonatomic,strong) UIImage *placeholderImage;

@property (nonatomic,strong) CPPageControl *pageControl;

@property (nonatomic,strong) UILabel *pageLabel;

@end

@implementation CPCycleScrollView



- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame placeholderImage:nil];
}

-(instancetype)initWithFrame:(CGRect)frame placeholderImage:(UIImage * _Nullable)image
{
    if (self = [super initWithFrame:frame]) {
        _pageControlAliment = CPCycleScrollViewPageContolAlimentBottom;
        self.placeholderImage = image;
        [self setupSubView];
    }
    return self;
}

-(void)setupSubView
{
    self.backgroundColor = CPWhiteColor;
    SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:self.placeholderImage];
    cycleView.backgroundColor = [UIColor clearColor];
    cycleView.delegate = self;
    cycleView.autoScroll = NO;
    cycleView.showPageControl = NO;
    cycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cycleView.clipsToBounds = YES;
    [self addSubview:cycleView];
    self.cycleView = cycleView;
}

-(void)setBannerImageViewContentMode:(NSInteger)bannerImageViewContentMode
{
    self.cycleView.bannerImageViewContentMode = bannerImageViewContentMode;
}

-(void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    self.pageControl.hidden = !showPageControl;
}

-(void)setShowPage:(BOOL)showPage
{
    _showPage = showPage;
    [self updatePageLabel:0];
}

-(void)setupPageControlLayout
{
    if (_pageControlAliment == CPCycleScrollViewPageContolAlimentTop) {
        self.pageControl.top = 10;
    }else if (_pageControlAliment == CPCycleScrollViewPageContolAlimentBottom) {
        self.pageControl.bottom = self.height-10;
    }
}

-(void)setPageControlAliment:(CPCycleScrollViewPageContolAliment)pageControlAliment
{
    if (_pageControlAliment != pageControlAliment) {
        _pageControlAliment = pageControlAliment;
        [self setupPageControlLayout];
    }
}

-(void)setContentInset:(UIEdgeInsets)contentInset
{
    _contentInset = contentInset;
    CGFloat top = contentInset.top;
    CGFloat left = contentInset.left;
    CGFloat right = contentInset.right;
    CGFloat bottom = contentInset.bottom;
    self.cycleView.frame = CGRectMake(left, top, self.width-left-right, self.height-top-bottom);
}

-(void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup
{
    _imageURLStringsGroup = imageURLStringsGroup;
    self.cycleView.imageURLStringsGroup = imageURLStringsGroup;
    self.pageControl.numberOfPages = imageURLStringsGroup.count;
    [self updatePageLabel:0];
}

-(void)configCustomBanner:(NSArray *)list
{
    self.cycleView.imageURLStringsGroup = list;
    self.pageControl.numberOfPages = list.count;
}

-(void)setTitlesGroup:(NSArray *)titlesGroup
{
    _titlesGroup = titlesGroup;
    self.cycleView.titlesGroup = titlesGroup;
   
}

-(void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    self.cycleView.autoScrollTimeInterval = autoScrollTimeInterval;
}

- (void)setAutoScroll:(BOOL)autoScroll {
    
    self.cycleView.autoScroll = autoScroll;
}

-(void)setLocalizationImageNamesGroup:(NSArray *)localizationImageNamesGroup
{
    _localizationImageNamesGroup = localizationImageNamesGroup;
    self.cycleView.localizationImageNamesGroup = localizationImageNamesGroup;
    self.pageControl.numberOfPages = localizationImageNamesGroup.count;
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    self.cycleView.cornerRadius = cornerRadius;
    self.cycleView.masksToBounds = YES;
}



-(CPPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[CPPageControl alloc] initWithFrame:CGRectMake(0, self.height-30-10, self.width, 30)];
        _pageControl.currentSize = CGSizeMake(10, 10);
        _pageControl.otherSize = CGSizeMake(6, 6);
        _pageControl.controlSpacing = 5;
        _pageControl.currentBkImg = CPImageNamed(@"banner_currentpagedot");
        _pageControl.otherBkImg = CPImageNamed(@"banner_pagedot");
        _pageControl.delegate = self;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

-(UILabel *)pageLabel
{
    if (!_pageLabel) {
        _pageLabel = [UILabel labelWithFont:12 textColor:CPWhiteColor textAlignment:NSTextAlignmentCenter];
        _pageLabel.backgroundColor = [CPTitleColor colorWithAlphaComponent:0.6];
        _pageLabel.size = CGSizeMake(30, 18);
        _pageLabel.right = self.width-16;
        _pageLabel.bottom = self.height-16;
        [self addSubview:_pageLabel];
        [_pageLabel jy_cornerRadius:9];
        
    }
    return _pageLabel;
}


/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:index];
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:index];
    }
    [self.pageControl selectedAtIndex:index];
    [self updatePageLabel:index];
}

-(void)cp_pageControlClick:(CPPageControl*)pageControl index:(NSInteger)clickIndex;
{
    [self.cycleView makeScrollViewScrollToIndex:clickIndex];
    [self updatePageLabel:clickIndex];
}

-(void)updatePageLabel:(NSInteger)index
{
    self.pageLabel.hidden = !self.showPage;
    if (self.imageURLStringsGroup.count <=1) {
        self.pageLabel.hidden = YES;
        return;
    }
    self.pageLabel.text = CPSTRINGFORMAT(@"%ld/%ld",index+1,self.imageURLStringsGroup.count);
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.cycleView.frame = self.bounds;
    if (_pageControlAliment == CPCycleScrollViewPageContolAlimentTop) {
        self.pageControl.top = 10;
    }else if (_pageControlAliment == CPCycleScrollViewPageContolAlimentBottom) {
        self.pageControl.bottom = self.height-10;
    }
    self.pageLabel.right = self.width-16;
    self.pageLabel.bottom = self.height-16;
}

@end
