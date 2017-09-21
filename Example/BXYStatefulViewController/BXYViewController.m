//
//  BXYViewController.m
//  BXYStatefulViewController
//
//  Created by bxyfighting on 09/20/2017.
//  Copyright (c) 2017 bxyfighting. All rights reserved.
//

#import "BXYViewController.h"
#import <BXYStatefulViewController/BXYStatefulViewController.h>
#import "LoadingView.h"
#import "EmptyView.h"
#import "ErrorView.h"

@interface BXYViewController () <StatefulViewControllerProtocol, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BXYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    _dataSource = @[
//                    @"first",
//                    @"second",
//                    @"third",
//                    ];
    
    [self.view addSubview:self.tableView];
	
    self.bxy_loadingView = [[LoadingView alloc] init];
    self.bxy_emptyView = [[EmptyView alloc] init];
    self.bxy_errorView = [[ErrorView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
    
    [self bxy_setupInitialViewState];
    [self refresh];
}

- (void)refresh {
    [self bxy_startLoading:NO completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSError *error = [[NSError alloc] init];
        [self bxy_endLoading:NO error:error completion:nil];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - StatefulViewControllerProtocol

- (BOOL)hasContent {
    return self.dataSource.count > 0;
}

- (void)handleErrorWhenContentAvailable:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"error!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - BackingViewProvider

- (UIView *)backingView {
    return self.view;
}

#pragma mark - getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
