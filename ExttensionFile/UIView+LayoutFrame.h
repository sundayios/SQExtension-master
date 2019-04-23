//
//  UIView+Layout.h
//  categoryKitDemo
//
//  Created by zhanghao on 2016/7/23.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LayoutFrame)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;     

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)right;
- (CGFloat)bottom;
- (CGFloat)centerX;
- (CGFloat)centerY;
- (CGPoint)origin;
- (CGSize)size;

- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setRight:(CGFloat)right;
- (void)setBottom:(CGFloat)bottom;
- (void)setCenterX:(CGFloat)centerX;
-(void)setCenterY:(CGFloat)centerY;
- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;

@end
