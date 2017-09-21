//
//  LoadingView.m
//  BXYStatefulViewController_Example
//
//  Created by baixiangyu on 2017/9/21.
//  Copyright © 2017年 bxyfighting. All rights reserved.
//

#import "LoadingView.h"
#import <BXYStatefulViewController/BXYStatefulViewController.h>

@interface LoadingView () <BXYStatefulPlaceHolderView>

@property (nonatomic, strong) UILabel *label;

@end

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.centerView.backgroundColor = [UIColor grayColor];
    
    _label = [[UILabel alloc] init];
    _label.text = @"Loading...";
    [self.centerView addSubview:_label];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_label sizeToFit];
    _label.center = CGPointMake(CGRectGetMidX(self.centerView.bounds), CGRectGetMidY(self.centerView.bounds));
}

#pragma mark - BXYStatefulPlaceHolderView

- (UIEdgeInsets)placeholderViewInsets {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
