//
//  CE_HeadView.m
//  Ymr
//
//  Created by cxq on 16/4/20.
//  Copyright © 2016年 celink. All rights reserved.
//

#import "CE_HeadView.h"

@implementation CE_HeadView

- (id)initWithFrame:(CGRect)frame edgeWidth:(CGFloat)edgeWidth {
    
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = frame.size.width/2;
        
        self.clipsToBounds = YES;
        
        self.foreImageSize = CGSizeMake(frame.size.width - 2*edgeWidth, frame.size.height - 2*edgeWidth);
        self.foreImageView.layer.cornerRadius = frame.size.width/2 - edgeWidth;
        self.foreImageView.clipsToBounds = YES;
        
        self.adjustImageByState = NO;
    }
    
    return self;
}

@end
