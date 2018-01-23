//
//  XHSSCutImageView.m
//  TestCollectionViewLayout
//
//  Created by Apple on 2017/11/27.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSCutImageView.h"
#import "XHSSPaintingView.h"

typedef NS_ENUM(NSUInteger, XHSSContentStyle) {
    XHSSContentStyleNone,
    XHSSContentStyleHorizontalArea,
    XHSSContentStyleVerticalArea,
    XHSSContentStyleInside,
};

typedef NS_ENUM(NSUInteger, XHSSOprationType) {
    XHSSOprationTypeNone,
    XHSSOprationTypeCut,
    XHSSOprationTypeDraw,
};

@interface XHSSCutImageView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) XHSSCutImageViewStyle cutStyle;
@property (nonatomic, assign) XHSSOprationType oprationType;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIImageView *tlControl;
@property (nonatomic, strong) UIImageView *trControl;
@property (nonatomic, strong) UIImageView *blControl;
@property (nonatomic, strong) UIImageView *brControl;
//@property (nonatomic, strong) UIImageView *drawImageView;
@property (nonatomic, strong) XHSSPaintingView *paintView;

@end

@implementation XHSSCutImageView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self refreshCutImageUI];
}

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        self = [self initWithFrame:[UIScreen mainScreen].bounds];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.cutStyle = XHSSCutImageViewStyleRect;
        self.oprationType = XHSSOprationTypeCut;
        [self refreshCutImageUI];
    }
    return self;
}

#pragma mark - UI
- (void)refreshCutImageUI {
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    [self setupCutImageViewUI];
}
- (void)setupCutImageViewUI {
    // cut
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    
    // 截图控件
    UIView *contentview = [[UIView alloc] init];
    contentview.frame = self.bounds;
    contentview.backgroundColor = [UIColor clearColor];
    contentview.userInteractionEnabled = YES;
    [self addSubview:contentview];
    _contentView = contentview;
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(12, 32, 40, 30);
    [_sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"确定" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor blueColor]}];
    [_sureBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sureBtnColick:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_sureBtn];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(self.frame.size.width -12 -40, 32, 40, 30);
    [_cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    attrStr = [[NSMutableAttributedString alloc] initWithString:@"取消" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor redColor]}];
    [_cancelBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnColick:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_cancelBtn];
    
    CGFloat controlPointW = 20;
    CGFloat controlPointH = 20;
    
    _tlControl = [[UIImageView alloc] init];
    _tlControl.frame = CGRectMake(50, 100, controlPointW, controlPointH);
    _tlControl.layer.cornerRadius = [self WidthOfView:_tlControl]/2.0;
    _tlControl.clipsToBounds = YES;
    _tlControl.backgroundColor = [UIColor blueColor];
    [_contentView addSubview:_tlControl];
    
    _trControl = [[UIImageView alloc] init];
    _trControl.frame = CGRectMake(self.frame.size.width-50, 100, controlPointW, controlPointH);
    _trControl.layer.cornerRadius = [self WidthOfView:_trControl]/2.0;
    _trControl.clipsToBounds = YES;
    _trControl.backgroundColor = [UIColor blueColor];
    [_contentView addSubview:_trControl];
    
    _blControl = [[UIImageView alloc] init];
    _blControl.frame = CGRectMake(50, self.frame.size.height-100, controlPointW, controlPointH);
    _blControl.layer.cornerRadius = [self WidthOfView:_blControl]/2.0;
    _blControl.clipsToBounds = YES;
    _blControl.backgroundColor = [UIColor blueColor];
    [_contentView addSubview:_blControl];
    
    _brControl = [[UIImageView alloc] init];
    _brControl.frame = CGRectMake(self.frame.size.width-50, self.frame.size.height-100, controlPointW, controlPointH);
    _brControl.layer.cornerRadius = [self WidthOfView:_brControl]/2.0;
    _brControl.clipsToBounds = YES;
    _brControl.backgroundColor = [UIColor blueColor];
    [_contentView addSubview:_brControl];
    
    [self setNeedsDisplay];
}

