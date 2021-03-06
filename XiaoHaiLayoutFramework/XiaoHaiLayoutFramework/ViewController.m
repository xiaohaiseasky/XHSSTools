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
#import "XHSSTabScrollView.h"
#import "TestTabScrollVC.h"
#import "XHSSScrollPopWindow.h"
#import "XHSSMapUnlockScrollView.h"


@interface ViewController () <XHSSTabScrollViewDelegate, XHSSTabScrollViewDataSource, XHSSScrollPopWindowDelegate>

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
}

- (void)test {
    
#if 0
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
#endif
    
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor redColor];
//    [bottomiew addSubview:view];
//    [leftView addSubview:[view copy]];
//
//    view.topEqualToNum(2).leftEqualToNum(2).widthEqualToNum(10).bottomEqualToNum(2);
    
    
//    [self testUIFactoryModel];
    
//    [self testTabScrollView];
    
    
    [self testMapUnLockView];
    
//    [self testScrollPopView];
}

#pragma mark - test testMapUnLockView
- (void)testMapUnLockView {
    //XHSSMapUnLockView *map = [[XHSSMapUnLockView alloc] init];
    XHSSMapUnlockScrollView *map = [[XHSSMapUnlockScrollView alloc] init];
    map.contentSize = CGSizeMake(1000, 2000);
    map.frame = CGRectMake(0, 100, [UIApplication sharedApplication].keyWindow.bounds.size.width, 400);
    [self.view addSubview:map];
    
    [map addNextStep:CGPointMake(0, 0)];
    [map addNextStep:CGPointMake(0, 100)];
    [map addNextStep:CGPointMake(100, 100)];
    [map addNextStep:CGPointMake(200, 100)];
    [map addNextStep:CGPointMake(200, 200)];
    [map addNextStep:CGPointMake(300, 200)];
    [map addNextStep:CGPointMake(300, 300)];
    [map addNextStep:CGPointMake(400, 300)];
    [map addNextStep:CGPointMake(400, 400)];
    [map addNextStep:CGPointMake(500, 400)];
    [map addNextStep:CGPointMake(500, 500)];
    [map addNextStep:CGPointMake(600, 500)];
    [map addNextStep:CGPointMake(600, 600)];
    [map addNextStep:CGPointMake(700, 600)];
    
    map.bgImage = [UIImage imageNamed:@"pic.jpg"];
    
    map.iconArr = [NSMutableArray arrayWithArray:@[[UIImage imageNamed:@"icon.jpg"],
                                                    [UIImage imageNamed:@"icon.jpg"],
                                                    [UIImage imageNamed:@"icon.jpg"],
                                                    [UIImage imageNamed:@"icon.jpg"],
                                                    [UIImage imageNamed:@"icon.jpg"],
                                                    [UIImage imageNamed:@"icon.jpg"],
                                                    [UIImage imageNamed:@"icon.jpg"],
                                                    [UIImage imageNamed:@"icon.jpg"],
                                                    [UIImage imageNamed:@"icon.jpg"],
                                                    [UIImage imageNamed:@"icon.jpg"],
                                                    [UIImage imageNamed:@"icon.jpg"],
                                                    [UIImage imageNamed:@"icon.jpg"],
                                                    [UIImage imageNamed:@"icon.jpg"],
                                                    [UIImage imageNamed:@"icon.jpg"]]];
    
    map.currentPositionIcon = [UIImage imageNamed:@"icon.jpg"];
    
    map.finishPercentText = @"123%";
    
    [map refreshPath];
}

#pragma mark - test testScrollPopView
- (void)testScrollPopView {
    XHSSScrollPopWindow *pop = [[XHSSScrollPopWindow alloc] init];
    pop.delegate = self;
    pop.maxAvilableScrollIndex = 10;
    pop.reuseEnable = YES;
    [pop show];
}

/// XHSSScrollPopWindowDelegate
- (NSInteger)pageNumberInScrollPopWindow:(XHSSScrollPopWindow *)scrollPopWindow {
    return 10;
}

- (UIView *)pageViewInScrollPopWindow:(XHSSScrollPopWindow *)scrollPopWindow atIndex:(NSInteger)index {
    UIView *view; // = [[UIView alloc] init];
    view = [scrollPopWindow reusePageViewOfClass:[UIView class] withIdentifier:@"UIView"];
    NSLog(@"<<<<<<< view address = %p>>>>>>>", view);
    view.backgroundColor = [UIColor redColor];
    return view;
}

- (CGSize)pageViewSizeInScrollPopWindow:(XHSSScrollPopWindow *)scrollPopWindow atIndex:(NSInteger)index {
    return CGSizeMake(300, 500);
}


