//
//  JYAlertSheet.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/13.
//  Copyright © 2020 isenu. All rights reserved.
//

#import "JYBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYAlertSheet : JYBaseAlertView

+(void)showSheetWithActionTitles:(NSArray *)titles atView:(UIView *)superView handler:(VoidBlock_int) handler;

+(void)showSettingSheetWithActionTitles:(NSArray *)titles atView:(UIView *)superView handler:(VoidBlock_int) handler;

@end

NS_ASSUME_NONNULL_END
