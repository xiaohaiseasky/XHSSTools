//
//  XHSSPaintingView.m
//  TestCollectionViewLayout
//
//  Created by Apple on 2017/11/28.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSPaintingView.h"

@interface XHSSPath : UIBezierPath
@property (nonatomic, strong) UIColor *pathColor;
@end
@implementation XHSSPath
@end



typedef NS_ENUM(NSUInteger, XHSSPathType) {
    XHSSPathTypeCurve,
    XHSSPathTypeLine,
    XHSSPathTypeRect,
    XHSSPathTypeOval,
    XHSSPathTypeRoundedRect,
    XHSSPathTypeRoundedRectbyRoundingCorners,
    XHSSPathTypeArc,
    XHSSPathTypeQuadCurve,
    XHSSPathTypeQuadCurveTwoControlPoint,
};

@interface XHSSPaintingView ()

//@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;

@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIButton *undoBtn;
@property (nonatomic, strong) UIButton *eraserBtn;
@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UISlider *lineWidthSlider;

//@property (nonatomic, strong) NSMutableArray *btnColorArr;

//
@property (nonatomic, strong) XHSSPath *path;
@property (nonatomic, assign) CGPoint tempPoint;
@property (nonatomic, assign) XHSSPathType pathType;
@property (nonatomic, assign) BOOL isAvilablePath;
@property (nonatomic, strong) NSMutableArray *pathArr;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *drawColor;

@end

#define kXHSSBaseBtnTag 321
#define kXHSSBaseColorBtnTag 789

@implementation XHSSPaintingView
#pragma mark - setter & getter
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setup];
}

- (void)setImage:(UIImage *)image {
    _image = image;

    [self.pathArr addObject:image];
    [self setNeedsDisplay];
}

- (NSMutableArray*)btnColorArr {
    if (_btnColorArr == nil) {
        _btnColorArr = [NSMutableArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor yellowColor], [UIColor blackColor], [UIColor cyanColor], [UIColor purpleColor], nil];
    }
    return _btnColorArr;
}

- (NSMutableArray *)pathArr {
    if (_pathArr == nil) {
        _pathArr = [NSMutableArray array];
    }
    return _pathArr;
}


#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [self initWithFrame:CGRectMake(0, 0, 200, 300)];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.lineWidth = 1;
    self.drawColor = [UIColor blackColor];
    [self setUpGestureRecognezer];
    [self setupView];
}

#pragma mark - UI
- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    [self setupTopBar];
    [self setupBottomBar];
}

