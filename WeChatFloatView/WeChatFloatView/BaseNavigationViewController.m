//
//  BaseNavigationViewController.m
//  WeChatFloatView
//
//  Created by fashion on 2018/8/3.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "TestViewController.h"
#import "ArticleFloatRoundEntryAnimator.h"
#import "ArticleFloatWindow.h"


@interface BaseNavigationViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.interactivePopGestureRecognizer.delaysTouchesBegan = true;
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = true;
    
    UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationTransition:)];
    gesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:gesture];
    
}
- (void)handleNavigationTransition:(UIScreenEdgePanGestureRecognizer *)gesture{

    ArticleFloatWindow.shareInstance.naviController = self;
    [ArticleFloatWindow.shareInstance handleNavigationTransition:gesture];
}

//MARK: - UIGestureRecognizerDelegate
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = true;
    }
    [super pushViewController:viewController animated:animated];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count <= 0) {
        return false;
    }
    return true;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}
//MARK: - UIGestureRecognizerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    BOOL isCustomTransition = false;
    
    if (operation == UINavigationControllerOperationPush){
        if ([toVC isKindOfClass:[TestViewController class]]){
            TestViewController *testVC = (TestViewController *)toVC;
            isCustomTransition = testVC.isNeedCustomTransition;
        }
    }else if (operation == UINavigationControllerOperationPop) {
        if ([fromVC isKindOfClass:[TestViewController class]]){
            
            TestViewController *testVC = (TestViewController *)fromVC;
            isCustomTransition = testVC.isNeedCustomTransition;
        }
    }
    if (isCustomTransition) {
        id<UIViewControllerAnimatedTransitioning> animator = [[ArticleFloatRoundEntryAnimator alloc] initWithOperation:operation sourceCenter: ArticleFloatWindow.shareInstance.roundEntryView.center];
        return animator;
    }else{
        return nil;
    }
    
}
    
    
    
@end
