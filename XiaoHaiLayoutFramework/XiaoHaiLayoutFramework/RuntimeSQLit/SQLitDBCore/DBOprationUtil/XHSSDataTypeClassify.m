//
//  XHSSDataTypeClassify.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/23.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import "XHSSDataTypeClassify.h"
#import "XHSSDBCommonSettingFile.h"

@implementation XHSSDataTypeClassify

static NSSet *foundationClasses_;

+(NSSet *) foundationClasses
{
    if (foundationClasses_ == nil) {
        // 集合中没有NSObject，因为几乎所有的类都是继承自NSObject，具体是不是NSObject需要特殊判断
        foundationClasses_ = [NSSet setWithObjects:
                              [NSURL class],
                              [NSDate class],
                              [NSValue class],
                              [NSData class],
                              [NSError class],
                              [NSArray class],
                              [NSDictionary class],
                              [NSString class],
                              [NSAttributedString class], nil];
    }
    return foundationClasses_;
}

+(BOOL) isClassFromFoundation:(Class)c
{
    if (c == [NSObject class] || c == [NSManagedObject class]) return YES;
    
    __block BOOL result = NO;
    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

@end
