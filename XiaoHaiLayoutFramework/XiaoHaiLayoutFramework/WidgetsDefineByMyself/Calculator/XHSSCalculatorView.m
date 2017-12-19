//
//  XHSSCalculatorView.m
//  TestCollectionViewLayout
//
//  Created by Apple on 2017/11/27.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSCalculatorView.h"

@interface XHSSCalculatorView ()

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

@implementation XHSSCalculatorView

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

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self refreshCalculatorUI];
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
        [self refreshCalculatorUI];
    }
    return self;
}

#pragma amrk - UI
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
        [self removeFromSuperview];
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
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.cloneStr;
    } else if ([input isEqualToString:@"="]) {
        //*******
        if ([_showResultLabel.text hasSuffix:input]) {
            return;
        }
        //*******
        if ([self isEmptyStack] /*|| [opratorArr containsObject:[self stackTopValue]]*/) {
            NSLog(@"ERROR INPUT ------- %@", NSStringFromSelector(_cmd));
            [self reDo];
            return;
        } else {
            //*******
            BOOL avilable = NO;
            for (NSString *operator in opratorArr) {
                if ([_showResultLabel.text rangeOfString:operator].location != NSNotFound) {
                    avilable = YES;
                }
            }
            if (!avilable) {
                return;
            }
            //*******
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
    //*******
    if ([_showResultLabel.text hasSuffix:oprator] ||
        _showResultLabel.text.length == 0) {
        return;
    }
    //*******
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

@end
