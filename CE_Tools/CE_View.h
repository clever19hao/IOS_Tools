//
//  CE_View.h
//  Ymr
//
//  Created by cxq on 16/4/18.
//  Copyright © 2016年 celink. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ContentAligment) {
    
    ContentCenter,
    ContentLeftRight,
    ContentUpDown,
    ContentRightLeft,
    ContentDownUp,
    ContentCustom
};

@class CE_View;

typedef void (^CE_ViewHandle)(CE_View *view);

/**
 *  自定义点击控件，由背景图片，图片，描述文字构成，可以自己调整图片和文字的位置，可以响应点击事件.
 */
@interface CE_View : UIImageView

@property (nonatomic,strong,readonly) UIImageView *foreImageView;//由外面设置foreImageView的属性
@property (nonatomic,strong,readonly) UILabel *describeLabel;//由外面设置describeLabel的属性

//@property (nonatomic,assign) UIEdgeInsets contentInset;//内容缩进 default{0,0,0,0}

@property (nonatomic,assign) BOOL adjustImageByState;// default YES

@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) BOOL enabled;

@property (nonatomic,assign) ContentAligment contentAligment;
@property (nonatomic,assign) CGSize foreImageSize;
@property (nonatomic,assign) CGFloat space;//default 3.0

@property (nonatomic, getter=isUserInteractionEnabled) BOOL userInteractionEnabled; // default is YES

- (void)setBackgroundImage:(NSString *)imageName forState:(UIControlState)state;
- (void)setForeImage:(NSString *)imageName forState:(UIControlState)state;

- (void)setTouchHandle:(CE_ViewHandle)selectHandle;

@end
