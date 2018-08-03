//
//  ArticleFloatCollectView.m
//  WeChatFloatView
//
//  Created by fashion on 2018/8/3.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

#import "ArticleFloatCollectView.h"

@interface ArticleFloatCollectView ()

@property (strong, nonatomic) CAShapeLayer *bgLayer;
    
@end

@implementation ArticleFloatCollectView
    
- (CAShapeLayer *)bgLayer{
    if (_bgLayer == nil) {
        _bgLayer = [[CAShapeLayer alloc] init];
    }
    return _bgLayer;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.bgLayer.fillColor = [UIColor redColor].CGColor;
        [self updateBGLayerPath:true];
        self.bgLayer.frame = self.bounds;
        [self.layer addSublayer:self.bgLayer];
    }
    return self;
}

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

@end
