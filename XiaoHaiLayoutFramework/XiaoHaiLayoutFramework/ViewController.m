//
//  ViewController.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/16.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "ViewController.h"
//#import "UIView+XHSSLayoutFramework.h"
//#import "XHSSWebViewVCViewController.h"

#import <AVFoundation/AVFoundation.h>
//#import "UIView+XHSSUIFactory.h"
#import "XHSSTextField.h"
#import "XHSSUIFactory.h"

#import "UIView+XHSSShadowMask.h"
#import "UIView+XHSSUIFactoryBaseView.h"


@interface ViewController ()

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
}

- (void)test {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 200, 30)];
    topView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:topView];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 30, 200)];
    leftView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:leftView];
    UIView *bottomiew = [[UIView alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height - 30, 300, 30)];
    bottomiew.backgroundColor = [UIColor blueColor];
    [self.view addSubview:bottomiew];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 30, 100, 30, 300)];
    rightView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:rightView];
    
    
    [self testUIFactoryModel];
}



#pragma mark - test UIFactoryModel
- (void)testUIFactoryModel {
    XHSSUIFactoryViewModel *UIModel = [[XHSSUIFactoryViewModel alloc] init];
    
//    [UIModel bindToView:self.view];
    [UIModel addSubComponent:[XHSSManagerBridge createComponentWithClass:[UILabel class]]
     .addToSuperView(UIModel.rootView)
     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
        configManager.text = @"lalbel";
        configManager.textAlignment = NSTextAlignmentCenter;
        configManager.backgroundColor = [UIColor redColor];
    })
     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
        layoutManager
        .topEqualToNum(100)
        .leftEqualToNum(10)
        .bottomEqualToNum(10)
        .rightEqualToNum(10)
        .heightEqualToNum(100);
    })
                     forName:@"label"];
    
    [UIModel addSubComponent:[XHSSManagerBridge createComponentWithClass:[UILabel class]]
     .addToSuperView(UIModel.rootView)
     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
        configManager.text = @"lalbel123";
        configManager.textAlignment = NSTextAlignmentCenter;
        configManager.backgroundColor = [UIColor blueColor];
    })
     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
        layoutManager
        .topDistance(30)
        .toTopRefView(UIModel.subComponentForKey(@"label"))
        .leftEqualToNum(10).bottomEqualToNum(10)
        .rightEqualToNum(10)
        .heightEqualToNum(100);
    })
                     forName:@"label123"];
    
    
#if 1
    [UIModel addSubComponent:[XHSSManagerBridge createComponentWithClass:[UILabel class]]
     .addToSuperView(UIModel.subComponentForKey(@"label123"))
     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
        configManager.text = @"***lalbel***";
        configManager.textAlignment = NSTextAlignmentCenter;
        configManager.backgroundColor = [UIColor cyanColor];
    })
     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
        layoutManager
        .topEqualToNum(10)
        .leftEqualToNum(10)
        .bottomEqualToNum(10)
        .rightEqualToNum(10);
    })
                     forName:@"***lalbel***"];
#endif
    
    [UIModel bindToView:self.view];
    
#if 0
    XHSSUIFactoryViewModel *ui = [[XHSSUIFactoryViewModel alloc] init];
    [ui bindToView:UIModel.subComponentForKey(@"***lalbel***")];
    [ui addSubComponent:[XHSSManagerBridge createComponentWithClass:[UIImageView class]]
     .addToSuperView(ui.rootView)
     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
        configManager.backgroundColor = [UIColor orangeColor];
    })
     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
        layoutManager
        .topEqualToNum(10)
        .leftEqualToNum(10)
        .bottomEqualToNum(10)
        .rightEqualToNum(10)
        .widthEqualToNum(150);
    })
                forName:@"imageView"];
#endif
    
#if 0
    [ui addSubComponent:[XHSSManagerBridge createComponentWithClass:[UIImageView class]]
     .addToSuperView(ui.subComponentForKey(@"imageView"))
     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
        configManager.backgroundColor = [UIColor purpleColor];
    })
     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
        layoutManager.topEqualToNum(10).leftEqualToNum(10).bottomEqualToNum(10).rightEqualToNum(10).widthEqualToNum(30);
    })
                forName:@"imageView1"];
