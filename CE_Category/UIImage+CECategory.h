//
//  UIImage+CECategory.h
//  CommanApp
//
//  Created by cxq on 15/12/12.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (CECategory)

- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage*)scaleToSizeForCircleCut:(CGSize)size;
- (UIImage*)scaleToSizeAutoWH:(CGSize)size;
- (UIImage *)shotImageWithSize:(CGSize)size;

@end
