//
//  UILabel+HDSExtension.m
//  HuaDian
//
//  Created by cb_2018 on 2019/3/22.
//  Copyright © 2019 91cb. All rights reserved.
//

#import "UILabel+HDSExtension.h"

@implementation UILabel (HDSExtension)
/**
 
 *  给UILabel设置行间距和字间距
 
 *  @param space 间距
 
 *  @param text  内容
 
 *  @param font  字体
 
 *  @param zpace  字间距 --> @10 这样设置  默认的话设置 0 就ok
 
 */

-(void)hds_setLineSpace:(CGFloat)space withLabelText:(NSString*)text withFont:(UIFont*)font withZspace:(NSNumber *)zspace

{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    
    paraStyle.alignment =NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = space; //设置行间距[space doubleValue]
    
    paraStyle.hyphenationFactor = 1.0;
    
    paraStyle.firstLineHeadIndent =0.0;
    
    paraStyle.paragraphSpacingBefore =0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    //设置字间距 NSKernAttributeName:@1.5f
    
    NSDictionary *dic;
    
    if (zspace == 0) {
        
        dic =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.5f
               
               };
        
    }else {
        
        dic =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:zspace
               
               };
        
    }
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
    
    self.attributedText = attributeStr;
    
}

/**
 
 *  计算UILabel的高度(带有行间距的情况)
 
 *  @param text  内容
 
 *  @param font  字体
 
 *  @param width 宽度
 
 *  @return 高度
 
 *  @param zpace  字间距 --> @10 这样设置  默认的话设置 0 就ok
 
 */

-(CGFloat)hds_getSpaceLabelHeight:(NSString*)text withFont:(UIFont*)font withWidth:(CGFloat)width withSpace:(CGFloat)space withZspace:(NSNumber *)zpace{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    
    paraStyle.alignment =NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = space;
    
    paraStyle.hyphenationFactor = 1.0;
    
    paraStyle.firstLineHeadIndent =0.0;
    
    paraStyle.paragraphSpacingBefore =0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    
    
    //设置字间距 NSKernAttributeName:@1.5f
    
    NSDictionary *dic;
    
    if (zpace == 0) {
        
        dic =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.5f
               
               };
        
    }else {
        
        dic =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:zpace
               
               };
        
    }
    CGSize size = [text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    return size.height;
    
}
@end