#endif

#if 0
    [ui addSubComponent:[XHSSManagerBridge createComponentWithClass:[UIImageView class]]
     .addToSuperView(ui.subComponentForKey(@"imageView"))
     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
        configManager.backgroundColor = [UIColor purpleColor];
    })
     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
        layoutManager.topEqualToNum(10).leftEqualToNum(10).bottomEqualToNum(10).rightEqualToNum(10).widthEqualToNum(30).leftDistance(10).toLeftRefView(ui.subComponentForKey(@"imageView1"));
    })
                forName:@"imageView2"];
#endif
    
#if 0
    [ui addSubComponent:[XHSSManagerBridge createComponentWithClass:[UIImageView class]]
     .addToSuperView(ui.subComponentForKey(@"imageView"))
     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
        configManager.backgroundColor = [UIColor purpleColor];
    })
     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
        layoutManager.topEqualToNum(10).bottomEqualToNum(10).widthEqualToNum(30).leftDistance(10).toLeftRefView(ui.subComponentForKey(@"imageView2"));
    })
                forName:@"imageView3"];
#endif
   
#if 0
    [ui addSubComponent:[XHSSManagerBridge createComponentWithClass:[UIImageView class]]
     .addToSuperView(ui.subComponentForKey(@"imageView"))
     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
        configManager.backgroundColor = [UIColor purpleColor];
    })
     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
        layoutManager.topEqualToNum(10).bottomEqualToNum(10).widthEqualToNum(30).leftDistance(10).toLeftRefView(ui.subComponentForKey(@"imageView3"));
    })
                forName:@"imageView4"];
#endif
   
#if 0
    [ui addSubComponent:[XHSSManagerBridge createComponentWithClass:[UIImageView class]]
     .addToSuperView(ui.subComponentForKey(@"imageView"))
     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
        configManager.backgroundColor = [UIColor purpleColor];
    })
     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
        layoutManager.topEqualToNum(10).bottomEqualToNum(10).widthEqualToNum(30).leftDistance(10).toLeftRefView(ui.subComponentForKey(@"imageView4"));
    })
                forName:@"imageView5"];
#endif
    
#if 0
    [ui addSubComponent:[XHSSManagerBridge createComponentWithClass:[UIImageView class]]
     .addToSuperView(ui.subComponentForKey(@"imageView"))
     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
        configManager.backgroundColor = [UIColor purpleColor];
    })
     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
        layoutManager.topEqualToNum(10).bottomEqualToNum(10).widthEqualToNum(30).leftDistance(10).toLeftRefView(ui.subComponentForKey(@"imageView5"));
    })
                forName:@"imageView6"];
#endif
    
    
//    [ui bindToView:UIModel.subComponentForKey(@"label")];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 170, 170)];
    [view setupWithViewModel:UIModel];
    [self.view addSubview:view];
}

#pragma mark - test draw rect
- (void)testDrawRect {
//    XHSSShadowView *shadowView = [[XHSSShadowView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
//    [self.view addSubview:shadowView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 170, 170)];
    [view addShadowMask:^(XHSSShadowMaskViewConfigManager *manager) {
        manager
        .backgroundColor([UIColor cyanColor])
        
        //.rect()
        .content([UIImage imageNamed:@"pic.jpg"])
        .innerRectRadius(10)
        .outterRectRadius(10)
        .cleareCenter(YES)
        
//        .gradientDirection(XHSSDrawGradientDirectionRadial)
        .gradientColors(@[[UIColor redColor],[UIColor greenColor],[UIColor blueColor]])
        .linearGradientStartPoint(CGPointMake(CGRectGetMinX(view.frame), CGRectGetMinY(view.frame)))
        .linearGradientEndPoint(CGPointMake(CGRectGetMinX(view.frame), CGRectGetMaxY(view.frame)))
        .radialGradientStartCenterPoint(CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame)))
        .radialGradientStartRadius(CGRectGetWidth(view.frame)/2.0f)
        .radialGradientEndCenterPoint(CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame)))
        .radialGradientEndRadius(CGRectGetWidth(view.frame)/2.0)
        
