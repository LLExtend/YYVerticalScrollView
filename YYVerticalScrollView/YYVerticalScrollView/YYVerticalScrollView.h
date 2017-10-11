//
//  YYVerticalScrollView.h
//  XLsn0wTextCarousel
//
//  Created by MAC on 2017/10/11.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYVerticalScrollModel;
//@class YYVerticalSubView;

@interface YYVerticalScrollView : UIView

@property (nonatomic ,strong) NSMutableArray *dataSourceArray;
@property (nonatomic ,assign ,readonly) NSTimeInterval autoTimeInterval;

//停止定时器(界面消失前必须要停止定时器否则内存泄漏)
- (void)stopTimer;
@end


@interface YYVerticalSubView : UIView

@property (nonatomic ,strong) YYVerticalScrollModel *topModel;
@property (nonatomic ,strong) YYVerticalScrollModel *bottomModel;

@end


@interface YYVerticalScrollModel : NSObject

@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *urlString;

@end

