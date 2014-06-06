//
//  CCParserRun.m
//  paraserLableDemo
//
//  Created by Elegknight on 13-10-30.
//  Copyright (c) 2013年 Elegknight. All rights reserved.
//

#import "CCParserRun.h"

@implementation CCParserRun

-(void)addToAttributeString:(NSMutableAttributedString *)attributeString
{
     [attributeString addAttribute:kCCParserRunName value:self range:self.range];
}
-(void)drawRunWithRect:(CGRect)rect
{

}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if (self) {
        self.originalText=[aDecoder decodeObjectForKey:@"originalText"];
        self.poiFont=[aDecoder decodeObjectForKey:@"poiFont"];
        self.range=[[aDecoder decodeObjectForKey:@"range"] rangeValue];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.poiFont forKey:@"poiFont"];
    [aCoder encodeObject:self.originalText forKey:@"originalText"];
    [aCoder encodeObject:[NSValue valueWithRange:self.range] forKey:@"range"];
}
@end
