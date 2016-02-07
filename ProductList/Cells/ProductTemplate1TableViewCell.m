//
//  ProductTemplate1TableViewCell.m
//  ProductList
//
//  Created by Test on 08/02/16.
//  Copyright © 2016 Test. All rights reserved.
//

#import "ProductTemplate1TableViewCell.h"


@implementation ProductTemplate1TableViewCell

- (void)awakeFromNib {
    // Initialization code
}


+(instancetype)getTemplate1Cell{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] objectAtIndex:0];
}

+(NSString *)cellIdentifierForTableView{
    return NSStringFromClass(self);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
