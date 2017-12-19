//
//  XHSSToolsView.m
//  TestCollectionViewLayout
//
//  Created by Apple on 2017/11/16.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSToolsView.h"

typedef NS_ENUM(NSUInteger, XHSSContentStyle) {
    XHSSContentStyleNone,
    XHSSContentStyleHorizontalArea,
    XHSSContentStyleVerticalArea,
    XHSSContentStyleInside,
};

@interface XHSSToolsView ()
// cut view
@property (nonatomic, assign) XHSSCutImageStyle cutStyle;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIImageView *tlControl;
@property (nonatomic, strong) UIImageView *trControl;
@property (nonatomic, strong) UIImageView *blControl;
@property (nonatomic, strong) UIImageView *brControl;
// calculate
@property (nonatomic, strong) UIView *calculateView;
@property (nonatomic, strong) UILabel *showResultLabel;
@property (nonatomic, strong) NSMutableArray *stack;
@property (nonatomic, copy) NSString *cloneStr;
@property (nonatomic, strong) NSArray *titleArr;
// calculate width
@property (nonatomic, assign) CGFloat calculateW;
// calculate height
@property (nonatomic, assign) CGFloat calculateH;
//
@property (nonatomic, assign) BOOL isCalculate;
@end

#define kXHSSCalculateBtnBaseTag 300
#define kXHSSCalculateExitBtnTag 100
#define kXHSSCalculateLabelTag 200

static XHSSToolsView *shareCutView;

@implementation XHSSToolsView
#pragma mark - setter & getter
- (NSMutableArray*)stack {
    if (_stack == nil) {
        _stack = [NSMutableArray array];
    }
    return _stack;
}

- (NSArray*)titleArr {
    if (_titleArr == nil) {
        _titleArr =  @[@"清除", @"退格", @"复制", @"／", @"7", @"8", @"9", @"*", @"4", @"5", @"6", @"-", @"1", @"2", @"3", @"+", @"0", @".", @"="];
    }
    return _titleArr;
}

#pragma mark - init
+ (instancetype)shareCutView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCutView = [[XHSSToolsView alloc] init];
    });
    return shareCutView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self makeSelf];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeSelf];
    }
    return self;
}

- (void)makeSelf {
    self.cutStyle = XHSSCutImageStyleRect;
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [self setupCalculatorView];
    [self setupCutImageViewUI];
}

- (void)setupCutImageViewUI {
    // cut
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(12, 32, 40, 30);
    [_sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"确定" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor blueColor]}];
    [_sureBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sureBtnColick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sureBtn];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(self.frame.size.width -12 -40, 32, 40, 30);
    [_cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    attrStr = [[NSMutableAttributedString alloc] initWithString:@"取消" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor redColor]}];
    [_cancelBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnColick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
    
    CGFloat controlPointW = 20;
    CGFloat controlPointH = 20;
    
    _tlControl = [[UIImageView alloc] init];
    _tlControl.frame = CGRectMake(50, 100, controlPointW, controlPointH);
    _tlControl.layer.cornerRadius = [self WidthOfView:_tlControl]/2.0;
    _tlControl.clipsToBounds = YES;
    _tlControl.backgroundColor = [UIColor blueColor];
    [self addSubview:_tlControl];
    
    _trControl = [[UIImageView alloc] init];
    _trControl.frame = CGRectMake(self.frame.size.width-50, 100, controlPointW, controlPointH);
    _trControl.layer.cornerRadius = [self WidthOfView:_trControl]/2.0;
    _trControl.clipsToBounds = YES;
    _trControl.backgroundColor = [UIColor blueColor];
    [self addSubview:_trControl];
    
    _blControl = [[UIImageView alloc] init];
    _blControl.frame = CGRectMake(50, self.frame.size.height-100, controlPointW, controlPointH);
    _blControl.layer.cornerRadius = [self WidthOfView:_blControl]/2.0;
    _blControl.clipsToBounds = YES;
    _blControl.backgroundColor = [UIColor blueColor];
    [self addSubview:_blControl];
    
    _brControl = [[UIImageView alloc] init];
    _brControl.frame = CGRectMake(self.frame.size.width-50, self.frame.size.height-100, controlPointW, controlPointH);
    _brControl.layer.cornerRadius = [self WidthOfView:_brControl]/2.0;
    _brControl.clipsToBounds = YES;
    _brControl.backgroundColor = [UIColor blueColor];
    [self addSubview:_brControl];
    
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
    if (self.isCalculate) {
        return;
    }
    
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
    
    // get image
//    CGContextClip(context);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    if (self.callback) {
//        self.callback(image);
//    }
}

