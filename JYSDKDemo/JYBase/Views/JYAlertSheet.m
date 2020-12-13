//
//  JYAlertSheet.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/13.
//  Copyright © 2020 isenu. All rights reserved.
//

#import "JYAlertSheet.h"

@interface JYAlertSheet ()

@property (nonatomic,strong) NSArray *titles;/// 按钮标题

@property (nonatomic,strong) UIStackView *actionView;/// sheet

@property (nonatomic,strong) UIButton *cancelBtn;/// cancel

@property (nonatomic,copy) VoidBlock_int actionHandler;///

@property (nonatomic,strong) UIColor *listTitleColor;


@end

@implementation JYAlertSheet

+(void)showSheetWithActionTitles:(NSArray *)titles atView:(UIView *)superView handler:(VoidBlock_int) handler
{
    [[superView viewWithTag:11010] removeFromSuperview];
    JYAlertSheet *sheet = [[JYAlertSheet alloc] initWithFrame:superView.bounds titles:titles];
    sheet.actionHandler = handler;
    sheet.tag = 11010;
    [superView addSubview:sheet];
    [sheet show];
}

+(void)showSettingSheetWithActionTitles:(NSArray *)titles atView:(UIView *)superView handler:(VoidBlock_int) handler{
    
    [[superView viewWithTag:11010] removeFromSuperview];
    JYAlertSheet *sheet = [[JYAlertSheet alloc] initWithFrame:superView.bounds titles:titles];
    sheet.actionHandler = handler;
    sheet.listTitleColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    UIButton *btn = [ sheet viewWithTag:10];
    [btn setImage:[UIImage imageNamed:@"me_set_chat"] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    sheet.tag = 11010;
    [superView addSubview:sheet];
    [sheet show];
    
}



-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame]) {
        _titles = titles;
        [self configUI];
        [self configConstraints];
        
        self.listTitleColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];;
    }
    return self;
}

-(void)action:(UIButton *)sender
{
    
    if (self.actionHandler) {
        self.actionHandler((int)(sender.tag-10));
    }
    [self hide];
}



#pragma mark- UI布局
-(void)configUI
{
    self.contentView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];;
    
    UIStackView *actionView = [[UIStackView alloc] initWithFrame:CGRectZero];
    actionView.axis = UILayoutConstraintAxisVertical;
    actionView.spacing = 1;
    actionView.distribution = UIStackViewDistributionFillEqually;
    actionView.alignment = UIStackViewAlignmentTop;
    [self.contentView addSubview:actionView];
    self.actionView = actionView;
    
    for (NSInteger i = 0; i<_titles.count; i++) {
        UIButton *action = [UIButton buttonWithType:UIButtonTypeCustom];
        action.titleLabel.font = [UIFont systemFontOfSize:18];
        action.tag = 10+i;
        action.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];;
        [action setTitleColor: self.listTitleColor forState:UIControlStateNormal];
        [action setTitle:_titles[i] forState:UIControlStateNormal];
        [action addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionView addArrangedSubview:action];
        [action mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.left.right.mas_equalTo(0);
        }];
    }
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
}

-(void)configConstraints
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(40);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.contentView.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cancelBtn.mas_top).offset(-7);
        make.left.top.right.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(50);
    }];
    
}

- (void)setListTitleColor:(UIColor *)listTitleColor {
    
    _listTitleColor = listTitleColor;
    
    for (NSInteger i = 0; i<_titles.count; i++) {
           UIButton *action = [self viewWithTag:10+i];
           [action setTitleColor: listTitleColor forState:UIControlStateNormal];
       }
       
}



- (void)show
{
    self.alpha = 0;
    self.contentView.transform = CGAffineTransformMakeTranslation(0, self.jy_height);
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.contentView.transform = CGAffineTransformIdentity;
    }];
    
}

-(void)hide
{
    self.alpha = 1;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeTranslation(0, self.jy_height);
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
