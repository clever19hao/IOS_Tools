//
//  CE_SliderSelection.h
//  Ymr
//
//  Created by cxq on 16/4/20.
//  Copyright © 2016年 celink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CE_View;
@class CE_SliderSelection;

typedef void (^CE_SliderHandle)(CE_SliderSelection *view,NSInteger selectIndex);
/**
 *  自定义的滑动开关
 */
@interface CE_SliderSelection : UIView

@property (nonatomic,strong) UIColor *selectColor;//default 255,70,128
@property (nonatomic,assign) UIColor *boldLineColor;
@property (nonatomic,assign,readonly) NSInteger selectIndex;

+ (CE_View *)createItemImageSize:(CGSize)size
                        describe:(NSString *)describe;

- (void)setItems:(NSArray <CE_View *> *)items selectionHandle:(CE_SliderHandle)selectHandle;

- (void)sliderItem:(NSInteger)index animate:(BOOL)animate;

@end
