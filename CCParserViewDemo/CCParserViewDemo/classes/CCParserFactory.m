//
//  CCParserFactory.m
//  MyCall
//
//  Created by Elegknight on 14-1-10.
//
//

#import "CCParserFactory.h"
#import <CommonCrypto/CommonDigest.h>

NSString *CCParserViewCacheDictionary()
{
    NSString *cachesPath=[[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Caches"]stringByAppendingPathComponent:@"com.CCParserView.persistentViews"];
    BOOL isdir=NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath isDirectory:&isdir]&&isdir) {
        return cachesPath;
    }
    else
    {
        if ([[NSFileManager defaultManager] createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:NULL]) {
            return cachesPath;
        }
    }
    return NSTemporaryDirectory();
}
@interface CCParserFactory()
@property(nonatomic,strong,readwrite)NSDictionary   *expresionMap;
@property(nonatomic,strong)NSString                 *cacheDictionary;
@end
@implementation CCParserFactory

static CCParserFactory * _defalutFactory;

#pragma mark - CCParserFactory + lifeCycle

+(CCParserFactory *)shareFactory
{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _defalutFactory = [[super allocWithZone:nil] init];
    });
    return _defalutFactory;
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
+(id)allocWithZone:(NSZone *)zone
{
    return [self shareFactory];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxCacheSize=1024*1024*100;
#if TARGET_OS_IPHONE
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(backgroundCleanDisk)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
#endif
    }
    return self;
}
-(NSDictionary *)expresionMap
{
    if (!_expresionMap) {
        NSBundle *emojBundle=[NSBundle bundleWithPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"emojs.bundle"]];
        NSString *path= [emojBundle pathForResource:@"ExpresionMap" ofType:@"plist"];
        NSDictionary *ExpresionMap=[NSDictionary dictionaryWithContentsOfFile:path];
        self.expresionMap=ExpresionMap;
    }
    return _expresionMap;
}
-(NSString *)cacheDictionary
{
    if (!_cacheDictionary) {
        self.cacheDictionary=CCParserViewCacheDictionary();
    }
    return _cacheDictionary;
}
#pragma mark - CCParserFactory + factory methods
-(CCParserView *)viewWithText:(NSString *)text
                        width:(CGFloat)width
                   attributes:(CCParserObject *)attributes
{
    return [self viewWithText:text width:width isShowAll:NULL attributes:attributes];
}
-(CCParserView *)viewWithText:(NSString *)text
                        width:(CGFloat )width
                    isShowAll:(BOOL *)isShowAll
                   attributes:(CCParserObject *)attributes
{
    UIFont *font=attributes.font?attributes.font: defaultFont;
    CGFloat lineSpacing=attributes.lineSpacing?[attributes.lineSpacing floatValue]:defaultSpacing;
    NSInteger maxLineCount=attributes.maxLineCount?[attributes.maxLineCount integerValue]:UINT16_MAX;
    NSString *otherFlag=attributes.otherFlag?attributes.otherFlag:@"0";
    NSString *identifier=[NSString stringWithFormat:@"%@_%@_%@_%.0f_%.0f_%.0f_%d_%@",text,font.familyName,font.fontName,font.lineHeight,width,lineSpacing,maxLineCount,otherFlag];
    NSString *key=[self encodingmd5:identifier];
    CCParserView *ccpView=[self viewForKey:key];
    if (!ccpView) {
        ccpView=[[CCParserView alloc] initWithFrame:CGRectMake(0, 0, width, font.lineHeight+5)];
        ccpView.font=font;
        ccpView.lineSpacing=lineSpacing;
        if (attributes) {
            if (attributes.textColor) {
                ccpView.textColor=attributes.textColor;
            }
            if (attributes.touchColor) {
                ccpView.bgColorWhenTouch=attributes.touchColor;
            }
            if (attributes.pois&&attributes.poiRanges&&attributes.poiColors) {
                ccpView.setPoiBlock=^(CCParserView *ccpv){
                    [ccpv setPois:attributes.pois forRanges:attributes.poiRanges andColors:attributes.poiColors];
                };
            }
            if (attributes.autoMatchURL) {
                ccpView.autoMatchURL=attributes.autoMatchURL.boolValue;
            }
        }
        ccpView.text=text;
        [ccpView limitToLineCount:maxLineCount];
        [self saveView:ccpView forKey:key];
    }
    if (isShowAll) {
        *isShowAll=ccpView.maxLineCount>=ccpView.lineCount;
    }
    return ccpView;
}

-(CGSize)sizeWithText:(NSString *)text width:(CGFloat)width isShowAll:(BOOL *)isShowAll attributes:(CCParserObject *)attributes
{
    CCParserView *ccpview=[self viewWithText:text width:width isShowAll:isShowAll attributes:attributes];
    if (ccpview.lineCount==1) {
        return CGSizeMake(ccpview.firstLineWidth, ccpview.lineHeight);
    }
    return ccpview.frame.size;
}
-(CGSize)sizeWithText:(NSString *)text width:(CGFloat)width attributes:(CCParserObject *)attributes
{
    return [self sizeWithText:text width:width isShowAll:NULL attributes:attributes];
}
#pragma mark - CCParserFactory + private methods
-(CCParserView *)viewForKey:(NSString *)key
{
    NSString *filePath=[self.cacheDictionary stringByAppendingPathComponent:key];
    NSData *viewData=[NSData dataWithContentsOfFile:filePath];
    if (viewData) {
        CCParserView *ccpview=[NSKeyedUnarchiver unarchiveObjectWithData:viewData];
        if ([ccpview isKindOfClass:[CCParserView class]]) {
            return ccpview;
        }
    }
    return nil;
}
-(void)saveView:(CCParserView *)ccpView forKey:(NSString *)key
{
    NSData *viewData=[NSKeyedArchiver archivedDataWithRootObject:ccpView];
    NSString *filePath=[CCParserViewCacheDictionary() stringByAppendingPathComponent:key];
    [viewData writeToFile:filePath atomically:YES];
}
-(NSString *)encodingmd5:(NSString *)sorceStr;
{
    const char *str = [sorceStr UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return [filename uppercaseString];
}
- (void)backgroundCleanDisk {
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self cleanDisk];
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
}

- (void)cleanDisk
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *diskCacheURL = [NSURL fileURLWithPath:self.cacheDictionary isDirectory:YES];
        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtURL:diskCacheURL
                                                  includingPropertiesForKeys:resourceKeys
                                                                     options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                errorHandler:NULL];
        
        NSMutableDictionary *cacheFiles = [NSMutableDictionary dictionary];
        NSUInteger currentCacheSize = 0;
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            if ([resourceValues[NSURLIsDirectoryKey] boolValue]) {
                continue;
            }
            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
            [cacheFiles setObject:resourceValues forKey:fileURL];
        }
        if (self.maxCacheSize > 0 && currentCacheSize > self.maxCacheSize) {
            const NSUInteger desiredCacheSize = self.maxCacheSize / 2;
            NSArray *sortedFiles = [cacheFiles keysSortedByValueWithOptions:NSSortConcurrent
                                                            usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                                                            }];
            for (NSURL *fileURL in sortedFiles) {
                if ([fileManager removeItemAtURL:fileURL error:nil]) {
                    NSDictionary *resourceValues = cacheFiles[fileURL];
                    NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                    currentCacheSize -= [totalAllocatedSize unsignedIntegerValue];
                    if (currentCacheSize < desiredCacheSize) {
                        break;
                    }
                }
            }
        }
    });
}
@end

@implementation CCParserObject

@end