//        .maskColor([UIColor blueColor])
        .innerEdgeInsets(UIEdgeInsetsMake(10, 10, 10, 10))
        .outterEdgeInsets(UIEdgeInsetsMake(30, 30, 30, 30))
        
        .shadowColor([UIColor redColor])
        //.shadowOffset(CGSizeMake(17, 17))
        .shadowBlur(23)
        ;
    }];
    [self.view addSubview:view];
}

#pragma mark - test Layout
- (void)testLayout {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 200, 30)];
    topView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:topView];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 30, 200)];
    leftView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:leftView];
    UIView *bottomiew = [[UIView alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height - 30, 300, 30)];
    bottomiew.backgroundColor = [UIColor blueColor];
    [self.view addSubview:bottomiew];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 30, 100, 30, 300)];
    rightView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:rightView];
    
    //UIView *targetView = [[UIView alloc] init];
    //    UILabel *targetView = [[UILabel alloc] init];
    //    targetView.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:targetView];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    
    
    // refrence to view
    //    targetView.leftDistance(100).toLeftRefView(leftView);
    //    targetView.topDistance(10).toTopRefView(topView);
    //    targetView.bottomDistance(70).toBottomRefView(bottomiew);
    //    targetView.rightDistance(30).toRightRefView(rightView);
    
    
    // refrence to view
    //    targetView.leftDistance(20).toLeftRefView(leftView).topDistance(10).toTopRefView(topView).bottomDistance(70).toBottomRefView(bottomiew).rightDistance(30).toRightRefView(rightView);
    
    
    // equal to num
    //    targetView.leftEqualToNum(20).topEqualToNum(10).bottomEqualToNum(70).rightEqualToNum(40);
    
    
    // equal to view
    //    targetView.leftEqualToView(bottomiew).topEqualToView(leftView).bottomEqualToView(rightView).rightEqualToView(topView);
    
    
    //
    //    targetView.topEqualToNum(70).leftDistance(30).toLeftRefView(leftView).bottomEqualToView(rightView).rightEqualToView(topView);
    
    //
    //    targetView.widthEqualToNum(123).heightEqualToNum(321);
    
    
    //
    //    [self.view setAdaptionBaseScreenWidth:320];
    //    targetView.laBaseScreenWidth(375).topEqualToNumScreenFit(200).leftEqualToNumScreenFit(30).bottomEqualToNumScreenFit(200).rightEqualToNumScreenFit(30);
    
    //
    //    XHSSLayoutBlock layout = ^(UIView *manager){
    //
    //    };
    //    targetView.xhss_addLayout(layout);
    
    
    
    
    
    //
    XHSSConfigBlock config = ^(XHSSConfigManager *manager) {
        manager.borderWidth(4).borderColor([UIColor blueColor]).cornerRadius(47).backgroundColor([UIColor redColor]).clipsToBounds(YES).label_text(@"test XHSSUIManager founction");
    };
    config = [XHSSUIFactory labelConfigBlockWithFont:XHSS_FONT_SYSTEM_WITH_SIZE(21) textColor:XHSS_COLOR_RED textAligment:XHSS_TEXT_ALIGNMENT_LEFT];
    
    UILabel *targetView =
    [XHSSUIFactory label]
    .xhss_addToSuperView(self.view)
    .xhss_addLayout(^(UIView *manager) {
        manager
        .topEqualToView(leftView)
        .leftEqualToView(bottomiew)
        .bottomEqualToView(rightView)
        .rightEqualToView(topView);
    })
    .xhss_addConfig(config)
    .xhss_addConfig(^(XHSSConfigManager *manager) {
        manager
        .borderWidth(4)
        .borderColor([UIColor blueColor])
        .cornerRadius(47)
        .backgroundColor([UIColor purpleColor])
        .clipsToBounds(YES)
        .label_text(@"test XHSSUIManager founction");
    });
    
    [XHSSUIFactory label]
    .xhss_addToSuperView(self.view)
    .xhss_addLayout(^(UIView *manager) {
        manager
        .topDistance(100).toTopRefView(targetView)
        .leftEqualToView(bottomiew)
        //        .bottomEqualToView(rightView)
        .bottomEqualToViewTop(bottomiew)
        .rightEqualToView(topView);
        //        .heightEqualToNum(70);
    })
    .xhss_addConfig(config)
    .xhss_addConfig(^(XHSSConfigManager *manager) {
        manager
        .backgroundColor(XHSS_COLOR_RED);
    });
    
    //    targetView1
    //    .xhss_addToSuperView(self.view)
    //    .xhss_addLayout(^(UIView *manager) {
    //        manager
    //        .topDistance(10).toTopRefView(targetView)
    //        .leftEqualToView(targetView)
    //        .heightEqualToView(targetView)
    //        .rightEqualToView(targetView);
    //    })
    //    .xhss_addConfig(config);
    //
    //    targetView2
    //    .xhss_addToSuperView(self.view)
    //    .xhss_addLayout(^(UIView *manager) {
    //        manager
    //        .topDistance(10).toTopRefView(targetView1)
    //        .leftEqualToView(targetView1)
    //        .heightEqualToView(targetView1)
    //        .rightEqualToView(targetView1);
    //    })
    //    .xhss_addConfig(config);
}


