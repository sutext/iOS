//
//  testViewController.m
//  CCParserViewDemo
//
//  Created by Elegknight on 14-6-6.
//  Copyright (c) 2014年 Elegknight. All rights reserved.
//

#import "testViewController.h"
#import "CCParserFactory.h"
#import "CCParserPoiRun.h"
@interface testViewController()
@property(nonatomic,copy)NSArray *textArray;
@end
@implementation testViewController
{
    BOOL _useCache;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    _useCache=YES;
    UISegmentedControl *seg=[[UISegmentedControl alloc] initWithItems:@[@"use cache",@"no use cache"]];
    [seg addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    seg.selectedSegmentIndex=0;
    self.navigationItem.titleView=seg;
    self.tableView.separatorColor=[UIColor redColor];
}
-(void)segmentValueChanged:(UISegmentedControl *)seg
{
    BOOL use=!seg.selectedSegmentIndex;
    if (_useCache!=use) {
        _useCache=use;
        [self.tableView reloadData];
    }
}
-(NSArray *)textArray
{
    if (!_textArray) {
        NSMutableArray *ary=[NSMutableArray array];
        for (NSInteger i=0; i<10; i++) {
            [ary addObject:[NSString stringWithFormat:@"%d:这是一个超链接 咿呀咿呀伊二哟[憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈] www.baidu.com咿呀咿呀伊二哟[憨笑][委屈]www.baidu.com 咿呀咿呀伊二哟[憨笑][委屈]咿呀咿呀伊二哟 [憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈][憨笑][委屈]",i]];
        }
        self.textArray=ary;
    }
    return _textArray;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_useCache) {
        CCParserObject *attr=[[CCParserObject alloc] init];
        attr.autoMatchURL=[NSNumber numberWithBool:YES];
        attr.maxLineCount=[NSNumber numberWithInteger:indexPath.row+10];
        attr.poiColors=@[[UIColor blueColor]];
        attr.poiRanges=@[[NSValue valueWithRange:NSMakeRange(2, 7)]];
        attr.pois=@[@"www.baidu.com"];
        return [[CCParserFactory shareFactory] sizeWithText:self.textArray[indexPath.row] width:tableView.frame.size.width attributes:attr].height;
    }
    else
    {
        return [CCParserView sizeWithText:self.textArray[indexPath.row] width:tableView.frame.size.width maxLineCount:indexPath.row+10].height;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=[NSString stringWithFormat:@"testcell_%d",_useCache];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (!_useCache) {
            CCParserView *view=[[CCParserView alloc] initWithFrame:cell.contentView.bounds];
            view.tag=1000;
            view.autoMatchURL=YES;
            view.setPoiBlock=^(CCParserView *v){
                [v setPoi:@"www.baidu.com" forRange:NSMakeRange(2, 7) andColor:[UIColor blueColor]];
            };
            [cell.contentView addSubview:view];
        }
    }
    CCParserView *ccpview=nil;
    if (_useCache) {
        [cell.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        CCParserObject *attr=[[CCParserObject alloc] init];
        attr.autoMatchURL=[NSNumber numberWithBool:YES];
        attr.maxLineCount=[NSNumber numberWithInteger:indexPath.row+10];
        
        ccpview=[[CCParserFactory shareFactory] viewWithText:self.textArray[indexPath.row] width:tableView.frame.size.width attributes:attr];
        [cell.contentView addSubview:ccpview];
    }else{
        ccpview=(CCParserView *)[cell viewWithTag:1000];
        ccpview.text=self.textArray[indexPath.row];
        [ccpview limitToLineCount:indexPath.row+10];
    }
    ccpview.poiClickedBlock=^(CCParserView *ccv,CCParserPoiRun *run){
        
        NSLog(@"%@",run.poiText);
    };
    return cell;
}
@end
