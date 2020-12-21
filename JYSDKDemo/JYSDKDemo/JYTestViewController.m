//
//  JYTestViewController.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/20.
//  Copyright © 2020 isenu. All rights reserved.
//

#import "JYTestViewController.h"

@interface JYTestViewController ()

@end

@implementation JYTestViewController

- (void)viewDidLoad {
    self.prefersNavigationBarHidden = ((arc4random()%30)%2 == 0);
    CGFloat red = arc4random() % 256 / 255.0;
    CGFloat green = arc4random() % 256 / 255.0;
    CGFloat blue = arc4random() % 256 / 255.0;
    self.prefersNavigationBarTintColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.75];
    [super viewDidLoad];
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushBtn setTitle:@"跳转" forState:UIControlStateNormal];
    pushBtn.frame = CGRectMake(80, 120, 60, 30);
    [pushBtn addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushBtn];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(80, 70, 60, 30);
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
}

- (void)push:(UIButton *)sender {
    JYTestViewController *vc = [[JYTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
