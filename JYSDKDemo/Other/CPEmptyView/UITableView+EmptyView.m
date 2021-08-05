//
//  UITableView+EmptyView.m
//  CollectionPlates
//
//  Created by champ on 2019/12/27.
//  Copyright © 2019 jayant hoo. All rights reserved.
//

#import "UITableView+EmptyView.h"
#import <objc/runtime.h>

/// 加载完数据的标记属性名
static NSString * const TableViewFinish = @"TableViewFinish";


@implementation NSObject (swizzle)

+ (void)swizzleInstanceSelector:(SEL)originalSel
           WithSwizzledSelector:(SEL)swizzledSel
{
    Method originMethod = class_getInstanceMethod(self, originalSel);
    Method swizzedMehtod = class_getInstanceMethod(self, swizzledSel);
    BOOL methodAdded = class_addMethod(self, originalSel, method_getImplementation(swizzedMehtod), method_getTypeEncoding(swizzedMehtod));
    
    if (methodAdded) {
        class_replaceMethod(self, swizzledSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else{
        method_exchangeImplementations(originMethod, swizzedMehtod);
    }
}

@end


@implementation UITableView (EmptyView)


+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(reloadData) WithSwizzledSelector:@selector(cp_reloadData)];
    });
    
}


- (void)setEmptyView:(UIView *)emptyView {
    
    objc_setAssociatedObject(self, @selector(emptyView), emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIView *)emptyView
{
    return objc_getAssociatedObject(self, @selector(emptyView));
}


- (void)setIsInitFinish:(BOOL)finish {
    objc_setAssociatedObject(self, &TableViewFinish, @(finish), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isInitFinish {
    id obj = objc_getAssociatedObject(self, &TableViewFinish);
    return [obj boolValue];
}

- (void)cp_reloadData
{
    [self cp_reloadData];
    [self cp_checkEmpty];
   
}

- (void)cp_checkEmpty
{
    // 如果没有设置空视图是不会加载的
    if (self.emptyView == nil) {
        return;
    }
    
    // 初始化tableview 后系统会默认调用一次reload，但是数据没有下来，会导致提前出线空视图，所以要过滤掉第一次reload
    if (![self isInitFinish]) {
        [self setIsInitFinish:YES];
        return ;
    }
    //  刷新完成之后检测数据量
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger numberOfSections = [self numberOfSections];
        BOOL havingData = NO;
        for (NSInteger i = 0; i < numberOfSections; i++) {
            if ([self numberOfRowsInSection:i] > 0) {
                havingData = YES;
                break;
            }
        }

        if (havingData == NO ) {
            [self.emptyView removeFromSuperview];
            [self addSubview:self.emptyView];
        }else{
            [self.emptyView removeFromSuperview];
        }
        
    });
    
    
}

@end
