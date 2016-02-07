//
//  ProductTemplate3TableViewCell.m
//  ProductList
//
//  Created by Test on 08/02/16.
//  Copyright © 2016 Test. All rights reserved.
//

#import "ProductTemplate3TableViewCell.h"

@implementation PTScrollView


@end

@interface ProductTemplate3TableViewCell ()

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSMutableArray *pageViews;


@end

@implementation ProductTemplate3TableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
}


-(void)configureCellView{
    
    
    
    _itemArray = self.pModel.itemArr;
    NSInteger pageCount = self.itemArray.count;
    
    // Set up the page control
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.itemArray.count, pagesScrollViewSize.height);
    
    // Load the initial set of pages that are on screen
    [self loadVisiblePages];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+(instancetype)getTemplate3Cell{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] objectAtIndex:0];
}

+(NSString *)cellIdentifierForTableView{
    return NSStringFromClass(self);
}



#pragma mark - Scroll View

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.itemArray.count; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.itemArray.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        UIImageView *newPageView = [[UIImageView alloc] init];
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
        
        ItemModel *iModel = [self.itemArray objectAtIndex:page];
        
        // STORE IN FILESYSTEM
        
        
        //Image Caching
        NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *file = [cachesDirectory stringByAppendingPathComponent:iModel.imageUrl];
        NSData *imageData = [self.memoryCache objectForKey:iModel.imageUrl];
        
        if (imageData) {
            
            newPageView.image = [UIImage imageWithData: imageData];
            newPageView.contentMode = UIViewContentModeScaleToFill;
            
            
        }
        else if ([[NSFileManager defaultManager] fileExistsAtPath:file]){
            
            NSData *diskData = [NSData dataWithContentsOfFile:file];
            [self.memoryCache setObject:diskData forKey:iModel.imageUrl];
            newPageView.image = [UIImage imageWithData: diskData];
            newPageView.contentMode = UIViewContentModeScaleToFill;
            
        }
        else{
            
            [self displayActivityIndicatorInView:newPageView];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                NSString *urlString = iModel.imageUrl;
                
                NSData *downloadedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                
                if (downloadedData) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        newPageView.image = [UIImage imageWithData: downloadedData];
                        newPageView.contentMode = UIViewContentModeScaleToFill;
                        [self hideActivityIndicatorInView:newPageView];
                    });
                    
                    
                    [downloadedData writeToFile:file atomically:YES];
                    
                    // STORE IN MEMORY
                    [_memoryCache setObject:downloadedData forKey:urlString];
                }
                
                // NOW YOU CAN CREATE AN AVASSET OR UIIMAGE FROM THE FILE OR DATA
            });
            
        }
        
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.itemArray.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages which are now on screen
    [self loadVisiblePages];
}

#pragma mark - Activity Indicator

-(void)displayActivityIndicatorInView:(UIView *)view{
    
    UIActivityIndicatorView *_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.hidesWhenStopped = YES;
    [view addSubview:_activityIndicator];
    _activityIndicator.center = view.center;
    
    
    
    [_activityIndicator startAnimating];
    
}

-(void)hideActivityIndicatorInView:(UIView *)view{
    
    for (id sbview in [view subviews]) {
        if ([sbview isKindOfClass:[UIActivityIndicatorView class]]) {
            [sbview removeFromSuperview];
        }
    }
}





@end
