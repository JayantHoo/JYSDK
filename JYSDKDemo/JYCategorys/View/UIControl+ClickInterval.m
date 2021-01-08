//
//  UIControl+ClickInterval.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/21.
//  Copyright © 2020 isenu. All rights reserved.
//

#import "UIControl+ClickInterval.h"
#import "NSObject+JYRuntime.h"

static double kDefaultInterval = 2.5;

@interface UIControl ()
/// 是否可以点击
@property (nonatomic, assign) BOOL isIgnoreClick;
/// 上次按钮响应的方法名
@property (nonatomic, strong) NSString *oldSELName;
@end

@implementation UIControl (ClickInterval)


+ (void)load {
    [NSClassFromString(@"UIControl") swapMethod:@selector(sendAction:to:forEvent:) currentMethod:@selector(jy_sendClickIntervalAction:to:forEvent:)];
}



- (void)jy_sendClickIntervalAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
}



@end
