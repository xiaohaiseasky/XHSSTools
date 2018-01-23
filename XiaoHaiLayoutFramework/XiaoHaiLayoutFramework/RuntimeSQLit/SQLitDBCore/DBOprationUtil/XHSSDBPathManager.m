//
//  XHSSDBPathManager.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/23.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import "XHSSDBPathManager.h"

@implementation XHSSDBPathManager

+(NSString*) getPath {
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* dbPath = [path stringByAppendingPathComponent:@"TestDatabase.db"];
    return dbPath;
}

@end
