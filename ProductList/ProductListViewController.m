//
//  ProductListViewController.m
//  ProductList
//
//  Created by Test on 06/02/16.
//  Copyright © 2016 Test. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductTemplate1TableViewCell.h"
#import "ProductTemplate2TableViewCell.h"
#import "ProductTemplate3TableViewCell.h"
#import "CVCell.h"



@interface ProductListViewController ()

@property (nonatomic , strong) NSMutableArray *productArr;
@property (nonatomic , strong) NSCache *memoryCache;
@property (nonatomic , strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.memoryCache = [[NSCache alloc] init];

    [self convertJsonFileToObjectModel];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)convertJsonFileToObjectModel{
    
    NSString *f1 = [[NSBundle mainBundle] pathForResource:@"f_one" ofType:@"json"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:f1];
    
    NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    self.productArr = [[NSMutableArray alloc] init];
    
    for (NSDictionary *productDict in jsonArr) {
        
        ProductModel *prModel = [[ProductModel alloc] init];
        prModel.productLabel = productDict[product_label];
        prModel.imageUrl = productDict[product_imageUrl];
        NSString *str = productDict[product_template];
        
        if ([str isEqualToString:@"product-template-1"]) {
            prModel.productTemplateType = ProductTemplate1;
        }
        else if ([str isEqualToString:@"product-template-2"]){
            prModel.productTemplateType = ProductTemplate2;
        }
        else{
            prModel.productTemplateType = ProductTemplate3;
        }
        
        NSArray *itemsJsonArr = productDict[product_items];
        
        NSMutableArray *itemsModelArr = [[NSMutableArray alloc] init];
        
        for (NSDictionary *itemDict in itemsJsonArr) {
            
            ItemModel *itemModel = [[ItemModel alloc] init];
            itemModel.itemLabel = itemDict[item_label];
            itemModel.imageUrl = itemDict[item_image];
            itemModel.webUrl = itemDict[item_webUrl];
            [itemsModelArr addObject:itemModel];
        }
        
        prModel.itemArr = itemsModelArr;
        [self.productArr addObject:prModel];
        
    }
    
}


#pragma mark -UITableView delagate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.productArr count];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductModel *pModel = [self.productArr objectAtIndex:indexPath.section];
    ItemModel *iModel = [pModel.itemArr objectAtIndex:0];
    
    
    switch (pModel.productTemplateType) {
        case ProductTemplate1:{
            
            ProductTemplate1TableViewCell *pt1Cell = [tableView dequeueReusableCellWithIdentifier:[ProductTemplate1TableViewCell cellIdentifierForTableView]];
            if (pt1Cell == nil) {
                pt1Cell = [ProductTemplate1TableViewCell getTemplate1Cell];
            }
            
            // STORE IN FILESYSTEM
            NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *file = [cachesDirectory stringByAppendingPathComponent:iModel.imageUrl];
            NSData *imageData = [self.memoryCache objectForKey:iModel.imageUrl];
            
            if (imageData) {
                
                pt1Cell.productImageView.image = [UIImage imageWithData:imageData];
                pt1Cell.productImageView.contentMode = UIViewContentModeScaleToFill;
                
                
            }
            else if ([[NSFileManager defaultManager] fileExistsAtPath:file]){
                
                NSData *diskData = [NSData dataWithContentsOfFile:file];
                [self.memoryCache setObject:diskData forKey:iModel.imageUrl];
                pt1Cell.productImageView.image = [UIImage imageWithData:diskData];
                pt1Cell.productImageView.contentMode = UIViewContentModeScaleToFill;
                
                
            }
            else{
                
                [self displayActivityIndicatorInView:pt1Cell.contentView];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    
                    NSString *urlString = iModel.imageUrl;
                    
                    NSData *downloadedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                    
                    if (downloadedData) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if ([[tableView indexPathForCell:pt1Cell] isEqual: indexPath]) {
                                pt1Cell.productImageView.image = [UIImage imageWithData:downloadedData];
                                pt1Cell.productImageView.contentMode = UIViewContentModeScaleToFill;
                                
                            }
                            [self hideActivityIndicatorInView:pt1Cell.contentView];
                        });
                        
                        
                        [downloadedData writeToFile:file atomically:YES];
                        
                        // STORE IN MEMORY
                        [_memoryCache setObject:downloadedData forKey:urlString];
                    }
                    
                    // NOW YOU CAN CREATE AN AVASSET OR UIIMAGE FROM THE FILE OR DATA
                });
                
            }
            return pt1Cell;
            
            
        }
            break;
        case ProductTemplate2:{
            
            ProductTemplate2TableViewCell *pt2Cell = [tableView dequeueReusableCellWithIdentifier:[ProductTemplate2TableViewCell cellIdentifierForTableView]];
            if (pt2Cell == nil) {
                
                pt2Cell = [ProductTemplate2TableViewCell getTemplate2Cell];
                
            }
            
            return pt2Cell;
        }
            break;
        case ProductTemplate3:{
            
            ProductTemplate3TableViewCell *pt3Cell = [tableView dequeueReusableCellWithIdentifier:[ProductTemplate3TableViewCell cellIdentifierForTableView]];
            if (pt3Cell == nil) {
                pt3Cell = [ProductTemplate3TableViewCell getTemplate3Cell];
            }
            
            
            pt3Cell.memoryCache = self.memoryCache;
            pt3Cell.pModel = pModel;
            [pt3Cell configureCellView];
            
            return pt3Cell;
        }
            break;
        default:{
            
            return nil;
            
        }
            break;
    }
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 193.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *pModel = [self.productArr objectAtIndex:indexPath.section];
    
    if (pModel.productTemplateType == ProductTemplate2) {
        
        
        [(ProductTemplate2TableViewCell *)cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
        
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 2, tableView.bounds.size.width-10, 30)];
    
    ProductModel *pModel = [self.productArr objectAtIndex:section];
    
    UIFont *font = [UIFont systemFontOfSize:13.0f];
    
    label.attributedText = [[NSAttributedString alloc] initWithString:pModel.productLabel attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,[UIColor lightGrayColor],NSForegroundColorAttributeName, nil]];
    
    // [UIColor colorWithRed:227 green:230 blue:244 alpha:1];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.bounds.size.width, 30)];
    containerView.backgroundColor = [UIColor colorWithRed:(227.0/255.0) green:(232.0/255.0) blue:(244.0/255.0) alpha:1];
    
    [containerView addSubview:label];
    
    
    
    return containerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}



