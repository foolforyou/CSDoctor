//
//  DetailViewController.m
//  CS_Doctor
//
//  Created by qianfeng on 15/10/3.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import "DetailViewController.h"
#import "UIView+Common.h"
#import "DetailModel.h"
#import <AFNetworking.h>
#import "JWCache.h"
//#import "UMSocial.h"

#define PATH @"http://www.dxy.cn/webservices/article?ac=058417c6-2724-4002-92b7-0e4462b31bbb&id=%@&mc=69dc8f19553ec87034b82fd369a3d67e36c5def2udidfor7&vs=9.0.2"

@interface DetailViewController () <UIWebViewDelegate>{
    UIWebView *_webView;
    NSString *_data;
    NSData *_dataWithURL;
    DetailModel *_detail;
    UILabel *_titleLabel;
    UIActivityIndicatorView *_activity;
    UIButton *_centerButton;
    
    UIImageView *_likeThisImageView;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataWithURL = [NSData data];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, width(self.view.frame), height(self.view.frame)-60-44)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    
//    _webView.dataDetectorTypes = UIDataDetectorTypePhoneNumber|UIDataDetectorTypeLink;
//    
//    _webView.scrollView.pagingEnabled = YES;
//    
//    _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0,0, 0);
//    
//    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(midX(self.view), midY(self.view), 0, 0)];
    _activity.transform = CGAffineTransformMakeScale(2.5, 2.5);
    _activity.color = [UIColor grayColor];
    
    [_webView addSubview:_activity];
    
    [_activity startAnimating];
    
    [self.view addSubview:_webView];
    
    [self createDownView];
    
    [self createHeardView];
    
    [self createData];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'"];
    
    //字体颜色
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'black'"];
    
    //页面背景色
    
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
}

- (void)createData {
    
    [JWCache cacheDirectory];
    
    NSArray *keyArray = [JWCache giveMeAllKey];
    
    for (NSString *strKey in keyArray) {
        if ([strKey isEqualToString:_url]) {
            NSData *responseObject = [JWCache objectForKey:_url];
            [self setData:responseObject];
            _centerButton.selected = YES;
            _dataWithURL = responseObject;
            _centerButton.hidden = NO;
            return;
        }
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:PATH,_url];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _dataWithURL = responseObject;
        
        [self setData:responseObject];
        _centerButton.hidden = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)setData:(NSData *)responseObject {
    _detail = [[DetailModel alloc] initWithData:responseObject error:nil];
    
    _titleLabel.text = _detail.message.title;
    
    _data = _detail.message.body;
    
    [self createUIData];
}

- (void)createUIData {
    
    NSString *htmlString=_data;
    [_webView loadHTMLString:htmlString baseURL:nil];
    
    [_activity stopAnimating];
    
    
}

- (void)createHeardView {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, width(self.view.frame), 40)];
    _titleLabel.backgroundColor = [UIColor grayColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _titleLabel.numberOfLines = 0;
    [self.view addSubview:_titleLabel];
}

- (void)createDownView {
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, height(self.view.frame)-44, width(self.view.frame), 44)];
    downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 10, 24, 24);
    [button setImage:[UIImage imageNamed:@"arrow-left"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:button];
    
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _centerButton.frame = CGRectMake(midX(downView)-12, minY(button), 24, 24);
    [_centerButton setImage:[UIImage imageNamed:@"braceletUnLiked"] forState:UIControlStateNormal];
    [_centerButton setImage:[UIImage imageNamed:@"braceletLiked"] forState:UIControlStateSelected];
    [_centerButton addTarget:self action:@selector(centerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _centerButton.hidden = YES;
    [downView addSubview:_centerButton];
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(width(downView.frame)-30-20, minY(button), 24, 24);
    [rightButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [downView addSubview:rightButton];
    
    
    _likeThisImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _likeThisImageView.center = self.view.center;
    _likeThisImageView.image = [UIImage imageNamed:@"likethis"];
    _likeThisImageView.alpha = 0;
    [self.view addSubview:_likeThisImageView];
}

- (void)centerButtonClick:(UIButton *)button {
    if (!button.selected) {
        [JWCache cacheDirectory];
        [JWCache setObject:_dataWithURL forKey:_url];
        
        _likeThisImageView.alpha = 1;
        [UIView animateWithDuration:1 animations:^{
            _likeThisImageView.alpha = 0;
        }];
        
        button.selected = YES;
    } else {
        [JWCache cacheDirectory];
        [JWCache delateObjectForKey:_url];
        button.selected = NO;
    }
}

- (void)rightButtonClick:(UIButton *)button {
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"561affe567e58e036900205c" shareText:@"你要分享的文字" shareImage:[UIImage imageNamed:@"UMS_nav_button_refresh"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,nil] delegate:self];
}

- (void)buttonClick:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
