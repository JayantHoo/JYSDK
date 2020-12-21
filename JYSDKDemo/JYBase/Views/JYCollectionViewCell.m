//
//  JYCollectionViewCell.m
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/20.
//  Copyright © 2020 isenu. All rights reserved.
//

#import "JYCollectionViewCell.h"

@implementation JYCollectionViewCell

+(instancetype) cellWithCollectionView:(UICollectionView *)collectionView
forIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

@end
