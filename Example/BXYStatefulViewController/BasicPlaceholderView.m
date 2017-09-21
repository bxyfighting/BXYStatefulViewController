//
//  BasicPlaceholderView.m
//  BXYStatefulViewController_Example
//
//  Created by baixiangyu on 2017/9/21.
//  Copyright © 2017年 bxyfighting. All rights reserved.
//

#import "BasicPlaceholderView.h"

@implementation BasicPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [self addSubview:_centerView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _centerView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

@end
