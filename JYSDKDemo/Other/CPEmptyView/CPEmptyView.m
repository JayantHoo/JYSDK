//
//  CPEmptyView.m
//  CollectionPlates
//
//  Created by champ on 2019/12/26.
//  Copyright © 2019 jayant hoo. All rights reserved.
//

#import "CPEmptyView.h"


@interface CPEmptyView ()

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIButton *continueBtn;
@property (nonatomic, copy) TouchCallBack touchCallBack;
@property (nonatomic, assign) EmptyType type;


@end

@implementation CPEmptyView


+ (void)showInView:(UIView *)superView isNetworkError:(BOOL)isNetworkError callback:(TouchCallBack)callBack{
    
    [CPEmptyView dissmissFromSuperView:superView];
    CPEmptyView *v =  [CPEmptyView new];
    v.touchCallBack = callBack;
    v.continueBtn.hidden = NO;
    v.tag = 1000;
    if (isNetworkError == YES) {
        v.type = EmptyTypeNetWork;
    }else {
        v.type = EmptyTypeService;
    }
    [superView addSubview:v];
}


+ (void)dissmissFromSuperView:(UIView *)superView {
    UIView *view = [superView viewWithTag:1000];
    [view removeFromSuperview];
}

- (instancetype)init {
    
    if (self = [super init]) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWihtType:(EmptyType)type {
    
    if (self = [super init]) {
        [self configUI];
        self.type = type;
    }
    return self;
}

- (instancetype)initWihtHoldertext:(NSString *)holder holderImage:(NSString*)imageName {
    
    if (self = [super init]) {
        [self configUI];
        self.tipsLabel.text = holder;
        self.imageV.image = [UIImage imageNamed:imageName];
    }
    return self;
}


- (void)configUI {
    
     self.frame = [UIScreen mainScreen].bounds;
     // containview
     [self addSubview:self.scrollview];
     [self.scrollview addSubview:self.container];
     [self.container addSubview:self.tipsLabel];
     [self.container addSubview:self.imageV];
     [self.container addSubview:self.continueBtn];
     self.type = EmptyTypeNormal;  // 默认视图
    
    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollview);
        make.height.width.equalTo(self.scrollview);
    }];
    
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.container.mas_centerX);
        make.bottom.equalTo(self.mas_centerY);
        make.width.mas_equalTo(95);
        make.height.mas_equalTo(78);
    }];
    
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.container.mas_centerX);
        make.top.equalTo(self.imageV.mas_bottom).offset(14);
        make.height.mas_equalTo(14);
    }];
    
    [_continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.container.mas_centerX);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(30);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(34);
    }];

}


- (void)setType:(EmptyType)type {
    
    _type = type;
    
    if (type == EmptyTypeNormal) {
        
        self.tipsLabel.text = @"暂无数据";
        self.imageV.image = [UIImage imageNamed:@"empty_icon_normal"];

    }
    else if (type == EmptyTypeSearch)
    {
        self.tipsLabel.text = @"搜索不到相关结果";
        self.imageV.image = [UIImage imageNamed:@"empty_icon_search"];

    }
    else if (type == EmptyTypeService)
    {
        self.tipsLabel.text = @"服务器崩溃了";
        self.imageV.image = [UIImage imageNamed:@"empty_icon_failed"];
    }
    else if (type == EmptyTypeNetWork)
    {
        self.tipsLabel.text = @"无法连接到网络";
        self.imageV.image = [UIImage imageNamed:@"empty_icon_no_wifi"];
    }
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.width = self.superview.width;
    self.height = self.superview.height;
    
}


- (void)continueBtnClicked {
    
    if (self.touchCallBack) {
        self.touchCallBack();
    }
    
}

- (UIScrollView *)scrollview {
    
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc]init];
        _scrollview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _scrollview.alwaysBounceVertical = YES;
        _scrollview.bounces = YES;
    }
    return _scrollview;
}

- (UIView *)container {
    
    if (!_container) {
        _container = [[UIView alloc] init];
    }
    return _container;
}

- (UIButton *)continueBtn {
    
    if (!_continueBtn) {
        _continueBtn = [UIButton new];
        [_continueBtn addTarget:self action:@selector(continueBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_continueBtn setTitle:@"再试一下" forState:UIControlStateNormal];
        _continueBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        [_continueBtn setTitleColor:CPRedColor forState:UIControlStateNormal];
        _continueBtn.layer.borderColor = [CPRedColor colorWithAlphaComponent:0.7].CGColor ;
        _continueBtn.layer.borderWidth = 1;
        _continueBtn.layer.cornerRadius = 17;
        _continueBtn.clipsToBounds = YES;
        _continueBtn.hidden = YES;
    }
    return _continueBtn;
}

- (UILabel *)tipsLabel {
    
    if (!_tipsLabel) {
        _tipsLabel = [UILabel new];
        _tipsLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _tipsLabel.textColor = CPLightGaryColor;
    }
    return _tipsLabel;
}

- (UIImageView *)imageV {
    
    if (!_imageV) {
        _imageV = [UIImageView new];
    }
    return _imageV;
}





@end
