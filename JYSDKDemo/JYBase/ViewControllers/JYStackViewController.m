//
//  JYStackViewController.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/20.
//  Copyright © 2020 isenu. All rights reserved.
//

#import "JYStackViewController.h"

@interface JYStackViewController ()

@property (nonatomic, strong) UIScrollView *scrollview;

@end

@implementation JYStackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScrollView];
}

-(void)setupScrollView
{
    // 添加滑动容器
    self.scrollview = [[UIScrollView alloc]init];
    self.scrollview.backgroundColor = [UIColor whiteColor];
    self.scrollview.alwaysBounceVertical = YES;
    
    [self.view addSubview:self.scrollview];
    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
    [self.scrollview addSubview:self.stackView];
    [_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollview);
        make.width.mas_equalTo(JYSCREENWIDTH);
    }];
    
}

-(void)setContentInset:(UIEdgeInsets)contentInset
{
    self.scrollview.contentInset = contentInset;
}

-(void)addViewAtStackView:(UIView *)view
{
    [self.stackView addArrangedSubview:view];
}

-(void)addLineSpaceWithHeight:(CGFloat)height
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.stackView addArrangedSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
}

#pragma mark -  懒加载
- (UIStackView *)stackView {
    
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _stackView;
}


@end
