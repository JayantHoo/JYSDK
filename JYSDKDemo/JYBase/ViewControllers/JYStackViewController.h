//
//  JYStackViewController.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/20.
//  Copyright © 2020 isenu. All rights reserved.
//

#import "JYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYStackViewController : JYBaseViewController

@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, assign) UIEdgeInsets contentInset;

-(void)addLineSpaceWithHeight:(CGFloat)height;

-(void)addViewAtStackView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