#pragma mark - cut
- (UIImage*)cutImageInRect:(CGRect)rect {
    UIGraphicsBeginImageContext(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef cgImage = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *cutImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return cutImage;
}

#pragma mark - draw
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw iamge
    //    CGContextDrawImage(context, [UIApplication sharedApplication].keyWindow.bounds, self.image.CGImage);
    
    // background
    [[UIColor colorWithWhite:0 alpha:0.4] setFill];
    //CGContextBeginPath(context);
    CGContextFillRect(context, rect);
    //CGContextFillPath(context);
    
    // cut area
    CGPoint tlContrlCenter = [self centerPointOfView:_tlControl];
    CGPoint trContrlCenter = [self centerPointOfView:_trControl];
    CGPoint blContrlCenter = [self centerPointOfView:_blControl];
    CGPoint brContrlCenter = [self centerPointOfView:_brControl];
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(context, 2);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, tlContrlCenter.x, tlContrlCenter.y);
    CGContextAddLineToPoint(context, trContrlCenter.x, trContrlCenter.y);
    CGContextAddLineToPoint(context, brContrlCenter.x, brContrlCenter.y);
    CGContextAddLineToPoint(context, blContrlCenter.x, blContrlCenter.y);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextFillRect(context, [self cutRectByControlPoints]);
    CGContextFillPath(context);
}

#pragma mark - action
- (void)sureBtnColick:(UIButton*)btn {
    UIImage *image = [self cutImageInRect:[self cutRectByControlPoints]];
    
    self.oprationType = XHSSOprationTypeDraw;
    
    _paintView = [[XHSSPaintingView alloc] init];
    _paintView.frame = self.bounds;
    _paintView.image = image;
    __weak typeof(self) weakSelf = self;
    _paintView.finishCallback = ^(UIImage *image) {
        if (image == nil) {
            [weakSelf removeFromSuperview];
        } else if (weakSelf.callback) {
            weakSelf.callback(image);
            [weakSelf removeFromSuperview];
        }
    };
    [self addSubview:_paintView];
    
//    if (self.callback) {
//        self.callback(image);
//    }
}

- (void)cancelBtnColick:(UIButton*)btn {
    [self removeFromSuperview];
}

#pragma mark -touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *oneTouch = [touches anyObject];
    
    switch (self.oprationType) {
        case XHSSOprationTypeCut: {
            UIView *controlPoint = [self touchedControlPoint:oneTouch];
            if (controlPoint) {
                [self setCenterPointOfView:controlPoint centerPoint:[oneTouch locationInView:self] cutStyle:self.cutStyle];
            } else {
                // 平移整个区域
                [self moveCutAreaWithLastPoint:[oneTouch previousLocationInView:self] currentPoint:[oneTouch locationInView:self]];
            }
        }
            break;
        case XHSSOprationTypeDraw: {
        }
            break;
        default:
            break;
    }
    
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - tools
- (CGFloat)XOfView:(UIView*)view {
    return view.frame.origin.x;
}

- (CGFloat)YOfView:(UIView*)view {
    return view.frame.origin.y;
}

- (CGFloat)WidthOfView:(UIView*)view {
    return view.frame.size.width;
}

- (CGFloat)HeightOfView:(UIView*)view {
    return view.frame.size.height;
}

- (CGPoint)centerPointOfView:(UIView*)view {
    //    return [self convertPoint:CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0) toView:self];
    return CGPointMake(view.frame.origin.x + view.frame.size.width/2.0, view.frame.origin.y + view.frame.size.height/2.0);
}

- (CGRect)cutRectByControlPoints {
    return CGRectMake([self centerPointOfView:_tlControl].x,
                      [self centerPointOfView:_tlControl].y,
                      [self centerPointOfView:_trControl].x - [self centerPointOfView:_tlControl].x,
                      [self centerPointOfView:_blControl].y - [self centerPointOfView:_tlControl].y);
}

