//
//  CE_ScrollCell.h
//  CommanApp
//
//  Created by cxq on 16/5/28.
//  Copyright © 2016年 cxq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CE_ScrollCell : UIView

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) CGFloat progress;

@property (nonatomic,strong) UIImageView *ivContent;

- (void)resetZoomScale;

@end
