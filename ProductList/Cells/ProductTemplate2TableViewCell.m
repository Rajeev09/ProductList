//
//  ProductTemplate2TableViewCell.m
//  ProductList
//
//  Created by Test on 08/02/16.
//  Copyright © 2016 Test. All rights reserved.
//

#import "ProductTemplate2TableViewCell.h"
#import "CVCell.h"

@implementation PLIndexCollectionView



@end

@implementation ProductTemplate2TableViewCell

- (void)awakeFromNib {
    // Initialization code
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(175, 190);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:@"CVCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView setCollectionViewLayout:layout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+(instancetype)getTemplate2Cell{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] objectAtIndex:0];
}

+(NSString *)cellIdentifierForTableView{
    return NSStringFromClass(self);
}


- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.indexPath = indexPath;
    
    [self.collectionView reloadData];
}

//




@end