#pragma mark - UICollectionViewDataSource Methods


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    ProductModel *pModel = self.productArr[[(PLIndexCollectionView *)collectionView indexPath].section];
    return pModel.itemArr.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Setup cell identifier
    static NSString *cellIdentifier = @"CVCell";
    
    
    /* Uncomment this block to use subclass-based cells */
    CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    ProductModel *pModel = self.productArr[[(PLIndexCollectionView *)collectionView indexPath].section];
    
    ItemModel *iModel = [pModel.itemArr objectAtIndex:indexPath.item];
    
    // STORE IN FILESYSTEM
    
    
    //Image Caching
    NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *file = [cachesDirectory stringByAppendingPathComponent:iModel.imageUrl];
    NSData *imageData = [self.memoryCache objectForKey:iModel.imageUrl];
    
    if (imageData) {
        
        cell.imageView.image = [UIImage imageWithData: imageData];
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        cell.titleLabel.text = iModel.itemLabel;
        
        
    }
    else if ([[NSFileManager defaultManager] fileExistsAtPath:file]){
        
        NSData *diskData = [NSData dataWithContentsOfFile:file];
        [self.memoryCache setObject:diskData forKey:iModel.imageUrl];
        cell.imageView.image = [UIImage imageWithData: diskData];
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        cell.titleLabel.text = iModel.itemLabel;
        
        
    }
    else{
        
        [self displayActivityIndicatorInView:cell.contentView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSString *urlString = iModel.imageUrl;
            
            NSData *downloadedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            
            if (downloadedData) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = [UIImage imageWithData: downloadedData];
                    cell.imageView.contentMode = UIViewContentModeScaleToFill;
                    cell.titleLabel.text = iModel.itemLabel;
                    
                    [self hideActivityIndicatorInView:cell.contentView];
                });
                
                
                [downloadedData writeToFile:file atomically:YES];
                
                // STORE IN MEMORY
                [_memoryCache setObject:downloadedData forKey:urlString];
            }
            
            // NOW YOU CAN CREATE AN AVASSET OR UIIMAGE FROM THE FILE OR DATA
        });
        
    }
    
    return cell;
    
}

#pragma mark - Activity Indicator

-(void)displayActivityIndicatorInView:(UIView *)view{
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.hidesWhenStopped = YES;
    [view addSubview:self.activityIndicator];
    self.activityIndicator.center = view.center;
    [self.activityIndicator startAnimating];
    
}

-(void)hideActivityIndicatorInView:(UIView *)view{
    
    for (id sbview in [view subviews]) {
        if ([sbview isKindOfClass:[UIActivityIndicatorView class]]) {
            [sbview removeFromSuperview];
        }
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
