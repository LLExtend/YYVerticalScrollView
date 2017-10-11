//
//  ViewController.m
//  YYVerticalScrollView
//
//  Created by MAC on 2017/10/11.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "ViewController.h"
#import "YYVerticalScrollView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    NSMutableArray *dataSourceArray = [NSMutableArray array];
    
    
    NSDictionary *dataDicts = @{
                                @"type" : @[@"最新",
                                            @"头条",
                                            @"推荐",
                                            @"热门",
                                            @"热评",
                                            @"热议"
                                            ],
                                @"title" : @[@"小巧便携/USB充电",
                                             @"人工智能将是微软的下一阶段的重要工作重心",
                                             @"小米5s高配版拆解",
                                             @"海量新画面根本不是一个画风",
                                             @"路由器没这个设置",
                                             @"起点一打开微博就..."
                                             ],
                                @"urlString" : @[@"http://0",
                                                 @"http://1",
                                                 @"http://2",
                                                 @"http://3",
                                                 @"http://4",
                                                 @"http://5"
                                                 ]
                                
                                };
    
    
    for (int i = 0; i < ((NSArray *)dataDicts[@"title"]).count-1; i++) {
        YYVerticalScrollModel *model = [[YYVerticalScrollModel alloc] init];
        model.title = [(NSArray *)dataDicts[@"title"] objectAtIndex:i];
        model.type = [(NSArray *)dataDicts[@"type"] objectAtIndex:i];
        model.urlString = [(NSArray *)dataDicts[@"urlString"] objectAtIndex:i];
        [dataSourceArray addObject:model];
    }
    
    YYVerticalScrollView *view = [[YYVerticalScrollView alloc] initWithFrame:CGRectMake(35 , 200, [UIScreen mainScreen].bounds.size.width-70, 80)];
    [self.view addSubview:view];
    view.dataSourceArray = dataSourceArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
