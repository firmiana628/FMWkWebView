//
//  ViewController.m
//  FMWKWebViewDemo
//
//  Created by 张大威 on 2018/5/5.
//  Copyright © 2018年 zhang-yawei. All rights reserved.
//

#import "ViewController.h"
#import "FMBaseWebViewController.h"
#import "FMBaseWebDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    FMBaseWebDelegate *delegate = [[FMBaseWebDelegate alloc]init];
    FMBaseWebViewController *webViewVC = [[FMBaseWebViewController alloc]initWithUrl:@"https://www.baidu.com" Delegate:delegate];
    [self.navigationController pushViewController:webViewVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
