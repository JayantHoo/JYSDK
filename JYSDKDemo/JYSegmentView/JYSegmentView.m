//
//  JYSegmentView.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2019/4/15.
//  Copyright © 2019 isenu. All rights reserved.
//

#import "JYSegmentView.h"

@interface JYSegmentView ()

@property (nonatomic,copy) NSArray *titles;

@property (nonatomic,assign) CGFloat space;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,assign) CGFloat itemWidth;

@property (nonatomic,strong) UIButton *selectedItem;

@property (nonatomic,assign) BOOL isShowConfig;

@property (nonatomic,strong) UIView *sliderView;//移动条

@property (nonatomic,assign) CGFloat contentOffsetX;//记录偏移位置

@property (nonatomic,strong) UIImageView *jyBackgroundView;

@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation JYSegmentView

-(instancetype)initWithTitels:(NSArray *)titles frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titles = titles;
        _itemTitleNormalColor = [UIColor lightGrayColor];
        _itemTitleSelectedColor = [UIColor blackColor];
        _itemFont = [UIFont systemFontOfSize:20];
        _space = 10.0f;
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithTitels:[NSArray new] frame:frame];
}

-(void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    
//    _itemWidth = self.jy_width/self.titles.count - _space;
    for (NSInteger i=0; i<self.titles.count; i++) {
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        [item jy_setNormalTitle:self.titles[i] titleColor:_itemTitleNormalColor];
        [item jy_setSelectedTitle:self.titles[i] titleColor:_itemTitleSelectedColor];
        [item addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [item.titleLabel sizeToFit];
        item.tag = 1000+i;
        
        [self.scrollView addSubview:item];
    }
    
    UIView *sliderView = [[UIView alloc] initWithFrame:CGRectMake((20+_space)*0, self.scrollView.jy_height-4, 20, 4)];
    sliderView.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:sliderView];
    self.sliderView = sliderView;
    
    
    self.scrollView.contentSize = CGSizeMake((_itemWidth + _space)*_titles.count, self.scrollView.jy_height);
//    [self clickedBtn:self.selectedItem];//设置默认选中
}

//点击item
-(void)clickedBtn:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:didSelectedAtIndex:)]) {
        [self.delegate segmentView:self didSelectedAtIndex:sender.tag - 1000];
    }
    [self setselectedItemAtIndex:sender.tag -1000];
}

//设置选中
-(void)setselectedItemAtIndex:(NSInteger) index
{
    if (index == _currentIndex) {
        return;
    }
    _currentIndex = index;
    UIButton *selectBtn = (UIButton *)[self.scrollView viewWithTag:index +1000];
    self.selectedItem.selected = NO;
//    self.selectedItem.titleLabel.font = [UIFont systemFontOfSize:_itemFontSize];
    selectBtn.selected = YES;
//    selectBtn.titleLabel.font = [UIFont systemFontOfSize:_itemFontSize];
    self.selectedItem = selectBtn;
    [UIView animateWithDuration:0.25 animations:^{
        self.sliderView.jy_centerX = self.selectedItem.jy_centerX;
    }];
    
    //判断当前选中的标签按钮是否在屏幕中显示
    if ([self isDisplayedInScreen:selectBtn]) {
        return;
    }
    
    CGFloat contentOffsetX = 0;
    if (CGRectGetMaxX(self.selectedItem.frame) > self.scrollView.jy_width) {
        contentOffsetX = (CGRectGetMaxX(self.selectedItem.frame) - self.scrollView.jy_width);
    }
    
    self.scrollView.contentOffset = CGPointMake(contentOffsetX, 0);
    self.contentOffsetX = contentOffsetX;
}

//判断当前选中的标签按钮是否在屏幕中显示
-(BOOL) isDisplayedInScreen:(UIButton *)btn
{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGFloat x=[btn convertRect: btn.bounds toView:window].origin.x;
    if (x> 0 && x< (self.jy_width-(_itemWidth +_space))) {
        return YES;
    }
    return NO;
}

#pragma mark - set方法
-(void)setHiddenSlider:(BOOL)hiddenSlider
{
    _hiddenSlider = hiddenSlider;
    self.sliderView.hidden = hiddenSlider;
}

-(void)setSliderSize:(CGSize)sliderSize
{
    self.sliderView.jy_size = sliderSize;
}

- (void)setSliderBottomInset:(CGFloat)sliderBottomInset
{
    self.sliderView.jy_bottom = self.scrollView.jy_height-sliderBottomInset;
}

-(void)setSliderColor:(UIColor *)sliderColor
{
    self.sliderView.backgroundColor = sliderColor;
}

-(void)setSliderImage:(UIImage *)sliderImage
{
    self.sliderView.layer.contents = (id)sliderImage.CGImage;
}

-(void)setItemTitleNormalColor:(UIColor *)itemTitleNormalColor
{
    _itemTitleNormalColor = itemTitleNormalColor;
}

-(void)setItemFont:(UIFont *)itemFont
{
    _itemFont = itemFont;

}

-(void)setItemTitleSelectedColor:(UIColor *)itemTitleSelectedColor
{
    _itemTitleSelectedColor = itemTitleSelectedColor;
}


-(void)updateViewLayout
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark -布局

-(void)layoutSubviews
{
    [super layoutSubviews];
    _itemWidth = self.jy_width/self.titles.count - _space;
    for (NSInteger i=0; i<self.titles.count; i++) {
        UIButton *item = [self.scrollView viewWithTag:1000+i];
        [item setTitleColor:_itemTitleNormalColor forState:UIControlStateNormal];
        [item setTitleColor:_itemTitleSelectedColor forState:UIControlStateSelected];
        item.titleLabel.font = _itemFont;
        item.frame = CGRectMake((_itemWidth+_space)*i, 0, _itemWidth, self.scrollView.jy_height);
        if (i == _currentIndex) {//设置选中
            item.selected = YES;
            self.selectedItem = item;
        }
    }
    
    self.sliderView.jy_centerX = self.selectedItem.jy_centerX;
    self.scrollView.contentSize = CGSizeMake((_itemWidth + _space)*_titles.count, self.scrollView.jy_height);
    [self clickedBtn:self.selectedItem];//设置选中
}

@end
