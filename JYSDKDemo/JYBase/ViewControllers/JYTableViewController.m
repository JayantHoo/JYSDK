//
//  JYTableViewController.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/8/14.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYTableViewController.h"
#import <MJRefresh/MJRefresh.h>

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
        _style = UITableViewStyleGrouped;
        _page = 1;
        _perPage = 10;
        
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    self.keyboardEnable = NO;
    [super viewDidLoad];
    [self __setupSubView];
    [self configureTableView];
}

-(void)__setupSubView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:self.style];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorInset = UIEdgeInsetsZero;
//    tableView.separatorColor = CPLineColor;
    // set delegate and dataSource
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] init];
    //    / 布局
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
//    tableView.emptyView = [CPEmptyView new];  // 空视图
//
//    self.tableView = tableView;
}

#pragma mark-注册cell

-(void)configureTableView{}

//-(void)registerCell:(nullable Class)cellClass
//{
//    [self.tableView jy_registerCell:cellClass];
//}
//
//-(void)registerCellWithNib:(nullable Class)cellClass
//{
//    [self.tableView jy_registerNibCell:cellClass];
//}
#pragma mark - 上下拉刷新事件
/// 下拉事件
- (void)tableViewDidTriggerHeaderRefresh{
    /// subclass override it
    [self tableViewDidFinishTriggerHeader:YES reload:NO];
}

/// 上拉事件
- (void)tableViewDidTriggerFooterRefresh{
    /// subclass override it
    [self tableViewDidFinishTriggerHeader:NO reload:NO];
}

/// 结束刷新
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload{
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
//        if (reload) {
//            [self.tableView reloadData];
//        }
//        self.shouldEndRefreshingWithNoMoreData = self.lastPage;
//        if (isHeader) {
//            /// 重置没有更多的状态
//            if (!self.shouldEndRefreshingWithNoMoreData){
//                
//                [self.tableView.mj_footer setHidden:NO];
//                [self.tableView.mj_footer resetNoMoreData];
//
//            }else{
//
//                [self.tableView.mj_footer setHidden:NO];
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//            [self.tableView.mj_header endRefreshing];
//            self.shouldEndRefreshingWithNoMoreData = NO;
//            self.lastPage = NO;
//        }
//        else{
//            if (self.shouldEndRefreshingWithNoMoreData){
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }else{
//                [self.tableView.mj_footer endRefreshing];
//            }
//        }
    });
}



#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.tableView.sectionFooterHeight>0) {
        return self.tableView.sectionFooterHeight;
    }
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tableView.sectionHeaderHeight>0) {
        return self.tableView.sectionHeaderHeight;
    }
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_sectionColor) {
        UIView *section = [[UIView alloc] init];
        section.backgroundColor = _sectionColor;
        return section;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_sectionColor) {
        UIView *section = [[UIView alloc] init];
        section.backgroundColor = _sectionColor;
        return section;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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

-(void)setContentInset:(UIEdgeInsets)contentInset
{
    self.tableView.contentInset = contentInset;
}

- (void)setShouldPullDownToRefresh:(BOOL)shouldPullDownToRefresh{
    if (_shouldPullDownToRefresh != shouldPullDownToRefresh) {
        _shouldPullDownToRefresh = shouldPullDownToRefresh;
        
        if (_shouldPullDownToRefresh) {
            @weakify(self);
            
            MJRefreshNormalHeader *header = [CPRefreshNormalHeader headerWithRefreshingBlock:^{
                /// 加载下拉刷新的数据
                @strongify(self);
                [self tableViewDidTriggerHeaderRefresh];
            }];
            //            header.lastUpdatedTimeLabel.hidden = YES;
            //            [header setTitle:@"鬆開立即刷新" forState:MJRefreshStatePulling];
            //            [header setTitle:@"刷新數據中..." forState:MJRefreshStateRefreshing];
            self.tableView.mj_header = header;
        }else{
            self.tableView.mj_header = nil;
        }
    }
}

- (void)setShouldPullUpToLoadMore:(BOOL)shouldPullUpToLoadMore{
    if (_shouldPullUpToLoadMore != shouldPullUpToLoadMore) {
        _shouldPullUpToLoadMore = shouldPullUpToLoadMore;
        if (_shouldPullUpToLoadMore) {
            /// 上拉加载
            @weakify(self);
            self.tableView.mj_footer = [CPRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                /// 加载上拉刷新的数据
                @strongify(self);
                [self tableViewDidTriggerFooterRefresh];
            }];
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.mj_footer = nil;
        }
    }
}


@end
