//
//  BookViewController.m
//  CS_Doctor
//
//  Created by qianfeng on 15/10/4.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import "BookViewController.h"
#import "JT3DScrollView.h"
#import "UIView+Common.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "BookModel.h"
#import "BookListViewController.h"
#import "BookListModel.h"

#define PATH @"http://i.dxy.cn/bbs/bbsapi/mobile?ac=058417c6-2724-4002-92b7-0e4462b31bbb&appType=1&mc=69dc8f19553ec87034b82fd369a3d67e36c5def2udidfor7&page=1&s=special_book_list&size=20&typeId=12&vs=9.0.2"

#define BOOKLIST_PATH @"http://i.dxy.cn/bbs/bbsapi/mobile?ac=058417c6-2724-4002-92b7-0e4462b31bbb&id=%@&mc=69dc8f19553ec87034b82fd369a3d67e36c5def2udidfor7&s=book_detail&vs=9.0.2"

@interface BookViewController () <UIScrollViewDelegate> {
    JT3DScrollView *_scrollView;
    NSMutableArray *_dataArray;
    NSMutableArray *_idArray;
    NSMutableArray *_viewArray;
}

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    _dataArray = [NSMutableArray array];
    _idArray = [NSMutableArray array];
    _viewArray = [NSMutableArray array];
    
    if (_isYES) {
        [_idArray addObjectsFromArray:_array];
    } else {
        [self getData];
    }
    
    _scrollView = [[JT3DScrollView alloc] initWithFrame:CGRectMake(20, 20+44+20, width(self.view.frame)-40, height(self.view.frame)-(20+44+20+44+20))];
    
    _scrollView.effect = JT3DScrollViewEffectDepth;
    
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    
    [self createView];
    
    [self getUIData];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [button setTitle:@"分类" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)buttonClick:(UIButton *)button {
    BookListViewController *book = [BookListViewController new];
    [self.navigationController pushViewController:book animated:YES];
}

- (void)createView {
    
    for (int i = 0; i < _idArray.count; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width(_scrollView.frame)*i, 0, width(_scrollView.frame), height(_scrollView.frame))];
        
        view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        
        view.layer.cornerRadius = 8;
        
        [_viewArray addObject:view];
        
        [_scrollView addSubview:view];
        
    }
    
    _scrollView.contentSize = CGSizeMake(_idArray.count*width(_scrollView.frame), height(_scrollView.frame));
    
}

- (void)addBookView:(NSInteger)index item:(id)item{
   
    UIView *aView = _viewArray[index];
    
    BookModel *bookModel = (BookModel *)item;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 160)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:bookModel.cover] placeholderImage:nil];
    [aView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(maxX(imageView)+10, minY(imageView), width(aView.frame)-20-width(imageView.frame), 20)];
    titleLabel.text = bookModel.title;
    [aView addSubview:titleLabel];
    
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX(titleLabel), maxY(titleLabel)+15, width(titleLabel.frame), 20)];
    authorLabel.text = [NSString stringWithFormat:@"作者：%@",bookModel.author];
    authorLabel.textColor = [UIColor grayColor];
    authorLabel.font = [UIFont systemFontOfSize:15];
    [aView addSubview:authorLabel];
    
    UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX(titleLabel), maxY(authorLabel)+15, width(titleLabel.frame), 20)];
    float size = (float)[bookModel.length floatValue]/1000000.0;
    sizeLabel.text = [NSString stringWithFormat:@"大小：%.1fMB",size];
    sizeLabel.textColor = [UIColor grayColor];
    sizeLabel.font = [UIFont systemFontOfSize:15];
    [aView addSubview:sizeLabel];
    
    UILabel *pirceLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX(titleLabel), maxY(sizeLabel)+15, 120, 20)];
    float price = (float)[bookModel.currentPrice floatValue]/100.0;
    pirceLabel.text = [NSString stringWithFormat:@"价格：￥%.2f |",price];
    pirceLabel.textColor = [UIColor grayColor];
    pirceLabel.font = [UIFont systemFontOfSize:15];
    [aView addSubview:pirceLabel];
    
    UILabel *oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(maxX(pirceLabel), minY(pirceLabel), 60, 20)];
    price = (float)[bookModel.originalPrice floatValue]/100.0;
    oldPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
    oldPriceLabel.textColor = [UIColor grayColor];
    oldPriceLabel.font = [UIFont systemFontOfSize:15];
    [aView addSubview:oldPriceLabel];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(maxX(pirceLabel), minY(pirceLabel)+10, 60, 1)];
    lineLabel.backgroundColor = [UIColor grayColor];
    [aView addSubview:lineLabel];
    
    UILabel *longLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, maxY(imageView)+20, width(aView.frame), 1)];
    longLineLabel.backgroundColor = [UIColor grayColor];
    longLineLabel.alpha = 0.5;
    [aView addSubview:longLineLabel];
    
    UILabel *JJLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX(imageView), maxY(longLineLabel)+20, width(aView.frame)-20, 20)];
    JJLabel.text = @"内容简介";
    [aView addSubview:JJLabel];
    
    UITextView *bodyTextView = [[UITextView alloc] initWithFrame:CGRectMake(minX(imageView), maxY(JJLabel)+20, width(JJLabel.frame), 250)];
    bodyTextView.text = bookModel.myDescription;
    bodyTextView.font = [UIFont systemFontOfSize:15];
    bodyTextView.editable = NO;
    bodyTextView.textColor = [UIColor grayColor];
    [aView addSubview:bodyTextView];
}

#pragma mark -
#pragma mark -- 获取数据

- (void)getData {
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"BookList" ofType:@"plist"];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:pListPath];
    
    NSDictionary *dic = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:nil];
    
    for (NSString *str in dic) {
        [_idArray addObject:dic[str]];
    }
}

- (void)getUIData {
    for (int i = 0; i < _idArray.count; i++) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSString *url = @"";
        
        if (_isYES) {
            
            BooksModel *book = _idArray[i];
            
            url = [NSString stringWithFormat:BOOKLIST_PATH,book.id];
            
            NSLog(@"%@",url);
        } else {
            url = _idArray[i];
        }
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            ItemModel *item = [[ItemModel alloc] initWithData:responseObject error:nil];
            
            [_dataArray addObject:item.item];
            
            [self addBookView:i item:item.item];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
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
