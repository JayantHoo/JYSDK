//
//  ViewController.m
//  JYSDKDemo
//
//  Created by isenu on 2018/3/28.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "ViewController.h"
#import "JYSegmentView.h"

@interface ViewController ()

@property (nonatomic,copy) NSString *testSting;

@property (nonatomic,copy) NSMutableString *mString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        JYLog(@"这里死锁了");
//    });
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button jy_setNormalTitle:@"测试" titleColor:[UIColor redColor]];
//    button.frame = CGRectMake(40, 60, 60, 50);
//    [button addTarget:self action:@selector(doSomethingTest) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
//    JYSegmentView *segment = [[JYSegmentView alloc] initWithTitels:@[@"dududu",@"seleeee"] frame:CGRectMake(20, 50, 200, 44)];
//    [self.view addSubview:segment];
//    self.definesPresentationContext = YES;
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)]];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 100, 150, 35)];
    slider.minimumValue = 0;
//    UIImage *thumImage = [[[UIImage jy_imageWithColor:JTWhiteColor] jy_scaleToSize:CGSizeMake(18, 18)] jy_circleImage];
//    [slider setThumbImage:thumImage forState:UIControlStateNormal];
//    slider.minimumTrackTintColor = JT40Color;
//    slider.maximumTrackTintColor = JTDefaultLightGaryColor;
    [slider addTarget:self action:@selector(sliderDidChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGuestAction)]];
    [self.view addSubview:slider];
    
}

-(void)panGuestAction
{
    
}

-(void)sliderDidChanged:(UISlider *)slider
{
    
}

-(void)tapAction
{
    ViewController *vc = [[ViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.view.superview.frame = CGRectMake(100, 50, 100, 200);//重新设置界面vc的view的大小
    vc.view.backgroundColor = [UIColor redColor];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
