//
//  XHSSDBCommonSettingFile.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/23.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>
#import <objc/runtime.h>
//#import <objc/message.h>
#import <CoreData/CoreData.h>


//
//
//
/**
 生成存储和查询路径：
 
 模型数据操作：
 获取类型信息：
 类名：
 属性名：
 属性类型：
 区分默认值和给定的特殊值
 
 数据库操作：
 新建数据库：
 打开数据库：
 关闭数据库：
 
 表操作：
 创建表：
 String
 Model
 增加：
 String
 Model
 删除：
 String
 Model
 修改：
 String
 Model
 查询：
 String
 Model
 
 生成SQL语句：
 生成建表语句：
 传递一个 Model 对象
 生成增加语句：
 传递一个 Model 对象
 生成删除语句：
 传递一个 Model 对象
 生成修改语句：
 传递俩个 Model 对象
 生成查询语句：
 传递一个 Model 对象
 
 多线程优化
 */

/**
 
 */


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


@interface XHSSDBCommonSettingFile : NSObject

@end
