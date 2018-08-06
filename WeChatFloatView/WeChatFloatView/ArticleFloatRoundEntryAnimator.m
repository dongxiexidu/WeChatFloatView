//
//  ArticleFloatRoundEntryAnimator.m
//  WeChatFloatView
//
//  Created by fashion on 2018/8/3.
//  Copyright © 2018年 shangZhu. All rights reserved.
//  博客地址:https://www.jianshu.com/u/6f76b136c31e


#import "ArticleFloatRoundEntryAnimator.h"
#import "ArticleFloatWindow.h"

@interface ArticleFloatRoundEntryAnimator ()<UIViewControllerAnimatedTransitioning,CAAnimationDelegate>

@end

@implementation ArticleFloatRoundEntryAnimator
    
- (instancetype)initWithOperation:(UINavigationControllerOperation)operation sourceCenter:(CGPoint)sourceCenter {
    if (self=[super init]) {
        _sourceCenter = sourceCenter;
        _operation = operation;
    }
    return self;
}
    
// MARK: UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}
    
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    CGFloat size = 100;
    CGRect sourceRect = CGRectMake(self.sourceCenter.x - size/2, self.sourceCenter.y - size/2, size, size);
    UIBezierPath *sourcePath = [UIBezierPath bezierPathWithRoundedRect:sourceRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    UIBezierPath *screenPath = [UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(100, 100)];
    
    CABasicAnimation *animation = [[CABasicAnimation alloc] init];
    animation.keyPath = @"path";
    animation.duration = [self transitionDuration:transitionContext];
    animation.delegate = self;
    animation.removedOnCompletion = true;
    [animation setValue:transitionContext forKey:@"transitionContext"];
    [animation setValue:mask forKey:@"mask"];
    
    if (self.operation == UINavigationControllerOperationPush) {
        ArticleFloatWindow.shareInstance.roundEntryView.alpha = 0;
        ArticleFloatWindow.shareInstance.status = ArticleFloatWindowStatusRoundEntryViewHidden;
        mask.path = screenPath.CGPath;
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.layer.mask = mask;
        [transitionContext.containerView addSubview:toView];
        
        animation.fromValue = (__bridge id _Nullable)(sourcePath.CGPath);
        animation.toValue = (__bridge id _Nullable)(screenPath.CGPath);
    }else{
        ArticleFloatWindow.shareInstance.roundEntryView.alpha = 1;
        ArticleFloatWindow.shareInstance.status = ArticleFloatWindowStatusRoundEntryViewShowed;

        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [transitionContext.containerView insertSubview:toView atIndex:0];
        
        mask.path = screenPath.CGPath;
        fromView.layer.mask = mask;

        animation.fromValue = (__bridge id _Nullable)(screenPath.CGPath);
        animation.toValue = (__bridge id _Nullable)(sourcePath.CGPath);
    }
    [mask addAnimation:animation forKey:@"pathAnimation"];
}
    
// MARK: CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    CAShapeLayer *mask = [anim valueForKey:@"mask"];
    [mask removeFromSuperlayer];
    
     id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
    [transitionContext completeTransition:flag];
}

@end
