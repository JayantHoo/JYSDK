//
//  CPViewController+CPPush.m
//  CollectionPlates
//
//  Created by jayant hoo on 2019/11/20.
//  Copyright © 2019 jayant hoo. All rights reserved.
//

#import "UIViewController+CPPush.h"


@implementation UIViewController (CPPush)

-(void)pushToController:(Class _Nullable) cls
{
    [self pushToController:cls params:nil animated:YES];
}

-(void)pushToController:(Class _Nullable) cls
                 params:(nullable NSDictionary *) params
               animated:(BOOL) animated
{
    [self pushToController:cls params:params animated:animated callBack:nil];
}

-(void)pushToController:(Class _Nullable) cls
                 params:(nullable NSDictionary *) params
{
    [self pushToController:cls params:params animated:YES];
}

-(void)pushToController:(Class _Nullable) cls
               callBack:(void (^)(id data)) callBack
{
    [self pushToController:cls params:nil animated:YES callBack:callBack];
}

-(void)pushToController:(Class _Nullable) cls
                 params:(nullable NSDictionary *) params
               callBack:(void (^)(id data)) callBack
{
    [self pushToController:cls params:params animated:YES callBack:callBack];
}

-(void)pushToController:(Class _Nullable) cls
                 params:(nullable NSDictionary *) params
               animated:(BOOL) animated
               callBack:(void (^)(id data)) callBack
{
    if (!cls) {
        return;
    }
    if (self.navigationController==nil) {//容错
        return;
    }
    CPViewController *vc = nil;
    if (params != nil) {
        vc  = [[cls alloc] initWithParams:params];
    }else {
        vc  = [[cls alloc] init];
    }
    vc.callback = callBack;
    
    [self.navigationController pushViewController:vc animated:animated];
}


-(void)popToViewControllerClass:(Class _Nullable) clas
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:clas]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
}

-(void)removeFromViewControllers
{
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [tempArr removeObject:self];
    
    [self.navigationController setViewControllers:tempArr];
}

@end
