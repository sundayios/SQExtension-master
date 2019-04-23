//
//  NSArray+HDSerialize.m
//  HuaDian
//
//  Created by cb_2018 on 2019/3/16.
//  Copyright © 2019 91cb. All rights reserved.
//

#import "NSArray+HDSerialize.h"

@implementation NSArray (HDSerialize)
/**
 *  字段转换成json字符串
 *
 *  @param dict <#dict description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)arrayToJsonStr:(NSArray *)array{
    
    //    NSMutableDictionary *dict = [NSMutableDictionary new];
    //    [dict setObject:@"" forKey:@"AWL_LAN"];
    //    [dict setObject:@"" forKey:@"AWL_LON"];
    //    [dict setObject:@"1"  forKey:@"U_ID"];
    NSString *jsonString = nil;
    if ([NSJSONSerialization isValidJSONObject:array])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"json data:%@",jsonString);
        if (error) {
            NSLog(@"Error:%@" , error);
        }
    }
    return jsonString;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return array;
}
@end
