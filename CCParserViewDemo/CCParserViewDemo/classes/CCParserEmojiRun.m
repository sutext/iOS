//
//  CCParserEmojiRun.m
//  paraserLableDemo
//
//  Created by Elegknight on 13-10-28.
//  Copyright (c) 2013年 Elegknight. All rights reserved.
//

#import "CCParserEmojiRun.h"
#import "CCParserFactory.h"
#import <CoreText/CoreText.h>
@interface CCParserEmojiRun()

@end
@implementation CCParserEmojiRun

- (void)drawRunWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *image = [self getEmotionForKey:self.originalText];
    if (image)
    {
        CGContextDrawImage(context, rect, image.CGImage);
    }
}

// 通过表情名获得表情的图片
- (UIImage *)getEmotionForKey:(NSString *)key
{
    NSString *imageName;
    if ([key isEqualToString:@"[赞美]"])
    {
        imageName=@"praise";
    }
    else
    {
        imageName=[kExpresionMap objectForKey:[key substringWithRange:NSMakeRange(1, key.length-2)]];
    }
    return [UIImage imageNamed:[@"emojs.bundle" stringByAppendingPathComponent:imageName]];
}

-(void)addToAttributeString:(NSMutableAttributedString *)attributeString
{
    [super addToAttributeString:attributeString];
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = RunDelegateDeallocCallback;
    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks,(__bridge void *)self);
    [attributeString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge_transfer id)runDelegate range:self.range];
}

void RunDelegateDeallocCallback( void* refCon )
{
    // Do nothing here
}

CGFloat RunDelegateGetAscentCallback( void *refCon )
{
    CCParserEmojiRun *run =(__bridge CCParserEmojiRun *) refCon;
    return run.poiFont.ascender;
}

CGFloat RunDelegateGetDescentCallback(void *refCon)
{
    CCParserEmojiRun *run =(__bridge CCParserEmojiRun *) refCon;
    return -run.poiFont.descender;
}

CGFloat RunDelegateGetWidthCallback(void *refCon)
{
    // EmotionImageWidth + 2 * ImageLeftPadding
    CCParserEmojiRun *run =(__bridge CCParserEmojiRun *) refCon;
    return run.poiFont.ascender-run.poiFont.descender;
}

@end
