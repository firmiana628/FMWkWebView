//
//  FMBaseWebViewController.h
//  WKWebViewController
//
//  Created by 郦道元  on 2017/7/21.
//  Copyright © 2017年 郦道元 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface FMBaseWebViewController : UIViewController

@property(nonatomic,strong)WKWebView *webView;
//@property(nonatomic,assign)BOOL isNeedsSign;
//
//@property(nonatomic,assign)BOOL hiddenNativeNavBar;
-(instancetype)initWithUrl:(NSString *)Url;

-(instancetype)initWithUrl:(NSString *)Url Delegate:(id)delegate;

-(instancetype)initWithUrl:(NSString *)Url Configuration:(WKWebViewConfiguration *)config;



/**
 初始化webView

 @param Url url
 @param config 配置信息
 @param delegate 代理对象,这里是强引用
 @return webView实例
 */
-(instancetype)initWithUrl:(NSString *)Url Configuration:(WKWebViewConfiguration *)config Delegate:(id)delegate;



/**
 刷新当前webview
 */
-(void)reloadWebView;


/**
 关闭当前webview
 */
-(void)closeWebView;

/**
 打开一个新的webviewVC

 @param url url
 */
-(void)openUrl:(NSString *)url;


/**
 在当前webView 重新加载url

 @param url url
 */
-(void)loadUrl:(NSString *)url;



-(void)webViewBack;

@end
