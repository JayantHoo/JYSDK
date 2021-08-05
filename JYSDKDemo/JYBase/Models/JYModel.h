//
//  JYModel.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2018/8/2.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYModel : NSObject

+ (NSArray *)modelListFromArray:(NSArray *) array;

+ (instancetype)modelFromDictionary:(NSDictionary *)dictionary;

- (NSMutableDictionary *)jy_keyValues;

//解档
+ (instancetype)modelFromCoder;
//归档
+ (void)encodeModel:(NSDictionary *)dictionary;

@end
