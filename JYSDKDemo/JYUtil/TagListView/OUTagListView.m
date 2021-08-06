//
//  OUTagListView.m
//  XiaoYaoJi
//
//  Created by jayant hoo on 2020/12/28.
//  Copyright © 2020 OU. All rights reserved.
//

#import "OUTagListView.h"


@interface OUTagListView ()



@end

@implementation OUTagListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alignment = alignCenter;
        self.textColor = UIColorHex(@"333333");
        self.textFont = [UIFont systemFontOfSize:13];
        self.tagBackgroundColor = UIColorHex(@"F5F5FA");
        self.cornerRadius = 12.5;
        self.paddingX = 15;
        self.marginX = 15;
        self.paddingY = 5;
        self.marginY = 15;
        self.textFont = [UIFont systemFontOfSize:13];
    }
    return self;
}




@end
