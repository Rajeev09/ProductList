//
//  ProductModel.h
//  ProductList
//
//  Created by Test on 06/02/16.
//  Copyright © 2016 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ProductTemplate1,
    ProductTemplate2,
    ProductTemplate3,
}ProductTemplateType;

@interface ProductModel : NSObject

@property (nonatomic , strong) NSString *productLabel;
@property (nonatomic , strong) NSString *imageUrl;
@property (nonatomic , assign) ProductTemplateType productTemplateType;
@property (nonatomic , strong) NSMutableArray *itemArr;

@end
