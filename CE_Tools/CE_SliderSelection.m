//
//  CE_SliderSelection.m
//  Ymr
//
//  Created by cxq on 16/4/20.
//  Copyright © 2016年 celink. All rights reserved.
//

#import "CE_SliderSelection.h"
#import "CE_View.h"

@interface CE_SliderSelection  ()

@property (nonatomic,copy) CE_SliderHandle handle;

@property (nonatomic,strong) UIView *sliderView;

@end

@implementation CE_SliderSelection

+ (CE_View *)createItemImageSize:(CGSize)size
                        describe:(NSString *)describe {
    
    CE_View *item = [[CE_View alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    if (describe.length) {
        
        item.describeLabel.text = describe;
        item.describeLabel.textAlignment = NSTextAlignmentCenter;
        item.describeLabel.frame = CGRectMake(0, 0, w, h);
        item.describeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    
    return item;
}

- (void)setItems:(NSArray <CE_View *> *)items selectionHandle:(CE_SliderHandle)selectHandle {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.handle = selectHandle;
    
    if (!_sliderView) {
        _sliderView = [[UIView alloc] init];
        [self addSubview:_sliderView];
    }
    
    self.layer.borderColor = self.boldLineColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = self.frame.size.height/2;
    
    __weak CE_SliderSelection *tmpSelf = self;
    
    CGFloat start_x = 0;
    for (int i = 0; i < [items count]; i++) {
        
        CE_View *item = [items objectAtIndex:i];
        item.tag = i+1000;
        item.frame = CGRectMake(start_x, 0, item.frame.size.width, item.frame.size.height);
        
        [item setTouchHandle:^(CE_View *view) {
            
            [tmpSelf sliderItem:i animate:YES];
            
        }];
        
        start_x += item.frame.size.width;
        
        [self addSubview:item];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self sliderItem:0 animate:NO];
    });
    
}

- (void)sliderItem:(NSInteger)index animate:(BOOL)animate {
    
    CE_View *old = [self viewWithTag:1000 + _selectIndex];
    old.selected = NO;
    
    CE_View *item = [self viewWithTag:1000+index];
    item.selected = YES;
    
    _selectIndex = index;
    
    _sliderView.backgroundColor = [UIColor colorWithRed:255/255.0 green:70/255.0 blue:128/255.0 alpha:1.0];
    _sliderView.layer.cornerRadius = item.frame.size.height/2;
    
    if (animate) {
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             
                             _sliderView.frame = item.frame;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    else {
        _sliderView.frame = item.frame;
    }
    
    if (self.handle) {
        self.handle(self,_selectIndex);
    }
}

@end