- (void)setupTopBar {
    if (_topBar) {
        [_topBar removeFromSuperview];
    }
    
    CGFloat totalWidth = self.frame.size.width;
    CGFloat topBarH = 70;
    
    // topBar
    UIView *topBar = [[UIView alloc] init];
    topBar.frame = CGRectMake(0, 0, totalWidth, topBarH);
    topBar.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:topBar];
    UIView *topBgView = [[UIView alloc] init];
    topBgView.frame = topBar.bounds;
    topBgView.backgroundColor = [UIColor blackColor];
    topBgView.alpha = 0.4;
    [_topBar addSubview:topBgView];
    _topBar = topBar;
    
    UIColor *textColor = [UIColor blueColor];
    UIColor *borderColor = [UIColor blueColor];
    CGFloat cornerRadius = 7;
    CGFloat borderWidth = 2;
    
    CGFloat btnW = 60;
    CGFloat btnH = 30;
    CGFloat btnX = 10;
    CGFloat btnY = topBarH -btnH-7;
    CGFloat btnSpace = (totalWidth -btnW*5 -btnX*2)/4.0;
    
    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [_clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    _clearBtn.layer.cornerRadius = cornerRadius;
    _clearBtn.layer.borderColor = borderColor.CGColor;
    _clearBtn.layer.borderWidth = borderWidth;
    [_clearBtn setTitleColor:textColor forState:UIControlStateNormal];
    _clearBtn.backgroundColor = [UIColor blueColor];
    [_clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_clearBtn addTarget:self action:@selector(topBarBtnColick:) forControlEvents:UIControlEventTouchUpInside];
    _clearBtn.tag = (kXHSSBaseBtnTag +0);
    [topBar addSubview:_clearBtn];
    
    _undoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _undoBtn.frame = CGRectMake(btnX +(btnW +btnSpace), btnY, btnW, btnH);
    [_undoBtn setTitle:@"撤销" forState:UIControlStateNormal];
    _undoBtn.layer.cornerRadius = cornerRadius;
    _undoBtn.layer.borderColor = borderColor.CGColor;
    _undoBtn.layer.borderWidth = borderWidth;
    [_undoBtn setTitleColor:textColor forState:UIControlStateNormal];
    _undoBtn.backgroundColor = [UIColor blueColor];
    [_undoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_undoBtn addTarget:self action:@selector(topBarBtnColick:) forControlEvents:UIControlEventTouchUpInside];
    _undoBtn.tag = (kXHSSBaseBtnTag +1);
    [topBar addSubview:_undoBtn];
    
    _eraserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _eraserBtn.frame = CGRectMake(btnX +(btnW +btnSpace)*2, btnY, btnW, btnH);
    [_eraserBtn setTitle:@"橡皮擦" forState:UIControlStateNormal];
    _eraserBtn.layer.cornerRadius = cornerRadius;
    _eraserBtn.layer.borderColor = borderColor.CGColor;
    _eraserBtn.layer.borderWidth = borderWidth;
    [_eraserBtn setTitleColor:textColor forState:UIControlStateNormal];
     _eraserBtn.backgroundColor = [UIColor blueColor];
    [_eraserBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_eraserBtn addTarget:self action:@selector(topBarBtnColick:) forControlEvents:UIControlEventTouchUpInside];
    _eraserBtn.tag = (kXHSSBaseBtnTag +2);
    [topBar addSubview:_eraserBtn];
    
    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishBtn.frame = CGRectMake(btnX +(btnW +btnSpace)*3, btnY, btnW, btnH);
    [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    _finishBtn.layer.cornerRadius = cornerRadius;
    _finishBtn.layer.borderColor = borderColor.CGColor;
    _finishBtn.layer.borderWidth = borderWidth;
    [_finishBtn setTitleColor:textColor forState:UIControlStateNormal];
    _finishBtn.backgroundColor = [UIColor greenColor];
    [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_finishBtn addTarget:self action:@selector(topBarBtnColick:) forControlEvents:UIControlEventTouchUpInside];
    _finishBtn.tag = (kXHSSBaseBtnTag +3);
    [topBar addSubview:_finishBtn];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(btnX +(btnW +btnSpace)*4, btnY, btnW, btnH);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBtn.layer.cornerRadius = cornerRadius;
    _cancelBtn.layer.borderColor = borderColor.CGColor;
    _cancelBtn.layer.borderWidth = borderWidth;
    [_cancelBtn setTitleColor:textColor forState:UIControlStateNormal];
    _cancelBtn.backgroundColor = [UIColor redColor];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(topBarBtnColick:) forControlEvents:UIControlEventTouchUpInside];
     _cancelBtn.tag = (kXHSSBaseBtnTag +4);
    [topBar addSubview:_cancelBtn];
}

- (void)setupBottomBar {
    if (_bottomBar) {
        [_bottomBar removeFromSuperview];
    }
    
    CGFloat totalWidth = self.frame.size.width;
    CGFloat totalHeight = self.frame.size.height;
    CGFloat bottomBarH = 77;
    
    // bottomBar
    UIView *bottomBar = [[UIView alloc] init];
    bottomBar.frame = CGRectMake(0, totalHeight -bottomBarH, totalWidth, bottomBarH);
    bottomBar.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomBar];
    UIView *bottomBgView = [[UIView alloc] init];
    bottomBgView.frame = bottomBar.bounds;
    bottomBgView.backgroundColor = [UIColor blackColor];
    bottomBgView.alpha = 0.4;
    [_bottomBar addSubview:bottomBgView];
    _bottomBar = bottomBar;
    
    NSArray *btnTitles = @[@"直线", @"曲线", @"矩形", @"椭圆"];
    CGFloat btnX = 10;
    CGFloat btnY = 10;
    CGFloat btnSpace = 7;
    CGFloat btnW = (bottomBar.frame.size.width -btnX*2 -btnSpace*self.btnColorArr.count)/(self.btnColorArr.count);
    CGFloat btnH = 30;
    
    for (NSInteger i=0; i<4; i++) {
        UILabel *btn = [[UILabel alloc] init];
        btn.frame = CGRectMake(btnX +(i > 1 ? i+3 : i)*(btnW +btnSpace), btnY, btnW, btnH);
        btn.text = btnTitles[i];
        btn.textColor = [UIColor whiteColor];
        btn.backgroundColor = [UIColor blueColor];
        btn.font = [UIFont systemFontOfSize:13];
        btn.textAlignment = NSTextAlignmentCenter;
        btn.layer.cornerRadius = 4;
        btn.clipsToBounds = YES;
        btn.tag = kXHSSBaseColorBtnTag +123 +i;
        btn.userInteractionEnabled = YES;
        [btn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barBtnColick:)]];
        [bottomBar addSubview:btn];
    }
    
    CGFloat sliderX = btnX +(btnW +btnSpace)*2;
    CGFloat sliderW = (btnW +btnSpace)*2 +btnW;
    
    _lineWidthSlider = [[UISlider alloc] init];
    _lineWidthSlider.frame = CGRectMake(sliderX, 10, sliderW, 30);
    [_lineWidthSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _lineWidthSlider.minimumValue = 1;
    _lineWidthSlider.maximumValue = 30;
    _lineWidthSlider.value = 1;
    [bottomBar addSubview:_lineWidthSlider];
    
    CGFloat colorBtnX = 10;
    CGFloat colorBtnY = CGRectGetMaxY(_lineWidthSlider.frame) +10;
    CGFloat colorBtnSpace = 7;
    CGFloat colorBtnW = (bottomBar.frame.size.width -colorBtnX*2 -colorBtnSpace*self.btnColorArr.count)/(self.btnColorArr.count);
    CGFloat colorBtnH = bottomBarH - colorBtnY -10;
    
    for (NSInteger i=0; i<self.btnColorArr.count; i++) {
        UILabel *colorBtn = [[UILabel alloc] init];
        colorBtn.frame = CGRectMake(colorBtnX +i*(colorBtnW +colorBtnSpace), colorBtnY, colorBtnW, colorBtnH);
        colorBtn.backgroundColor = self.btnColorArr[i];
        colorBtn.layer.cornerRadius = 4;
        colorBtn.clipsToBounds = YES;
        colorBtn.tag = kXHSSBaseColorBtnTag +i;
        colorBtn.userInteractionEnabled = YES;
        [colorBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barBtnColick:)]];
        [bottomBar addSubview:colorBtn];
    }
}

