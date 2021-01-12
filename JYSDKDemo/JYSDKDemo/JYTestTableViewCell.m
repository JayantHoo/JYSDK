//
//  JYTestTableViewCell.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2021/1/12.
//  Copyright © 2021 isenu. All rights reserved.
//

#import "JYTestTableViewCell.h"

@interface JYTestTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CAGradientLayer *desaltLayer;

@end

@implementation JYTestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
        [self makeConstraint];
    }
    return self;
}

#pragma mark - 布局
- (void)initUI {
    self.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor clearColor];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = JYFONT(15);
    titleLabel.text = @" 滑出渐变滑出渐变滑出渐变滑出渐变    ";
    [titleLabel sizeToFit];
    titleLabel.jy_height = 30;
    titleLabel.jy_x = 16;
    titleLabel.jy_y = 10;
    titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    titleLabel.layer.cornerRadius = 15;
    titleLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    
//    CALayer *maskLayer = [[CALayer alloc] init];
//    maskLayer.frame = titleLabel.frame;
//    maskLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
//    [self.contentView.layer insertSublayer:maskLayer atIndex:0];
//    self.maskLayer = maskLayer;
    
    
}

- (void)setIsDesalt:(BOOL)isDesalt {
    _isDesalt = isDesalt;
    if (isDesalt) {
        CAGradientLayer *desaltLayer = [[CAGradientLayer alloc] init];
        desaltLayer.frame = self.titleLabel.bounds;
        desaltLayer.colors = @[(__bridge id)[[UIColor clearColor] colorWithAlphaComponent:0.0].CGColor,(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor,(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor,(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:1.0].CGColor];
        desaltLayer.startPoint = CGPointMake(0, 0);
        desaltLayer.endPoint = CGPointMake(0, 1);
        desaltLayer.cornerRadius = 15;
        [self.titleLabel.layer setMask:desaltLayer];
        self.desaltLayer = desaltLayer;
    }else {
//        CALayer *maskLayer = [[CALayer alloc] init];
//        maskLayer.frame = self.titleLabel.bounds;
//        maskLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
        if (self.desaltLayer) {
            [self.desaltLayer removeFromSuperlayer];
        }
    }
}

- (void)makeConstraint {

}

-(void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - 懒加载

@end
