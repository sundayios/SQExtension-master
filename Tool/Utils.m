//
//  Utils.m
//  SQExtension
//
//  Created by cb_2018 on 2019/3/23.
//  Copyright © 2019 cfwf. All rights reserved.
//

#import "Utils.h"
#import <sys/utsname.h>//iponePlatForm
#import <AVFoundation/AVFoundation.h>
#import "Header.h"

@implementation Utils

// 判断文件是否已经在沙盒中已经存在？
+ (BOOL) isFileExist:(NSString *)fileName
{
    NSString *path = CachesPath;
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

+ (void)deleteFile:(NSString *)fileName{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *path = CachesPath;
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    BOOL bRet = [fileMgr fileExistsAtPath:filePath];
    if (bRet) {
        //
        NSError *err;
        [fileMgr removeItemAtPath:filePath error:&err];
    }
}

#pragma mark - UIImage
+ (UIImage *)grayscale:(UIImage *)anImage type:(int)type
{
    CGImageRef imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
    if (data) {
        UInt8 *buffer = (UInt8 *)CFDataGetBytePtr(data);
        
        NSUInteger  x, y;
        for (y = 0; y < height; y++) {
            for (x = 0; x < width; x++) {
                UInt8 *tmp;
                tmp = buffer + y * bytesPerRow + x * 4;
                
                UInt8 red,green,blue;
                red = *(tmp + 0);
                green = *(tmp + 1);
                blue = *(tmp + 2);
                
                UInt8 brightness;
                switch (type) {
                    case 1:
                        brightness = (77 * red + 28 * green + 151 * blue) / 256;
                        *(tmp + 0) = brightness;
                        *(tmp + 1) = brightness;
                        *(tmp + 2) = brightness;
                        break;
                    case 2:
                        *(tmp + 0) = red;
                        *(tmp + 1) = green * 0.7;
                        *(tmp + 2) = blue * 0.4;
                        break;
                    case 3:
                        *(tmp + 0) = 255 - red;
                        *(tmp + 1) = 255 - green;
                        *(tmp + 2) = 255 - blue;
                        break;
                    default:
                        *(tmp + 0) = red;
                        *(tmp + 1) = green;
                        *(tmp + 2) = blue;
                        break;
                }
            }
        }
        
        CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
        
        CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
        
        CGImageRef effectedCgImage = CGImageCreate(
                                                   width, height,
                                                   bitsPerComponent, bitsPerPixel, bytesPerRow,
                                                   colorSpace, bitmapInfo, effectedDataProvider,
                                                   NULL, shouldInterpolate, intent);
        
        UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
        
        CGImageRelease(effectedCgImage);
        
        CFRelease(effectedDataProvider);
        
        CFRelease(effectedData);
        
        CFRelease(data);
        
        return effectedImage;
    }
    
    return nil;
}


#pragma mark - UIImagePicker
/**
 是否包含特殊符号
 
 @param str <#str description#>
 @return <#return value description#>
 */
+(BOOL)containSpecialSymbol:(NSString *)str{
    //字符串获取
    NSString *nsStr = str;
    if (nsStr == nil || [nsStr isKindOfClass:[NSNull class]] || nsStr.length == 0) {
        //过滤空字符串
        return NO;
    }
    
    nsStr = [nsStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //遍历字符串中的每一个字符进行判断是否包含特殊符号
    for (int i = 0; i < nsStr.length; i++) {
        
        //截取单个字符
        NSString *singleStr = [nsStr substringWithRange:NSMakeRange(i, 1)];
        
        //1.emoji表情之间都可以通过这个方法判断，不需要遍历所有emoji表情
        BOOL isEmoji = NO;
        NSString *emoji = @"🙂";
        
        for (int i = 0; i < emoji.length; i++) {
            
            NSString *emojiSingle = [emoji substringWithRange:NSMakeRange(i, 1)];
            
            if([singleStr rangeOfString:emojiSingle].location != NSNotFound){
                //包含emoji表情
                isEmoji = YES;
                break;
            }
        }
        
        //2.判断是否是中文
        BOOL isChinese = NO;
        NSString *match = @"(^[\u4e00-\u9fa5]+$)";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
        isChinese = [predicate evaluateWithObject:singleStr];
        
        //3.判断是否是字母
        BOOL isEnglish = NO;
        if (([singleStr characterAtIndex:0] >= 'a' && [singleStr characterAtIndex:0] <= 'z') || ([singleStr characterAtIndex:0] >= 'A' && [singleStr characterAtIndex:0] <= 'Z')) {
            isEnglish = YES;
        }
        
        //4.判断是否是中文标点（根据安卓提供的标点符号编码判断）
        BOOL isZhongWenBiaoDian = NO;
        NSArray *ZhongWenBiaoDian = @[@"33", @"95", @"64", @"35", @"36", @"42", @"40", @"41",
                                      @"45", @"43", @"61", @"65", @"66", @"67", @"68", @"69", @"70", @"71", @"72",
                                      @"73", @"74", @"75", @"76", @"77", @"78", @"79", @"80", @"81", @"82", @"83",
                                      @"84", @"85", @"86", @"87", @"88", @"89", @"90", @"97", @"98", @"99", @"100",
                                      @"101", @"102", @"103", @"104", @"105", @"106", @"107", @"108", @"109",
                                      @"110", @"111", @"112", @"113", @"114", @"115", @"116", @"117", @"118",
                                      @"119", @"120", @"121", @"122", @"48", @"49", @"50", @"51", @"52", @"53",
                                      @"54", @"55", @"56", @"57"];
        for (int i = 0; i < ZhongWenBiaoDian.count; i++) {
            NSString *numStr = ZhongWenBiaoDian[i];
            NSInteger asc = numStr.integerValue;
            if ([singleStr characterAtIndex:0] == asc) {
                isZhongWenBiaoDian = YES;
                break;
            }
        }
        
        //5.判断是否是英文标点（根据安卓提供的标点符号编码判断）
        BOOL isYingWenBiaoDian = NO;
        NSArray *YingWenBiaoDian = @[@"65097", @"8230", @"183", @"165", @"8211", @"8364",
                                     @"65292", @"12290", @"65311", @"65281", @"65374", @"12289", @"65306",
                                     @"65283", @"65307", @"65285", @"65290", @"8212", @"65286", @"65284",
                                     @"65288", @"65289", @"8216", @"8217", @"8220", @"8221", @"12302", @"12308",
                                     @"65371", @"12304", @"65505", @"9792", @"8214", @"12298", @"12301",
                                     @"12299", @"12311", @"12305", @"65373", @"12309", @"12303", @"12310",
                                     @"12300", @"65509"];
        for (int i = 0; i < YingWenBiaoDian.count; i++) {
            NSString *numStr = YingWenBiaoDian[i];
            NSInteger asc = numStr.integerValue;
            if ([singleStr characterAtIndex:0] == asc) {
                isYingWenBiaoDian = YES;
                break;
            }
        }
        
        //返回结果：优先判断是否为emoji表情
        if (isEmoji) {
            return YES;
        }
        //返回结果：不是emoji表情，且不是普通字符时，条件才成立
        if (isChinese == NO && isEnglish == NO && isZhongWenBiaoDian == NO && isYingWenBiaoDian == NO ) {
            
            //最后过滤可能忽略的普通字符（其中➋➌➍➎➏➐➑➒是系统自带九宫格输入法的占位字符）
            //键盘
            NSString *space = @"\n 〈〉`1234567890-=~!@#$%^&*()_+[]\{}|【】、;':\"；‘：“/<>,.，。、？➋➌➍➎➏➐➑➒➏yu a➏";
            //手机键盘中文符号
            space  = [space stringByAppendingString:@"，。？！：、……“；（《～‘〈——·〉’》）”ˉˇ¨々‖∶＂＇｀｜〃〔「『．〖【［｛｝］】〗』」〕"];
            //手机键盘英文符号
            space  = [space stringByAppendingString:@".,?':...@/;!(*&[\\`~#$':..._^+-={|<\">}])"];
            
            if([space rangeOfString:singleStr].location != NSNotFound){
                
            }else{
                return YES;
            }
        }
    }
    return NO;
}



#pragma mark - phonePlatForm
+ (NSString *)getDevicePlatform{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"Phone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s (A1633/A1688/A1691/A1700)";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus (A1634/A1687/A1690/A1699)";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE (A1662/A1723/A1724)";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7 (A1660/A1779/A1780)";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7 (A1778)";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus (A1661/A1785/A1786)";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus (A1784)";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"platform 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"platform X";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod touch 6G (A1574)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2 (A1566)";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2 (A1567)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9 inch) (A1584)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9 inch) (A1652)";
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7 inch) (A1673)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7 inch) (A1674/A1675)";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3 (A1599)";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3 (A1600)";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3 (A1601)";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4 (A1538)";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4 (A1550)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}