- (UILabel*)labelWithFont:(UIFont*)font TextColor:(UIColor*)textColor aligment:(NSTextAlignment)aligment cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = aligment;
    label.layer.cornerRadius = cornerRadius;
    label.layer.borderColor = borderColor.CGColor;
    label.layer.borderWidth = borderWidth;
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barBtnColick:)]];
    return label;
}

#pragma mark - action
- (void)topBarBtnColick:(UIButton*)btn {
    if ([btn.titleLabel.text isEqualToString:@"清除"]) {
        [self clear];
    } else if ([btn.titleLabel.text isEqualToString:@"撤销"]) {
        [self undo];
    } else if ([btn.titleLabel.text isEqualToString:@"橡皮擦"]) {
        [self erase];
    } else if ([btn.titleLabel.text isEqualToString:@"完成"]) {
        [self finish];
    } else if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        [self cancel];
    }
}
- (void)barBtnColick:(UITapGestureRecognizer*)tap {
    UIView *view = [tap view];
    if (view.tag >= kXHSSBaseColorBtnTag) {
        if (view.tag -kXHSSBaseColorBtnTag >= 123) {
            UILabel *label = (UILabel*)view;
            if ([label.text isEqualToString:@"直线"]) {
                self.pathType = XHSSPathTypeLine;
            } else if ([label.text isEqualToString:@"曲线"]) {
                self.pathType = XHSSPathTypeCurve;
            } else if ([label.text isEqualToString:@"矩形"]) {
                self.pathType = XHSSPathTypeRect;
            } else if ([label.text isEqualToString:@"椭圆"]) {
                self.pathType = XHSSPathTypeOval;
            }
        } else {
            self.drawColor = view.backgroundColor;
        }
    }
}

- (void)sliderValueChanged:(UISlider*)slider {
    self.lineWidth = slider.value;
}

- (void)clear {
    [self.pathArr removeAllObjects];
    [self.pathArr addObject:self.image];
    [self setNeedsDisplay];
}

- (void)undo {
    if ([self.pathArr.lastObject isKindOfClass:[UIImage class]]) {
        return;
    }
    [self.pathArr removeLastObject];
    [self setNeedsDisplay];
}

- (void)erase {
    self.drawColor = [UIColor whiteColor];
}

- (void)finish {
    if (self.finishCallback) {
        self.finishCallback([self generatImage]);
    }
}

- (void)cancel {
    if (self.finishCallback) {
        self.finishCallback(nil);
    }
}

- (UIImage*)generatImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - draw action
- (void)setUpGestureRecognezer
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
//    [self addGestureRecognizer:pan];
    
    self.lineWidth = 1;
    self.drawColor = [UIColor blackColor];
}


