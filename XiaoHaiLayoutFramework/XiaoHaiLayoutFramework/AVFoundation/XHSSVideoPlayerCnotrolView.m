//
//  XHSSVideoPlayerCnotrolView.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/26.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSVideoPlayerCnotrolView.h"
#import "XHSSDoubleControlSlider.h"

@interface XHSSVideoPlayerCnotrolView ()

@property (nonatomic, strong) UIImageView *showImageView;

@end

@implementation XHSSVideoPlayerCnotrolView {
    // 播放／暂停
    XHSSDoubleControlSlider *_slider; // 滑块
    UILabel *_doneBtnLabel;
    // 全屏
}

#pragma mark - SETTER & GETTER
- (void)setDuration:(double)duration {
    _duration = duration;
    _slider.maxValue = duration;
    _slider.minValue = 0;
    _slider.leftValue = 0;
    _slider.rightValue = duration;
    __weak typeof(self) weakSelf = self;
    _slider.valueChangeCallback = ^(CGFloat leftValue, CGFloat rightValue) {
        if (weakSelf.valueChangeCallback) {
//            weakSelf.valueChangeCallback(leftValue, rightValue, weakSelf.showImageView);
        }
    };
    _slider.leftValueChangeCallback = ^(CGFloat leftValue) {
        if (weakSelf.valueChangeCallback) {
            weakSelf.valueChangeCallback(leftValue, -123, weakSelf.showImageView);
        }
    };
    _slider.rightValueChangeCallback = ^(CGFloat rightValue) {
        if (weakSelf.valueChangeCallback) {
            weakSelf.valueChangeCallback(-123, rightValue, weakSelf.showImageView);
        }
    };
    
    [self refreshFrame];
    
    if (self.valueChangeCallback) {
        self.valueChangeCallback(_slider.leftValue, _slider.rightValue, _showImageView);
    }
}

#pragma mark - LIFE CYCLE
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self refreshFrame];
}

- (void)refreshFrame {
    _showImageView.frame = self.bounds;
    _slider.frame = CGRectMake(0, self.frame.size.height-30, self.frame.size.width - 50, 30);
    _doneBtnLabel.frame = CGRectMake(self.frame.size.width - 50 - 10, _slider.frame.origin.y, 50, 30);
}

#pragma mark - UI
- (void)setupUI {
    _showImageView = [[UIImageView alloc] init];
    _showImageView.frame = self.bounds;
    _showImageView.backgroundColor = [UIColor cyanColor];
    [self addSubview:_showImageView];
    
    _slider = [[XHSSDoubleControlSlider alloc] init];
    _slider.frame = CGRectMake(0, self.frame.size.height-30, self.frame.size.width - 50, 30);
    _slider.minValue = 0;
    _slider.maxValue = 1;
    _slider.leftValue = 0;
    _slider.rightValue = 1;
    [self addSubview:_slider];
    
    _doneBtnLabel = [[UILabel alloc] init];
    _doneBtnLabel.frame = CGRectMake(self.frame.size.width - 50 - 10, _slider.frame.origin.y, 50, 30);
    _doneBtnLabel.textColor = [UIColor whiteColor];
    _doneBtnLabel.backgroundColor = [UIColor orangeColor];
    _doneBtnLabel.textAlignment = NSTextAlignmentCenter;
    _doneBtnLabel.userInteractionEnabled = YES;
    _doneBtnLabel.layer.cornerRadius = _doneBtnLabel.frame.size.height*0.5;
    [_doneBtnLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doneBtnColick)]];
    [self addSubview:_doneBtnLabel];
}

#pragma mark - REQUEST
#pragma mark - TABLE VIEW DELEGATE
#pragma mark - TABLE VIEW DATASOURCE
#pragma mark - COLLECTION VIEW DELEGATE
#pragma mark - COLLECTION VIEW DATASOURCE
#pragma mark - COLLECTION VIEW LAYOUT DELEGATE
#pragma mark - ACTION
- (void)doneBtnColick {
    if (self.doneCallback) {
        self.doneCallback();
    }
}
#pragma mark - TOOLS FOUNCTION
#pragma mark - OTHER

@end
