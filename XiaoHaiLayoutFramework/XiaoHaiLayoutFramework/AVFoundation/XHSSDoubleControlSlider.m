//
//  XHSSDoubleControlSlider.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/30.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSDoubleControlSlider.h"

@interface XHSSDoubleControlSlider ()

@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation XHSSDoubleControlSlider {
#warning UIImageView design
    UIImageView *_baseTrack;
    UIImageView *_topTrack;
    UIImageView *_leftControl;
    UIImageView *_rightControl;
}

#pragma mark - setter & getter
//- (void)setLeftValue:(CGFloat)leftValue {
//    _leftValue = leftValue;
//    if (self.leftValueChangeCallback) {
//        self.leftValueChangeCallback(_leftValue);
//    }
//}

//- (void)setRightValue:(CGFloat)rightValue {
//    _rightValue = rightValue;
//    if (self.rightValueChangeCallback) {
//        self.rightValueChangeCallback(_rightValue);
//    }
//}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    //
    [self refreshFrame];
}

- (void)setupUI {
    
    
    _baseTrack = [self imageViewWithBackgroundColor:[UIColor blueColor] cornerRadius:0*0.5];
    [self addSubview:_baseTrack];
    
    _topTrack = [self imageViewWithBackgroundColor:[UIColor redColor] cornerRadius:0*0.5];
    [self addSubview:_topTrack];
    
    _leftControl = [self imageViewWithBackgroundColor:[UIColor purpleColor] cornerRadius:0*0.5];
    [self addSubview:_leftControl];
    
    _rightControl = [self imageViewWithBackgroundColor:[UIColor purpleColor] cornerRadius:0*0.5];
    [self addSubview:_rightControl];
    
    [self refreshFrame];
}

- (void)refreshFrame {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat leftControlW = 30;
    CGFloat leftControlH = 30;
    CGFloat leftControlX = 0;
    CGFloat leftControlY = (height - leftControlH)*0.5;
    
    CGFloat rightControlW = 30;
    CGFloat rightControlH = 30;
    CGFloat rightControlX = width - leftControlW;
    CGFloat rightControlY = (height - rightControlH)*0.5;
    
    CGFloat baseTrackW = width - (leftControlX*2 + leftControlW);
    CGFloat baseTrackH = height > 10 ? 10 : height;
    CGFloat baseTrackX = leftControlX + leftControlW*0.5;
    CGFloat baseTrackY = (height - baseTrackH)*0.5;
    
    CGFloat topTrackW = baseTrackW;
    CGFloat topTrackH = baseTrackH;
    CGFloat topTrackX = baseTrackX;
    CGFloat topTrackY = baseTrackY;
    
    _baseTrack.frame = CGRectMake(baseTrackX, baseTrackY, baseTrackW, baseTrackH);
    _baseTrack.layer.cornerRadius = baseTrackH*0.5;
    _topTrack.frame = CGRectMake(topTrackX, topTrackY, topTrackW, topTrackH);
    _topTrack.layer.cornerRadius = topTrackH*0.5;
    _leftControl.frame = CGRectMake(leftControlX, leftControlY, leftControlW, leftControlH);
    _leftControl.layer.cornerRadius = leftControlW*0.5;
    _rightControl.frame = CGRectMake(rightControlX, rightControlY, rightControlW, rightControlH);
    _rightControl.layer.cornerRadius = rightControlW*0.5;
}

// create UIImageView
- (UIImageView*)imageViewWithBackgroundColor:(UIColor*)color cornerRadius:(CGFloat)cornerRadius {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = color;
    imageView.layer.cornerRadius = cornerRadius;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    return imageView;
}

#pragma mark - action
- (void)addTarget:(id)target action:(SEL)action {
    self.target = target;
    self.action = action;
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    if ([self ifPoint:currentLocation inView:_leftControl]) {
    }
    if ([self ifPoint:currentLocation inView:_rightControl]) {
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    if ([self ifPoint:currentLocation inView:_leftControl]) {
        if (currentLocation.x - _leftControl.frame.size.width*0.5 < 0 ||
            currentLocation.x + _leftControl.frame.size.width*0.5 > _rightControl.frame.origin.x) {
            return;
        }
        
        CGRect oldFramel = _leftControl.frame;
        oldFramel.origin.x = currentLocation.x - oldFramel.size.width*0.5;
        _leftControl.frame = oldFramel;
    }
    if ([self ifPoint:currentLocation inView:_rightControl]) {
        if (currentLocation.x - _rightControl.frame.size.width*0.5 < CGRectGetMaxX(_leftControl.frame) ||
            currentLocation.x + _rightControl.frame.size.width*0.5 > self.frame.size.width) {
            return;
        }
        
        CGRect oldFramer = _rightControl.frame;
        oldFramer.origin.x = currentLocation.x - oldFramer.size.width*0.5;
        _rightControl.frame = oldFramer;
    }
    [self calculateValuesWithLeftValue:CGRectGetMaxX(_leftControl.frame) rightValue:_rightControl.frame.origin.x];
}

- (BOOL)ifPoint:(CGPoint)point inView:(UIView*)view {
    return (point.x >= view.frame.origin.x && point.x <= view.frame.origin.x+view.frame.size.width) && (point.y >= view.frame.origin.y && point.y <= view.frame.origin.y+view.frame.size.height);
}

- (void)calculateValuesWithLeftValue:(CGFloat)leftValue rightValue:(CGFloat)rightValue {
    CGFloat totalWidth = _baseTrack.frame.size.width - _leftControl.frame.size.width*0.5 - _rightControl.frame.size.width*0.5;
    CGFloat leftWidth = leftValue - _baseTrack.frame.origin.x - _leftControl.frame.size.width*0.5;
    CGFloat rightWidth = rightValue - _baseTrack.frame.origin.x - _leftControl.frame.size.width*0.5;
    
    CGFloat oldLeftValue = self.leftValue;
    CGFloat oldRightValue = self.rightValue;
    
    self.leftValue = leftWidth/totalWidth*(self.maxValue - self.minValue) + self.minValue;
    self.rightValue = rightWidth/totalWidth*(self.maxValue - self.minValue) + self.minValue;
    
    if (oldLeftValue != self.leftValue) {
        if (self.leftValueChangeCallback) {
            self.leftValueChangeCallback(self.leftValue);
        }
    }
    if (oldRightValue != self.rightValue) {
        if (self.rightValueChangeCallback) {
            self.rightValueChangeCallback(self.rightValue);
        }
    }
//    [self.target performSelector:self.action withObject:self];
    if (self.valueChangeCallback) {
        self.valueChangeCallback(self.leftValue, self.rightValue);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    if ([self ifPoint:currentLocation inView:_leftControl]) {
    }
    if ([self ifPoint:currentLocation inView:_rightControl]) {
    }
}

@end
