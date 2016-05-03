//
//  CE_Polyline.m
//  Ymr
//
//  Created by cxq on 16/4/22.
//  Copyright © 2016年 celink. All rights reserved.
//

#import "CE_Polyline.h"
#import "CE_SeperatorView.h"

@interface CE_PolylineLayer : CAShapeLayer

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) CGFloat currentValue;
@property (nonatomic,assign) CGFloat maxValue;

@end

@implementation CE_PolylineLayer


@end

@interface CE_RepeatItem : NSObject

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) CGFloat currentValue;
@property (nonatomic,strong) NSString *toptitle;
@property (nonatomic,strong) NSString *bottomtitle;

@property (nonatomic,strong) CAShapeLayer *lineLayer;
@property (nonatomic,strong) CAShapeLayer *pointLayer;
@property (nonatomic,strong) UILabel *pointDesLabel;
@property (nonatomic,strong) UILabel *pointDateLabel;

- (void)clear;

@end

@implementation CE_RepeatItem

- (id)init {
    
    if (self = [super init]) {
        
        _index = -1;
        
        _lineLayer = [[CAShapeLayer alloc] init];
        _lineLayer.fillColor = [UIColor clearColor].CGColor;
        
        _pointLayer = [[CAShapeLayer alloc] init];
        
        _pointDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _pointDesLabel.font = [UIFont systemFontOfSize:12];
        _pointDesLabel.textAlignment = NSTextAlignmentCenter;
        _pointDesLabel.textColor = [UIColor colorWithRed:255/255.0 green:204/255.0 blue:0 alpha:1.0];
        
        _pointDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _pointDateLabel.backgroundColor = [UIColor clearColor];
        _pointDateLabel.font = [UIFont systemFontOfSize:12];
        _pointDateLabel.textAlignment = NSTextAlignmentCenter;
        _pointDateLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    }
    
    return self;
}

- (void)clear {
    
    if (_index == 0) {
        _index = -1;
    }
    _index = abs((int)_index) * -1;
    _currentValue = 0;
    _toptitle = nil;
    _bottomtitle = nil;
    
    [_lineLayer removeFromSuperlayer];
    [_pointLayer removeFromSuperlayer];
    [_pointDesLabel removeFromSuperview];
    [_pointDateLabel removeFromSuperview];
}

@end

#define CONTENT_OFFSET_HOR      20
#define BOTTOM_LABEL_H          20//日期的高度
#define TOP_LABEL_H             20

@interface CE_Polyline ()
{
    NSMutableArray *lbDes;
    NSMutableArray *seperators;
    NSInteger _numberOfLines;
}

@property (nonatomic,strong) UIScrollView *lineScroll;

@property (nonatomic,strong) NSMutableDictionary *repeatItems;//复用的items

@end

@implementation CE_Polyline

- (void)dealloc {
    [_lineScroll removeObserver:self forKeyPath:@"contentOffset"];
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _lineScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _lineScroll.contentInset = UIEdgeInsetsMake(0, CONTENT_OFFSET_HOR, 0, CONTENT_OFFSET_HOR);
        
        [_lineScroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [self addSubview:_lineScroll];
        
        _repeatItems = [NSMutableDictionary dictionaryWithCapacity:1];
        
        _maxValue = 100;
        
        _lineColor = [UIColor colorWithRed:255/255.0 green:70/250.0 blue:128/255.0 alpha:1.0];
        _lineWidth = 1.0;
        _lineInternalSpace = 45;
        
        _linePointColor = [UIColor colorWithRed:255/255.0 green:204/250.0 blue:0/255.0 alpha:1.0];
        _linePointRadius = 2;
        
        _seperatorDesWidth = 70;
        
        _seperatorDes = [NSMutableArray arrayWithCapacity:1];
        lbDes = [NSMutableArray arrayWithCapacity:1];
        seperators = [NSMutableArray arrayWithCapacity:1];
        
        _unitDes = @"kg";
        
        CGFloat per = _maxValue / 5.0;
        
        for (int i = 1; i <= 5; i++) {
            
            if (i == 5) {
                [_seperatorDes insertObject:[NSString stringWithFormat:@"%.1f%@",_maxValue,_unitDes] atIndex:0];
            }
            else {
                [_seperatorDes insertObject:[NSString stringWithFormat:@"%.1f%@",i*per,_unitDes] atIndex:0];
            }
        }
        
        UIView *bgLine = [[UIView alloc] initWithFrame:CGRectMake(15, frame.size.height - 20, frame.size.width - 30, 1)];
        bgLine.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
        [self addSubview:bgLine];
    }
    
    return self;
}

