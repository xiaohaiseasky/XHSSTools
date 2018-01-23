//
//  Book.h
//  RuntimeSQLit
//
//  Created by Admin on 16/9/21.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property(strong, nonatomic) NSString* bookName;
@property(strong, nonatomic) NSString* bookColor;
@property(assign, nonatomic) double bookPrice;
@property(assign, nonatomic) BOOL isShow;

@end
