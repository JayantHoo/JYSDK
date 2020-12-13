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
//默认UITableViewStylePlain
@property (nonatomic, readwrite, assign) UITableViewStyle style;
/// The data source of table view <数据源懒加载>
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 当前页 defalut is 1
@property (nonatomic, readwrite, assign) NSUInteger page;
/// 每一页的数据 defalut is 15
@property (nonatomic, readwrite, assign) NSUInteger perPage;
@end
