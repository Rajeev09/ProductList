//
//  ProductTemplate2TableViewCell.h
//  ProductList
//
//  Created by Test on 08/02/16.
//  Copyright © 2016 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"


@interface PLIndexCollectionView : UICollectionView

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@interface ProductTemplate2TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PLIndexCollectionView *collectionView;



+(instancetype)getTemplate2Cell;

+(NSString *)cellIdentifierForTableView;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;


@end
