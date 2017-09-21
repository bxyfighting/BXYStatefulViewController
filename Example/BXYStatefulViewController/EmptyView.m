//
//  EmptyView.m
//  BXYStatefulViewController_Example
//
//  Created by baixiangyu on 2017/9/21.
//  Copyright © 2017年 bxyfighting. All rights reserved.
//

#import "EmptyView.h"

@interface EmptyView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation EmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.centerView.backgroundColor = [UIColor orangeColor];
    
    _label = [[UILabel alloc] init];
    _label.text = @"empty...";
    [self.centerView addSubview:_label];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_label sizeToFit];
    _label.center = CGPointMake(CGRectGetMidX(self.centerView.bounds), CGRectGetMidY(self.centerView.bounds));
}

@end
