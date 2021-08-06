//
//  CPViewController+CPPush.h
//  CollectionPlates
//
//  Created by jayant hoo on 2019/11/20.
//  Copyright © 2019 jayant hoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (CPPush)

-(void)pushToController:(Class _Nullable ) cls;

-(void)pushToController:(Class _Nullable ) cls
                 params:(nullable NSDictionary *) params
               animated:(BOOL) animated;

-(void)pushToController:(Class _Nullable ) cls
                 params:(nullable NSDictionary *) params;

-(void)pushToController:(Class _Nullable ) cls
               callBack:(void (^_Nullable)(id _Nullable data)) callBack;

-(void)pushToController:(Class _Nullable ) cls
                 params:(nullable NSDictionary *) params
               callBack:(void (^_Nullable)(id _Nullable data)) callBack;

-(void)pushToController:(Class _Nullable ) cls
                 params:(nullable NSDictionary *) params
               animated:(BOOL) animated
               callBack:(void (^_Nullable)(id _Nullable data)) callBack;

-(void)popToViewControllerClass:(Class _Nullable ) clas;

//把自己从控制器列表中移除
-(void)removeFromViewControllers;

@end

NS_ASSUME_NONNULL_END
