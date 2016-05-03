//
//  CE_View.m
//  Ymr
//
//  Created by cxq on 16/4/18.
//  Copyright © 2016年 celink. All rights reserved.
//

#import "CE_View.h"

@interface CE_View ()

@property (nonatomic,assign) UIControlState status;
@property (nonatomic,copy) CE_ViewHandle handle;

@end

@implementation CE_View
{
    CGFloat _originAlpha;
    
    NSMutableDictionary *foreImageInfo;
    NSMutableDictionary *backImageInfo;
}

@synthesize foreImageView = _foreImageView;
@synthesize describeLabel = _describeLabel;
@synthesize userInteractionEnabled = _userInteractionEnabled;

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _userInteractionEnabled = YES;
        
        _space = 3;
        
        _originAlpha = 1.0;
        
        _adjustImageByState = YES;
        _contentAligment = ContentCenter;
    }
    
    return self;
}

- (id)init {
    
    return [[CE_View alloc] initWithFrame:CGRectZero];
}

- (UIImageView *)foreImageView {
    
    if (!_foreImageView) {
        
        _foreImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_foreImageView];
    }
    
    return _foreImageView;
}

- (UILabel *)describeLabel {
    
    if (!_describeLabel) {
        
        _describeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _describeLabel.numberOfLines = 0;
        [self addSubview:_describeLabel];
    }
    
    return _describeLabel;
}

- (BOOL)isUserInteractionEnabled {
    
    return _userInteractionEnabled;
}

- (void)setEnabled:(BOOL)enabled {
    
    if (enabled) {
        self.status = UIControlStateNormal;
    }
    else {
        self.status = UIControlStateDisabled;
    }
    
    _enabled = enabled;
}

- (void)setAlpha:(CGFloat)alpha {
    
    [super setAlpha:alpha];
    
    _originAlpha = alpha;
}

