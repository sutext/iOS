//
//  CCParserView.m
//  paraserLableDemo
//
//  Created by Elegknight on 13-10-30.
//  Copyright (c) 2013年 Elegknight. All rights reserved.
//

#import "CCParserView.h"
#import <CoreText/CoreText.h>
#import "CCParserEmojiRun.h"
#import "CCParserPoiRun.h"
#import "NSString+Parser.h"
#import "CCParserRun.h"
#define LINEHEIGHT (self.font.ascender + (- self.font.descender) + self.lineSpacing)
#define LONGPRESFLAG 1.0
@interface CCParserView()
@property(nonatomic,strong)   NSMutableDictionary *runRectDictionary;
@property(nonatomic,strong)   UIColor             *bgColorBeforeTouching;
@property(nonatomic,strong)   NSMutableArray      *lineRanges;
@property(nonatomic,strong)   NSAttributedString  *attributedText;
@property(nonatomic,copy)     NSString  *parsedText;
@property(nonatomic,strong)   NSMutableArray  *allRuns;
@end
@implementation CCParserView
{
    __weak CCParserPoiRun   *_highlightRun;
    NSMutableArray          *_pois;
    NSMutableArray          *_poiRanges;
    NSMutableArray          *_poiColors;
    NSMutableArray          *_poiTypes;
    NSInteger               _firstLineWidth;
    NSInteger               _maxShowLineCount;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _text = @"";
        _font = [UIFont systemFontOfSize:14.0];
        _textColor =[UIColor blackColor];
        _lineSpacing = 1.5;
        _maxShowLineCount=UINT16_MAX;
        _autoMatchURL=NO;
        self.runRectDictionary = [[NSMutableDictionary alloc] init];
        self.lineRanges=[[NSMutableArray alloc] init];
        self.allRuns=[[NSMutableArray alloc] init];
        self.backgroundColor=[UIColor clearColor];
        self.bgColorWhenTouch=[UIColor clearColor];
        self.userInteractionEnabled=YES;
        
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _text=[aDecoder decodeObjectForKey:@"text"];
        _parsedText=[aDecoder decodeObjectForKey:@"parsedText"];
        _font=[aDecoder decodeObjectForKey:@"font"];
        
        _allRuns=[aDecoder decodeObjectForKey:@"allRuns"];
        _textColor=[aDecoder decodeObjectForKey:@"textColor"];
        _runRectDictionary=[aDecoder decodeObjectForKey:@"runRectDictionary"];
        _lineRanges=[aDecoder decodeObjectForKey:@"lineRanges"];
        
        _bgColorWhenTouch=[aDecoder decodeObjectForKey:@"bgColorWhenTouch"];
        _lineSpacing=[aDecoder decodeFloatForKey:@"lineSpacing"];
        
        _pois=[aDecoder decodeObjectForKey:@"pois"];
        _poiRanges=[aDecoder decodeObjectForKey:@"poiRanges"];
        _poiColors=[aDecoder decodeObjectForKey:@"poiColors"];
        _poiTypes=[aDecoder decodeObjectForKey:@"poiTypes"];
        
        _firstLineWidth=[aDecoder decodeIntegerForKey:@"firstLineWidth"];
        _maxShowLineCount=[aDecoder decodeIntegerForKey:@"maxShowLineCount"];
        _lineCount=[aDecoder decodeIntegerForKey:@"lineCount"];
        _autoMatchURL=[aDecoder decodeBoolForKey:@"autoMatchURL"];
        
        NSMutableAttributedString *mutattr=[[NSMutableAttributedString alloc] initWithString:self.parsedText];
        [mutattr addAttributes:[self defaultAttributes] range:NSMakeRange(0, _parsedText.length)];
        [_allRuns enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CCParserRun *run=obj;
            [run addToAttributeString:mutattr];
        }];
        _attributedText=mutattr;
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aEnoder
{
    [super encodeWithCoder:aEnoder];
    [aEnoder encodeObject:self.text forKey:@"text"];
    [aEnoder encodeObject:self.font forKey:@"font"];
    [aEnoder encodeObject:self.parsedText forKey:@"parsedText"];
    
    [aEnoder encodeObject:self.allRuns forKey:@"allRuns"];
    [aEnoder encodeObject:self.textColor forKey:@"textColor"];
    [aEnoder encodeObject:self.runRectDictionary forKey:@"runRectDictionary"];
    [aEnoder encodeObject:self.lineRanges forKey:@"lineRanges"];
    
    [aEnoder encodeObject:self.bgColorWhenTouch forKey:@"bgColorWhenTouch"];
    [aEnoder encodeFloat:self.lineSpacing forKey:@"lineSpacing"];
    [aEnoder encodeBool:self.autoMatchURL forKey:@"autoMatchURL"];
    [aEnoder encodeInteger:self.lineCount forKey:@"lineCount"];
    
    [aEnoder encodeObject:_pois forKey:@"pois"];
    [aEnoder encodeObject:_poiRanges forKey:@"poiRanges"];
    [aEnoder encodeObject:_poiColors forKey:@"poiColors"];
    [aEnoder encodeObject:_poiTypes forKey:@"poiTypes"];
    
    [aEnoder encodeInteger:_firstLineWidth forKey:@"firstLineWidth"];
    
    [aEnoder encodeInteger: _maxShowLineCount forKey:@"maxShowLineCount"];
   
}
-(NSInteger)maxLineCount
{
    return _maxShowLineCount;
}
-(CGFloat)lineHeight
{
    return LINEHEIGHT;
}
-(CGFloat)firstLineWidth
{
    return _firstLineWidth;
}
-(BOOL)limitToLineCount:(NSInteger)lineCount
{
    BOOL flag=NO;
    _maxShowLineCount=lineCount;
    if (_lineCount<=lineCount) {
        lineCount=_lineCount;
        flag=YES;
    }
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, lineCount*LINEHEIGHT);
    return flag;
}
#pragma mark -
-(void)setPoi:(NSString *)poi forRange:(NSRange)range andColor:(UIColor *)color
{
    [self setPoi:poi forRange:range andColor:color andType:CCParserPoiTypeSuperLinker];
}
- (void)setPoi:(NSString *)poi forRange:(NSRange)range andColor:(UIColor*)color andType:(CCParserPoiType)type;
{
    if (!_pois)
    {
        _pois = [[NSMutableArray alloc] init];
        _poiRanges = [[NSMutableArray alloc] init];
        _poiColors=[[NSMutableArray alloc] init];
        _poiTypes=[[NSMutableArray alloc] init];
    }
    
    NSValue *rng = [NSValue valueWithRange:range];
    NSUInteger idx = [_poiRanges indexOfObject:rng inSortedRange:NSMakeRange(0, [_poiRanges count]) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2){
        NSRange r1 = [obj1 rangeValue];
        NSRange r2 = [obj2 rangeValue];
        if (r1.location < r2.location)
            return NSOrderedAscending;
        
        if (r1.location > r2.location)
            return NSOrderedDescending;
        
        return NSOrderedSame;
    }];
    
    [_pois insertObject:poi atIndex:idx];
    [_poiRanges insertObject:rng atIndex:idx];
    [_poiColors insertObject:color atIndex:idx];
    [_poiTypes insertObject:[NSNumber numberWithInteger:type] atIndex:idx];
}
-(void)setPois:(NSArray *)pois forRanges:(NSArray *)ranges andColors:(NSArray *)coclos
{
    NSMutableArray *types=[NSMutableArray array];
    for (NSInteger i = 0; i<pois.count; i++) {
        [types addObject:[NSNumber numberWithInteger:CCParserPoiTypeSuperLinker]];
    }
    [self setPois:pois forRanges:ranges andColors:coclos andTypes:types];
}
- (void)setPois:(NSArray *)pois forRanges:(NSArray *)ranges andColors:(NSArray *)coclos andTypes:(NSArray *)types
{
    if (!_pois){
        _pois = [pois mutableCopy];
        _poiRanges = [ranges mutableCopy];
        _poiColors=[coclos mutableCopy];
        _poiTypes=[types mutableCopy];
        return;
    }
    [pois enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [self setPoi:obj forRange:[ranges[idx] rangeValue] andColor:coclos[idx] andType:[types[idx] integerValue]];
    }];
}
- (void)removeURLForRange:(NSRange)range
{
    NSValue *v = [NSValue valueWithRange:range];
    NSUInteger idx = [_poiRanges indexOfObject:v];
    if (idx == NSNotFound)
        return;
    
    [_poiRanges removeObjectAtIndex:idx];
    [_pois removeObjectAtIndex:idx];
    [_poiColors removeObjectAtIndex:idx];
    [_poiTypes removeObjectAtIndex:idx];
}

