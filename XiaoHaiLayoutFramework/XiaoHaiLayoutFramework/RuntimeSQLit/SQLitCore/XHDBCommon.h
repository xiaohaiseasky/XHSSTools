//
//  XHDBCommon.h
//  RuntimeSQLit
//
//  Created by Admin on 16/9/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>
#import <objc/runtime.h>
//#import <objc/message.h>
#import <CoreData/CoreData.h>



#ifdef DEBUG
#define CustomLog(...)       NSLog(@"%s [line: %d]", __PRETTY_FUNCTION__, __LINE__, __VA_ARGS__);
#else
#define CustomLog(...)
#endif

#define kJudgeSQLPara(sqlStr)       if (sqlStr == nil || sqlStr.length <= 0) {\
                                        NSLog(@"sql 语句为空");\
                                        return NO;\
                                    }

#define kJudgeInputModle(modle)     if (!modle) {\
                                        NSLog(@"参考模型 为空");\
                                        return nil;\
                                    }

#define kJudgeProperty(property)    if (!property) {\
                                        NSLog(@"属性 为空");\
                                        return nil;\
                                    }

#define lJudgePropertyTypeDes(propertyTypeDes)    if (propertyTypeDes == nil) {\
                                                      NSLog(@"属性类型描述 为空");\
                                                      return XHPropertyBaseTypeNull;\
                                                  }






#define kColumnsStrKey   @"columnsStr"
#define kValuesStrKey    @"valuesStr"
#define kTypesStrKey     @"typesStr"
#define kColumnsArrKey   @"columnsArr"
#define kValuesArrKey    @"valuesArr"
#define kTypesArrKey     @"typesArr"

#define kPropertyName    @"propertyName"
#define kPropertyType    @"propertyType"
#define kPropertyValue   @"propertyValue"





typedef enum {
    DbOperateTypeAdd        = 1,
    DbOperateTypeDelete     = 2,
    DbOperateTypeUpdate     =3,
    DbOperateTypeSelect     = 4,
}DbOperateType;

typedef NS_ENUM(NSInteger, XHPropertyType) {
    XHPropertyTypeShort     = 1,
    XHPropertyTypeInt       = 2,
    XHPropertyTypeLong      = 3,
    XHPropertyTypeLongLong  = 4,
    XHPropertyTypeFloat     = 5,
    XHPropertyTypeDouble    = 6,
    XHPropertyTypeChar      = 7,
    XHPropertyTypeBool      = 8,
};

typedef NS_ENUM(NSInteger, XHPropertyBaseType) {
    XHPropertyBaseTypeNull              = 1,
    XHPropertyBaseTypeBOOL              = 1 << 1,
    XHPropertyBaseTypeNumber            = 1 << 2,
    XHPropertyBaseTypeId                = 1 << 3,
    XHPropertyBaseTypeClass             = 1 << 4,
    XHPropertyBaseTypeFromFoundation    = 1 << 5,
    XHPropertyBaseTypeKVCDisabled       = 1 << 6,
};



/**
 * 1. 模型属性值的类型区分
 * 2. 存入数据库的所有字段，除自动生成的id 外，都用 CHAR 类型
 * 3. 模型嵌套的情况
 * 4. 数据库基本数据类型，OC基本数据类型 的区分
 * 5. 优化处理
 * 6. WHERE 语句处理，要支持排序条件／模糊查询条件
 */

@interface XHDBCommon : NSObject

@end