#pragma mark - action
- (void)sureBtnColick:(UIButton*)btn {
    if (!self.isCalculate) {
        UIImage *image = [self cutImageInRect:[self cutRectByControlPoints]];
        if (self.callback) {
            self.callback(image);
        }
    }
    //[XHSSCustomCutImageView hiddenCutView];
    [self removeFromSuperview];
}

- (void)cancelBtnColick:(UIButton*)btn {
    //[XHSSToolsView hiddenCutView];
    [self removeFromSuperview];
}

#pragma mark -touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isCalculate) {
        UITouch *oneTouch = [touches anyObject];
        UIView *controlPoint = [self touchedControlPoint:oneTouch];
        [self setCenterPointOfView:controlPoint centerPoint:[oneTouch locationInView:self] cutStyle:self.cutStyle];
        [self setNeedsDisplay];
    }
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

- (void)setCenterPointOfView:(UIView*)view centerPoint:(CGPoint)centerPoint cutStyle:(XHSSCutImageStyle)cutStyle {
    switch (cutStyle) {
        case XHSSCutImageStyleRect: {
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
        case XHSSCutImageStyleAny: {
            [self setCenterPointOfView:view centerPoint:centerPoint cutStyle:cutStyle];
        }
            break;
        case XHSSCutImageStyleNone: {
            
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

#pragma mark -
- (void)hiddenCutViewWidgets {
    [_tlControl removeFromSuperview];
    [_trControl removeFromSuperview];
    [_blControl removeFromSuperview];
    [_brControl removeFromSuperview];
}

#pragma mark - public
+ (void)showCutViewWithComplementation:(void(^)(UIImage *cutImage))callback {
    [XHSSToolsView showCutView];
    [XHSSToolsView shareCutView].callback = callback;
}
+ (void)showCutView {
    [[UIApplication sharedApplication].keyWindow addSubview:[XHSSToolsView shareCutView]];
    [[XHSSToolsView shareCutView] hiddenCalculateViewWidgets];
    [[XHSSToolsView shareCutView] setIsCalculate:NO];
}
+ (void)hiddenCutView {
    [[XHSSToolsView shareCutView] removeFromSuperview];
}

- (void)showCutViewWithComplementation:(void(^)(UIImage *cutImage))callback {
    self.callback = [callback copy];
    [self hiddenCalculateViewWidgets];
    [self setIsCalculate:NO];
}
- (void)showCutView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)hiddenCutView {
    [self removeFromSuperview];
}

#pragma mark - =================================================
- (void)refreshCalculatorUI {
    if (_calculateView) {
        [_calculateView removeFromSuperview];
    }
    [self setupCalculatorView];
}
- (void)setupCalculatorView {
    // calculate
    UIColor *blueBack = [UIColor cyanColor];
    UIColor *orangeBack = [UIColor orangeColor];
    
    CGFloat thisWidth = self.frame.size.width;
    CGFloat thisHeight = self.frame.size.height;
    
    CGFloat calculatorW = self.frame.size.width > 0 ? self.frame.size.width : 200;
    CGFloat calculatorH = self.frame.size.height > 0 ? self.frame.size.height : 370;
    if (self.calculateW > 0 && self.calculateH > 0) {
        calculatorW = self.calculateW;
        calculatorH = self.calculateH;
    }
    
    NSInteger rowNum = 7;
    NSInteger columNum = 4;
    
    CGFloat borderSpace = 3;
    CGFloat btnHorizontalSpace = 4;
    CGFloat btnVerticalSpace = 4;
    CGFloat btnW = (calculatorW -borderSpace*2 -btnHorizontalSpace*(columNum-1))/columNum;
    CGFloat btnH = (calculatorH -borderSpace*2 -btnVerticalSpace*(rowNum-1))/rowNum;     //btnW;
    calculatorH = borderSpace*2+(btnH+btnVerticalSpace)*rowNum;
    
    UIView *contentview = [[UIView alloc] init];
    contentview.frame = CGRectMake((thisWidth-calculatorW)/2, (thisHeight-calculatorH)/2, calculatorW, calculatorH);
    contentview.backgroundColor = [UIColor blackColor];
    [self addSubview:contentview];
    _calculateView = contentview;
    
    for (NSInteger row=0; row<rowNum; row++) {
        if (row == 0) {
            UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            exitBtn.backgroundColor = [UIColor redColor];
            exitBtn.frame = CGRectMake(0, borderSpace, calculatorW, btnH);
            [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"退出" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName: [UIColor whiteColor]}];
            [exitBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
            [exitBtn addTarget:self action:@selector(btnColick:) forControlEvents:UIControlEventTouchUpInside];
            exitBtn.tag = kXHSSCalculateExitBtnTag;
            [contentview addSubview:exitBtn];
        } else if (row == 1) {
            UILabel *showresultLable = [[UILabel alloc] init];
            showresultLable.frame = CGRectMake(0, borderSpace+btnH+btnVerticalSpace, calculatorW, btnH);
            showresultLable.backgroundColor = blueBack;
            showresultLable.font = [UIFont boldSystemFontOfSize:17];
            showresultLable.textColor = [UIColor blackColor];
            showresultLable.textAlignment = NSTextAlignmentRight;
            showresultLable.tag = kXHSSCalculateLabelTag;
            showresultLable.text = @"";
            [contentview addSubview:showresultLable];
            _showResultLabel = showresultLable;
        } else {
            NSArray *titlesArr = self.titleArr;
            for (NSInteger colum=0; colum<columNum; colum++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:titlesArr[(row-2)*columNum+colum] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName: [UIColor blackColor]}];
                [btn setAttributedTitle:attrStr forState:UIControlStateNormal];
                btn.tag = kXHSSCalculateBtnBaseTag + (row-2)*columNum+colum;
                [btn addTarget:self action:@selector(btnColick:) forControlEvents:UIControlEventTouchUpInside];
                [contentview addSubview:btn];
                if ((row == 6) && (colum == 2)) {
                    btn.backgroundColor = orangeBack;
                    btn.frame = CGRectMake(borderSpace + colum*(btnW+btnHorizontalSpace),
                                           borderSpace + row*(btnH+btnVerticalSpace),
                                           btnW*2+btnHorizontalSpace,
                                           btnH);
                    // content view size fix last
                    CGRect contentFrame = _calculateView.frame;
                    contentFrame.size.height = CGRectGetMaxY(btn.frame) +btnHorizontalSpace;
                    _calculateView.frame = contentFrame;
                    return;
                } else {
                    btn.backgroundColor = blueBack;
                    btn.frame = CGRectMake(borderSpace + colum*(btnW+btnHorizontalSpace),
                                           borderSpace + row*(btnH+btnVerticalSpace),
                                           btnW,
                                           btnH);
                    if (colum == 3) {
                        btn.backgroundColor = orangeBack;
                    }
                }
            }
        }
    }
}

#pragma mark - btn colick
- (void)btnColick:(UIButton*)btn {
    if (btn.tag == kXHSSCalculateExitBtnTag) {
        [self hiddenCalculateView];
        return;
    }
    
    NSArray *titlesArr = self.titleArr;
    NSInteger index = btn.tag - kXHSSCalculateBtnBaseTag;
    NSString *inputStr = titlesArr[index];
    NSLog(@"%@", inputStr);
    
    [self updateLabelWithInput:inputStr];
}

- (void)updateLabelWithInput:(NSString*)input {
    NSArray *opratorArr = @[@"／", @"*", @"-", @"+"];
    if ([input isEqualToString:@"清除"]) {
        _showResultLabel.text = @"";
        [self clearStack];
    } else if ([input isEqualToString:@"退格"]) {
        if (_showResultLabel.text.length <= 0) {
            return;
        }
        _showResultLabel.text = [_showResultLabel.text substringToIndex:_showResultLabel.text.length-1];
    } else if ([input isEqualToString:@"复制"]) {
        self.cloneStr = _showResultLabel.text;
    } else if ([input isEqualToString:@"="]) {
        if ([self isEmptyStack] /*|| [opratorArr containsObject:[self stackTopValue]]*/) {
            NSLog(@"ERROR INPUT ------- %@", NSStringFromSelector(_cmd));
            [self reDo];
            return;
        } else {
            [self pushStack:[_showResultLabel.text substringFromIndex:[self stackBottomValue].length+1]];
            [self calculateAndUpdateShow:input];
        }
    } else if ([opratorArr containsObject:input]) {
        [self calculateWithOprator:input];
    } else {
        [self appendShowLable:input];
    }
}

- (void)appendShowLable:(NSString*)appendStr {
    _showResultLabel.text = [_showResultLabel.text stringByAppendingString:appendStr];
}

- (void)setShowLabelText:(NSString*)text {
    _showResultLabel.text = text;
}

- (void)calculateWithOprator:(NSString*)oprator {
    NSArray *opratorArr = @[@"／", @"*", @"-", @"+"];
    if ([self isEmptyStack]) {
        [self pushStack:_showResultLabel.text];
        [self appendShowLable:oprator];
        [self pushStack:oprator];
    } else {
        NSString *value = [self stackTopValue];
        if ([opratorArr containsObject:value]) {
            if ([self stackValueCount] < 3) {
                [self pushStack:[_showResultLabel.text substringFromIndex:[self stackBottomValue].length+1]];
                [self calculateAndUpdateShow:oprator];
            } else {
                NSLog(@"ERROR INPUT ------- %@", NSStringFromSelector(_cmd));
                [self reDo];
                return;
            }
        } else {
            //////////////////////////////////////////
            if ([self stackValueCount] < 3) {
                [self pushStack:oprator];
                [self appendShowLable:oprator];
            } else {
                [self calculateAndUpdateShow:oprator];
            }
            //[self calculateAndUpdateShow:oprator];
        }
    }
}

- (void)calculateAndUpdateShow:(NSString*)oprator {
    NSString *resultStr = [self calculateResultWithSecondValue:[self popStack] operator:[self popStack] firstValue:[self popStack]];
    [self setShowLabelText:resultStr];
    [self pushStack:resultStr];
    if ([oprator isEqualToString:@"="]) {
        //[self clearStack];
    } else {
        [self pushStack:oprator];
        [self appendShowLable:oprator];
    }
}

- (void)reDo {
    [self clearStack];
    _showResultLabel.text = @"";
}

- (NSString*)calculateResultWithSecondValue:(NSString*)secondValueStr operator:(NSString*)operator firstValue:(NSString*)firstValueStr {
    if ([firstValueStr isEqualToString:@""] ||
        [operator isEqualToString:@""] ||
        [secondValueStr isEqualToString:@""]) {
        NSLog(@"ERROR INPUT ------- %@", NSStringFromSelector(_cmd));
        [self reDo];
        return @"";
    }
    
    double firstValue = [firstValueStr doubleValue];
    double secondValue = [secondValueStr doubleValue];
    double result = 0;
    if ([operator isEqualToString:@"+"]) {
        result = firstValue + secondValue;
    } else if ([operator isEqualToString:@"-"]) {
        result = firstValue - secondValue;
    } else if ([operator isEqualToString:@"*"]) {
        result = firstValue * secondValue;
    } else if ([operator isEqualToString:@"／"]) {
        result = firstValue / secondValue;
    }
    return [NSString stringWithFormat:@"%.2lf", result];
}

#pragma mark - stack
- (void)pushStack:(NSString*)value {
    //NSLog(@"stack values count before push = %ld ------- %@", self.stack.count, NSStringFromSelector(_cmd));
    if (![self.titleArr containsObject:value]) {
    }
    [self.stack addObject:value];
    NSLog(@"stack values count after push = %ld ------- push value = %@ ------- %@\n", self.stack.count, value, NSStringFromSelector(_cmd));
}

- (NSString*)popStack {
    if (self.stack.count == 0) {
        return @"";
    }
    NSString *value = self.stack.lastObject;
    [self.stack removeLastObject];
    NSLog(@"stack values count = %ld ------- pop value = %@ ------- %@\n", self.stack.count, value, NSStringFromSelector(_cmd));
    return value;
}

- (void)clearStack {
    NSLog(@"stack values count = %ld ------- %@\n", self.stack.count, NSStringFromSelector(_cmd));
    [self.stack removeAllObjects];
}

- (BOOL)isEmptyStack {
    return self.stack.count <= 0;
}

- (NSInteger)stackValueCount {
    return self.stack.count;
}

- (NSString*)stackTopValue {
    return self.stack.lastObject;
}

- (NSString*)stackBottomValue {
    return self.stack.firstObject;
}

#pragma mark - public
+ (void)showCalculateViewWithWidht:(CGFloat)width heigth:(CGFloat)height {
    [XHSSToolsView shareCutView].calculateW = width;
    [XHSSToolsView shareCutView].calculateH = height;
    [[XHSSToolsView shareCutView] refreshCalculatorUI];
    [XHSSToolsView showCalculateView];
}
+ (void)showCalculateView {
    [[UIApplication sharedApplication].keyWindow addSubview:[XHSSToolsView shareCutView]];
    [[XHSSToolsView shareCutView] hiddenCutViewWidgets];
    [[XHSSToolsView shareCutView] setIsCalculate:YES];
}
+ (void)hiddenCalculateView {
    [[XHSSToolsView shareCutView] removeFromSuperview];
}

- (void)showCalculateViewWithWidht:(CGFloat)width heigth:(CGFloat)height {
    self.calculateW = width;
    self.calculateH = height;
    [self refreshCalculatorUI];
    [self showCalculateView];
}
- (void)showCalculateView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self hiddenCutViewWidgets];
    [self setIsCalculate:YES];
}
- (void)hiddenCalculateView {
    [self removeFromSuperview];
}
- (void)hiddenCalculateViewWidgets {
    [_calculateView removeFromSuperview];
}

#pragma mark - init cutView or calculator
- (instancetype)initCutImageWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.cutStyle = XHSSCutImageStyleRect;
        //self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        [self setupCutImageViewUI];
    }
    return self;
}

- (instancetype)initCalculatorWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCalculatorView];
    }
    return self;
}

@end
