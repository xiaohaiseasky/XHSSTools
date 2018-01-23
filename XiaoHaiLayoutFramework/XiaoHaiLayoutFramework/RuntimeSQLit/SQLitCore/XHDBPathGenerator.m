//
//  XHDBPathGenerator.m
//  RuntimeSQLit
//
//  Created by Admin on 16/9/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHDBPathGenerator.h"

@implementation XHDBPathGenerator

+(NSString*) getPath {
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* dbPath = [path stringByAppendingPathComponent:@"TestDatabase.db"];
    return dbPath;
}

@end
