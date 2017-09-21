//
//  ErrorView.m
//  BXYStatefulViewController_Example
//
//  Created by baixiangyu on 2017/9/21.
//  Copyright © 2017年 bxyfighting. All rights reserved.
//

#import "ErrorView.h"

@interface ErrorView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.centerView.backgroundColor = [UIColor redColor];
    
    _label = [[UILabel alloc] init];
    _label.text = @"error...";
    [self.centerView addSubview:_label];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_label sizeToFit];
    _label.center = CGPointMake(CGRectGetMidX(self.centerView.bounds), CGRectGetMidY(self.centerView.bounds));
}

@end