- (void)setBackgroundImage:(NSString *)imageName forState:(UIControlState)state {
    
    if (!backImageInfo) {
        backImageInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    
    if (imageName.length) {
        [backImageInfo setObject:imageName forKey:@(state)];
    }
    else {
        [backImageInfo removeObjectForKey:@(state)];
    }
    
    [self displayImage];
}

- (void)setForeImage:(NSString *)imageName forState:(UIControlState)state {
    
    if (!foreImageInfo) {
        foreImageInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    
    if (imageName.length) {
        [foreImageInfo setObject:imageName forKey:@(state)];
    }
    else {
        [foreImageInfo removeObjectForKey:@(state)];
    }
    
    [self displayImage];
}

- (void)displayImage {
    
    if (!_adjustImageByState) {
        return;
    }
    
    switch (_status) {
        case UIControlStateNormal:
        {
            self.foreImageView.image = [UIImage imageNamed:foreImageInfo[@(UIControlStateNormal)]];
            
            self.image = [UIImage imageNamed:backImageInfo[@(UIControlStateNormal)]];
        }
            break;
        case UIControlStateHighlighted:
        {
            
            if (foreImageInfo[@(UIControlStateHighlighted)]) {
                
                self.foreImageView.image = [UIImage imageNamed:foreImageInfo[@(UIControlStateHighlighted)]];
            }
            else {
                self.foreImageView.image = [UIImage imageNamed:foreImageInfo[@(UIControlStateNormal)]];
            }
            
            if (backImageInfo[@(UIControlStateHighlighted)]) {
                
                self.image = [UIImage imageNamed:backImageInfo[@(UIControlStateHighlighted)]];
            }
            else {
                self.image = [UIImage imageNamed:backImageInfo[@(UIControlStateNormal)]];
            }
        }
            break;
        case UIControlStateSelected:
        {
            
            if (foreImageInfo[@(UIControlStateSelected)]) {
                
                self.foreImageView.image = [UIImage imageNamed:foreImageInfo[@(UIControlStateSelected)]];
            }
            else {
                self.foreImageView.image = [UIImage imageNamed:foreImageInfo[@(UIControlStateNormal)]];
            }
            
            if (backImageInfo[@(UIControlStateSelected)]) {
                
                self.image = [UIImage imageNamed:backImageInfo[@(UIControlStateSelected)]];
            }
            else {
                self.image = [UIImage imageNamed:backImageInfo[@(UIControlStateNormal)]];
            }
        }
            break;
        case UIControlStateDisabled:
        {
            
            if (foreImageInfo[@(UIControlStateDisabled)]) {
                
                self.foreImageView.image = [UIImage imageNamed:foreImageInfo[@(UIControlStateDisabled)]];
            }
            else {
                self.foreImageView.image = [UIImage imageNamed:foreImageInfo[@(UIControlStateNormal)]];
            }
            
            if (backImageInfo[@(UIControlStateDisabled)]) {
                
                self.image = [UIImage imageNamed:backImageInfo[@(UIControlStateDisabled)]];
            }
            else {
                self.image = [UIImage imageNamed:backImageInfo[@(UIControlStateNormal)]];
            }
        }
            break;
        default:
            
            self.foreImageView.image = [UIImage imageNamed:foreImageInfo[@(UIControlStateNormal)]];
            
            self.image = [UIImage imageNamed:backImageInfo[@(UIControlStateNormal)]];
            break;
    }
}

- (void)setStatus:(UIControlState)status {
    
    _status = status;
    
    [self displayImage];
    
    switch (status) {
        case UIControlStateNormal:
        {
            _describeLabel.highlighted = NO;
            super.alpha = _originAlpha;
        }
            break;
        case UIControlStateHighlighted:
        {
            _describeLabel.highlighted = YES;
            
            if (![UIImage imageNamed:backImageInfo[@(UIControlStateHighlighted)]] && ![UIImage imageNamed:foreImageInfo[@(UIControlStateHighlighted)]]) {
                
                super.alpha = _originAlpha*0.5;
            }
        }
            break;
        case UIControlStateSelected:
        {
            _describeLabel.highlighted = YES;
        }
            break;
        case UIControlStateDisabled:
        {
            _describeLabel.highlighted = NO;
            
            if (![UIImage imageNamed:backImageInfo[@(UIControlStateDisabled)]] && ![UIImage imageNamed:foreImageInfo[@(UIControlStateDisabled)]]) {
                
                super.alpha = _originAlpha*0.5;
            }
        }
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        self.status = UIControlStateSelected;
    }
    else {
        self.status = UIControlStateNormal;
    }
    
    _selected = selected;
}

- (void)layoutSubviews {
    
    //DBG(@"layoutSubviews %@",self);
    [super layoutSubviews];
    
    if (_contentAligment == ContentLeftRight) {
        
        _foreImageView.frame = CGRectMake(0,(self.bounds.size.height - _foreImageSize.height)/2,_foreImageSize.width,_foreImageSize.height);
        
        _describeLabel.frame = CGRectMake(_foreImageSize.width + _space, 0, self.bounds.size.width - _foreImageSize.width - _space, self.bounds.size.height);
    }
    else if (_contentAligment == ContentUpDown) {
        
        _foreImageView.frame = CGRectMake((self.bounds.size.width - _foreImageSize.width)/2,0,_foreImageSize.width,_foreImageSize.height);
        
        CGSize tSize = [CE_Methods getStrSize:_describeLabel.text font:_describeLabel.font containSize:CGSizeMake(self.bounds.size.width,10000)];
        
        _describeLabel.frame = CGRectMake((self.bounds.size.width - tSize.width)/2, _foreImageSize.height + _space, tSize.width, tSize.height);
    }
    else if (_contentAligment == ContentCenter) {
        
        _foreImageView.frame = CGRectMake((self.bounds.size.width - _foreImageSize.width)/2,(self.bounds.size.height - _foreImageSize.height)/2,_foreImageSize.width,_foreImageSize.height);
        _describeLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    }
    else if (_contentAligment == ContentRightLeft) {
        
        _foreImageView.frame = CGRectMake(self.bounds.size.width - _foreImageSize.width,(self.bounds.size.height - _foreImageSize.height)/2,_foreImageSize.width,_foreImageSize.height);
        _describeLabel.frame = CGRectMake(0, 0, self.bounds.size.width - _foreImageSize.width - _space, self.bounds.size.height);
        _describeLabel.textAlignment = NSTextAlignmentRight;
    }
    else if (_contentAligment == ContentDownUp) {
        
        _foreImageView.frame = CGRectMake((self.bounds.size.width - _foreImageSize.width)/2,self.bounds.size.height - _foreImageSize.height,_foreImageSize.width,_foreImageSize.height);
        _describeLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - _foreImageSize.height - _space);
    }
}

- (void)setTouchHandle:(CE_ViewHandle)selectHandle {
    
    self.handle = selectHandle;
}

#pragma mark - touch methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_status == UIControlStateDisabled) {
        return;
    }
    
    if (_status == UIControlStateNormal) {
        
        self.status = UIControlStateHighlighted;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_status == UIControlStateDisabled) {
        return;
    }
    
    if (_status == UIControlStateHighlighted) {
        self.status = UIControlStateNormal;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    if (p.x < 0 || p.x > self.frame.size.width || p.y < 0 || p.y > self.frame.size.height) {
        return;
    }
    
    if (self.handle) {
        self.handle(self);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_status == UIControlStateDisabled) {
        return;
    }
    
    if (_status == UIControlStateHighlighted) {
        self.status = UIControlStateNormal;
    }
}


@end
