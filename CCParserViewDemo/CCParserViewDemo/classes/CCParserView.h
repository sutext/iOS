//
//  CCParserView.h
//  paraserLableDemo
//
//  Created by Elegknight on 13-10-30.
//  Copyright (c) 2013年 Elegknight. All rights reserved.
//

#import <UIKit/UIKit.h>

#define defaultSpacing 1.5

#define defaultFont [UIFont systemFontOfSize:14.0]

#define defaultColor [UIColor blackColor]

@class CCParserPoiRun;
@class CCParserView;

typedef void (^CCParserPOIBlock)    (CCParserView *ccpview, CCParserPoiRun *run);
typedef void (^CCParserBlock)    (CCParserView *ccpview);

@interface CCParserView : UIView
//total line count
@property(nonatomic) NSInteger lineCount;
//the content of the custom view
@property(nonatomic,copy)   NSString           *text;    
//the font of this view
@property(nonatomic,strong) UIFont             *font;           
//the text color
@property(nonatomic,strong) UIColor            *textColor;
//the backgroundColor when touch
@property(nonatomic,strong) UIColor            *bgColorWhenTouch;
//the lineSpacing
@property(nonatomic)        CGFloat            lineSpacing;
//auto matchURL or no
@property(nonatomic,getter = isAutoMatchURL)BOOL   autoMatchURL;
//the callback when you cliked the poi
@property (nonatomic, copy)   CCParserPOIBlock poiClickedBlock;
//the callback when you longpress the poi
@property (nonatomic, copy)   CCParserPOIBlock poiLongPressBlock;
//the callback when you cliked other
@property (nonatomic, copy)   CCParserBlock otherClickedBlock;
//the callback when you longpress other
@property (nonatomic, copy)   CCParserBlock longpressBlock;
/*you can appoint poi in some string .you may do it like this:
 *ccpView.setPoiBlock=^(){
 *[ccpView setPoi:@"www.baidu.com" forRange:NSMakeRange(0,3) andColor:[UIColor redColor]] 
 *};
 */
@property (nonatomic, copy)   CCParserBlock setPoiBlock;

-(void)clearHighlight;
//appoint some poi
- (void)setPoi:(NSString *)   poi forRange:(NSRange)range andColor:(UIColor*)color;

- (void)setPois:(NSArray *)   pois forRanges:(NSArray *)ranges andColors:(NSArray *)coclos;

//this method will change the size of this view.if the lineCount less than the real line count return NO otherwise return YES
-(BOOL)limitToLineCount:(NSInteger)lineCount;

-(CGFloat)lineHeight;

-(CGFloat)firstLineWidth;

-(NSInteger)maxLineCount;

+(CGSize)sizeWithText:(NSString *)text//calculate the size 
                width:(CGFloat)width
                 font:(UIFont *)font
          lineSpacing:(CGFloat)lineSpacing
         maxLineCount:(NSInteger)maxLineCount;

+(CGSize)sizeWithText:(NSString *)text
                width:(CGFloat)width
                 font:(UIFont *)font
         maxLineCount:(NSInteger)maxLineCount;

+(CGSize)sizeWithText:(NSString *)text
                width:(CGFloat)width
                 font:(UIFont *)font;

+(CGSize)sizeWithText:(NSString *)text
                width:(CGFloat)width
         maxLineCount:(NSInteger)maxLineCount;

+(CGSize)sizeWithText:(NSString *)text
                width:(CGFloat)width;
@end



