//
//  NSObject+JYRuntime.m
//  JYSDKDemo
//
//  Created by isenu on 2018/4/25.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "NSObject+JYRuntime.h"

@implementation NSObject (JYRuntime)


/** 获取成员变量列表 包括属性生成的成员变量*/
+(NSArray *) fetchIvarList
{
    unsigned count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);//获取所有成员变量列表
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++ )
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        const char *ivarName = ivar_getName(ivarList[i]);// 获取成员变量名
        const char *ivarType = ivar_getTypeEncoding(ivarList[i]);// 获取成员变量类型编码
        dic[@"type"] = [NSString stringWithUTF8String: ivarType];
        dic[@"ivarName"] = [NSString stringWithUTF8String: ivarName];
        
        [mutableList addObject:dic];
    }
    free(ivarList);
    return [NSArray arrayWithArray:mutableList];
}

/**
 获取类的属性列表：包括私有和公有属性，也包括分类中的属性*/
+(NSArray *) fetchPropertyList
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(self, &count);//获取所有属性列表
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++)
    {
        const char *propertyName = property_getName(propertyList[i]);// 获取属性名
        // 获取属性特性描述字符串
        //property_getAttributes
        // 获取所有属性特性
        //property_copyAttributeList
        
        //属性类型  name值：T  value：变化
        //编码类型  name值：C(copy) &(strong) W(weak) 空(assign) 等 value：无
        //非/原子性 name值：空(atomic) N(Nonatomic)  value：无
        //变量名称  name值：V  value：变化
        //使用property_getAttributes获得的描述是property_copyAttributeList能获取到的所有的name和value的总体描述，如 T@"NSDictionary",C,N,V_dict1
        [mutableList addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(propertyList);
    return [NSArray arrayWithArray:mutableList];
}

/**
 获取对象方法列表：包括getter，setter，方法等
 */
+(NSArray *) fetchInstanceMethodList
{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(self, &count);
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++)
    {
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        [mutableList addObject:NSStringFromSelector(methodName)];
    }
    free(methodList);
    return [NSArray arrayWithArray:mutableList];
}
/**
 获取类方法列表
 */
+ (NSArray *)fetchClassMethodList
{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(object_getClass(self), &count);
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++)
    {
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        [mutableList addObject:NSStringFromSelector(methodName)];
    }
    free(methodList);
    return [NSArray arrayWithArray:mutableList];
}

/**
 获取协议列表 包括：.h .m 和分类里的
 */
+ (NSArray *)fetchProtocolList
{
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(self, &count);
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++ )
    {
        Protocol *protocol = protocolList[i];
        const char *protocolName = protocol_getName(protocol);
        [mutableList addObject:[NSString stringWithUTF8String:protocolName]];
    }
    
    return [NSArray arrayWithArray:mutableList];
}

/**
 给类添加一个方法
 这个可以用在找不到某个方法时就添加一个，不然有可能会崩溃
 @param methodSel 方法的SEL
 @param methodImp 提供方法实现的SEL
 */
+ (void)addMethod:(SEL)methodSel methodImp:(SEL)methodImp
{
    Method method = class_getInstanceMethod(self, methodImp);
    IMP methodIMP = method_getImplementation(method);
    const char *types = method_getTypeEncoding(method);
    class_addMethod(self, methodSel, methodIMP, types);
}

/**
 交换实例方法
 如果将originMethod与currentMethod的方法实现进行交换的话，调用originMethod时就会执行currentMethod的内容
 */
+ (void)swapMethod:(SEL)originMethod currentMethod:(SEL)currentMethod
{
    Method firstMethod = class_getInstanceMethod(self, originMethod);
    Method secondMethod = class_getInstanceMethod(self, currentMethod);
    method_exchangeImplementations(firstMethod, secondMethod);
}

/**
 交换类方法 与交换实例方法类似
 */
+ (void)swapClassMethod:(SEL)originMethod currentMethod:(SEL)currentMethod
{
    Method firstMethod = class_getClassMethod(self, originMethod);
    Method secondMethod = class_getClassMethod(self, currentMethod);
    method_exchangeImplementations(firstMethod, secondMethod);
}


@end