- (void)removeAllURLs
{
    _pois = nil;
    _poiRanges = nil;
    _poiColors=nil;
    _poiTypes=nil;
}
#pragma mark - Draw Rect
-(void)parseText
{
//    if (_text.length==0) {
//        return;
//    }
    
    [_lineRanges removeAllObjects];
    [_allRuns removeAllObjects];
    [self removeAllURLs];
    NSArray *expNames;
    NSArray *expRanges;
    NSString *string=[_text parseStringToNames:&expNames expRanges:&expRanges];
    if (self.isAutoMatchURL) {
        NSArray *pois;
        NSArray *ranges;
        NSArray *colors;
        [string parseStringToLinkers:&pois linkRanges:&ranges linkColors:&colors];
        NSMutableArray *types=[NSMutableArray array];
        for (NSInteger i = 0; i<pois.count; i++) {
            [types addObject:[NSNumber numberWithInteger:CCParserPoiTypeURL]];
        }
        [self setPois:pois forRanges:ranges andColors:colors andTypes:types];
    }
    if (_setPoiBlock!=NULL) {
        _setPoiBlock(self);
    }
    NSMutableAttributedString *muAttrText=[[NSMutableAttributedString alloc] initWithString:string];
    [muAttrText addAttributes:[self defaultAttributes] range:NSMakeRange(0, muAttrText.length)];
    NSInteger count=0;
    for (NSString *orgText in expNames) {
        CCParserEmojiRun *run=[[CCParserEmojiRun alloc] init];
        run.originalText=orgText;
        run.range=[[expRanges objectAtIndex:count] rangeValue];
        run.poiFont=self.font;
        [run addToAttributeString:muAttrText];
        [self.allRuns addObject:run];
        count++;
    }
    if (_poiRanges&&_poiRanges.count>0) {
        count=0;
        for (NSValue *rangValue in _poiRanges) {
            CCParserPoiRun *run=[[CCParserPoiRun alloc] init];
            run.poiFont=self.font;
            
            run.poiText=[_pois objectAtIndex:count];
            run.range=[rangValue rangeValue];
            run.poiColor=[_poiColors objectAtIndex:count];
            run.poiType=[[_poiTypes objectAtIndex:count] integerValue];
            
            run.originalText=[string substringWithRange:run.range];
            [run addToAttributeString:muAttrText];
            [self.allRuns addObject:run];
            count++;
        }
    }
    _lineCount=[self calculateLineCount:muAttrText expRanges:expRanges];
}
-(NSUInteger)calculateLineCount:(NSMutableAttributedString *)attrString expRanges:(NSArray *)expRages
{
    NSUInteger lineCount = 0;
    CFRange lineRange = CFRangeMake(0,0);
    CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    BOOL drawFlag = YES;
    while(drawFlag)
    {
        CFIndex testLineLength = CTTypesetterSuggestClusterBreak(typeSetter,lineRange.location,self.bounds.size.width);
        BOOL goonCheck=YES;
        CTLineRef line=NULL;
        while (goonCheck) {
            goonCheck=NO;
            lineRange = CFRangeMake(lineRange.location,testLineLength);
            line = CTTypesetterCreateLine(typeSetter,lineRange);
            CFArrayRef runs = CTLineGetGlyphRuns(line);
            CTRunRef lastRun = CFArrayGetValueAtIndex(runs, CFArrayGetCount(runs) - 1);
            CGFloat lastRunAscent;
            CGFloat laseRunDescent;
            CGFloat lastRunWidth  = CTRunGetTypographicBounds(lastRun, CFRangeMake(0,0), &lastRunAscent, &laseRunDescent, NULL);
            CGFloat lastRunPointX = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(lastRun).location, NULL);
            if ((lastRunWidth + lastRunPointX) > self.bounds.size.width)
            {
                goonCheck=YES;
                testLineLength--;
                CFRelease(line);
            }
            else
            {
                if (lineCount==0) {
                    _firstLineWidth=lastRunPointX+lastRunWidth+5;
                }
            }
        }
        CFRelease(line);
        if(lineRange.location + lineRange.length >= attrString.length)
        {
            drawFlag = NO;
        }
        lineCount++;
        [self.lineRanges addObject:[NSValue valueWithRange:NSMakeRange(lineRange.location, lineRange.length)]];
        lineRange.location += lineRange.length;
    }
    for (NSValue *rangValue in expRages) {
        [attrString replaceCharactersInRange:[rangValue rangeValue] withString:@" "];
    }
    self.parsedText=[attrString string];
    self.attributedText=attrString;
    CFRelease(typeSetter);
    return lineCount;
}

