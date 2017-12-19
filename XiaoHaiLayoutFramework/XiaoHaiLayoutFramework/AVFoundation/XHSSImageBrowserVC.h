//
//  XHSSImageBrowserVC.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/24.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHSSImageBrowserVC : UIViewController

@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, assign) NSInteger currentIndex;

@end


/**
 底部图片信息视图
 */
@interface XHSSBottomView : UIView

- (void)setLabelInfoWithTotal:(NSInteger)total currentIndex:(NSInteger)currentIndex;

@end
