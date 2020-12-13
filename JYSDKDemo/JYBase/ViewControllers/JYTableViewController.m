//
//  JYTableViewController.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/8/14.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYTableViewController.h"

@interface JYTableViewController ()

@end

@implementation JYTableViewController

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    
}

- (instancetype)init{
    if (self = [super init]) {
        _style = UITableViewStylePlain;
        _page = 1;
        _perPage = 15;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubView];
}

-(void)setupSubView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:self.style];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // set delegate and dataSource
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
//    / 布局
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.tableView = tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -懒加载
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource  = [[NSMutableArray alloc] init];
    }
    return _dataSource ;
}


@end
