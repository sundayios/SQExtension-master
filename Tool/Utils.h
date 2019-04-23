//
//  Utils.h
//  SQExtension
//
//  Created by cb_2018 on 2019/3/23.
//  Copyright © 2019 cfwf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject
// 判断文件是否已经在沙盒中已经存在？
+ (BOOL)isFileExist:(NSString *)fileName;
// 删除文件
+ (void)deleteFile:(NSString *)fileName;
#pragma mark - UIImage
+ (UIImage *)grayscale:(UIImage *)anImage type:(int)type;
/**
 震动响铃
 */
+ (void)shakeAndRing;

/**
 把字典数组转为一个JSON字符串
 
 @param array 字典数组
 @return JSON字符串
 */
+ (NSString *)objArrayToJSON:(NSArray *)array;

/**
 将字典转为JSON字符串
 
 @param objDic 字典
 @return JSON字符串
 */
+ (NSString *)objDicToJSON:(NSDictionary *)objDic;

/**
 将JSON字符串转为OC对象
 
 @param json JSON字符串
 @return OC对象
 */
+ (id)JSONToObjc:(NSString *)jsonStr;

// 将时间戳转换为时间
+ (NSString *)getTimeFromTimestamp:(NSInteger)timestamp withDateFormat:(NSString *)dateFormat;

// 将时间转换为时间戳
+ (NSInteger)getTimestampFromTime:(NSString *)time WithDateFormat:(NSString *)dateFormat;

/*
 *  和当前时间比较
 *  1) 1分钟以内 显示：刚刚
 *  2) 10分钟以内 显示：X分钟前
 *  3) 今天或者昨天 显示：今天 09:30 昨天 09:30
 *  4) 今年 显示：09月12日 09:30
 *  5) 不在今年 显示：YY-MM-DD 09:30
 */
+ (NSString *)dateString:(NSString *)dateString withFormat:(NSString *)format;

/**
 根据文件名返回新图片
 
 @param fileName 文件名
 @return 新图片
 */
+ (UIImage *)getNewImgFromFileName:(NSString *)fileName;

/**
 图片旋转
 
 @param aImage <#aImage description#>
 @return <#return value description#>
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 获取本地沙盒图片地址
 
 @param image 图片
 @param size 压缩大小
 @return 图片地址
 */
+ (NSString *)getImagePath:(UIImage *)image withImageSize:(NSInteger)size;

// 压缩图片
+ (NSData *)compressImage:(UIImage *)image toLength:(CGFloat)length;

// 生成缩略图
+ (NSData *)getThumbnail:(UIImage *)image;

// 等比例缩放图片
+ (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth;

// 将文件写入到本地
+ (void)writeToMemoryWithData:(NSData *)data name:(NSString *)name;

/**
 计算文件大小
 
 @param filePathUrl 文件URL路径
 @return 文件大小
 */
+ (unsigned long long)fileSizeAtPath:(NSURL *)filePathUrl;

/**
 根据文件名返回图片
 
 @param fileName 文件名
 @return 图片
 */
+ (UIImage *)getImgFromFileName:(NSString *)fileName;
@end

NS_ASSUME_NONNULL_END
