//
//  JYPageViewController.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2019/4/17.
//  Copyright © 2019 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYPageViewController;

@protocol JYPageViewControllerDelegate <NSObject>
@optional

-(void)pageViewController:(JYPageViewController *)pageController DidSelectAtIndex:(NSInteger) index;

@end

@interface JYPageViewController : UIViewController

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,weak) id<JYPageViewControllerDelegate> delegate;
@property (nonatomic,assign) BOOL shouldScroll;//默认是可滑动的

/**
 初始化方法
 @param controllers 控制器数组
 @return LYPageViewController
 */
-(instancetype)initWithContorllers:(NSArray *)controllers;

-(void)setSelectedControllerAtIndex:(NSInteger) index;

@end

