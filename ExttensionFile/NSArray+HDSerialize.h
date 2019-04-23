//
//  NSArray+HDSerialize.h
//  HuaDian
//
//  Created by cb_2018 on 2019/3/16.
//  Copyright © 2019 91cb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (HDSerialize)
/**
 *  字段转换成json字符串
 *
 *  @param dict <#dict description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)arrayToJsonStr:(NSArray *)dict;
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
