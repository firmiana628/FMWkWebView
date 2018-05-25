//
//  FMBaseWebViewController.m
//  WKWebViewController
//
//  Created by 郦道元  on 2017/7/21.
//  Copyright © 2017年 郦道元 . All rights reserved.
//

#import "FMBaseWebViewController.h"
#import "FMBaseWebDelegate.h"
//#import "NSString+FMAdd.h"

// 状态栏高度
// 导航栏高度
#define NAV_BAR_HEIGHT (44.f)

#define STATUS_BAR_HEIGHT (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))

#define STATUS_AND_NAV_BAR_HEIGHT (STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface FMBaseWebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property(nonatomic,strong) WKWebViewConfiguration *config;
@property(nonatomic,strong)id delegate;
@property(nonatomic,copy)NSString *url;
@end

@implementation FMBaseWebViewController
#pragma mark -  getter
-(WKWebView *)webView
{
    if (_webView == nil) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0,STATUS_AND_NAV_BAR_HEIGHT,SCREEN_WIDTH , SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT) configuration:self.config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}
-(WKWebViewConfiguration *)config
{
    if (_config == nil) {
        
        _config = [[WKWebViewConfiguration alloc]init];
        //初始化偏好设置属性：preferences
        _config.preferences = [[WKPreferences alloc]init];
        //The minimum font size in points default is 0;
        // config.preferences.minimumFontSize = 10;
        //是否支持JavaScript
        _config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        _config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
      //  _config.applicationNameForUserAgent = [NSString stringWithFormat:@"IOS_VERSION%fSCREEN_HEIGHT%d",IOS_VERSION,(int)SCREEN_HEIGHT];
    }
    return _config;
}


-(instancetype)initWithUrl:(NSString *)Url Configuration:(WKWebViewConfiguration *)config
{
    return [self initWithUrl:Url Configuration:config Delegate:nil];
}

-(instancetype)initWithUrl:(NSString *)Url Delegate:(id)delegate
{
    return [self initWithUrl:Url Configuration:nil Delegate:delegate];
}



-(instancetype)initWithUrl:(NSString *)Url
{
    return [self initWithUrl:Url Configuration:nil Delegate:nil];
}


-(instancetype)initWithUrl:(NSString *)Url Configuration:(WKWebViewConfiguration *)config Delegate:(id)delegate
{
    if (self = [super init]) {
        _config = config;
        _delegate = delegate;
        if([_delegate isKindOfClass:[FMBaseWebDelegate class]]){
            ((FMBaseWebDelegate *)_delegate).webViewController = self;
        }
        _url = Url;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (void)viewDidLoad {
  
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.webView];
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.webView.scrollView.scrollIndicatorInsets = self.webView.scrollView.contentInset;
    }
    
    if (self.url) {
        self.url = [self buildUrl:self.url];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
       
        [self.webView loadRequest:request];
    }
   
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(expectedInjectionJsMethod)]) {
        NSArray *jsMethods = [self.delegate expectedInjectionJsMethod];
        if (jsMethods && jsMethods.count>0) {
            [jsMethods enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.config.userContentController addScriptMessageHandler:self.delegate name:obj];
            }];
        }
        
    }
    
}


-(void)pressBackButton
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - public

-(void)reloadWebView
{
    [self.webView reload];
}


-(void)closeWebView
{

  [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadUrl:(NSString *)url
{

    url = [self buildUrl:url];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}


-(void)openUrl:(NSString *)url
{
    FMBaseWebDelegate *baseDelegate = [[FMBaseWebDelegate alloc]init];
    FMBaseWebViewController *webViewController = [[FMBaseWebViewController alloc]initWithUrl:url Delegate:baseDelegate];
    [self.navigationController pushViewController:webViewController animated:YES];
}

-(void)webViewBack
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self closeWebView];
    }
}


#pragma mark - private
-(NSString *)buildUrl:(NSString *)url
{
    if (!url) {
        return @"https://www.baidu.com";
    }
    return url;
}


#pragma mark - WKNavigationD
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [self.delegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:decidePolicyForNavigationResponse:decisionHandler:)]) {
        [self.delegate webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
    }else{
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}


// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [self.delegate webView:webView didStartProvisionalNavigation:navigation];
    }
}

// 接收到服务重定向时回调
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didReceiveServerRedirectForProvisionalNavigation:)]) {
        [self.delegate webView:webView didReceiveServerRedirectForProvisionalNavigation:navigation];
    }
}


// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [self.delegate webView:webView didFailProvisionalNavigation:navigation withError:error];
    }
}


// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didCommitNavigation:)]) {
        [self.delegate webView:webView didCommitNavigation:navigation];
    }
}


// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    if (!self.title) {
        [self setTitle:self.webView.title];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [self.delegate webView:webView didFinishNavigation:navigation];
    }
}

// 当最后下载数据失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        [self.delegate webView:webView didFailNavigation:navigation withError:error];
    }
}


// https
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didReceiveAuthenticationChallenge:completionHandler:)]) {
//        [self.delegate webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
//    }else{
//
//    }
//}


- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewWebContentProcessDidTerminate:)]) {
       [self.delegate webViewWebContentProcessDidTerminate:webView];
    }
}

#pragma mark  - uidelegate



- (void)webViewDidClose:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidClose:)]) {
        [self.delegate webViewDidClose:webView];
    }
}

// 
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:)]) {
//        [self.delegate webView:webView runJavaScriptAlertPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler ];
//    }
//}


//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:)]) {
//        [self.delegate webView:webView runJavaScriptConfirmPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler ];
//    }
//}

//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:)]) {
//        [self.delegate webView:webView runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler ];
//    }
//}


- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo API_AVAILABLE(ios(10.0))
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:shouldPreviewElement:)]) {
       return  [self.delegate webView:webView shouldPreviewElement:elementInfo ];
    }else{
        return YES;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(expectedInjectionJsMethod)]) {
        NSArray *jsMethods = [self.delegate expectedInjectionJsMethod];
        if (jsMethods && jsMethods.count>0) {
            [jsMethods enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.config.userContentController removeScriptMessageHandlerForName:obj];
            }];
        }
        
    }
}

@end