+ (void)shakeAndRing
{
    NSDate *lastRingDate = [UserDefaults objectForKey:@"lastRingTime"];
    
    NSDate *nowDate = [NSDate date];
    
    NSTimeInterval time = MAXFLOAT;
    
    if (lastRingDate) {
        // 取当前时间和转换时间两个日期对象的时间间隔
        time = [nowDate timeIntervalSinceDate:lastRingDate];
    }
    
    // 3秒钟以上的
    if (time > 3) {
        
        // 保存最近的响铃时间
        [UserDefaults setObject:nowDate forKey:@"lastRingTime"];
        
        // 震动
        BOOL _shakeAllowed ;
        
        if (_shakeAllowed) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        
        // 响铃
        BOOL _soundAllowed = ![UserDefaults boolForKey:[NSString stringWithFormat:@"soundDisallowed.%li", 1]];
        
        if (_soundAllowed) {
            SystemSoundID soundID = 0;
            
            CFURLRef url = (__bridge CFURLRef)[[NSBundle mainBundle] URLForResource:@"prompt.wav" withExtension:nil];
            AudioServicesCreateSystemSoundID(url, &soundID);
            
            // 播放音效
            AudioServicesPlaySystemSound(soundID);
        }
    }
}

+ (NSString *)objArrayToJSON:(NSArray *)array
{
    NSString *jsonStr = @"[";
    for (NSInteger i = 0; i < array.count; ++i) {
        
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array[i] options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        jsonStr = [jsonStr stringByAppendingString:jsonString];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    
    return jsonStr;
}

+ (NSString *)objDicToJSON:(NSDictionary *)objDic
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:objDic options:0 error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (id)JSONToObjc:(NSString *)jsonStr
{
    NSError *error = nil;
    NSData *JSONData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    
    if (!error){
        return jsonObject;
    }
    return nil;
}

+ (NSString *)getTimeFromTimestamp:(NSInteger)timestamp withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    
    // 东八区不用加8个小时？
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    return [formatter stringFromDate:date];
}

