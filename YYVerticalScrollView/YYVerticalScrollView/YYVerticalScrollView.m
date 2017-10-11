//
//  YYVerticalScrollView.m
//  XLsn0wTextCarousel
//
//  Created by MAC on 2017/10/11.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "YYVerticalScrollView.h"

@interface YYVerticalScrollView ()

@property (nonatomic ,strong) YYVerticalSubView *currentSubview;
@property (nonatomic ,strong) YYVerticalSubView *hiddenSubview;

@property (nonatomic ,strong) UIView *currentView;//当前显示的view
@property (nonatomic ,strong) UIView *hidenView;//底部藏起的view
@property (nonatomic ,strong) NSTimer *timer;

@end

@implementation YYVerticalScrollView {
    int count;  // model计数器
    BOOL currentFlag; //标识当前是哪个view显示(currentView/hidenView)
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    [self createSubview];
    [self initTimer];
}

- (void)initTimer {
    _autoTimeInterval = 3;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_autoTimeInterval
                                              target:self
                                            selector:@selector(carouselTimerEvent)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)createSubview {
    YYVerticalScrollModel *topModel = _dataSourceArray[count];
    YYVerticalScrollModel *bottomModel = nil;
    if (count + 1 < _dataSourceArray.count) {
        bottomModel = _dataSourceArray[count + 1];
    }
    
    
    // 当前显示view
    self.currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.currentView];
    
    self.currentSubview = [[YYVerticalSubView alloc] init];
    self.currentSubview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.currentSubview.topModel = topModel;
    self.currentSubview.bottomModel = bottomModel;
    [self.currentView addSubview:self.currentSubview];
    
    
    // 隐藏view
    self.hidenView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height , self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.hidenView];
    
    self.hiddenSubview = [[YYVerticalSubView alloc] init];
    self.hiddenSubview.frame = self.hidenView.bounds;
    [self.hidenView addSubview:self.hiddenSubview];
    
}

#pragma mark - 停止定时器
- (void)stopTimer {
    if ([self.timer isValid] == YES) {//在invalidate之前最好先用isValid先判断是否还在线程中
        [self.timer invalidate];
        self.timer = nil;
    } else {
        NSLog(@"timer invalidate already");
    }
}

- (void)setDataSourceArray:(NSMutableArray *)dataSourceArray {
    if (_dataSourceArray != dataSourceArray) {
        _dataSourceArray = dataSourceArray;
        
        YYVerticalScrollModel *currentTopModel    = _dataSourceArray[count];
        YYVerticalScrollModel *currentBottomModel = _dataSourceArray[count + 1];

        self.currentSubview.topModel = currentTopModel;
        self.currentSubview.bottomModel = currentBottomModel;
    }
}

#pragma mark - 跑马灯操作
- (void)carouselTimerEvent {
    count += 2;
    if (count >= _dataSourceArray.count) count = 0;
    
    
    // 要增加判断 count + 1 没有值的情况下
    YYVerticalScrollModel *topModel = _dataSourceArray[count];
    YYVerticalScrollModel *bottomModel = nil;
    if(count + 1 < _dataSourceArray.count)
        bottomModel = _dataSourceArray[count + 1];

    YYVerticalSubView *tmpSubview = (currentFlag ? self.currentSubview : self.hiddenSubview);
    tmpSubview.topModel = topModel;
    tmpSubview.bottomModel = bottomModel;

    [UIView animateWithDuration:0.5 animations:^{
        CGFloat currentY = (currentFlag ? 0 : -self.frame.size.height);
        CGFloat hiddenY = (currentFlag ? -self.frame.size.height : 0);

        self.currentView.frame = CGRectMake(0, currentY, self.frame.size.width, self.frame.size.height);
        
        self.hidenView.frame = CGRectMake(0, hiddenY, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        UIView *view = (currentFlag ? self.hidenView : self.currentView);
        view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        
        currentFlag = !currentFlag;
    }];
}

@end

#define kFit6PWidth  ([UIScreen mainScreen].bounds.size.width / 414)
#define kFit6PHeight ([UIScreen mainScreen].bounds.size.height / 736)
#define iPhone4s    ([[UIScreen mainScreen] bounds].size.height == 480)
#define iPhone5     ([[UIScreen mainScreen] bounds].size.height == 568)
#define iPhone6     ([[UIScreen mainScreen] bounds].size.height == 667)
#define iPhone6Plus ([[UIScreen mainScreen] bounds].size.height == 736)

@implementation YYVerticalSubView {
    //  显示type
    UILabel *_topTypeLabel , *_bottomTypeLabel;
    //  显示内容
    UILabel *_topContentLabel , *_bottomContentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _topTypeLabel = [UILabel new];
    _bottomTypeLabel = [UILabel new];
    
    _topContentLabel = [UILabel new];
    _bottomContentLabel = [UILabel new];
    
    [self addSubview:_topTypeLabel];
    [self addSubview:_bottomTypeLabel];
    
    [self addSubview:_topContentLabel];
    [self addSubview:_bottomContentLabel];
    
    
    [self setupLabel:_topTypeLabel color:[UIColor orangeColor]];
    [self setupLabel:_bottomTypeLabel color:[UIColor blueColor]];
    
    
    CGFloat fontSize = 0;
    
    if (iPhone6Plus) fontSize = 16;
    else if (iPhone6) fontSize = 15;
    else if (iPhone5) fontSize = 14;
    else fontSize = 13;
    
    _topContentLabel.font = [UIFont systemFontOfSize:fontSize];
    _bottomContentLabel.font = [UIFont systemFontOfSize:fontSize];
    
    _topContentLabel.userInteractionEnabled = YES;
    _bottomContentLabel.userInteractionEnabled = YES;
    
    [_topContentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topClick:)]];
    [_bottomContentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomClick:)]];
}

- (void)setupLabel:(UILabel *)label color:(UIColor *)color {
    label.layer.borderWidth = 1;
    label.layer.borderColor = [color CGColor];
    label.textColor = color;
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
}

- (void)setTopModel:(YYVerticalScrollModel *)topModel {
    if (_topModel != topModel) {
        _topModel = topModel;
        //  去掉\n
        NSString *title = [NSString stringWithFormat:@"%@", [topModel.title stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];
        _topContentLabel.text = title;
        _topTypeLabel.text = topModel.type;
    }
}

- (void)setBottomModel:(YYVerticalScrollModel *)bottomModel {
    if (_bottomModel != bottomModel) {
        _bottomModel = bottomModel;
        
        _bottomContentLabel.hidden = !_bottomModel;
        _bottomTypeLabel.hidden = !_bottomModel;
            
        NSString *title = [NSString stringWithFormat:@"%@", [bottomModel.title stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];
        _bottomContentLabel.text = title;
        _bottomTypeLabel.text = bottomModel.type;
        
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _topTypeLabel.frame = CGRectMake(10*kFit6PWidth, 10, 35, 25);
    _bottomTypeLabel.frame = CGRectMake(10*kFit6PWidth, 40, 35, 25);
    
    _topContentLabel.frame = CGRectMake(64*kFit6PWidth, 13, self.frame.size.width-64*kFit6PWidth-5, 21);
    _bottomContentLabel.frame = CGRectMake(64*kFit6PWidth, 43, self.frame.size.width-64*kFit6PWidth-5, 21);
}


- (void)topClick:(UITapGestureRecognizer *)tap {
    NSLog(@"top - %@",_topModel.urlString);
}

- (void)bottomClick:(UITapGestureRecognizer *)tap {
    NSLog(@"bottom - %@",_bottomModel.urlString);
}

@end


@implementation YYVerticalScrollModel
@end