-(NSDictionary *)defaultAttributes{
    NSString *fontName = self.font.fontName;
    CGFloat fontSize= self.font.pointSize;
    UIColor *color = self.textColor;
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName,
                                             fontSize, NULL);
    NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id)color.CGColor, (__bridge id)kCTForegroundColorAttributeName,
                           (__bridge id)fontRef, (__bridge id)kCTFontAttributeName,
                           nil];
    CFRelease(fontRef);
    return attrs;
}
- (void)drawRect:(CGRect)rect
{
    if (!self.attributedText) {
        return;
    }
    [self.runRectDictionary removeAllObjects];
    //绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //修正坐标系
    CGAffineTransform textTran = CGAffineTransformIdentity;
    textTran = CGAffineTransformMakeTranslation(0.0, self.bounds.size.height);
    textTran = CGAffineTransformScale(textTran, 1.0, -1.0);
    CGContextConcatCTM(context, textTran);
    __block CGFloat drawLineY = self.bounds.origin.y + self.bounds.size.height - self.font.ascender;
    [self.lineRanges enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSRange lineRange=[obj rangeValue];
        NSAttributedString *lineAttrString=[self.attributedText attributedSubstringFromRange:lineRange];
        CTLineRef line=CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)lineAttrString);
        CGFloat drawLineX = CTLineGetPenOffsetForFlush(line,0,self.bounds.size.width-20);
        CGContextSetTextPosition(context,drawLineX,drawLineY);
        if (idx==_maxShowLineCount-1&&_lineCount>_maxShowLineCount)
        {
            NSMutableAttributedString *truncatedString = [[NSMutableAttributedString alloc]initWithString:@"\u2026"];
            [truncatedString setAttributes:[self defaultAttributes] range:NSMakeRange(0, truncatedString.length)];
            CTLineRef token = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncatedString);
            CTLineRef newLine= CTLineCreateTruncatedLine(line, self.frame.size.width-15, kCTLineTruncationEnd, token);
            CTLineDraw(newLine,context);
            CFRelease(token);
            CFRelease(newLine);
        }
        else
        {
            CTLineDraw(line,context);
        }
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        //绘制替换过的特殊文本单元
        NSInteger runCount=CFArrayGetCount(runs);
        for (int i = 0; i < runCount; i++)
        {
            CTRunRef run = CFArrayGetValueAtIndex(runs, i);
            NSDictionary* attributes = (__bridge NSDictionary*)CTRunGetAttributes(run);
            CCParserRun *ccpRun = [attributes objectForKey:kCCParserRunName];
            if (ccpRun)
            {
                CGFloat runAscent,runDescent;
                CGFloat runWidth  = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
                CGFloat runHeight = runAscent + ABS(runDescent);
                CGFloat runPointX = drawLineX + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                CGFloat runPointY = drawLineY - ABS(runDescent);
                CGRect runRect = CGRectMake(runPointX, runPointY, runWidth, runHeight);
                
                if (idx==_maxShowLineCount-1&&i==runCount-1&&_lineCount>_maxShowLineCount&&[ccpRun isKindOfClass:[CCParserEmojiRun class]])
                {
                    [@"..." drawInRect:CGRectMake(runPointX, runPointY-10, runWidth, 3) withFont:self.font];
                }
                else
                {
                    [ccpRun drawRunWithRect:runRect];
                    if ([ccpRun isKindOfClass:[CCParserPoiRun class]]) {
                        CCParserPoiRun *poiRun=(CCParserPoiRun*)ccpRun;
                        if (poiRun.colorWhenTouching&&poiRun.ishighLight)
                        {
                            UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:runRect cornerRadius:2.0];
                            CGContextSaveGState(context);
                            CGContextAddPath(context, bp.CGPath);
                            CGContextSetFillColorWithColor(context, poiRun.colorWhenTouching.CGColor);
                            CGContextFillPath(context);
                            CGContextRestoreGState(context);
                        }
                        runRect = CTRunGetImageBounds(run, context, CFRangeMake(0, 0));
                        runRect.origin.x = runPointX;
                        [self.runRectDictionary setObject:ccpRun forKey:[NSValue valueWithCGRect:runRect]];
                    }
                }
            }
        }
        CFRelease(line);
        drawLineY -= LINEHEIGHT;
        if (idx>=_maxShowLineCount-1) {
            *stop=YES;
        }
    }];
}
#pragma mark - touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
    __block BOOL isFinded=NO;
    [self.runRectDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         CGRect rect = [((NSValue *)key) CGRectValue];
         if(CGRectContainsPoint(rect, runLocation))
         {
             CCParserPoiRun *run = obj;
             run.ishighLight=YES;
             [self setNeedsDisplay];
             _highlightRun=run;
             isFinded=YES;
             *stop=YES;
         }
     }];
    if (!isFinded) {
        self.bgColorBeforeTouching=self.backgroundColor;
        self.backgroundColor=self.bgColorWhenTouch;
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.backgroundColor=self.bgColorBeforeTouching;
        });
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
    __weak CCParserView *weakSelf = self;
    __block BOOL isFinded=NO;
    [self.runRectDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         CGRect rect = [((NSValue *)key) CGRectValue];
         CCParserPoiRun *run = obj;
         if(CGRectContainsPoint(rect, runLocation))
         {
             run.ishighLight=NO;
             [self setNeedsDisplay];
             isFinded=YES;
             *stop=YES;
             if (_poiClickedBlock!=NULL) {
                 _poiClickedBlock(weakSelf,run);
             }
         }
     }];
    if (!isFinded) {
        if (self.bgColorBeforeTouching) {
            self.backgroundColor=self.bgColorBeforeTouching;
        }
        if (_otherClickedBlock!=NULL) {
            _otherClickedBlock(self);
        }
    }
}
-(void)clearHighlight
{
    if (_highlightRun) {
        _highlightRun.ishighLight=NO;
        _highlightRun=nil;
        if (self.bgColorBeforeTouching) {
            self.backgroundColor=self.bgColorBeforeTouching;
        }
        [self setNeedsDisplay];
    }
}
-(void)longPressAction:(UILongPressGestureRecognizer *)sender

