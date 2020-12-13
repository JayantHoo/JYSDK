//
//  JYTableViewCell.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/13.
//  Copyright © 2020 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYTableViewCell : UITableViewCell

@property (nonatomic,weak) id cellData;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
