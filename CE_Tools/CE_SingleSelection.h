//
//  CE_SingleSelection.h
//  Ymr
//
//  Created by cxq on 16/4/19.
//  Copyright © 2016年 celink. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CE_View;

@class CE_SingleSelection;

typedef void (^CE_SelectHandle)(CE_SingleSelection *view,NSInteger selectIndex);

/**
 *  自定义单选控件，由多个item <CE_View *>构成，可以定义每个item的大小及item之间的距离
 */
@interface CE_SingleSelection : UIView

@property (nonatomic,assign) CGSize itemSize;
@property (nonatomic,assign) CGFloat itemSpace;
@property (nonatomic,assign,readonly) NSInteger selectIndex;

+ (CE_View *)createItemWithImageSize:(CGSize)size
                            describe:(NSString *)describe;

- (void)setSelectionItems:(NSArray <CE_View *> *)items selectionHandle:(CE_SelectHandle)selectHandle;

- (CE_View *)itemAtIndex:(NSInteger)index;

- (void)setSelectIndex:(NSInteger)selectIndex animate:(BOOL)animate;

@end
