//
//  JYTestViewController.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/20.
//  Copyright © 2020 isenu. All rights reserved.
//

#import "JYTestViewController.h"
#import "JYTestTableViewCell.h"

@interface JYTestViewController ()

@property (nonatomic, strong) NSIndexPath *firstIndexPath;
@property (nonatomic, strong) NSLock *indexPathLock;
@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JYTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _indexPathLock = [[NSLock alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.tableView.rowHeight = 40;
    _total = 50;
//    _point = CGPointMake(0, 0);
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        _point = CGPointMake(0, _point.y+40);
//        if (_point.y + self.tableView.jy_height >= self.tableView.contentSize.height) {
//            [self.timer invalidate];
//        }
//        self.tableView.contentOffset = _point;
//    }];
    
//    self.prefersNavigationBarHidden = ((arc4random()%30)%2 == 0);
//    CGFloat red = arc4random() % 256 / 255.0;
//    CGFloat green = arc4random() % 256 / 255.0;
//    CGFloat blue = arc4random() % 256 / 255.0;
//    self.prefersNavigationBarTintColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.75];
//    [super viewDidLoad];
//    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [pushBtn setTitle:@"跳转" forState:UIControlStateNormal];
//    pushBtn.frame = CGRectMake(80, 120, 60, 30);
//    [pushBtn addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:pushBtn];
//
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    backBtn.frame = CGRectMake(80, 70, 60, 30);
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
//
//    UIImage *image = [UIImage imageWithUrl:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3087915783,104865090&fm=26&gp=0.jpg"];
//
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
////    [button jy_setNormalTitle:@"测试" titleColor:[UIColor redColor]];
//    [button setImage:[UIImage jy_compressImage:image toByte:10000] forState:UIControlStateNormal];
//    button.frame = CGRectMake(50, 200, 300, 500);
//    [button addTarget:self action:@selector(doSomethingTest) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
//    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
//    testLabel.backgroundColor = [UIColor redColor];
//    testLabel.text = @"标题自适应大小标题自适应大小";
//    testLabel.adjustsFontSizeToFitWidth = YES;
//    [self.view addSubview:testLabel];
    
}

//-(void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    CAGradientLayer *desaltLayer = [[CAGradientLayer alloc] init];
////    desaltLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
//    desaltLayer.frame = CGRectMake(0, self.tableView.jy_top, JYSCREENWIDTH, 40);
//    desaltLayer.colors = @[(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor,
////                           (__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor,
////                           (__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor,
//                           (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:0.0].CGColor,];
//    desaltLayer.startPoint = CGPointMake(0, 0);
//    desaltLayer.endPoint = CGPointMake(0, 1);
////    desaltLayer.locations = @[@0.8,@1.0];
////    desaltLayer.cornerRadius = 15;
//    [self.view.layer addSublayer:desaltLayer];
//}

//- (void)push:(UIButton *)sender {
//    JYTestViewController *vc = [[JYTestViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (void)back {
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _total;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYTestTableViewCell *cell = [JYTestTableViewCell cellWithTableView:tableView];
    cell.isDesalt = NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    JYTestTableViewCell *tempCell = (JYTestTableViewCell *)cell;
    tempCell.isDesalt = NO;
    if (_total>15) {
        NSArray<NSIndexPath *> *indexPathList = [self.tableView indexPathsForVisibleRows];
        if (indexPath.row <= [indexPathList firstObject].row) {
            self.firstIndexPath = [indexPathList firstObject];
            tempCell.isDesalt = YES;
        }
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_total>15) {
        NSArray<NSIndexPath *> *indexPathList = [self.tableView indexPathsForVisibleRows];
        JYTestTableViewCell *secondCell = (JYTestTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.firstIndexPath.row+1 inSection:0]];
        secondCell.isDesalt = NO;
        if (self.firstIndexPath.row < [indexPathList firstObject].row) {
            self.firstIndexPath = [indexPathList firstObject];
            JYTestTableViewCell *firstCell = (JYTestTableViewCell *)[self.tableView cellForRowAtIndexPath:self.firstIndexPath];
            firstCell.isDesalt = YES;
        }
    }

}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//
////    NSArray<NSIndexPath *> *indexPathList = [self.tableView indexPathsForVisibleRows];
////    [indexPathList enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////        if (idx != 0) {
////            JYTestTableViewCell *notFirstCell = (JYTestTableViewCell *)[self.tableView cellForRowAtIndexPath:self.firstIndexPath];
////            notFirstCell.isDesalt = NO;
////        }
////    }];
//}

@end
