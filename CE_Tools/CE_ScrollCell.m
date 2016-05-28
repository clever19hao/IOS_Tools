//
//  CE_ScrollCell.m
//  CommanApp
//
//  Created by cxq on 16/5/28.
//  Copyright © 2016年 cxq. All rights reserved.
//

#import "CE_ScrollCell.h"

@interface CE_ScrollCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *containerView;

@end

@implementation CE_ScrollCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.clipsToBounds = YES;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 2;
        _scrollView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _scrollView.layer.position = CGPointMake(_scrollView.frame.size.width/2, _scrollView.frame.size.height/2);
        
        [self addSubview:_scrollView];
        
        _ivContent = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
        _ivContent.contentMode = UIViewContentModeScaleAspectFit;
        _ivContent.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _ivContent.backgroundColor = [UIColor orangeColor];
        [_scrollView addSubview:_ivContent];
    }
    
    return self;
}

#pragma mark- Scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _ivContent;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    NSLog(@"%f %f %f %f %f %f",scrollView.contentSize.width,scrollView.contentSize.height,scrollView.frame.size.width,scrollView.frame.size.height,scrollView.frame.origin.x,scrollView.frame.origin.y);
    
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _ivContent.frame.size.width;
    CGFloat H = _ivContent.frame.size.height;
    
    CGRect rct = _ivContent.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    _containerView.frame = rct;
}

- (void)resetZoomScale {
    
    _scrollView.zoomScale = 1;
    
}



@end
