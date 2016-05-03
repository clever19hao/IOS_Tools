//
//  CE_Polyline.h
//  Ymr
//
//  Created by cxq on 16/4/22.
//  Copyright © 2016年 celink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CE_Polyline;

@protocol CE_PolylineDelegate  <NSObject>

@required
- (NSInteger)numberOfLinesInPolyline:(CE_Polyline *)poline;
- (CGFloat)polylineValue:(CE_Polyline *)polyline atIndex:(NSInteger)index;

@optional
- (NSString *)polylineTopTitle:(CE_Polyline *)polyline atIndex:(NSInteger)index;
- (NSString *)polylineBottomTitle:(CE_Polyline *)polyline atIndex:(NSInteger)index;

@end

@interface CE_Polyline : UIView

@property (nonatomic,weak) id <CE_PolylineDelegate> delegate;

@property (nonatomic,strong) NSMutableArray <NSString *> *seperatorDes;
@property (nonatomic,assign) CGFloat seperatorDesWidth;//default 70

@property (nonatomic,assign) CGFloat maxValue;//default 100;
@property (nonatomic,assign) CGFloat standardUpValue;
@property (nonatomic,assign) CGFloat standardDownValue;

@property (nonatomic,assign) CGFloat lineInternalSpace;//default 45
@property (nonatomic,assign) CGFloat lineWidth;//default 2

@property (nonatomic,strong) UIColor *lineColor;//default RGB(255,70,128)

@property (nonatomic,strong) UIColor *linePointColor;//default RGB(255,204,0)
@property (nonatomic,assign) CGFloat linePointRadius;

@property (nonatomic,strong) NSString *unitDes;//default kg;

- (void)reloadPolyline;

@end