+ (NSInteger)getTimestampFromTime:(NSString *)time WithDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:dateFormat];
    
    NSDate *date = [formatter dateFromString:time];
    
    return [date timeIntervalSince1970];
}

+ (NSString *)dateString:(NSString *)dateString withFormat:(NSString *)format
{
    @try {
        // 实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        
        NSDate *nowDate = [NSDate date];
        
        // 将要转换的时间转成NSDate对象
        NSDate *needFormatDate = [dateFormatter dateFromString:dateString];
        // 取当前时间和转换时间两个日期对象的时间间隔
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        NSString *dateStr = @"";
        
        // 把间隔的秒数折算成天数和小时数
        if (time <= 60) {  // 1分钟以内的
            dateStr = @"刚刚";
        }else if(time <= 10 * 60){  // 10分钟以内的
            NSInteger mins = time / 60;
            dateStr = [NSString stringWithFormat:@"%li分钟前", mins];
        }else if(time <= 60 * 60 * 24){   // 在两天内的
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString *need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                // 在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@", [dateFormatter stringFromDate:needFormatDate]];
            }else{
                // 昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:needFormatDate]];
            }
        }else{
            [dateFormatter setDateFormat:@"yyyy"];
            NSString *need_yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([need_yearStr isEqualToString:nowYear]) {
                // 在同一年
                [dateFormatter setDateFormat:@"MM月dd日"];
                NSString *mdStr = [dateFormatter stringFromDate:needFormatDate];
                
                [dateFormatter setDateFormat:@"HH:mm"];
                dateStr = [NSString stringWithFormat:@"%@ %@", mdStr, [dateFormatter stringFromDate:needFormatDate]];
            }else{
                // 不在今年
                [dateFormatter setDateFormat:@"yy-MM-dd"];
                NSString *ymdStr = [dateFormatter stringFromDate:needFormatDate];
                
                [dateFormatter setDateFormat:@"HH:mm"];
                dateStr = [NSString stringWithFormat:@"%@ %@", ymdStr, [dateFormatter stringFromDate:needFormatDate]];
            }
        }
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

+ (UIImage *)getNewImgFromFileName:(NSString *)fileName
{
    // 获取后缀
    NSString *postfix = [[fileName pathExtension] lowercaseString];
    
    // ico_apk
    if ([postfix containsString:@"apk"]) {
        return [UIImage imageNamed:@"ico_apk"];
    }
    
    // ico_excel
    if ([postfix containsString:@"xlsx"] || [postfix containsString:@"xlsm"] || [postfix containsString:@"xltx"] || [postfix containsString:@"xltm"] || [postfix containsString:@"xlsb"] || [postfix containsString:@"xlam"] ||[postfix containsString:@"xls"] ) {
        return [UIImage imageNamed:@"ico_excel"];
    }
    
    // ico_music
    if ([postfix containsString:@"mp3"] || [postfix containsString:@"wma"] || [postfix containsString:@"flac"] || [postfix containsString:@"aac"] || [postfix containsString:@"wav"] || [postfix containsString:@"wv"] || [postfix containsString:@"mmf"] ||[postfix containsString:@"amr"] || [postfix containsString:@"m4a"] ||[postfix containsString:@"m4r"] || [postfix containsString:@"ogg"] ||[postfix containsString:@"mp2"]) {
        return [UIImage imageNamed:@"ico_music"];
    }
    
    // ico_pdf
    if ([postfix containsString:@"pdf"]) {
        return [UIImage imageNamed:@"ico_pdf"];
    }
    
    // ico_ppt
    if ([postfix containsString:@"ppt"] || [postfix containsString:@"pptx"]) {
        return [UIImage imageNamed:@"ico_ppt"];
    }
    
    // ico_txt
    if ([postfix containsString:@"txt"]) {
        return [UIImage imageNamed:@"ico_txt"];
    }
    
    // ico_word
    if ([postfix containsString:@"docx"] || [postfix containsString:@"docm"] || [postfix containsString:@"dotx"] || [postfix containsString:@"dotm"] ||[postfix containsString:@"doc"] ) {
        return [UIImage imageNamed:@"ico_word"];
    }
    
    // ico_zip
    if ([postfix containsString:@"rar"] || [postfix containsString:@"zip"]) {
        return [UIImage imageNamed:@"ico_zip"];
    }
    
    // ico_video
    if ([postfix containsString:@"aiff"] || [postfix containsString:@"avi"] || [postfix containsString:@"mov"] || [postfix containsString:@"mpeg"] || [postfix containsString:@"mpg"] || [postfix containsString:@"qt"] || [postfix containsString:@"ram"] || [postfix containsString:@"mp4"] || [postfix containsString:@"viv"]) {
        return [UIImage imageNamed:@"ico_video"];
    }
    
    // file-icon-img
    //    if ([postfix containsString:@"jpg"] || [postfix containsString:@"jpeg"] || [postfix containsString:@"gif"] || [postfix containsString:@"png"] || [postfix containsString:@"bmp"] ) {
    //        return [UIImage imageNamed:@"file-icon-img"];
    //    }
    
    return [UIImage imageNamed:@"ico_un"];
}

/**
 图片旋转
 
 @param aImage <#aImage description#>
 @return <#return value description#>
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (NSString *)getImagePath:(UIImage *)image withImageSize:(NSInteger)size
{
    // 压缩原始图片
    NSData *data = [Utils compressImage:image toLength:size];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *cachesPath = CachesPath;
    
    NSString *imageName = nil;
    BOOL exists = NO;
    
    // 判断文件名是否已存在
    do {
        // 文件名以时间顺序命名
        NSInteger r = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        imageName = [NSString stringWithFormat:@"%li%li.jpg", (NSInteger)time, r];
        
        NSString *fullPath = [cachesPath stringByAppendingPathComponent:imageName];
        
        exists = [manager fileExistsAtPath:fullPath];
    } while (exists);
    
    // 写入本地
    [Utils writeToMemoryWithData:data name:imageName];
    
    // 拼接图片信息
    NSString *originalPath = [cachesPath stringByAppendingPathComponent:imageName];
    
    return originalPath;
}

+ (void)writeToMemoryWithData:(NSData *)data name:(NSString *)name
{
    NSString *cachesPath = CachesPath;
    
    NSString *fullPath = [cachesPath stringByAppendingPathComponent:name];
    [data writeToFile:fullPath atomically:YES];
}

+ (NSData *)compressImage:(UIImage *)image toLength:(CGFloat)length
{
    CGFloat i = 1.0;
    
    // 将image转为data，第二个参数为图片压缩系数
    NSData *data = UIImageJPEGRepresentation(image, i);
    
    DLog(@"原始图片大小%likb", data.length / 1000)
    
    while (data.length / 1000 >= length) {
        // 若最小压缩比例下仍大于目标大小，直接采用最小压缩比例
        if (UIImageJPEGRepresentation(image, 0.1) .length / 1000 >= length) {
            data = UIImageJPEGRepresentation(image, 0.1);
            break;
        }
        
        i -= 0.2;
        
        if (i < 0.2) {
            // 最小压缩比例0.1
            data = UIImageJPEGRepresentation(image, 0.1);
            break;
        }
        
        data = UIImageJPEGRepresentation(image, i);
        DLog(@"压缩比例%f，压缩后图片大小%likb", i, data.length / 1000)
    }
    
    DLog(@"压缩完图片大小%likb", data.length / 1000)
    
    return data;
}

+ (NSData *)getThumbnail:(UIImage *)image
{
    // 生成缩略图（宽度缩至120）
    if (image.size.width > 120) {
        DLog(@"宽度缩小至120")
        image = [self compressImage:image toTargetWidth:120.0];
    }
    
    // 压缩到50kb以内
    return [self compressImage:image toLength:50];
}

+ (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth {
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (unsigned long long)fileSizeAtPath:(NSURL *)filePathUrl
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isExist = [fileManager fileExistsAtPath:[filePathUrl path]];
    
    if (isExist) {
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:[filePathUrl path] error:nil] fileSize];
        DLog(@"%@大小：%fM", [filePathUrl path], fileSize/1024.0/1024.0);
        return fileSize;
    }else{
        DLog(@"file is not exist");
        return 0;
    }
}

+ (UIImage *)getImgFromFileName:(NSString *)fileName
{
    // 获取后缀
    NSString *postfix = [[fileName pathExtension] lowercaseString];
    
    // file-icon-excle
    if ([postfix containsString:@"xlsx"] || [postfix containsString:@"xlsm"] || [postfix containsString:@"xltx"] || [postfix containsString:@"xltm"] || [postfix containsString:@"xlsb"] || [postfix containsString:@"xlam"] ||[postfix containsString:@"xls"] ) {
        return [UIImage imageNamed:@"file-icon-excle"];
    }
    
    // file-icon-word
    if ([postfix containsString:@"docx"] || [postfix containsString:@"docm"] || [postfix containsString:@"dotx"] || [postfix containsString:@"dotm"] ||[postfix containsString:@"doc"] ) {
        return [UIImage imageNamed:@"file-icon-word"];
    }
    
    // file-icon-pdf
    if ([postfix containsString:@"pdf"]) {
        return [UIImage imageNamed:@"file-icon-pdf"];
    }
    
    // file-icon-rar
    if ([postfix containsString:@"rar"] || [postfix containsString:@"zip"]) {
        return [UIImage imageNamed:@"file-icon-rar"];
    }
    
    // file-icon-txt
    if ([postfix containsString:@"txt"]) {
        return [UIImage imageNamed:@"file-icon-txt"];
    }
    
    // file-icon-video
    if ([postfix containsString:@"aiff"] || [postfix containsString:@"avi"] || [postfix containsString:@"mov"] || [postfix containsString:@"mpeg"] || [postfix containsString:@"mpg"] || [postfix containsString:@"qt"] || [postfix containsString:@"ram"] || [postfix containsString:@"mp4"] || [postfix containsString:@"viv"]) {
        return [UIImage imageNamed:@"file-icon-video"];
    }
    
    // file-icon-img
    if ([postfix containsString:@"jpg"]  || [postfix containsString:@"jpeg"] || [postfix containsString:@"gif"] || [postfix containsString:@"png"] || [postfix containsString:@"bmp"] ) {
        return [UIImage imageNamed:@"file-icon-img"];
    }
    
    // file-icon-ppt
    if ([postfix containsString:@"ppt"] || [postfix containsString:@"pptx"]) {
        return [UIImage imageNamed:@"file-icon-ppt"];
    }
    
    return [UIImage imageNamed:@"file-icon-unkonwn"];
}
@end
