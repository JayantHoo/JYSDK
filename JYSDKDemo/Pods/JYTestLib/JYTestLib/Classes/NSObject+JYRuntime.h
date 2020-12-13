//
//  NSObject+JYRuntime.h
//  JYSDKDemo
//
//  Created by isenu on 2018/4/25.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JYRuntime)

/** 获取成员变量列表 包括属性生成的成员变量*/
+(NSArray *) fetchIvarList;

/**
 获取类的属性列表：包括私有和公有属性，也包括分类中的属性*/
+(NSArray *) fetchPropertyList;

/**
 获取对象方法列表：包括getter，setter，方法等
 */
+(NSArray *) fetchInstanceMethodList;
/**
 获取类方法列表
 */
+ (NSArray *)fetchClassMethodList;
/**
 获取协议列表 包括：.h .m 和分类里的
 */
+ (NSArray *)fetchProtocolList;
/**
 给类添加一个方法
 这个可以用在找不到某个方法时就添加一个，不然有可能会崩溃
 @param methodSel 方法的SEL
 @param methodImp 提供方法实现的SEL
 */
+ (void)addMethod:(SEL)methodSel methodImp:(SEL)methodImp;
/**
 交换实例方法
 如果将originMethod与currentMethod的方法实现进行交换的话，调用originMethod时就会执行currentMethod的内容
 */
+ (void)swapMethod:(SEL)originMethod currentMethod:(SEL)currentMethod;
/**
 交换类方法 与交换实例方法类似
 */
+ (void)swapClassMethod:(SEL)originMethod currentMethod:(SEL)currentMethod;

@end
