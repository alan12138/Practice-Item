//
//  ATWebViewController.m
//  ShopApp
//
//  Created by 谷士雄 on 16/5/30.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATWebViewController.h"
#import <WebKit/WebKit.h>

@interface ATWebViewController ()<WKNavigationDelegate>
/** 网页 */
@property (strong,nonatomic)  WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation ATWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = self.navTitle;
    
    //1.创建WKWebView
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [_webView setAllowsBackForwardNavigationGestures:true];
    [self.view addSubview:_webView];
    self.webView = _webView;
    self.webView.navigationDelegate = self;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
@end
