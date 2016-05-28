//
//  CE_LoopView.m
//  CommanApp
//
//  Created by cxq on 16/5/28.
//  Copyright © 2016年 cxq. All rights reserved.
//

#import "CE_LoopView.h"
#import "CE_ScrollCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#define NUM 3

@interface CE_LoopView () <UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *sourceArray;

@property (nonatomic,strong) UIScrollView *scroll;

@property (nonatomic,assign) NSInteger loadStatus;//0未加载 1加载下一张 1<<1:加载这张 1<<2加载过上一张

@end

@implementation CE_LoopView

- (id)initWithFrame:(CGRect)frame delegate:(id <CE_LoopViewDelegate>)delegate {
    
    if (self = [super initWithFrame:frame]) {
        
        _delegate = delegate;
        
        _sourceArray = [NSMutableArray arrayWithCapacity:1];
    }
    
    return self;
}

- (void)showPage:(NSInteger)pageIndex withAllImage:(id)imageSourceArray {
    
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scroll.backgroundColor = [UIColor grayColor];
        _scroll.delegate = self;
        _scroll.pagingEnabled = YES;
        [self addSubview:_scroll];
        
        _scroll.contentSize = CGSizeMake(NUM * _scroll.frame.size.width, _scroll.frame.size.height);
        
        for (int i = 0; i < 3; i++) {
            
            CE_ScrollCell *cell = [[CE_ScrollCell alloc] initWithFrame:CGRectMake(i * _scroll.frame.size.width, 0, _scroll.frame.size.width, _scroll.frame.size.height)];
            cell.tag = 1000 + i;
            [_scroll addSubview:cell];
        }
    }
    
    [_sourceArray setArray:imageSourceArray];
    
    CE_ScrollCell *cell = [self currentCell];
    cell.index = pageIndex;
    
    [_scroll setContentOffset:CGPointMake(_scroll.frame.size.width, 0) animated:NO];
    
    [self reloadCurrent];
}

- (CE_ScrollCell *)currentCell {
    
    CE_ScrollCell *cell = (CE_ScrollCell *)[_scroll viewWithTag:1001];
    
    return cell;
}

- (CE_ScrollCell *)preCell {
    
    CE_ScrollCell *cell = (CE_ScrollCell *)[_scroll viewWithTag:1000];
    
    return cell;
}

- (CE_ScrollCell *)nextCell {
    
    CE_ScrollCell *cell = (CE_ScrollCell *)[_scroll viewWithTag:1002];
    
    return cell;
}

- (void)reloadPrev {
    
    CE_ScrollCell *cur = [self currentCell];
    CE_ScrollCell *pre = [self preCell];
    
    pre.index = (cur.index + [_sourceArray count] - 1) % [_sourceArray count];
    
    [self showCell:pre];
    
    _loadStatus |= (1 << 2);
}

- (void)reloadCurrent {
    
    CE_ScrollCell *cur = [self currentCell];
    
    [self showCell:cur];
    
    _loadStatus |= (1 << 1);
}

- (void)reloadNext {
    
    CE_ScrollCell *cur = [self currentCell];
    CE_ScrollCell *next = [self nextCell];
    
    next.index = (cur.index + 1) % [_sourceArray count];
    
    [self showCell:next];
    
    _loadStatus |= (1 << 0);
}

- (void)showCell:(CE_ScrollCell *)cell {
    
    NSInteger index = cell.index;
    
    id obj = [_sourceArray objectAtIndex:index];
    
    if ([obj isKindOfClass:[UIImage class]]) {
        
        cell.ivContent.image = obj;
    }
    else if ([obj isKindOfClass:[NSData class]]) {
        
        UIImage *img = [UIImage imageWithData:obj];
        
        cell.ivContent.image = img;
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        
        UIImage *img = [UIImage imageWithContentsOfFile:obj];
        cell.ivContent.image = img;
    }
    else if ([obj isKindOfClass:[ALAsset class]]) {
        
        ALAssetRepresentation *repr = [(ALAsset *)obj defaultRepresentation];
        cell.ivContent.image = [UIImage imageWithCGImage:[repr fullScreenImage]];
    }
    else if ([obj isKindOfClass:[PHAsset class]]) {
        
        [[PHImageManager defaultManager] requestImageDataForAsset:obj options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            cell.ivContent.image = [UIImage imageWithData:imageData];
        }];
    }
    
    [cell resetZoomScale];
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x < (NUM/2)*scrollView.frame.size.width) {
        
        if (!(_loadStatus & (1 << 2))) {
            
            [self reloadPrev];
        }
    }
    else if (scrollView.contentOffset.x > (NUM/2)*scrollView.frame.size.width) {
        
        if (!(_loadStatus & (1 << 0))) {
            
            [self reloadNext];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    scrollView.scrollEnabled = YES;
    
    int index = floor(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
    
    if (index == NUM/2) {
        
        if (!(_loadStatus & (1 << 0))) {
            
            [self reloadNext];
        }
        
        if (!(_loadStatus & (1 << 2))) {
            
            [self reloadPrev];
        }
        
        return;
    }
    
    if (index == NUM/2 + 1) {
        
        CE_ScrollCell *c0 = [self preCell];
        CE_ScrollCell *c1 = [self currentCell];
        CE_ScrollCell *c2 = [self nextCell];
        
        c0.frame = CGRectMake(scrollView.frame.size.width*2, 0, c0.frame.size.width, c0.frame.size.height);
        c0.tag = 1000 + 2;
        
        c1.frame = CGRectMake(0, 0, c1.frame.size.width, c1.frame.size.height);
        c1.tag = 1000 + 0;
        
        c2.frame = CGRectMake(scrollView.frame.size.width, 0, c2.frame.size.width, c2.frame.size.height);
        c2.tag = 1000 + 1;
        
        _loadStatus &= 0x0E;
    }
    else if (index == NUM/2 - 1) {
        
        CE_ScrollCell *c0 = [self preCell];
        CE_ScrollCell *c1 = [self currentCell];
        CE_ScrollCell *c2 = [self nextCell];
        
        c0.frame = CGRectMake(scrollView.frame.size.width, 0, c0.frame.size.width, c0.frame.size.height);
        c0.tag = 1000 + 1;
        
        c1.frame = CGRectMake(scrollView.frame.size.width*2, 0, c1.frame.size.width, c1.frame.size.height);
        c1.tag = 1000 + 2;
        
        c2.frame = CGRectMake(0, 0, c2.frame.size.width, c2.frame.size.height);
        c2.tag = 1000 + 0;
        
        _loadStatus &= 0x0B;
    }
    
    if (!(_loadStatus & (1 << 0))) {
        
        [self reloadNext];
    }
    
    if (!(_loadStatus & (1 << 2))) {
        
        [self reloadPrev];
    }
    
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (decelerate) {
        scrollView.scrollEnabled = NO;
    }
}
@end
