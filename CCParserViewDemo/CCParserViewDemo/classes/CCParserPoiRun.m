//
//  CCParserPoiRun.m
//  paraserLableDemo
//
//  Created by Elegknight on 13-10-30.
//  Copyright (c) 2013年 Elegknight. All rights reserved.
//

#import "CCParserPoiRun.h"
#import <CoreText/CoreText.h>
@implementation CCParserPoiRun
- (id)init
{
    self = [super init];
    if (self) {
        self.colorWhenTouching = [UIColor colorWithRed:128.00/255 green:0.0 blue:128.00/255 alpha:0.3];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        self.poiText=[aDecoder decodeObjectForKey:@"poiText"];
        self.poiColor=[aDecoder decodeObjectForKey:@"poiColor"];
        self.poiType=[aDecoder decodeIntegerForKey:@"poiType"];
        
        self.colorWhenTouching=[aDecoder decodeObjectForKey:@"colorWhenTouching"];
        self.ishighLight=[aDecoder decodeBoolForKey:@"ishighLight"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.poiText forKey:@"poiText"];
    [aCoder encodeObject:self.poiColor forKey:@"poiColor"];
    [aCoder encodeInteger:self.poiType forKey:@"poiType"];
    
    [aCoder encodeObject:self.colorWhenTouching forKey:@"colorWhenTouching"];
    [aCoder encodeBool:self.ishighLight forKey:@"ishighLight"];
}

-(void)addToAttributeString:(NSMutableAttributedString *)attributeString
{
    [super addToAttributeString:attributeString];
    [attributeString addAttributes:[self defaultAttributes] range:self.range];
}
-(NSDictionary *)defaultAttributes{
    NSString *fontName = self.poiFont.fontName;
    CGFloat fontSize= self.poiFont.pointSize;
    UIColor *color = self.poiColor;
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName,
                                             fontSize, NULL);
    NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id)color.CGColor, (__bridge id)kCTForegroundColorAttributeName,
                           (__bridge id)fontRef, (__bridge id)kCTFontAttributeName,
                           nil];
    CFRelease(fontRef);
    return attrs;
}
@end
