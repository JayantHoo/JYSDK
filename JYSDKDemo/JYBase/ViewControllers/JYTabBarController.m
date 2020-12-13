//
//  JYTabBarController.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/8/3.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYTabBarController.h"
#import "JYTabBar.h"

@interface JYTabBarController ()

/// tabBarController
@property (nonatomic, strong, readwrite) UITabBarController *tabBarController;

@end

@implementation JYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController = [[UITabBarController alloc] init];
    /// 添加子控制器
    [self.view addSubview:self.tabBarController.view];
    [self addChildViewController:self.tabBarController];
    [self.tabBarController didMoveToParentViewController:self];
    
    // kvc替换系统的tabBar
    JYTabBar *tabbar = [[JYTabBar alloc] init];
    //kvc实质是修改了系统的_tabBar
    [self.tabBarController setValue:tabbar forKeyPath:@"tabBar"];
}

#pragma mark - Ovveride
- (BOOL)shouldAutorotate {
    return self.tabBarController.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.tabBarController.selectedViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.tabBarController.selectedViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden{
    return self.tabBarController.selectedViewController.prefersStatusBarHidden;
}

@end