#pragma mark - test UIFactoryModel
- (void)testTabScrollView {
    XHSSTabScrollViewConfig *config = [[XHSSTabScrollViewConfig alloc] init];
    config.contentVC = self;
    config.toolBarEdgeInsets = UIEdgeInsetsMake(10, 30, 0, 30);
    config.toolBarItemTitleArr = @[@"111", @"222", @"333"];
    config.toolBarItemFont = [UIFont boldSystemFontOfSize:23];
    config.toolBarItemNormalTextColor = [UIColor magentaColor];
    config.toolBarYOffset = 70;
    XHSSTabScrollView *tabView = [[XHSSTabScrollView alloc] initWithConfig:config];
    tabView.frame = self.view.bounds;
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:tabView];
    
}

- (void)XHSSTabScrollView:(XHSSTabScrollView *)tabScrollView didSwitchToSubVC:(UIViewController *)subVC atIndex:(NSInteger)index {
    
}

- (void)XHSSTabScrollView:(XHSSTabScrollView *)tabScrollView toolBar:(UIView *)toolBar didSwitchToItem:(UIView *)item atIndex:(NSInteger)index {
    
}

- (NSInteger)numberOfSubVCInXHSSTabScrollView:(XHSSTabScrollView *)tabScrollView {
    return 3;
}

- (UIViewController *)XHSSTabScrollView:(XHSSTabScrollView *)tabScrollView subVCAtIndex:(NSInteger)index {
    TestTabScrollVC *vc;
    if (index == 0) {
        TestTabScrollVC *vc1 = [[TestTabScrollVC alloc] init];
        vc1.view.backgroundColor = [UIColor redColor];
        vc = vc1;
    } else if (index == 1) {
        TestTabScrollVC *vc2 = [[TestTabScrollVC alloc] init];
        vc2.view.backgroundColor = [UIColor greenColor];
        vc = vc2;
    } else if (index == 2) {
        TestTabScrollVC *vc3 = [[TestTabScrollVC alloc] init];
        vc3.view.backgroundColor = [UIColor magentaColor];
        vc = vc3;
    }
    return vc;
}

- (CGFloat)headerViewHeightForXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView {
    return 70;
}

- (UIView*)viewForHeaderInXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor magentaColor];
    return view;
}

- (CGFloat)toolBarHeightForXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView {
    return 150;
}

- (UIView<XHSSTabScrollViewToolBarViewDelegate>*)viewForToolBarInXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView {
    XHSSTabScrollViewToolBarView *toolBar = [[XHSSTabScrollViewToolBarView alloc] init];
    toolBar.titlesArr = @[@"1", @"2", @"3"];
    toolBar.contentEdgeInsets = UIEdgeInsetsMake(10, 30, 0, 30);
    return toolBar;
}

- (UIEdgeInsets)toolBarEdgeInsetsForXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView {
    return UIEdgeInsetsMake(10, 30, 0, 30);
}

- (NSInteger)numberOfToolBarItemInXHSSTabScrollView:(XHSSTabScrollView*)tabScrollView {
    return 3;
}

//- (UIView *)XHSSTabScrollView:(XHSSTabScrollView *)tabScrollView viewForItemInToolBar:(UIView *)toolBar atIndex:(NSInteger)index {
//    UIView *view = [[UIView alloc] init];
//    if (index == 0) {
//        view.backgroundColor = [UIColor redColor];
//    } else if (index == 1) {
//        view.backgroundColor = [UIColor magentaColor];
//    } else if (index == 2) {
//        view.backgroundColor = [UIColor blueColor];
//    }
//    return view;
//}


