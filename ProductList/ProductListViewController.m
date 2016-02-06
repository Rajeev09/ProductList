//
//  ProductListViewController.m
//  ProductList
//
//  Created by Test on 06/02/16.
//  Copyright © 2016 Test. All rights reserved.
//

#import "ProductListViewController.h"



@interface ProductListViewController ()

@property (nonatomic , strong) NSMutableArray *productArr;

@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
