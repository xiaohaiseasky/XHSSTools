//
//  XHSSShadowView.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/19.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSShadowView.h"

@interface XHSSShadowView ()

// Size
@property (nonatomic, assign) UIEdgeInsets innerEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets outterEdgeInsets;
@property (nonatomic, assign) CGRect contentFrame;
@property (nonatomic, assign) CGSize size;

// position
@property (nonatomic, assign) CGSize shadowOffset;

// Color
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, strong) UIColor *borderColor;

// Appearance
@property (nonatomic, assign) CGFloat shadowBlur;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;

// Content
@property (nonatomic, strong) id content;

@end

@implementation XHSSShadowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor blueColor];
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // if need background color
    CGContextSetFillColorWithColor(currentContext, [UIColor cyanColor].CGColor);
    CGContextFillRect(currentContext, rect);
    
    self.contentFrame = CGRectMake(self.frame.size.width/2.0/2.0,
                                   self.frame.size.height/2.0/2.0,
                                   self.frame.size.width/2.0,
                                   self.frame.size.height/2.0);
    
//    CGContextSaveGState(currentContext);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.contentFrame cornerRadius:10];
//    CGContextAddPath(currentContext, path.CGPath);
//    CGContextDrawPath(currentContext, kCGPathFill);
//    CGContextClearRect(currentContext, self.contentFrame);
//    CGContextRestoreGState(currentContext);
    
    
    CGContextSaveGState(currentContext);
    CGContextSetShadowWithColor(currentContext, CGSizeZero/*CGSizeMake(7, 7)*/, 30, [UIColor colorWithWhite:0 alpha:0.7].CGColor);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.contentFrame cornerRadius:10];
    CGContextAddPath(currentContext, path.CGPath);
    CGContextSetFillColorWithColor(currentContext, [UIColor purpleColor].CGColor);
    CGContextDrawPath(currentContext, kCGPathFill);
    CGContextRestoreGState(currentContext);
    
    
    CGContextSaveGState(currentContext);
    CGContextAddPath(currentContext, path.CGPath);
    CGContextClip(currentContext);
//    cgcontextcle
    CGContextRestoreGState(currentContext);
    
}

@end
