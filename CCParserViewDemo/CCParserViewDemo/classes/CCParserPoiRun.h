//
//  CCParserPoiRun.h
//  paraserLableDemo
//
//  Created by Elegknight on 13-10-30.
//  Copyright (c) 2013年 Elegknight. All rights reserved.
//

#import "CCParserRun.h"

typedef NS_ENUM(NSInteger, CCParserPoiType) {
    CCParserPoiTypeURL,
    CCParserPoiTypePhoneNumber,
    CCParserPoiTypeSuperLinker
};
@interface CCParserPoiRun : CCParserRun
@property (nonatomic,copy) NSString *poiText;
@property (nonatomic,strong) UIColor *poiColor;
@property (nonatomic,strong) UIColor *colorWhenTouching;
@property (nonatomic,assign) BOOL ishighLight;
@property (nonatomic,assign) CCParserPoiType poiType;
@end
