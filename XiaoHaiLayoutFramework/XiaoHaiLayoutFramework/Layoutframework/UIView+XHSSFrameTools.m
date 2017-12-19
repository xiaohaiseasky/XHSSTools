//
//  UIView+XHSSFrameTools.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/17.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "UIView+XHSSFrameTools.h"

@implementation UIView (XHSSFrameTools)

// x
- (CGFloat)x {
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x {
    CGRect oldFrame = self.frame;
    oldFrame.origin.x = x;
    self.frame = oldFrame;
}

// y
- (CGFloat)y {
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y {
    CGRect oldFrame = self.frame;
    oldFrame.origin.y = y;
    self.frame = oldFrame;
}

// maxX
- (CGFloat)maxX {
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setMaxX:(CGFloat)maxX {
    CGRect oldFrame = self.frame;
    oldFrame.size.width = self.superview.frame.size.width - self.frame.origin.x - (self.superview.frame.size.width - maxX);
    self.frame = oldFrame;
}

// maxY
- (CGFloat)maxY {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setMaxY:(CGFloat)maxY {
    CGRect oldFrame = self.frame;
    oldFrame.size.height = self.superview.frame.size.height - self.frame.origin.y - (self.superview.frame.size.height - maxY);
    self.frame = oldFrame;
}

// width
- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect oldFrame = self.frame;
    oldFrame.size.width = width;
    self.frame = oldFrame;
}

// height
- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect oldFrame = self.frame;
    oldFrame.size.height = height;
    self.frame = oldFrame;
}

// center
- (CGPoint)selCenter {
    return self.center; //CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
}
- (void)setSelCenter:(CGPoint)selCenter {
    CGRect oldFrame = self.frame;
    oldFrame.origin.y = selCenter.x - self.frame.size.width/2.0;
    oldFrame.origin.y = selCenter.y - self.frame.size.height/2.0;
    self.frame = oldFrame;
}

// origin
- (CGPoint)selOrigin {
    return self.frame.origin;
}
- (void)setSelOrigin:(CGPoint)selOrigin {
    CGRect oldFrame = self.frame;
    oldFrame.origin.x = selOrigin.x;
    oldFrame.origin.y = selOrigin.y;
    self.frame = oldFrame;
}

// bounds
- (CGSize)selBounds {
    return self.bounds.size;
}
- (void)setSelBounds:(CGSize)selBounds {
    CGRect oldFrame = self.frame;
    oldFrame.size = selBounds;
    self.frame = oldFrame;
}

@end
