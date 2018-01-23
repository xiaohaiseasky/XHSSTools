//
//  XHSSModelRuntimeInfoManager.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/23.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import "XHSSModelRuntimeInfoManager.h"
#import "XHSSDBCommonSettingFile.h"
#import "XHSSDataTypeClassify.h"

@implementation XHSSModelRuntimeInfoManager

/**
 *  成员变量类型（属性类型）
 */
NSString *const XHSSPropertyTypeInt = @"i";
NSString *const XHSSPropertyTypeShort = @"s";
NSString *const XHSSPropertyTypeFloat = @"f";
NSString *const XHSSPropertyTypeDouble = @"d";
NSString *const XHSSPropertyTypeLong = @"l";
NSString *const XHSSPropertyTypeLongLong = @"q";
NSString *const XHSSPropertyTypeChar = @"c";
NSString *const XHSSPropertyTypeBOOL1 = @"c";
NSString *const XHSSPropertyTypeBOOL2 = @"b";
NSString *const XHSSPropertyTypePointer = @"*";

NSString *const XHSSPropertyTypeIvar = @"^{objc_ivar=}";
NSString *const XHSSPropertyTypeMethod = @"^{objc_method=}";
NSString *const XHSSPropertyTypeBlock = @"@?";
NSString *const XHSSPropertyTypeClass = @"#";
NSString *const XHSSPropertyTypeSEL = @":";
NSString *const XHSSPropertyTypeId = @"@";


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
    
    if ([propertyTypeDes isEqualToString:XHSSPropertyTypeId]) {
        baseType = XHPropertyBaseTypeId;
    } else if (propertyTypeDes.length == 0) {
        baseType = XHPropertyBaseTypeKVCDisabled;
    } else if (propertyTypeDes.length > 3 && [propertyTypeDes hasPrefix:@"@\""]) {
        // 去掉@"和"，截取中间的类型名称
        NSString* typeStr = [propertyTypeDes substringWithRange:NSMakeRange(2, propertyTypeDes.length - 3)];
        Class typeClass = NSClassFromString(typeStr);
        baseType = XHPropertyBaseTypeClass;
        if ([XHSSDataTypeClassify isClassFromFoundation:typeClass]) {
            baseType |= XHPropertyBaseTypeFromFoundation;
        }
        if ([typeClass isSubclassOfClass:[NSNumber class]]) {
            baseType |= XHPropertyBaseTypeNumber;
        }
        
    } else if ([propertyTypeDes isEqualToString:XHSSPropertyTypeSEL] ||
               [propertyTypeDes isEqualToString:XHSSPropertyTypeIvar] ||
               [propertyTypeDes isEqualToString:XHSSPropertyTypeMethod]) {
        baseType = XHPropertyBaseTypeKVCDisabled;
    }
    
    // 是否为数字类型
    NSString *lowerCode = propertyTypeDes.lowercaseString;
    NSArray *numberTypes = @[XHSSPropertyTypeInt, XHSSPropertyTypeShort, XHSSPropertyTypeBOOL1, XHSSPropertyTypeBOOL2, XHSSPropertyTypeFloat, XHSSPropertyTypeDouble, XHSSPropertyTypeLong, XHSSPropertyTypeLongLong, XHSSPropertyTypeChar];
    if ([numberTypes containsObject:lowerCode]) {
        baseType |= XHPropertyBaseTypeNumber;
        
        if ([lowerCode isEqualToString:XHSSPropertyTypeBOOL1] || [lowerCode isEqualToString:XHSSPropertyTypeBOOL2]) {
            baseType |= XHPropertyBaseTypeBOOL;
        }
    }
    
    return baseType;
}

@end
