//
//  JYTableViewController.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/8/14.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYBaseViewController.h"

@interface JYTableViewController : JYBaseViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *tableView;
//默认UITableViewStylePlain  在super didRoadR  前设置这个属性才有用
@property (nonatomic, readwrite, assign) UITableViewStyle style;
/// <数据源懒加载>
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 当前页 defalut is 1
@property (nonatomic, readwrite, assign) NSUInteger page;
/// 每一页的数据 defalut is 10
@property (nonatomic, readwrite, assign) NSUInteger perPage;
/// 是否是最后一页
@property (nonatomic,assign) BOOL lastPage;

/// `tableView` 的内容缩进，default is UIEdgeInsetsMake(64 Or 88,0,0,0)，you can override it
@property (nonatomic, assign) UIEdgeInsets contentInset;

/// 需要支持下来刷新 defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;
/// 是否默认开启自动刷新， YES : 系统会自动调用`tableViewDidTriggerHeaderRefresh` NO : 开发人员手动调用 `tableViewDidTriggerHeaderRefresh`
@property (nonatomic, readwrite, assign) BOOL shouldBeginRefreshing;
/// 需要支持上拉加载 defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldPullUpToLoadMore;
/// 是否在上拉加载后的数据,dataSource.count < pageSize 提示没有更多的数据.default is YES 否则 隐藏mi_footer 。 前提是` shouldMultiSections = NO `才有效。
@property (nonatomic, readwrite, assign) BOOL shouldEndRefreshingWithNoMoreData;

@property (nonatomic,strong) UIColor *sectionColor;/// sectionHeader,sectionFooter颜色

-(void)configureTableView;
//注册cell
-(void)registerCell:(nullable Class)cellClass;
-(void)registerCellWithNib:(nullable Class)cellClass;


/// 下拉刷新事件 子类需重写，无须调用 [super tableViewDidTriggerHeaderRefresh]
- (void)tableViewDidTriggerHeaderRefresh;
/// 上拉加载事件 子类需重写，无须调用 [super tableViewDidTriggerFooterRefresh]
- (void)tableViewDidTriggerFooterRefresh;
///brief 加载结束 这个方法  子类只需要在 `tableViewDidTriggerHeaderRefresh`和`tableViewDidTriggerFooterRefresh` 结束刷新状态的时候直接调用即可
///discussion 加载结束后，通过参数reload来判断是否需要调用tableView的reloadData，判断isHeader来停止加载
///param isHeader   是否结束下拉加载(或者上拉加载)
///param reload     是否需要重载TabeleView
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;
@end
