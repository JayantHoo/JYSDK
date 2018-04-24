//
//  JYTPUserInfo.h
//  JYSDKDemo
//
//  Created by isenu on 2018/3/29.
//  Copyright © 2018年 isenu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYTPUserInfo : NSObject

/** 用户名 */
@property (nonatomic,copy) NSString *userName;

/** 图像地址 */
@property (nonatomic,copy) NSString *imageUrl;

/** 性别 0男性，1女性 */
@property (nonatomic,assign) NSInteger sex;

/** 省份 */
@property (nonatomic,copy) NSString *province;

/** 城市 */
@property (nonatomic,copy) NSString *city;


+ (instancetype)userInfo;

@end
