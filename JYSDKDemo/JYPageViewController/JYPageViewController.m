//
//  JYPageViewController.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2019/4/17.
//  Copyright © 2019 isenu. All rights reserved.
//

#import "JYPageViewController.h"

@interface JYPageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate>


@property (nonatomic,copy) NSArray *controllers;

@property (nonatomic,strong) UIPageViewController *pageController;

@end

@implementation JYPageViewController

-(instancetype)initWithContorllers:(NSArray *)controllers
{
    self = [super init];
    if (self) {
        self.controllers = controllers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubView];
}

-(void)setupSubView
{
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
}

-(void)setShouldScroll:(BOOL)shouldScroll
{
    _shouldScroll = shouldScroll;
    for (UIView *subview in self.pageController.view.subviews) {
        //设置是否支持手势滑动
        [(UIScrollView *)subview setScrollEnabled:shouldScroll];
        
    }
}

-(void)setSelectedControllerAtIndex:(NSInteger) index
{
    if (index == _currentPage) {
        return;
    }
    __block JYPageViewController *blockSelf = self;
    [self.pageController setViewControllers:@[self.controllers[index]] direction:index<_currentPage animated:YES completion:^(BOOL finished) {
        blockSelf.currentPage = index;
        if (blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(pageViewController:DidSelectAtIndex:)]) {
            [blockSelf.delegate pageViewController:blockSelf DidSelectAtIndex:blockSelf->_currentPage];
        }
    }];
}

#pragma mark - UIPageViewControllerDataSource
// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self.controllers indexOfObject:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == [self.controllers count]) {
        return nil;
    }
    
    return self.controllers[index];
}
// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self.controllers indexOfObject:viewController];
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    
    return self.controllers[index];
}

#pragma mark - UIPageViewControllerDelegate

// 开始翻页调用
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0) {
    //    LYLog(@"开始翻页");
}
// 翻页完成调用
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    //    _done = YES;
    
    NSInteger index = [self.controllers indexOfObject:pageViewController.viewControllers[0]];
    _currentPage = index;
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:DidSelectAtIndex:)]) {
        [self.delegate pageViewController:self DidSelectAtIndex:_currentPage];
    }
    //    LYLog(@"翻页完成");
}
- (UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - 懒加载

-(UIPageViewController *)pageController
{
    if (!_pageController) {
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageController.dataSource = self;
        _pageController.delegate = self;
        _pageController.view.frame = self.view.bounds;
        
        for (UIView *subview in _pageController.view.subviews) {
            [(UIScrollView *)subview setDelegate:self];
            //设置是否支持手势滑动
            //            [(UIScrollView *)subview setScrollEnabled:NO];
            
        }
        [_pageController setViewControllers:@[[self.controllers objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    return _pageController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
