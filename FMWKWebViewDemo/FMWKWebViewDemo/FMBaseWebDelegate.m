//
//  FMBaseWebDelegate.m
//  FMSLive
//
//  Created by 张大威 on 2017/7/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FMBaseWebDelegate.h"
//#import <WebKit/WebKit.h>
#import "FMBaseWebViewController.h"

@implementation FMBaseWebDelegate


-(NSArray <NSString *>*)expectedInjectionJsMethod
{
    return @[@"exit",@"openUrl",@"back"];
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"exit"]) {
        if([self.webViewController respondsToSelector:@selector(closeWebView)]){
            [self.webViewController performSelector:@selector(closeWebView)];
            return;
        }
    }
    else if ([message.name isEqualToString:@"openUrl"]){
        if([self.webViewController respondsToSelector:@selector(openUrl:)]){
            if (!message.body) {
                [self.webViewController performSelector:@selector(openUrl:) withObject:message.body];
            }
            return;
        }
    }else if ([message.name isEqualToString:@"back"]){
        if([self.webViewController respondsToSelector:@selector(webViewBack)]){
            [self.webViewController performSelector:@selector(webViewBack)];
            return;
        }

    }

}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