{
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (_longpressBlock!=NULL) {
            _longpressBlock(self);
        }
    }
}
#pragma mark - Set
-(void)setAttributedText:(NSAttributedString *)attributedText
{
    if (attributedText!=_attributedText) {
        _attributedText=attributedText;
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)text
{
    if (_text!=text) {
        _text = text;
        if (text&&text.length>0) {
            [self parseText];
        }
        else
        {
            [_lineRanges removeAllObjects];
            [_allRuns removeAllObjects];
            
            [_pois removeAllObjects];
            [_poiRanges removeAllObjects];
            [_poiColors removeAllObjects];
            [_poiTypes removeAllObjects];
            
            [_runRectDictionary removeAllObjects];
            _lineCount=0;
            _maxShowLineCount=0;
            self.parsedText=nil;
            self.attributedText=nil;
        }
        
    }
    
}
- (void)setFont:(UIFont *)font
{
    if (_font!=font) {
        _font = font;
        if (self.attributedText) {
            NSMutableAttributedString *mattrString=[self.attributedText mutableCopy];
            NSString *fontName = self.font.fontName;
            CGFloat fontSize= self.font.pointSize;
            CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName,
                                                     fontSize, NULL);
    
            [mattrString addAttribute:(__bridge id)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, mattrString.length)];
            self.attributedText=mattrString;
        }
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if (_textColor!=textColor) {
        _textColor = textColor;
        if (self.attributedText) {
            NSMutableAttributedString *mattrString=[self.attributedText mutableCopy];
            [mattrString addAttribute:(__bridge id)kCTForegroundColorAttributeName value:(__bridge id)textColor.CGColor range:NSMakeRange(0, mattrString.length)];
            self.attributedText=mattrString;
        }
    }
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    if (_lineSpacing!=lineSpacing) {
        _lineSpacing = lineSpacing;
        [self setNeedsDisplay];
    }
}
#pragma mark - class methods
+(CGSize)sizeWithText:(NSString *)text
                width:(CGFloat)width
                 font:(UIFont *)font
          lineSpacing:(CGFloat)lineSpacing
         maxLineCount:(NSInteger)maxLineCount
{
    CCParserView* ccpView=[[CCParserView alloc] initWithFrame:CGRectMake(0, 0, width, font.lineHeight+5)];
    ccpView.font=font;
    ccpView.lineSpacing=lineSpacing;
    ccpView.text=text;
    [ccpView limitToLineCount:maxLineCount];
    if (ccpView.lineCount==1) {
        return CGSizeMake(ccpView.firstLineWidth, ccpView.lineHeight);
    }
    return ccpView.frame.size;
}
+(CGSize)sizeWithText:(NSString *)text
                width:(CGFloat)width
                 font:(UIFont *)font
         maxLineCount:(NSInteger)maxLineCount
{
    return [CCParserView sizeWithText:text width:width font:font lineSpacing:defaultSpacing maxLineCount:maxLineCount];
}
+(CGSize)sizeWithText:(NSString *)text
                width:(CGFloat)width
                 font:(UIFont *)font
{
    return [CCParserView sizeWithText:text width:width font:font maxLineCount:UINT16_MAX];
}
+(CGSize)sizeWithText:(NSString *)text
                width:(CGFloat)width
         maxLineCount:(NSInteger)maxLineCount
{
    return [CCParserView sizeWithText:text width:width font:defaultFont maxLineCount:maxLineCount];
}
+(CGSize)sizeWithText:(NSString *)text
                width:(CGFloat)width
{
    return [CCParserView sizeWithText:text width:width font:defaultFont];
}
@end
