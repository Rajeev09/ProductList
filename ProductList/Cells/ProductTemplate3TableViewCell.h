//
//  ProductTemplate3TableViewCell.h
//  ProductList
//
//  Created by Test on 08/02/16.
//  Copyright © 2016 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProductModel.h"
#import "ItemModel.h"

@interface PTScrollView : UIScrollView

@property (nonatomic, strong) NSIndexPath *indexPath;

@end


@interface ProductTemplate3TableViewCell : UITableViewCell

@property (nonatomic, strong) ProductModel *pModel;
@property (nonatomic, strong) NSCache *memoryCache;

+(instancetype)getTemplate3Cell;

+(NSString *)cellIdentifierForTableView;

-(void)configureCellView;

@property (weak, nonatomic) IBOutlet PTScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

//- (void)setScrollViewDelegate:(id<UIScrollViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
//;

@end
