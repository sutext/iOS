//
//  CCParserRun.h
//  paraserLableDemo
//
//  Created by Elegknight on 13-10-30.
//  Copyright (c) 2013年 Elegknight. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCCParserRunName @"com.busap.CCParserLable.RunName"

@interface CCParserRun : NSObject<NSCoding>

//-- 原始文本
@property (nonatomic,copy) NSString *originalText;
//-- 原始字体
@property (nonatomic,strong) UIFont *poiFont;

//-- 文本所在位置
@property (nonatomic,assign) NSRange range;
//-- 绘制内容

-(void)drawRunWithRect:(CGRect)rect;
//
-(void)addToAttributeString:(NSMutableAttributedString *)attributeString;
@end
