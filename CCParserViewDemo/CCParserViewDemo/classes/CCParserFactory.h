//
//  CCParserFactory.h
//  MyCall
//
//  Created by Elegknight on 14-1-10.
//
//

/*
 *the factory of the CCPaserView
 *if your text contain too many emojs and pois the parser text will  cost much times
 *if your app will show the view repeatly you can use this factory
 *
 *
 *
 *
 *
 *
 */
#import <Foundation/Foundation.h>
#import "CCParserView.h"

#define kExpresionMap           ([CCParserFactory shareFactory].expresionMap)
@class CCParserObject;
@interface CCParserFactory : NSObject

+(CCParserFactory *)shareFactory;
@property(nonatomic,strong,readonly)NSDictionary *expresionMap;

@property(assign, nonatomic) NSUInteger maxCacheSize;//The unit of this var is byte. The default size is 1024*1024*100=100MB

-(CCParserView *)viewWithText:(NSString *)text
                        width:(CGFloat )width
                    isShowAll:(BOOL *)isShowAll
                   attributes:(CCParserObject *)attributes;

-(CCParserView *)viewWithText:(NSString *)text
                        width:(CGFloat )width
                   attributes:(CCParserObject *)attributes;

-(CGSize)sizeWithText:(NSString *)text// use cache
                width:(CGFloat )width
           attributes:(CCParserObject *)attributes;

-(CGSize)sizeWithText:(NSString *)text
                width:(CGFloat )width
            isShowAll:(BOOL *)isShowAll
           attributes:(CCParserObject *)attributes;

@end

@interface CCParserObject : NSObject
@property(nonatomic,strong)UIFont   *font;
@property(nonatomic,strong)NSNumber *lineSpacing;
@property(nonatomic,strong)NSNumber *autoMatchURL;
@property(nonatomic,strong)UIColor  *textColor;
@property(nonatomic,strong)UIColor  *touchColor;
@property(nonatomic,strong)NSNumber *maxLineCount;
@property(nonatomic,strong)NSArray  *pois;
@property(nonatomic,strong)NSArray  *poiRanges;
@property(nonatomic,strong)NSArray  *poiColors;
@property(nonatomic,strong)NSString *otherFlag;//用户传入此标示
@end