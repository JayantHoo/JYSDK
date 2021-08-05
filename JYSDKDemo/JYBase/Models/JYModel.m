//
//  JYModel.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/8/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import "JYModel.h"
#import "NSObject+JYRuntime.h"

@implementation JYModel

//+ (NSArray *)modelListFromArray:(NSArray *) array {
//    
//}
//
//+ (instancetype)modelFromDictionary:(NSDictionary *)dictionary {
//    
//}


//-(NSMutableDictionary *)jy_keyValues
//{
//    return [self mj_keyValues];
//}


-(NSString *)description
{
    NSArray *propertyList = [[self class] fetchPropertyList];
    NSString *descriptionString = @"";
    for (id obj in propertyList) {
        NSString *propKey = obj;
        id propV = [self valueForKey:propKey];
        descriptionString = [descriptionString stringByAppendingFormat:@"\n %@ = %@ ;",propKey,propV];
    }
    
    return descriptionString;
}



#pragma mark- 归解档
//归档
- (void)encodeWithCoder:(NSCoder *)coder
{
    //告诉系统归档的属性是哪些
    NSArray *propertyList = [[self class] fetchPropertyList];
    for (id obj in propertyList) {
        NSString *propKey = obj;
        id propV = [self valueForKey:propKey];
        //归档 -- 利用KVC
        [coder encodeObject:propV forKey:propKey];
    }
}
//解档
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        //解档
        //告诉系统归档的属性是哪些
        NSArray *propertyList = [[self class] fetchPropertyList];
        for (id obj in propertyList) {
            NSString *propKey = obj;
            id propV = [coder decodeObjectForKey:propKey];
            if (!propV || !propKey) {//propV或propKey为nil则跳过该属性赋值
                continue;
            }
            // 利用KVC赋值
            [self setValue:propV forKey:propKey];
        }
    }
    return self;
}
//解档
+(instancetype) modelFromCoder
{
    NSString *coderFilePath = [JYDocumentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",NSStringFromClass([self class])]];
    //解档
    return [NSKeyedUnarchiver unarchiveObjectWithFile:coderFilePath];
}
//归档
+(void)encodeModel:(NSDictionary *)dictionary
{
    NSString *coderFilePath = [JYDocumentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",NSStringFromClass([self class])]];
    //归档
    [NSKeyedArchiver archiveRootObject:[[self class] modelFromDictionary:dictionary] toFile:coderFilePath];
}

@end
