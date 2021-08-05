//
//  FBKVOController+JYExtension.h
//  ShellProject
//
//  Created by jayant hoo on 2018/8/15.
//  Copyright © 2018年 jayant hoo. All rights reserved.
//

#import "FBKVOController.h"

@interface FBKVOController (JYExtension)

- (void)jy_observe:(nullable id)object keyPath:(NSString *_Nullable)keyPath block:(FBKVONotificationBlock _Nullable )block;

- (void)jy_observe:(nullable id)object keyPath:(NSString *_Nullable)keyPath action:(SEL _Nullable )action;

@end
