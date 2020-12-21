//
//  JYCollectionViewCell.h
//  JYSDKDemo
//
//  Created by jayant hoo on 2020/12/20.
//  Copyright © 2020 isenu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYCollectionViewCell : UICollectionViewCell

@property (nonatomic,weak) id cellData;

+(instancetype) cellWithCollectionView:(UICollectionView *)collectionView
forIndexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
