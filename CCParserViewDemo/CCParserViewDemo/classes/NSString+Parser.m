//
//  NSString+ExpresionParser.m
//  CXAHyperlinkLabelDemo
//
//  Created by Elegknight on 13-9-26.
//  Copyright (c) 2013年 lazyapps. All rights reserved.
//

#import "NSString+Parser.h"
#import <CoreText/CoreText.h>
#define EmotionItemPattern          @"(\\[勾引\\])|(\\[恶魔\\])|(\\[吐\\])|(\\[睡\\])|(\\[右哼哼\\])|(\\[蛋糕\\])|(\\[冷饮\\])|(\\[闪电\\])|(\\[篮球\\])|(\\[吓\\])|(\\[调皮\\])|(\\[爱心\\])|(\\[炸弹\\])|(\\[剪刀头\\])|(\\[发呆\\])|(\\[糗大了\\])|(\\[疯了\\])|(\\[发怒\\])|(\\[礼物\\])|(\\[害羞\\])|(\\[骷髅\\])|(\\[两颗心\\])|(\\[太阳\\])|(\\[西瓜\\])|(\\[小鬼\\])|(\\[小黄鸭\\])|(\\[得意\\])|(\\[虚\\])|(\\[小蛋糕\\])|(\\[咒骂\\])|(\\[微笑\\])|(\\[可怜\\])|(\\[爱你\\])|(\\[乒乓\\])|(\\[猪头\\])|(\\[抠鼻\\])|(\\[流泪\\])|(\\[撇嘴\\])|(\\[大足球\\])|(\\[哈气\\])|(\\[难过\\])|(\\[再见\\])|(\\[月亮\\])|(\\[阴险\\])|(\\[拳头\\])|(\\[菜刀\\])|(\\[奋斗\\])|(\\[便便\\])|(\\[闭嘴\\])|(\\[左哼哼\\])|(\\[凋谢\\])|(\\[惊讶\\])|(\\[流汗\\])|(\\[傲慢\\])|(\\[快哭了\\])|(\\[啤酒\\])|(\\[悠闲\\])|(\\[尴尬\\])|(\\[憨笑\\])|(\\[晕\\])|(\\[色\\])|(\\[OK\\])|(\\[瓢虫\\])|(\\[握手\\])|(\\[鄙视\\])|(\\[高跟鞋\\])|(\\[大哭\\])|(\\[足球\\])|(\\[困\\])|(\\[敲打\\])|(\\[胜利\\])|(\\[衰\\])|(\\[惊恐\\])|(\\[亲亲\\])|(\\[饥饿\\])|(\\[偷笑\\])|(\\[差劲\\])|(\\[坏笑\\])|(\\[心碎\\])|(\\[拍手\\])|(\\[玫瑰\\])|(\\[抱拳\\])|(\\[刀\\])|(\\[弱\\])|(\\[委屈\\])|(\\[嘴唇\\])|(\\[呲牙\\])|(\\[擦汗\\])|(\\[拥抱\\])|(\\[愉快\\])|(\\[抓狂\\])|(\\[疑问\\])|(\\[冷汗\\])|(\\[NO\\])|(\\[咖啡\\])|(\\[白眼\\])|(\\[强\\])|(\\[酷\\])|(\\[饭\\])|(\\[星星\\])|(\\[赞美\\])"
#define PlaceHolder                 @"鑱"
#define kLinkDefautColor            [UIColor  blueColor]
@implementation NSString (Parser)

- (BOOL)containsString:(NSString *)aString
{
	NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
	return range.location != NSNotFound;
}

- (NSString *)telephoneWithReformat
{
    NSMutableString *stringTemp = [NSMutableString stringWithString:self];
    [stringTemp replaceOccurrencesOfString:@"-" withString:@"" options:0 range:NSMakeRange(0, stringTemp.length)];
    [stringTemp replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, stringTemp.length)];
    [stringTemp replaceOccurrencesOfString:@"(" withString:@"" options:0 range:NSMakeRange(0, stringTemp.length)];
    [stringTemp replaceOccurrencesOfString:@")" withString:@"" options:0 range:NSMakeRange(0, stringTemp.length)];
    [stringTemp replaceOccurrencesOfString:@"+86" withString:@"" options:0 range:NSMakeRange(0, stringTemp.length)];
    return stringTemp;
}

-(NSString *)parseStringToNames:(NSArray *__autoreleasing *)expNames expRanges:(NSArray *__autoreleasing *)expRanges
{
    return [self parseStringToNames:expNames expRanges:expRanges placeHoder:PlaceHolder];
}
-(NSString *)parseStringToNames:(NSArray **)expNames expRanges:(NSArray **)expRanges placeHoder:(NSString *)placeHoder
{
    NSArray *itemIndexes = [self itemIndexesWithPattern: EmotionItemPattern expNames:expNames];
    NSString *newString = [self replaceCharactersAtIndexes:itemIndexes withString:placeHoder];
    *expRanges =[self offsetRangesInArray:itemIndexes newLenth:[PlaceHolder length]];
    return newString;
}
- (NSMutableArray *)itemsForPattern:(NSString *)pattern
{
    if ( !pattern )
        return nil;
    
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                     options:NSRegularExpressionCaseInsensitive error:&error];
    if (error)
    {
        NSLog(@"Error for create regular expression:\nString: %@\nPattern %@\nError: %@\n",self, pattern, error);
    }
    else
    {
        NSMutableArray *results = [[NSMutableArray alloc] init];
        NSRange searchRange = NSMakeRange(0, [self length]);
        [regx enumerateMatchesInString:self options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange groupRange =  [result range];
            NSString *match = [self substringWithRange:groupRange];
            [results addObject:match];
        }];
        return results;
    }
    return nil;
}

- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString
{
    NSAssert(indexes != nil, @"%s: indexes 不可以为nil", __PRETTY_FUNCTION__);
    NSAssert(aString != nil, @"%s: aString 不可以为nil", __PRETTY_FUNCTION__);
    
    NSUInteger offset = 0;
    NSMutableString *raw = [self mutableCopy];
    
    NSInteger prevLength = 0;
    for(NSInteger i = 0; i < [indexes count]; i++)
    {
        @autoreleasepool {
            NSRange range = [[indexes objectAtIndex:i] rangeValue];
            prevLength = range.length;
            
            range.location -= offset;
            [raw replaceCharactersInRange:range withString:aString];
            offset = offset + prevLength - [aString length];
        }
    }
    
    return raw;
}
-(NSArray *)itemIndexesWithPattern:(NSString *)pattern expNames:(NSArray *__autoreleasing *)expNames
{
    NSAssert(pattern != nil, @"%s: pattern 不可以为 nil", __PRETTY_FUNCTION__);
    
    NSError *error = nil;
    NSRange rangeL = [self rangeOfString:@"["];
    NSRange rangeR = [self rangeOfString:@"]"];
    if (rangeL.location==NSNotFound||rangeR.location==NSNotFound) {
        *expNames=[NSArray array];
        return [NSArray array];
    }
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:
                                   pattern options:NSRegularExpressionCaseInsensitive
                                                                         error:&error];
    // 查找匹配的字符串
    NSArray *result = [regExp matchesInString:self options: NSMatchingReportCompletion range:NSMakeRange(0, [self length])];
    if (error) {
        //NSLog(@"ERROR: %@", result);
        return nil;
    }
    NSUInteger count = [result count];
    // 没有查找到结果，返回空数组
    if (0 == count) {
        return [NSArray array];
    }
    // 将返回数组中的 NSTextCheckingResult 的实例的 range 取出生成新的 range 数组
    NSMutableArray *ranges = [[NSMutableArray alloc] initWithCapacity:count];
    NSMutableArray *names=[[NSMutableArray alloc] initWithCapacity:count];
    for(NSInteger i = 0; i < count; i++)
    {
        @autoreleasepool {
            NSRange aRange = [[result objectAtIndex:i] range];
            [ranges addObject:[NSValue valueWithRange:aRange]];
            [names addObject:[self substringWithRange:aRange]];
        }
    }
    *expNames=names;
    return ranges;
}

-(void)parseStringToLinkers:(NSArray *__autoreleasing *)links linkRanges:(NSArray *__autoreleasing *)linkRanges linkColors:(NSArray *__autoreleasing *)linkColors
{
    NSRegularExpression *detector2=[[NSRegularExpression alloc] initWithPattern:@"((http|https)\\://([a-zA-Z0-9_]{1,}+\\.)+([a-zA-Z]{2,4}\\:[0-9]{2,5}|[a-zA-Z]{2,4})+(/[a-zA-Z0-9_?\\.%&#=\\-]*){0,})|((www\\.)+([a-zA-Z0-9]{2,}+\\.)+([a-zA-Z]{2,4}\\:[0-9]{2,5}|[a-zA-Z]{2,4})+(/[a-zA-Z0-9_?\\.%&#=\\-]*){0,})|((((http|https)\\://)?)+((?:(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d))+((\\:[0-9]{2,5})?)+(/[a-zA-Z0-9_?\\.%&#=\\-]*){0,})" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:NULL];
    NSMutableArray *mlinks=[[NSMutableArray alloc] init];
    NSMutableArray *mranges=[[NSMutableArray alloc] init]; 
    NSMutableArray *mcolocs=[[NSMutableArray alloc] init];
    [detector2 enumerateMatchesInString:self options:0 range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [mlinks addObject:[self substringWithRange:result.range]];
        [mranges addObject:[NSValue valueWithRange:result.range]];
        [mcolocs addObject:kLinkDefautColor];
    }];
    if (links!=NULL) {
        *links=mlinks;
    }
    if (linkRanges!=NULL) {
        *linkRanges=mranges;
    }
    if (linkColors!=NULL) {
        *linkColors=mcolocs;
    }
}

#pragma mark - private method
- (NSArray *)offsetRangesInArray:(NSArray *) rangesAry newLenth:(NSUInteger)newlen
{
    NSUInteger aOffset = 0;
    NSUInteger prevLength = 0;
    NSMutableArray *ranges = [[NSMutableArray alloc] initWithCapacity:[rangesAry count]];
    for(NSInteger i = 0; i < [rangesAry count]; i++)
    {
        @autoreleasepool {
            NSRange range = [[rangesAry objectAtIndex:i] rangeValue];
            prevLength    = range.length;
            
            range.location -= aOffset;
            range.length    = newlen;
            [ranges addObject:[NSValue valueWithRange:range]];
            aOffset = aOffset + prevLength - newlen;
        }
    }
    return ranges;
}
@end
