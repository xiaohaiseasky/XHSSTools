//
//  XHSSImageBrowserVC.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/24.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSImageBrowserVC.h"

@interface XHSSImageBrowserVC ()

@property (nonatomic, assign) BOOL showBottomView;

@end

@implementation XHSSImageBrowserVC {
    UIImageView *_imageView;
    XHSSBottomView *_bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

-(void)setupView {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
//    swipe.direction = UISwipeGestureRecognizerDirectionRight |UISwipeGestureRecognizerDirectionLeft;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [tap requireGestureRecognizerToFail:doubleTap];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = self.view.bounds;
    _imageView.backgroundColor = [UIColor blackColor];
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeCenter;
    [_imageView addGestureRecognizer:swipe];
    [_imageView addGestureRecognizer:tap];
    [_imageView addGestureRecognizer:doubleTap];
    if (self.imagesArr) {
        _imageView.image = self.imagesArr[self.currentIndex];
    }
    [self.view addSubview:_imageView];
    
    _bottomView = [[XHSSBottomView alloc] init];
    _bottomView.frame = CGRectMake(0, self.view.frame.size.height-30, self.view.frame.size.width, 30);
    [_bottomView setLabelInfoWithTotal:self.imagesArr.count currentIndex:self.currentIndex];
    [self.view addSubview:_bottomView];
}

- (void)updateBottomViewContent {
    [_bottomView setLabelInfoWithTotal:_imagesArr.count currentIndex:_currentIndex];
}
                                     
#pragma mark - action
- (void)swipeAction:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft ||
        swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        _currentIndex = ++_currentIndex % _imagesArr.count;
        _imageView.image = _imagesArr[_currentIndex];
        [self updateBottomViewContent];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight ||
               swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        _currentIndex = (--_currentIndex + _imagesArr.count) % _imagesArr.count;
        _imageView.image = _imagesArr[_currentIndex];
        [self updateBottomViewContent];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    self.showBottomView = !self.showBottomView;
    _bottomView.hidden = self.showBottomView;
}

- (void)doubleTapAction:(UITapGestureRecognizer *)doubleTap {
    NSLog(@"double click");
}
                                     

@end


/**
 底部图片信息视图
 */
@interface XHSSBottomView ()

@end

@implementation XHSSBottomView {
    UILabel *_totalLabel;
    UILabel *_currentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    _totalLabel.frame = CGRectMake(width/2.0, 0, width/2.0, height);
    _currentLabel.frame = CGRectMake(0, 0, width/2.0, height);
}

- (void)setupView {
    
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.7;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    _totalLabel = [self labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blueColor] aligment:NSTextAlignmentLeft];
    _totalLabel.frame = CGRectMake(width/2.0, 0, width/2.0, height);
    [self addSubview:_totalLabel];
    
    _currentLabel = [self labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blueColor] aligment:NSTextAlignmentRight];
    _currentLabel.frame = CGRectMake(0, 0, width/2.0, height);
    [self addSubview:_currentLabel];
}

- (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)color aligment:(NSTextAlignment)aligment {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = font;
    label.textAlignment = aligment;
    return label;
}

#pragma mark - public
- (void)setLabelInfoWithTotal:(NSInteger)total currentIndex:(NSInteger)currentIndex {
    _currentLabel.text = [NSString stringWithFormat:@"%ld", currentIndex];
    _totalLabel.text = [NSString stringWithFormat:@" / %ld", total];
}

@end
