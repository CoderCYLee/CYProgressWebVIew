//
//  WKWebViewController.m
//  MkmyIOS
//
//  Created by Cyrill on 2016/10/15.
//  Copyright © 2016年 Cyrill. All rights reserved.
//

#import "CYWKWebViewController.h"
#import <WebKit/WebKit.h>

#define kProgressKey @"estimatedProgress"
#define kTitleKey    @"title"
#define kOldKey      @"old"
#define kNewKey      @"new"

@interface CYWKWebViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) CALayer *progresslayer;
@property (nonatomic, strong) UIButton *refreshButton;

@end

@implementation CYWKWebViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.progressView.layer addSublayer:self.progresslayer];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:self.refreshButton];
    
    if (self.url) {
        NSURLRequest *request =[NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    }
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:kProgressKey];
    [self.webView removeObserver:self forKeyPath:kTitleKey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:kProgressKey]) {
        self.progresslayer.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[kNewKey] floatValue] < [change[kOldKey] floatValue]) {
            return;
        }
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[kNewKey] floatValue], 3);
        if ([change[kNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    } else if ([keyPath isEqualToString:kTitleKey]) {
        if (object == self.webView) {
            self.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)refreshBtnAction:(UIButton *)btn {
    [self.webView reload];
}

#pragma mark - getters and setters
- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        [_webView addObserver:self forKeyPath:kProgressKey options:NSKeyValueObservingOptionNew context:nil];
        
        [_webView addObserver:self forKeyPath:kTitleKey options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _webView;
}

- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
        _progressView.backgroundColor = [UIColor clearColor];
    }
    return _progressView;
}

- (CALayer *)progresslayer
{
    if (!_progresslayer) {
        _progresslayer = [CALayer layer];
        _progresslayer.frame = CGRectMake(0, 0, 0, 3);
        _progresslayer.backgroundColor = [UIColor redColor].CGColor;
    }
    return _progresslayer;
}

- (UIButton *)refreshButton
{
    if (!_refreshButton) {
        _refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 26)];
        [_refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _refreshButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
        [_refreshButton addTarget:self action:@selector(refreshBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

@end