- (id)init {
    
    return [[CE_Polyline alloc] initWithFrame:CGRectZero];
}

#define CONTENTOFFSET_W 20//每次拖动时提前加载的宽度

- (UILabel *)seperatorDescribeLabel:(NSInteger)index {
    
    if ([lbDes count] > index) {
        
        return (UILabel *)lbDes[index];
    }
    
    UILabel *tmp = [[UILabel alloc] init];
    tmp.text = _seperatorDes[index];
    tmp.textAlignment = NSTextAlignmentRight;
    tmp.numberOfLines = 0;
    tmp.font = [UIFont systemFontOfSize:12];
    tmp.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    
    [lbDes addObject:tmp];
    
    return tmp;
}

- (CE_SeperatorView *)seperatorView:(NSInteger)index {
    
    if ([seperators count] > index) {
        
        return (CE_SeperatorView *)seperators[index];
    }
    
    CE_SeperatorView *line = [[CE_SeperatorView alloc] init];
    line.sepetatorColors = @[[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0],[UIColor whiteColor]];
    
    [seperators addObject:line];
    
    return line;
}

- (void)reloadPolyline {
    
    _lineScroll.frame = CGRectMake(_seperatorDesWidth, 0, self.frame.size.width - _seperatorDesWidth, self.frame.size.height);
    
    if ([_delegate respondsToSelector:@selector(numberOfLinesInPolyline:)]) {
        
        _numberOfLines = [_delegate numberOfLinesInPolyline:self];
        
        _lineScroll.contentSize = CGSizeMake((_lineInternalSpace + _lineWidth) * (_numberOfLines - 1), _lineScroll.frame.size.height);
        
    }
    
    [lbDes makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [seperators makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if ([_seperatorDes count]) {
        
        CGFloat lb_h = (_lineScroll.frame.size.height - TOP_LABEL_H - BOTTOM_LABEL_H)/[_seperatorDes count];
        
        for (int i = 0; i < [_seperatorDes count]; i++) {
            
            UILabel *tmp = [self seperatorDescribeLabel:i];
            tmp.text = _seperatorDes[i];
            tmp.frame = CGRectMake(0, i*lb_h + TOP_LABEL_H - lb_h*0.5, _seperatorDesWidth, lb_h);
            [self addSubview:tmp];
            
            CE_SeperatorView *line = [self seperatorView:i];
            line.frame = CGRectMake(_seperatorDesWidth + 5, i*lb_h + TOP_LABEL_H - 0.5, self.frame.size.width - _seperatorDesWidth, 1);
            [self addSubview:line];
        }
    }
    
    [self bringSubviewToFront:_lineScroll];
    
    //重置复用的item
    NSArray *keys = [_repeatItems allKeys];
    for (NSNumber *key in keys) {
        
        CE_RepeatItem *item = [_repeatItems objectForKey:key];
        [item clear];
        
        [_repeatItems removeObjectForKey:key];
        [_repeatItems setObject:item forKey:@(item.index)];
    }
    
    [self displayScrollViewFromContentOffsetX:_lineScroll.contentOffset.x to:_lineScroll.contentOffset.x + _lineScroll.frame.size.width + CONTENTOFFSET_W];
}

- (void)displayScrollViewFromContentOffsetX:(CGFloat)from to:(CGFloat)to {
    
    NSInteger startIndex = from / (_lineInternalSpace + _lineWidth);
    
    if (startIndex < 0) {
        startIndex = 0;
    }
    
    NSInteger endIndex = to / (_lineInternalSpace + _lineWidth) + 1;
    
    if (endIndex >= _numberOfLines) {
        endIndex = _numberOfLines - 1;
    }
    
    for (NSInteger i = startIndex; i <= endIndex; i++) {
        
        CE_RepeatItem *item = [self findItemAtIndex:i between:startIndex and:endIndex];
        
        [self displayItem:item between:startIndex and:endIndex];
    }
    
    //DBG(@"repeat items count %d", [[_repeatItems allKeys] count]);
}

- (CE_RepeatItem *)findItemAtIndex:(NSInteger)index between:(NSInteger)startIndex and:(NSInteger)endIndex {
    
    CE_RepeatItem *item = [_repeatItems objectForKey:@(index)];
    
    if (item) {
        
    }
    else {
        
        if (!item) {
            
            for (NSNumber *indexKey in [_repeatItems allKeys]) {
                
                if ([indexKey integerValue] < startIndex || [indexKey integerValue] > endIndex) {
                    //查找可复用的item
                    item = [_repeatItems objectForKey:indexKey];
                    
                    [_repeatItems removeObjectForKey:indexKey];
                    
                    [item clear];
                    
                    break;
                }
            }
        }
        
        if (!item) {
            
            item = [[CE_RepeatItem alloc] init];
        }
        
        [_repeatItems setObject:item forKey:@(index)];
        
        item.index = index;
        item.lineLayer.lineWidth = _lineWidth;
        item.lineLayer.strokeColor = _lineColor.CGColor;
        item.pointLayer.fillColor = _linePointColor.CGColor;
        item.pointLayer.strokeColor = _linePointColor.CGColor;
        item.pointLayer.lineWidth = _linePointRadius;
        
        CGFloat current = [_delegate polylineValue:self atIndex:index];
        item.currentValue = current;
        
        if ([_delegate respondsToSelector:@selector(polylineTopTitle:atIndex:)]) {
            item.toptitle = [_delegate polylineTopTitle:self atIndex:index];
        }
        else {
             item.toptitle = [NSString stringWithFormat:@"%.1f%@",current,_unitDes];
        }
        
        if ([_delegate respondsToSelector:@selector(polylineBottomTitle:atIndex:)]) {
            item.bottomtitle = [_delegate polylineBottomTitle:self atIndex:index];
        }
        else {
            item.bottomtitle = [NSString stringWithFormat:@"%d",(int)index];
        }
    }
    
    return item;
}

- (void)displayItem:(CE_RepeatItem *)item between:(NSInteger)startIndex and:(NSInteger)endIndex {
    
    //画线
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (item.index > 0) {
        
        CE_RepeatItem *lastItem = [self findItemAtIndex:item.index - 1 between:startIndex and:endIndex];
        
        CGPoint mid = CGPointMake((item.index - 1) * (_lineInternalSpace + _lineWidth), (_lineScroll.frame.size.height - TOP_LABEL_H - BOTTOM_LABEL_H)*(1 - lastItem.currentValue/_maxValue) + TOP_LABEL_H);
        CGPoint end = CGPointMake(item.index * (_lineInternalSpace + _lineWidth), (_lineScroll.frame.size.height - TOP_LABEL_H - BOTTOM_LABEL_H)*(1 - item.currentValue/_maxValue) + TOP_LABEL_H);
        
        [path moveToPoint:mid];
        [path addLineToPoint:end];
    }
    
    item.lineLayer.path = path.CGPath;
    
    [_lineScroll.layer insertSublayer:item.lineLayer atIndex:0];
    
    //画点
    UIBezierPath *pathPoint = [UIBezierPath bezierPath];
    
    CGPoint end = CGPointMake(item.index * (_lineInternalSpace + _lineWidth), (_lineScroll.frame.size.height - TOP_LABEL_H - BOTTOM_LABEL_H)*(1 - item.currentValue/_maxValue) + TOP_LABEL_H);
    
    [pathPoint moveToPoint:CGPointMake(end.x, end.y - _linePointRadius)];
    [pathPoint addArcWithCenter:end radius:_linePointRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    item.pointLayer.path = pathPoint.CGPath;
    
    [_lineScroll.layer addSublayer:item.pointLayer];
    
    //画点的描述1
    item.pointDesLabel.center = CGPointMake(end.x, end.y - 15);
    item.pointDesLabel.text = item.toptitle;
    [_lineScroll addSubview:item.pointDesLabel];
    
    //画线的描述2
    item.pointDateLabel.center = CGPointMake(end.x, _lineScroll.frame.size.height - 10);
    item.pointDateLabel.text = item.bottomtitle;
    [_lineScroll addSubview:item.pointDateLabel];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        //DBG(@"%.f", _lineScroll.contentOffset.x);
        
        [self displayScrollViewFromContentOffsetX:_lineScroll.contentOffset.x to:_lineScroll.contentOffset.x + _lineScroll.frame.size.width + CONTENTOFFSET_W];
    }
}
@end
