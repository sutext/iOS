//
//  NSString+Parser.h
//  CXAHyperlinkLabelDemo
//
//  Created by Elegknight on 13-9-26.
//  Copyright (c) 2013年 lazyapps. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kExpresionAttributeImageName      @"ExpresionImageName"

@interface NSString (Parser)
//解析字符串找出其中的表情字符并且用默认站位符替换其中的表情字符 返回表情字符名字数组和 替换后的表情range数组
-(NSString *)parseStringToNames:(NSArray **)expNames expRanges:(NSArray **)expRanges;
//解析字符串找出其中的表情字符并且用指定站位符替换其中的表情字符 返回表情字符名字数组和 替换后的表情range数组
-(NSString *)parseStringToNames:(NSArray **)expNames expRanges:(NSArray **)expRanges placeHoder:(NSString *)placeHoder;
/*** 返回符合 pattern 的所有 string 数组 */
- (NSMutableArray *)itemsForPattern:(NSString *)pattern;
//替换指定ranges的字符串为指定字符串
- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString;
//返回匹配正则的ranges
- (NSArray *)itemIndexesWithPattern:(NSString *)pattern expNames:(NSArray **)expNames;
//找出字符串中的链接 以及其对应的range
-(void)parseStringToLinkers:(NSArray **)links linkRanges:(NSArray **)linkRanges linkColors:(NSArray **)linkColors;

//是否包含某字符
- (BOOL)containsString:(NSString *)aString;

//格式化电话数据
- (NSString *)telephoneWithReformat;



@end