#pragma mark - test textField
- (void)testTextField {
    XHSSTextField *targetView = [[XHSSTextField alloc] init];
    targetView.targetViewByKeyboard = self.view;
    targetView.statusBarHeight = 20;
    
    //targetView.viladitor = self;
    //targetView.viladitefounction = ;
    targetView.viladitionCallBack = ^(BOOL isAvilable) {
        NSLog(@"<<<<<<< viladitionCallBack isAvilable = %d >>>>>>>", isAvilable);
    };
    
    targetView.shouldClear = YES;
    targetView.shouldReturn = YES;
    targetView.minInputLength = 3;
    targetView.maxInputLength = 12;
    
    targetView.shouldShowMessageWhenInputValidateFaild = YES;
    targetView.shouldShowMessageWhenInputLengthInvalidate = YES;
    targetView.tipMessageWhenInputValidateFaild = @"tipMessageWhenInputValidateFaild";
    targetView.tipMessageWhenInputLengthInvalidate = @"tipMessageWhenInputLengthInvalidate";
    //@property (nonatomic, strong) UIView *tipView;
    //    targetView.needShowMessageCallBack = ^(NSString *message) {
    //        NSLog(@"<<<<<<< needShowMessageCallBack message = %@ >>>>>>>", message);
    //    };
    
    targetView.viladateType = XHSSTextFieldViladateTypePhoneNumberNormal;
    
    targetView.inputLenghtAvilableStatusChangeCallBack = ^(BOOL isAvilable, XHSSTextFieldInputLengthAvilableType avilableType) {
        NSLog(@"<<<<<<< inputLenghtAvilableStatusChangeCallBack isAvilable = %d , %ld>>>>>>>", isAvilable, avilableType);
    };
    targetView.inputStatusChangeCallBack = ^(XHSSTextFieldInputStatusType inputState) {
        NSLog(@"<<<<<<< inputStatusChangeCallBack inputState = %ld >>>>>>>", inputState);
    };
    targetView.returnColickCallBack = ^() {
        NSLog(@"<<<<<<< returnColickCallBack >>>>>>>");
    };
    
    
    /////////////////////////////////////////////////
    XHSSTextField *targetView1 = [[XHSSTextField alloc] init];
    targetView.targetViewByKeyboard = self.view;
    
    XHSSTextField *targetView2 = [[XHSSTextField alloc] init];
    targetView.targetViewByKeyboard = self.view;
}

@end
