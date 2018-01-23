//
//  XHGetModleRuntimeInfo.m
//  RuntimeSQLit
//
//  Created by Admin on 16/9/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHGetModleRuntimeInfo.h"
#import "XHDBCommon.h"
#import "XHDataTypeClassify.h"

@implementation XHGetModleRuntimeInfo

/**
 *  成员变量类型（属性类型）
 */
NSString *const MJPropertyTypeInt = @"i";
NSString *const MJPropertyTypeShort = @"s";
NSString *const MJPropertyTypeFloat = @"f";
NSString *const MJPropertyTypeDouble = @"d";
NSString *const MJPropertyTypeLong = @"l";
NSString *const MJPropertyTypeLongLong = @"q";
NSString *const MJPropertyTypeChar = @"c";
NSString *const MJPropertyTypeBOOL1 = @"c";
NSString *const MJPropertyTypeBOOL2 = @"b";
NSString *const MJPropertyTypePointer = @"*";

NSString *const MJPropertyTypeIvar = @"^{objc_ivar=}";
NSString *const MJPropertyTypeMethod = @"^{objc_method=}";
NSString *const MJPropertyTypeBlock = @"@?";
NSString *const MJPropertyTypeClass = @"#";
NSString *const MJPropertyTypeSEL = @":";
NSString *const MJPropertyTypeId = @"@";


/**
 *
 */
+(NSArray*)getPropertyListOfModle:(id)modle {
    
    NSMutableArray* propertyInfoArr = [NSMutableArray arrayWithCapacity:1];
    
    unsigned int count;
    objc_property_t* propertyList = class_copyPropertyList([modle class], &count);
    for (unsigned int i = 0; i < count; ++i) {
        objc_property_t aProperty = propertyList[i];
        
        [propertyInfoArr addObject:[self getPropertyInfo:aProperty forModle:modle]];
    }
    
    return propertyInfoArr;
}

/**
 * 获取属性信息
 */
+(NSDictionary*) getPropertyInfo:(objc_property_t)property forModle:(id)modle {
    
    kJudgeProperty(property)
    
    NSMutableDictionary* propertyInfoDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    /// 属性名字 bookName
    const char* cPropertyName = property_getName(property);
    NSString* propertyName = [NSString stringWithUTF8String:cPropertyName];
    
    /// 属性特征／类型 T@"NSString",&,N,V_bookName
    const char* cPropertyAtt = property_getAttributes(property);
    NSString* propertyAtt = [NSString stringWithUTF8String:cPropertyAtt];
    NSInteger dotLocation = [propertyAtt rangeOfString:@","].location;
    NSString* propertyTypeDesStr = nil;
    NSInteger loc = 1;
    if (dotLocation == NSNotFound) {
        propertyTypeDesStr = [propertyAtt substringFromIndex:loc];
    }
    else {
        propertyTypeDesStr = [propertyAtt substringWithRange:NSMakeRange(loc, dotLocation - loc)];
    }
    /// 由类型字符串取得 类型
    XHPropertyBaseType baseType = [self getPropertyTypeByPropertyTypeDes:propertyTypeDesStr];
    
    /// 属性值
    id propertyValue = [modle valueForKey:propertyName];
    
#warning 注意 setObject 为非对象类型时候 导致错误
    if (propertyName != nil && propertyName.length != 0) {
        [propertyInfoDic setObject:propertyName forKey:kPropertyName];
    }
    else {
        [propertyInfoDic setObject:@"" forKey:kPropertyName];
    }
    
    if (!baseType) {
        [propertyInfoDic setObject:@(baseType) forKey:kPropertyType];
    }
    else {
        [propertyInfoDic setObject:@(baseType) forKey:kPropertyType];
    }
    
    if (propertyValue != nil && [[propertyValue class] isKindOfClass:[NSObject class]]) {
        [propertyInfoDic setObject:propertyValue forKey:kPropertyValue];
    }
    else {
        if (propertyValue == nil) {
            [propertyInfoDic setObject:[NSNull null] forKey:kPropertyValue];
        }
        else {
            //[propertyInfoDic setObject:propertyValue forKey:kPropertyValue];
        }
    }
    
    return propertyInfoDic;
}

/**
 * 获取属性类型
 */
+(XHPropertyBaseType) getPropertyTypeByPropertyTypeDes:(NSString*)propertyTypeDes {
    
    lJudgePropertyTypeDes(propertyTypeDes);
    
    XHPropertyBaseType baseType = XHPropertyBaseTypeNull;
    
    if ([propertyTypeDes isEqualToString:MJPropertyTypeId]) {
        baseType = XHPropertyBaseTypeId;
    } else if (propertyTypeDes.length == 0) {
        baseType = XHPropertyBaseTypeKVCDisabled;
    } else if (propertyTypeDes.length > 3 && [propertyTypeDes hasPrefix:@"@\""]) {
        // 去掉@"和"，截取中间的类型名称
        NSString* typeStr = [propertyTypeDes substringWithRange:NSMakeRange(2, propertyTypeDes.length - 3)];
        Class typeClass = NSClassFromString(typeStr);
        baseType = XHPropertyBaseTypeClass;
        if ([XHDataTypeClassify isClassFromFoundation:typeClass]) {
            baseType |= XHPropertyBaseTypeFromFoundation;
        }
        if ([typeClass isSubclassOfClass:[NSNumber class]]) {
            baseType |= XHPropertyBaseTypeNumber;
        }
        
    } else if ([propertyTypeDes isEqualToString:MJPropertyTypeSEL] ||
               [propertyTypeDes isEqualToString:MJPropertyTypeIvar] ||
               [propertyTypeDes isEqualToString:MJPropertyTypeMethod]) {
        baseType = XHPropertyBaseTypeKVCDisabled;
    }
    
    // 是否为数字类型
    NSString *lowerCode = propertyTypeDes.lowercaseString;
    NSArray *numberTypes = @[MJPropertyTypeInt, MJPropertyTypeShort, MJPropertyTypeBOOL1, MJPropertyTypeBOOL2, MJPropertyTypeFloat, MJPropertyTypeDouble, MJPropertyTypeLong, MJPropertyTypeLongLong, MJPropertyTypeChar];
    if ([numberTypes containsObject:lowerCode]) {
        baseType |= XHPropertyBaseTypeNumber;
        
        if ([lowerCode isEqualToString:MJPropertyTypeBOOL1] || [lowerCode isEqualToString:MJPropertyTypeBOOL2]) {
            baseType |= XHPropertyBaseTypeBOOL;
        }
    }
    
    return baseType;
}

@end
