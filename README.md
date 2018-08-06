# WeChatFloatView
高仿微信文章悬浮球
[Swift原文:Github地址](https://github.com/pujiaxin33/JXWeChatFloatView)

![头图.PNG](https://upload-images.jianshu.io/upload_images/1085173-bb3e00a5e84473d1.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/375)


## 核心技术点
### 1.悬浮球的出现
当我们通过屏幕边缘手势pop视图的时候，右下角会有一个圆角提示图，跟着手势进度移动。
**如何获取到`UIScreenEdgePanGestureRecognizer`的进度呢？**
  因为系统自带的`interactivePopGestureRecognizer`是被封装起来的，它的action我们无法挂钩拿到里面的手势进度。所以，需要另辟蹊径了。
- 首先，让`UINavigationController的delegate`等于自己，然后让多个手势可以同时响应。
```Objc
self.interactivePopGestureRecognizer?.delegate = self

//MARK: - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count <= 0) {
        return false;
    }
    return true;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}
````
- 然后自己添加一个`UIScreenEdgePanGestureRecognizer`到UINavigationController上面，用于获取pop手势的进度。
```
UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationTransition:)];
gesture.edges = UIRectEdgeLeft;
[self.view addGestureRecognizer:gesture];
```

### 2.悬浮球全局置顶
既然悬浮球可以在悬浮在任何一个页面，必然是放在一个新的UIWindow上面。
然后这个window的生命周期不依赖某一个页面，所以用单例实现比较好。

### 3.事件响应

- 悬浮UIWindow的事件传递
只要事件位置没有在圆球和右下角上，就不响应
```
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
```
- 右下角四分之一圆，事件响应
可以看到微信，只有当手指移动进右下角圆内，才能进行悬浮。而不是按着视图的frame来响应。
首先，通过`UIBezierPath`画一个四分之一圆，然后用`CGPath`的`contains(point)`方法判断。
```
- (void)updateBGLayerPath:(BOOL)isSmall{
    CGFloat ratio = 1;
    if (!isSmall) {
        ratio = 1.3;
    }
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGSize viewSize = self.bounds.size;
    [path moveToPoint:CGPointMake(viewSize.width, (1 - ratio)*viewSize.height)];
    [path addLineToPoint:CGPointMake(viewSize.width, viewSize.height)];
    [path addLineToPoint:CGPointMake((1 - ratio)*viewSize.width, viewSize.height)];
    [path addArcWithCenter:CGPointMake(viewSize.width, viewSize.height) radius:viewSize.width*ratio startAngle:M_PI endAngle:M_PI*3/2 clockwise:true];
    [path closePath];
    self.bgLayer.path = path.CGPath;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    return [self.bgLayer containsPoint:point];
}
```

### 4.自定义转场动画
可以看到点击悬浮球打开的文章，是通过一个自定义转场动画实现的，从悬浮球的位置开始展开。
判断哪个页面使用自定义专场动画,哪些页面不需要
```
//MARK: - UINavigationControllerDelegate
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
```
专场动画的具体实现,请参考代码



## 实现效果
![demo.gif](https://upload-images.jianshu.io/upload_images/1085173-7c404f4421258147.gif?imageMogr2/auto-orient/strip)


## 声明:本文参考了以下Swift版本,感谢原作者的开源
[Swift原文:Github地址](https://github.com/pujiaxin33/JXWeChatFloatView)











