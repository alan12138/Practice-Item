//
//  ATMarketViewController.m
//  ATXCF
//
//  Created by 谷士雄 on 16/9/23.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATMarketViewController.h"
#import <WebKit/WebKit.h>

@interface ATMarketViewController ()<WKNavigationDelegate>
/** 网页 */
@property (strong,nonatomic)  WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation ATMarketViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1.创建WKWebView
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, statusHeight, screenWidth, screenHeight - statusHeight)];
    [_webView setAllowsBackForwardNavigationGestures:true];
    [self.view addSubview:_webView];
    self.webView = _webView;
    self.webView.navigationDelegate = self;
    //没有接口，为了好看直接把网址放这了，猜测这个页面的内容是不是就是在这个网页中截取的，哪位大牛看到了如果知道如何截取请赐教一下
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.xiachufang.com/page/ec-tab/"]]];
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
