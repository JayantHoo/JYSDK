//
//  UITableView+JYExtension.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/7/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "UITableView+JYExtension.h"

@implementation UITableView (JYExtension)

- (void)jy_registerCell:(Class)cls {
    
    [self jy_registerCell:cls forCellReuseIdentifier:NSStringFromClass(cls)];
}
- (void)jy_registerCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerClass:cls forCellReuseIdentifier:reuseIdentifier];
}


- (void)jy_registerNibCell:(Class)cls {
    [self jy_registerNibCell:cls forCellReuseIdentifier:NSStringFromClass(cls)];
}
- (void)jy_registerNibCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(cls) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}

@end