#pragma mark - test UIFactoryModel
- (void)testUIFactoryModel {
    XHSSUIFactoryViewModel *UIModel = [[XHSSUIFactoryViewModel alloc] init];
    
////    [UIModel bindToView:self.view];
//    [UIModel addSubComponent:[XHSSManagerBridge createComponentWithClass:[UILabel class]]
//     .addToSuperView(UIModel.rootView)
////     .addToSuperView(self.view)
//     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
//        configManager.text = @"lalbel";
//        configManager.textAlignment = NSTextAlignmentCenter;
//        configManager.backgroundColor = [UIColor redColor];
//    })
//     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
//        layoutManager
//        .topEqualToNum(100)
//        .leftEqualToNum(10)
//        .bottomEqualToNum(10)
//        .rightEqualToNum(10)
//        .heightEqualToNum(100);
//    })
//                     forName:@"label"];
//
//    [UIModel addSubComponent:[XHSSManagerBridge createComponentWithClass:[UILabel class]]
//     .addToSuperView(UIModel.rootView)
////     .addToSuperView(self.view)
//     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
//        configManager.text = @"lalbel123";
//        configManager.textAlignment = NSTextAlignmentCenter;
//        configManager.backgroundColor = [UIColor blueColor];
//    })
//     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
//        layoutManager
//        .topDistance(30)
//        .toTopRefView(UIModel.subComponentForKey(@"label"))
//        .leftEqualToNum(10).bottomEqualToNum(10)
//        .rightEqualToNum(10)
//        .heightEqualToNum(100);
//    })
//                     forName:@"label123"];
//
//
//#if 1
//    [UIModel addSubComponent:[XHSSManagerBridge createComponentWithClass:[UILabel class]]
//     .addToSuperView(UIModel.subComponentForKey(@"label"))
//     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
//        configManager.text = @"***lalbel***";
//        configManager.textAlignment = NSTextAlignmentCenter;
//        configManager.backgroundColor = [UIColor cyanColor];
//    })
//     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
//        layoutManager
//        .topEqualToNum(10)
//        .leftEqualToNum(10)
//        .bottomEqualToNum(10)
//        .rightEqualToNum(10)
////        .heightEqualToNum(30)
//        ;
//    })
//                     forName:@"label/***lalbel***"];
//#endif
//
//    [UIModel bindToView:self.view];
//
//#if 1
//    XHSSUIFactoryViewModel *ui = [[XHSSUIFactoryViewModel alloc] init];
////    [ui bindToView:UIModel.subComponentForKey(@"***lalbel***")];
//    [ui addSubComponent:[XHSSManagerBridge createComponentWithClass:[UIImageView class]]
//     .addToSuperView(ui.rootView)
//     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
//        configManager.backgroundColor = [UIColor orangeColor];
//    })
//     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
//        layoutManager
//        .topEqualToNum(10)
//        .leftEqualToNum(10)
//        .bottomEqualToNum(10)
//        .rightEqualToNum(10)
//        .widthEqualToNum(150);
//    })
//                forName:@"imageView"]; // @"label/***lalbel***/imageView"
//#endif

//#if 1
//    [ui addSubComponent:[XHSSManagerBridge createComponentWithClass:[UIImageView class]]
//     .addToSuperView(ui.subComponentForKey(@"imageView"))
//     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
//        configManager.backgroundColor = [UIColor purpleColor];
//    })
//     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
//        layoutManager
//        .topEqualToNum(10)
//        .leftEqualToNum(10)
//        .bottomEqualToNum(10)
//        .rightEqualToNum(10)
//        .widthEqualToNum(30);
//    })
//                forName:@"imageView/imageView1"];
//#endif
//
//#if 1
//    [ui addSubComponent:[XHSSManagerBridge createComponentWithClass:[UIImageView class]]
//     .addToSuperView(ui.subComponentForKey(@"imageView"))
//     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
//        configManager.backgroundColor = [UIColor purpleColor];
//    })
//     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
//        layoutManager
//        .topEqualToNum(10)
////        .leftEqualToNum(10)
//        .bottomEqualToNum(10)
////        .rightEqualToNum(10)
//        .widthEqualToNum(30)
//        .leftDistance(10)
//        .toLeftRefView(ui.subComponentForKey(@"imageView/imageView1"));
//    })
//                forName:@"imageView/imageView2"];
//#endif
//
//#if 1
//    [ui addSubComponent:[XHSSManagerBridge createComponentWithClass:[UIImageView class]]
//     .addToSuperView(ui.subComponentForKey(@"imageView"))
//     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
//        configManager.backgroundColor = [UIColor purpleColor];
//    })
//     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
//        layoutManager.
//        topEqualToNum(10)
//        .bottomEqualToNum(10)
//        .widthEqualToNum(30)
//        .leftDistance(10)
//        .toLeftRefView(ui.subComponentForKey(@"imageView/imageView2"));
//    })
//                forName:@"imageView/imageView3"];
//#endif
//
//#if 0
//    [ui addSubComponent:[XHSSManagerBridge createComponentWithClass:[UIImageView class]]
//     .addToSuperView(ui.subComponentForKey(@"imageView"))
//     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
//        configManager.backgroundColor = [UIColor purpleColor];
//    })
//     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
//        layoutManager.topEqualToNum(10).bottomEqualToNum(10).widthEqualToNum(30).leftDistance(10).toLeftRefView(ui.subComponentForKey(@"imageView3"));
//    })
//                forName:@"imageView4"];
//#endif
//
//#if 0
//    [ui addSubComponent:[XHSSManagerBridge createComponentWithClass:[UIImageView class]]
//     .addToSuperView(ui.subComponentForKey(@"imageView"))
//     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
//        configManager.backgroundColor = [UIColor purpleColor];
//    })
//     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
//        layoutManager.topEqualToNum(10).bottomEqualToNum(10).widthEqualToNum(30).leftDistance(10).toLeftRefView(ui.subComponentForKey(@"imageView4"));
//    })
//                forName:@"imageView5"];
//#endif
//
//#if 0
//    [ui addSubComponent:[XHSSManagerBridge createComponentWithClass:[UIImageView class]]
//     .addToSuperView(ui.subComponentForKey(@"imageView"))
//     .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
//        configManager.backgroundColor = [UIColor purpleColor];
//    })
//     .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
//        layoutManager.topEqualToNum(10).bottomEqualToNum(10).widthEqualToNum(30).leftDistance(10).toLeftRefView(ui.subComponentForKey(@"imageView5"));
//    })
//                forName:@"imageView6"];
//#endif
//
//    [ui bindToView:UIModel.subComponentForKey(@"label123")];
//    [ui bindToView:UIModel.subComponentForKey(@"label/***lalbel***")];
    
    
    
    UIModel
    .addSubComponentForName([XHSSManagerBridge createComponentWithClass:[UILabel class]]
                            .addToSuperView(UIModel.rootView)
                            .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
                                configManager.text = @"!!!!!!!!!!!!!";
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
                            }),
    @"LABEL!!!")
    .addSubComponentForName([XHSSManagerBridge createComponentWithClass:[UILabel class]]
                            .addToSuperView(UIModel.rootView)
                            .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
                                configManager.text = @"@@@@@@@@@";
                                configManager.textAlignment = NSTextAlignmentCenter;
                                configManager.backgroundColor = [UIColor blueColor];
                            })
                            .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
                                layoutManager
                                .topDistance(30).toTopRefView(UIModel.subComponentForKey(@"LABEL!!!"))
                                .leftEqualToNum(10)
                                .bottomEqualToNum(10)
                                .rightEqualToNum(10)
                                .heightEqualToNum(100);
                            }),
    @"LABEL@@@")
    .addSubComponentForName([XHSSManagerBridge createComponentWithClass:[UILabel class]]
                            .addToSuperView(UIModel.subComponentForKey(@"LABEL@@@"))
                            .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
                                configManager.text = @"#############";
                                configManager.textAlignment = NSTextAlignmentCenter;
                                configManager.backgroundColor = [UIColor cyanColor];
                            })
                            .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
                                layoutManager
                                .topEqualToNum(10)
                                .leftEqualToNum(10)
                                .bottomEqualToNum(10)
                                .rightEqualToNum(10)
                            ;
                            }),
    @"LABEL###")
    
    .bindToView(self.view)
    ;
    
    
    XHSSUIFactoryViewModel *ui = [[XHSSUIFactoryViewModel alloc] init];
    ui.addSubComponentForName([XHSSManagerBridge createComponentWithClass:[UIImageView class]]
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
                                    ;
                              })
    ,@"IMAGEVIEW")
    .addSubComponentForName([XHSSManagerBridge createComponentWithClass:[UIImageView class]]
                            .addToSuperView(ui.subComponentForKey(@"IMAGEVIEW"))
                            .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
                                configManager.backgroundColor = [UIColor redColor];
                            })
                            .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
                                layoutManager
                                .topEqualToNum(10)
                                .leftEqualToNum(10)
                                .bottomEqualToNum(10)
                                .rightEqualToNum(10)
                                .widthEqualToNum([(UIView*)ui.subComponentForKey(@"IMAGEVIEW") xhssWidth]/3.0)
                                ;
                            })
    ,@"IMAGEVIEW111")
    .addSubComponentForName([XHSSManagerBridge createComponentWithClass:[UIImageView class]]
                            .addToSuperView(ui.subComponentForKey(@"IMAGEVIEW"))
                            .addConfig(^(XHSSConfigManagerBridge * _Nonnull configManager) {
                                configManager.backgroundColor = [UIColor redColor];
                            })
                            .addLayout(^(XHSSLayoutManagerBridge * _Nonnull layoutManager){
                                layoutManager
                                .topEqualToNum(10)
                                .leftEqualToNum(10)
                                .bottomEqualToNum(10)
                                .rightEqualToNum(10)
                                .widthEqualToNum([(UIView*)ui.subComponentForKey(@"IMAGEVIEW") xhssWidth]/3.0)
                                .rightAligmentToNum(10)
                                ;
                            })
    ,@"IMAGEVIEW222")
    .bindToView(UIModel.subComponentForKey(@"LABEL###"))
    .bindToView(UIModel.subComponentForKey(@"LABEL!!!"))
    ;
}

#pragma mark - test draw rect
#if 0
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
#endif

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
#if 0
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
#endif

@end
