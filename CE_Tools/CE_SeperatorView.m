//
//  CE_SeperatorView.m
//  Ymr
//
//  Created by cxq on 16/4/26.
//  Copyright © 2016年 celink. All rights reserved.
//

#import "CE_SeperatorView.h"

@implementation CE_SeperatorView

- (UIColor *)colorAtIndex:(NSInteger)index {
    
    if ([_sepetatorColors count] < 1) {
        return [UIColor blackColor];
    }
    
    return [_sepetatorColors objectAtIndex:index % [_sepetatorColors count]];
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat start = 0;
    NSInteger count = 0;
    
    CGFloat per = _seperatorLength;
    if (per == 0) {
        per = 10;
    }
    while (start < rect.size.width) {
        
        if (per + start > rect.size.width) {
            per = rect.size.width - start;
        }
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, rect.size.height);
        
        CGContextMoveToPoint(context, start, rect.size.height*0.5);
        
        CGContextAddLineToPoint(context, start + per, rect.size.height*0.5);
        CGContextSetStrokeColorWithColor(context, [self colorAtIndex:count].CGColor);
        CGContextStrokePath(context);
        
        count++;
        start += per;
    }
}

@end
