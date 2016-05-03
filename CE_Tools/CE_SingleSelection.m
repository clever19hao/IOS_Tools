//
//  CE_SingleSelection.m
//  Ymr
//
//  Created by cxq on 16/4/19.
//  Copyright © 2016年 celink. All rights reserved.
//

#import "CE_SingleSelection.h"
#import "CE_View.h"

@interface CE_SingleSelection ()

@property (nonatomic,copy) CE_SelectHandle handle;

@property (nonatomic,strong) NSMutableArray *items;

@end

@implementation CE_SingleSelection

+ (CE_View *)createItemWithImageSize:(CGSize)size
                            describe:(NSString *)describe {

    CE_View *item = [[CE_View alloc] initWithFrame:CGRectZero];
    item.foreImageSize = size;
    
    if (describe.length) {
        
        item.describeLabel.text = describe;
        item.describeLabel.numberOfLines = 0;
    }
        
    return item;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    for (CE_View *v in self.items) {
        
        NSInteger i = v.tag - 1000;
        
        v.frame = CGRectMake(i * (_itemSize.width + _itemSpace), (self.frame.size.height - _itemSize.height)/2, _itemSize.width, _itemSize.height);
        
//        CGFloat remaind_w = _itemSize.width - v.foreImageView.frame.size.width;
//        v.describeLabel.frame = CGRectMake(v.foreImageView.frame.size.width + 2, 0, remaind_w - 2, _itemSize.height);
//        v.foreImageView.frame = CGRectMake(0, (_itemSize.height - v.foreImageView.frame.size.height)/2, v.foreImageView.frame.size.width, v.foreImageView.frame.size.height);
    }
}



- (void)setSelectionItems:(NSArray <CE_View *> *)items selectionHandle:(CE_SelectHandle)selectHandle {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (!_items) {
        _items = [NSMutableArray arrayWithCapacity:1];
    }
    
    [_items setArray:items];
    
    self.handle = selectHandle;
    
    __weak CE_SingleSelection *tmpSelf = self;
    
    for (int i = 0; i < [items count]; i++) {
        
        CE_View *item = [items objectAtIndex:i];
        item.tag = i+1000;
        item.frame = CGRectMake(i * (_itemSize.width + _itemSpace), (self.frame.size.height - _itemSize.height)/2, _itemSize.width, _itemSize.height);
        
//        CGFloat remaind_w = _itemSize.width - item.foreImageView.frame.size.width;
//        item.describeLabel.frame = CGRectMake(item.foreImageView.frame.size.width + 2, 0, remaind_w - 2, _itemSize.height);
//        item.foreImageView.frame = CGRectMake(0, (_itemSize.height - item.foreImageView.frame.size.height)/2, item.foreImageView.frame.size.width, item.foreImageView.frame.size.height);
        
        [item setTouchHandle:^(CE_View *view) {
           
            [tmpSelf setSelectIndex:i animate:NO];
            
        }];
        
        [self addSubview:item];
    }
    
    CE_View *item = [self itemAtIndex:_selectIndex];
    item.selected = YES;
}

- (CE_View *)itemAtIndex:(NSInteger)index {
    
    return [self viewWithTag:1000+index];
}

- (void)setSelectIndex:(NSInteger)selectIndex animate:(BOOL)animate {
    
    CE_View *oldItem = [self itemAtIndex:_selectIndex];
    oldItem.selected = NO;
    
    CE_View *item = [self itemAtIndex:selectIndex];
    
    _selectIndex = selectIndex;
    
    item.selected = YES;
    
    if (self.handle) {
        self.handle(self,selectIndex);
    }
    
}

@end
