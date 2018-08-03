//
//  ArticleFloatWindow.m
//  WeChatFloatView
//
//  Created by fashion on 2018/8/3.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

#import "ArticleFloatWindow.h"
#import "ArticleFloatCollectView.h"
#import "TestViewController.h"


#define roundEntryViewWidth 100
#define roundEntryViewMargin 20
#define collectViewWidth 150
#define screenSize [UIScreen mainScreen].bounds.size

@interface ArticleFloatWindow ()

@property (assign, nonatomic) CGRect collectionViewOriginalFrame;
@property (assign, nonatomic) CGRect collectionViewDisplayFrame;
    
@end

@implementation ArticleFloatWindow
    
static ArticleFloatWindow * _instance = nil;
+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance =  [[self alloc] init];
        _instance.frame = [UIScreen mainScreen].bounds;
        [_instance config];
    });
    return _instance;
}
    
    
- (void)config {
    self.windowLevel = UIWindowLevelStatusBar - 1;
    self.hidden = true;
    
    self.backgroundColor = [UIColor clearColor];
    self.collectionViewOriginalFrame = CGRectMake(screenSize.width, screenSize.height, collectViewWidth, collectViewWidth);
    self.collectionViewDisplayFrame = CGRectMake(screenSize.width - collectViewWidth, screenSize.height - collectViewWidth, collectViewWidth, collectViewWidth);
    
    self.collectView = [[ArticleFloatCollectView alloc] initWithFrame:self.collectionViewOriginalFrame];
    [self addSubview:self.collectView];
    
    CGRect entryFrame = CGRectMake(screenSize.width - roundEntryViewMargin - roundEntryViewWidth, (screenSize.height - roundEntryViewWidth)/2, roundEntryViewWidth, roundEntryViewWidth);
    self.roundEntryView = [[ArticleFloatRoundEntryView alloc] initWithFrame:entryFrame];
    self.roundEntryView.layer.cornerRadius = roundEntryViewWidth/2;
    self.roundEntryView.backgroundColor = [UIColor blueColor];
    self.roundEntryView.hidden = true;
    
    __weak typeof(self) weakSelf = self;
    self.roundEntryView.clickedCallback = ^{
        [weakSelf pushViewController];
    };
    [self addSubview:self.roundEntryView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(processRoundEntryView:)];
    [self.roundEntryView addGestureRecognizer:pan];
}
- (void)pushViewController {
    TestViewController *testVC = [[TestViewController alloc] init];
    testVC.isNeedCustomTransition = true;
    [self.naviController pushViewController:testVC animated:true];
}
    
- (void)handleNavigationTransition:(UIScreenEdgePanGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    if (self.status == ArticleFloatWindowStatusWindowHidden) {
        
        if (gesture.state == UIGestureRecognizerStateBegan) {
            self.hidden = false;
        }else if (gesture.state == UIGestureRecognizerStateChanged) {
            CGFloat percent = point.x/screenSize.width;
            // 20%开始出现，50%完全展示
            percent -= 0.2;
            percent *= 10/3;
            percent = MIN(1, MAX(0, percent));

            CGRect frame = self.collectView.frame;
            frame.origin.x = [self interpolateFrom:self.collectionViewDisplayFrame.origin.x to:self.collectionViewOriginalFrame.origin.x percent:1 - percent];
            frame.origin.y = [self interpolateFrom:self.collectionViewDisplayFrame.origin.y to:self.collectionViewOriginalFrame.origin.y percent:1 - percent];
            self.collectView.frame = frame;
            
            BOOL isCollectViewInside = false;
            CGPoint collectViewPoint = [self convertPoint:point toView:self.collectView];
            if ([self.collectView pointInside:collectViewPoint withEvent:nil] == true) {
                isCollectViewInside = true;
            }
            [self.collectView updateBGLayerPath: !isCollectViewInside];
        }else if (gesture.state == UIGestureRecognizerStateEnded) {
            
            if (CGRectContainsPoint(self.collectView.frame, point)) {
                self.roundEntryView.hidden = false;
                self.status = ArticleFloatWindowStatusRoundEntryViewShowed;
                [self hideCollectView:nil];
            }else{
                __weak typeof(self) wself = self;
                [self hideCollectView:^{
                    wself.hidden = true;
                }];
            }
            
        }else if (gesture.state == UIGestureRecognizerStateCancelled) {
            __weak typeof(self) wself = self;
            [self hideCollectView:^{
                wself.hidden = true;
            }];
        }
    
    }else if (self.status == ArticleFloatWindowStatusRoundEntryViewShowed) {
        //不做任何处理
    }else if (self.status == ArticleFloatWindowStatusRoundEntryViewHidden) {
        switch (gesture.state) {
            case UIGestureRecognizerStateBegan:
            
            break;
            case UIGestureRecognizerStateChanged:{
                CGFloat percent = point.x/screenSize.width;
                self.roundEntryView.alpha = percent;
                break;
            }
            case UIGestureRecognizerStateEnded:{
                self.roundEntryView.alpha = 1;
                self.status = ArticleFloatWindowStatusRoundEntryViewShowed;
                break;
            }
            case UIGestureRecognizerStateCancelled:{
                self.roundEntryView.alpha = 0;
                break;
            }
            default:
            break;
        }
    }
}
// 插入
- (CGFloat)interpolateFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent {
    return from + (to - from)*percent;
}
    
// MARK: - Event
- (void)processRoundEntryView:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self displayCollectView];
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.roundEntryView.center = point;
        } completion:nil];
        
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        self.roundEntryView.center = point;
        BOOL isCollectViewInside = false;
        CGPoint collectViewPoint = [self convertPoint:point toView:self.collectView];
        if ([self.collectView pointInside:collectViewPoint withEvent:nil] == true) {
            isCollectViewInside = true;
        }
        [self.collectView updateBGLayerPath:!isCollectViewInside];
        
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        
        CGPoint collectViewPoint = [self convertPoint:point toView:self.collectView];
        if ([self.collectView pointInside:collectViewPoint withEvent:nil] == true) {
            [self hideCollectView:nil];
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.roundEntryView.alpha = 0;
            } completion:^(BOOL finished) {
                self.roundEntryView.hidden = true;
                self.roundEntryView.alpha = 1;
                self.hidden = true;
                self.status = ArticleFloatWindowStatusWindowHidden;
            }];
        }else {
            CGRect frame = self.roundEntryView.frame;
            if (point.x > screenSize.width/2) {
                frame.origin.x = screenSize.width - roundEntryViewMargin - roundEntryViewWidth;
            }else {
                frame.origin.x = roundEntryViewMargin;
            }
            [self hideCollectView:nil];
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.roundEntryView.frame = frame;
            } completion:nil];
            
        }
        
    }
}

- (void)displayCollectView {
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.collectView.frame = self.collectionViewDisplayFrame;
    } completion:nil];
}
- (void)hideCollectView:(void(^)(void))callback {
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.collectView.frame = self.collectionViewOriginalFrame;
    } completion:^(BOOL finished) {
        if (callback != nil) {
            callback();
        };
    }];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint roundEntryViewPoint = [self convertPoint:point toView:self.roundEntryView];
    if ([self.roundEntryView pointInside:roundEntryViewPoint withEvent:event] == true) {
        return true;
    }
    CGPoint collectViewPoint = [self convertPoint:point toView:self.collectView];
    if ([self.collectView pointInside:collectViewPoint withEvent:event] == true) {
        return true;
    }
    return false;
}
    
@end
