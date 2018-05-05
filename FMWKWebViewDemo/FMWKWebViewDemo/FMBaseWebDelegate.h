//
//  FMBaseWebDelegate.h
//  FMSLive
//
//  Created by 张大威 on 2017/7/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@interface FMBaseWebDelegate : NSObject<WKScriptMessageHandler>

@property(nonatomic,weak)UIViewController *webViewController;

#pragma mark - override  
-(NSArray <NSString *>*)expectedInjectionJsMethod;

@end