- (void)setCenterPointOfView:(UIView*)view centerPoint:(CGPoint)centerPoint cutStyle:(XHSSCutImageViewStyle)cutStyle {
    switch (cutStyle) {
        case XHSSCutImageViewStyleRect: {
            NSArray *controlPointArr = @[_tlControl, _trControl, _brControl, _blControl];
            [controlPointArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj == view) {
                    UIView *preView = controlPointArr[(idx-1+controlPointArr.count)%controlPointArr.count];
                    UIView *lastView = controlPointArr[(idx+1)%controlPointArr.count];
                    UIView *currentview = (UIView*)obj;
                    
                    [self setCenterPointOfView:currentview centerPoint:centerPoint];
                    if ([self touchPoint:centerPoint relationToView:preView] == XHSSContentStyleVerticalArea) {
                        [self setCenterPointOfView:preView centerPoint:CGPointMake([self XOfView:preView]+[self WidthOfView:preView]/2, centerPoint.y)];
                        [self setCenterPointOfView:lastView centerPoint:CGPointMake(centerPoint.x, [self YOfView:lastView]+[self HeightOfView:lastView]/2)];
                    } else if ([self touchPoint:centerPoint relationToView:preView] == XHSSContentStyleHorizontalArea) {
                        [self setCenterPointOfView:preView centerPoint:CGPointMake(centerPoint.x, [self YOfView:preView]+[self HeightOfView:preView]/2)];
                        [self setCenterPointOfView:lastView centerPoint:CGPointMake([self XOfView:lastView]+[self WidthOfView:lastView]/2, centerPoint.y)];
                    }
                    
                    [self setNeedsDisplay];
                    
                    *stop = YES;
                }
            }];
        }
            break;
        case XHSSCutImageViewStyleAny: {
            [self setCenterPointOfView:view centerPoint:centerPoint cutStyle:cutStyle];
        }
            break;
        case XHSSCutImageViewStyleNone: {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)setCenterPointOfView:(UIView*)view centerPoint:(CGPoint)centerPoint {
    CGRect frame = view.frame;
    frame.origin.x = centerPoint.x - view.frame.size.width/2.0;
    frame.origin.y = centerPoint.y - view.frame.size.height/2.0;
    view.frame = frame;
}

- (UIView*)touchedControlPoint:(UITouch*)touch {
    CGPoint touchPoint = [touch locationInView:self];
    if ([self ifTouch:touchPoint InView:_tlControl]) {
        return _tlControl;
    } else if ([self ifTouch:touchPoint InView:_trControl]) {
        return _trControl;
    } else if ([self ifTouch:touchPoint InView:_blControl]) {
        return _blControl;
    } else if ([self ifTouch:touchPoint InView:_brControl]) {
        return _brControl;
    }
    return nil;
}

- (BOOL)ifTouch:(CGPoint)touchPoint InView:(UIView*)view {
    if (touchPoint.x > view.frame.origin.x &&
        touchPoint.x < view.frame.origin.x + view.frame.size.width &&
        touchPoint.y > view.frame.origin.y &&
        touchPoint.y < view.frame.origin.y + view.frame.size.height) {
        return YES;
    }
    return NO;
}

- (XHSSContentStyle)touchPoint:(CGPoint)touchPoint relationToView:(UIView*)view {
    if (touchPoint.x > view.frame.origin.x &&
        touchPoint.x < view.frame.origin.x + view.frame.size.width &&
        touchPoint.y > view.frame.origin.y &&
        touchPoint.y < view.frame.origin.y + view.frame.size.height) {
        return XHSSContentStyleInside;
    } else if (touchPoint.x > view.frame.origin.x &&
               touchPoint.x < view.frame.origin.x + view.frame.size.width) {
        return XHSSContentStyleHorizontalArea;
    } else if (touchPoint.y > view.frame.origin.y &&
               touchPoint.y < view.frame.origin.y + view.frame.size.height) {
        return XHSSContentStyleVerticalArea;
    } else {
        return XHSSContentStyleNone;
    }
}

// 平移整个截图区域
- (void)moveCutAreaWithLastPoint:(CGPoint)lastPoint currentPoint:(CGPoint)point {
    CGFloat xOffset = point.x -lastPoint.x;
    CGFloat yOffset = point.y -lastPoint.y;
    [self moveOneControlPoint:_tlControl xOffset:xOffset yOffset:yOffset];
    [self moveOneControlPoint:_trControl xOffset:xOffset yOffset:yOffset];
    [self moveOneControlPoint:_blControl xOffset:xOffset yOffset:yOffset];
    [self moveOneControlPoint:_brControl xOffset:xOffset yOffset:yOffset];
}

- (void)moveOneControlPoint:(UIView*)controlPoint xOffset:(CGFloat)xOffset yOffset:(CGFloat)yOffset {
    CGRect frame = controlPoint.frame;
    
    frame.origin.x += xOffset;
    if (frame.origin.x < 0) {
        frame.origin.x = 0;
    } else if (frame.origin.x > self.frame.size.width) {
        frame.origin.x = self.frame.size.width;
    }
    
    frame.origin.y += yOffset;
    if (frame.origin.y < 0) {
        frame.origin.y = 0;
    } else if (frame.origin.y > self.frame.size.height) {
        frame.origin.y = self.frame.size.height;
    }
    
    controlPoint.frame = frame;
}

#pragma mark - public

@end
