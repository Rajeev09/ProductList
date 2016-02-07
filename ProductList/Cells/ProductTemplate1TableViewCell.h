//
//  ProductTemplate1TableViewCell.h
//  ProductList
//
//  Created by Test on 08/02/16.
//  Copyright © 2016 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTemplate1TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

+(instancetype)getTemplate1Cell;

+(NSString *)cellIdentifierForTableView;

@end