// 当手指拖动的时候调用
- (void)pan:(UIPanGestureRecognizer *)pan
{
#if 0
    // 获取当前手指触摸点
    CGPoint curP = [pan locationInView:self];
    
    // 获取开始点
    if (pan.state == UIGestureRecognizerStateBegan) {
        _path = [[XHSSPath alloc] init];
        _path.lineWidth = self.lineWidth;
        _path.pathColor = self.drawColor;
        [_path moveToPoint:curP];
        // 保存描述好的路径
        [self.pathArr addObject:_path];
    }
    
    // 手指一直在拖动
    // 添加线到当前触摸点
    [_path addLineToPoint:curP];
    
    // 重绘
    [self setNeedsDisplay];
#endif
}

#pragma mark - touch
#if 1
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    if ([self isPoint:currentPoint inView:_topBar] || [self isPoint:currentPoint inView:_bottomBar]) {
        return;
    }
    _path = [[XHSSPath alloc] init];
    _path.lineWidth = self.lineWidth;
    _path.pathColor = self.drawColor;
    [_path moveToPoint:currentPoint];
    [self.pathArr addObject:_path];
    
    self.tempPoint = currentPoint;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    switch (self.pathType) {
        case XHSSPathTypeCurve:  // 在路径中增加一条直线
            [self addCurveToPath:_path withPoint:currentPoint];
            break;
        case XHSSPathTypeLine:  // 在路径中增加一条直线
            [self addLineToPath:_path withStartPoint:_tempPoint endPoint:currentPoint];
            break;
        case XHSSPathTypeOval:  // 内切于一个矩形的椭圆路径
            [self paintOvalInRectWithFirstPoint:_tempPoint secondPoint:currentPoint];
            break;
        case XHSSPathTypeRect:  // 矩形路径
            [self paintRectWithFirstPoint:_tempPoint secondPoint:currentPoint];
            break;
        case XHSSPathTypeRoundedRect:   // 圆角矩形路径       cornerRadius
            [self paintRoundedRectWithFirstPoint:_tempPoint secondPoint:currentPoint cornerRadius:12];
            break;
        case XHSSPathTypeRoundedRectbyRoundingCorners:  // 可选圆弧位置的圆角矩形路径       byRoundingCorners       cornerRadii
            [self paintRoundedRectWithFirstPoint:_tempPoint secondPoint:currentPoint byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
            break;
        case XHSSPathTypeArc:   // 圆弧路径       Center      radius       startAngle       endAngle       clockwise
            [self paintArcWithCenter:_tempPoint radius:sqrt(pow((_tempPoint.x - currentPoint.x), 2) + pow((_tempPoint.y - currentPoint.y), 2)) startAngle:0 endAngle:M_PI clockwise:YES];
            // 在路径中增加一条圆弧
            //[self addArcToPath:_path withCenter:_tempPoint radius:sqrt(pow((_tempPoint.x - currentPoint.x), 2) + pow((_tempPoint.y - currentPoint.y), 2)) startAngle:0 endAngle:M_PI clockwise:YES];
            break;
        case XHSSPathTypeQuadCurve: // 在路径中增加一条二次贝塞尔曲线       controlPoint
            [self addQuadCurveToPath:_path withPoint:currentPoint controlPoint:_tempPoint];
            break;
        case XHSSPathTypeQuadCurveTwoControlPoint:  // 在路径中增加一条三次贝塞尔曲线       controlPoint1       controlPoint2
            [self addQuadCurveToPath:_path withPoint:currentPoint controlPoint1:_tempPoint controlPoint2:_tempPoint];
            break;
        default:
            break;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint lastPoint = [touch previousLocationInView:self];
    CGPoint currentPoint = [touch locationInView:self];
}
#endif

#pragma mark - tool
// 矩形路径
- (void)paintRectWithFirstPoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint {
    [self.pathArr removeLastObject];
    _path = [XHSSPath bezierPathWithRect:CGRectMake(firstPoint.x,
                                                    firstPoint.y,
                                                    secondPoint.x -firstPoint.x,
                                                    secondPoint.y -firstPoint.y)];
    _path.lineWidth = self.lineWidth;
    _path.pathColor = self.drawColor;
    [self.pathArr addObject:_path];

}
// 内切于一个矩形的椭圆路径
- (void)paintOvalInRectWithFirstPoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint {
    [self.pathArr removeLastObject];
    _path = [XHSSPath bezierPathWithOvalInRect:CGRectMake(firstPoint.x,
                                                          firstPoint.y,
                                                          secondPoint.x -firstPoint.x,
                                                          secondPoint.y -firstPoint.y)];
    _path.lineWidth = self.lineWidth;
    _path.pathColor = self.drawColor;
    [self.pathArr addObject:_path];
}
// 圆角矩形路径
- (void)paintRoundedRectWithFirstPoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint cornerRadius:(CGFloat)cornerRadius {
    [self.pathArr removeLastObject];
    _path = [XHSSPath bezierPathWithRoundedRect:CGRectMake(firstPoint.x,
                                                           firstPoint.y,
                                                           secondPoint.x -firstPoint.x,
                                                           secondPoint.y -firstPoint.y)
                                   cornerRadius:cornerRadius];
    _path.lineWidth = self.lineWidth;
    _path.pathColor = self.drawColor;
    [self.pathArr addObject:_path];
}
// 可选圆弧位置的圆角矩形路径
- (void)paintRoundedRectWithFirstPoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint byRoundingCorners:(UIRectCorner)roundingCorners cornerRadii:(CGSize)cornerRadii {
    [self.pathArr removeLastObject];
    _path = [XHSSPath bezierPathWithRoundedRect:CGRectMake(firstPoint.x,
                                                           firstPoint.y,
                                                           secondPoint.x -firstPoint.x,
                                                           secondPoint.y -firstPoint.y)
                              byRoundingCorners:roundingCorners
                                    cornerRadii:cornerRadii];
    _path.lineWidth = self.lineWidth;
    _path.pathColor = self.drawColor;
    [self.pathArr addObject:_path];
}
// 圆弧路径
- (void)paintArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise {
    [self.pathArr removeLastObject];
    _path = [XHSSPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    _path.lineWidth = self.lineWidth;
    _path.pathColor = self.drawColor;
    [self.pathArr addObject:_path];
}
- (void)paintArcWithFirstPoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint {
    [self.pathArr removeLastObject];
//    _path = [XHSSPath bezierPathWithArcCenter:CGPointMake((firstPoint.x -secondPoint.x)/2.0f, (firstPoint.y -secondPoint.y)/2.0f)
//                                       radius:sqrt(pow((firstPoint.x - secondPoint.x), 2) + pow((firstPoint.y - secondPoint.y), 2))
//                                   startAngle:startAngle
//                                     endAngle:endAngle
//                                    clockwise:YES];
    _path.lineWidth = self.lineWidth;
    _path.pathColor = self.drawColor;
    [self.pathArr addObject:_path];
}

// 在路径中增加一条直线
- (void)addLineToPath:(UIBezierPath*)path withStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    [self.pathArr removeLastObject];
    _path = [XHSSPath bezierPath];
    _path.lineWidth = self.lineWidth;
    _path.pathColor = self.drawColor;
    [_path moveToPoint:startPoint];
    [_path addLineToPoint:endPoint];
    [self.pathArr addObject:_path];
}
// 在路径中增加一条曲线
- (void)addCurveToPath:(UIBezierPath*)path withPoint:(CGPoint)point {
    [path addLineToPoint:point];
}

// 在路径中增加一条圆弧
- (void)addArcToPath:(UIBezierPath*)path withCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise  {
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
}
// 在路径中增加一条二次贝塞尔曲线
- (void)addQuadCurveToPath:(UIBezierPath*)path withPoint:(CGPoint)point controlPoint:(CGPoint)controlPoint {
    [path addQuadCurveToPoint:point controlPoint:controlPoint];
}
// 在路径中增加一条三次贝塞尔曲线
- (void)addQuadCurveToPath:(UIBezierPath*)path withPoint:(CGPoint)point controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2 {
    [path addCurveToPoint:point controlPoint1:controlPoint1 controlPoint2:controlPoint2];
}
- (BOOL)isPoint:(CGPoint)point inView:(UIView*)view {
    CGRect frame = view.frame;
    if (point.x >= frame.origin.x &&
        point.x <= CGRectGetMaxX(frame) &&
        point.y >= frame.origin.y &&
        point.y <= CGRectGetMaxY(frame)) {
        return YES;
    }
    return NO;
}

#pragma mark - draw
- (void)drawRect:(CGRect)rect
{
    for (XHSSPath *path in self.pathArr) {
        
        if ([path isKindOfClass:[UIImage class]]) {
            // 绘制图片
            UIImage *image = (UIImage *)path;
            CGRect drawImageRect = CGRectMake((rect.size.width - image.size.width)/2.0f,
                                              (rect.size.height - image.size.height)/2.0f,
                                              image.size.width,
                                              image.size.height);
            [image drawInRect:drawImageRect];
        }else{
            
            // 画线
            [path.pathColor set];
            //[self.drawColor set];
            
            [path stroke];
        }
        
    }
}

@end
