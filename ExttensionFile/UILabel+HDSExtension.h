//
//  UILabel+HDSExtension.h
//  HuaDian
//
//  Created by cb_2018 on 2019/3/22.
//  Copyright © 2019 91cb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (HDSExtension)

/**
 
 *  给UILabel设置行间距和字间距
 
 *  @param space 间距
 
 *  @param text  内容
 
 *  @param font  字体
 
 *  @param zpace  字间距 --> @10 这样设置  默认的话设置 0 就ok
 
 */

-(void)hds_setLineSpace:(CGFloat)space withLabelText:(NSString*)text withFont:(UIFont*)font withZspace:(NSNumber *)zspace;
/**
 
 *  计算UILabel的高度(带有行间距的情况)
 
 *  @param text  内容
 
 *  @param font  字体
 
 *  @param width 宽度
 
 *  @return 高度
 
 *  @param zpace  字间距 --> @10 这样设置  默认的话设置 0 就ok
 
 */

-(CGFloat)hds_getSpaceLabelHeight:(NSString*)text withFont:(UIFont*)font withWidth:(CGFloat)width withSpace:(CGFloat)space withZspace:(NSNumber *)zpace;
@end

NS_ASSUME_NONNULL_END
