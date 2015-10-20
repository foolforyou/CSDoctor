//
//  ViewController.m
//  CS_Doctor
//
//  Created by qianfeng on 15/9/30.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import "ConsultViewController.h"
#import <AFNetworking.h>
#import "ConsultModel.h"
#import "UIView+Common.h"
#import "ConsultCell.h"
#import <UIImageView+WebCache.h>
#import "SpecialViewController.h"
#import "DetailViewController.h"
#import "GuideViewController.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>

#define PATH @"http://www.dxy.cn/webservices/article/latest/v3.3?limit=20&pge=%ld&version=1&vs=9.0.1"

@interface ConsultViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    UIScrollView *_scrollView;
    NSMutableArray *_dataArray;
    NSMutableArray *_adListArray;
    NSMutableArray *_imageArray;
    UILabel *_titleLabel;
    UIPageControl *_pageControl;
}

@end

@implementation ConsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    _adListArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
    [self createTableView];
    [self createScrollView];
    [self getData:NO];
}

#pragma mark -
#pragma mark -- ScrollView

- (void)createScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width(self.view.frame), 170)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
}

- (void)addImageView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width(self.view.frame), 170)];
    [bgView addSubview:_scrollView];
    _tableView.tableHeaderView = bgView;
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width(_scrollView.frame)*i, 0, width(_scrollView.frame), 170)];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
        [_imageArray addObject:imageView];
    }
    _scrollView.contentSize = CGSizeMake(4*width(_scrollView.frame), 170);
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height(_scrollView.frame)-25, width(_scrollView.frame), 25)];
    aLabel.backgroundColor = [UIColor blackColor];
    aLabel.alpha = 0.5;
    [bgView addSubview:aLabel];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, height(_scrollView.frame)-25, width(aLabel.frame)-140, height(aLabel.frame))];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:_titleLabel];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(width(aLabel.frame)-80, height(_scrollView.frame)-25, 80, height(aLabel.frame))];
    _pageControl.numberOfPages = 4;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [bgView addSubview:_pageControl];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    DetailViewController *detail = [DetailViewController new];
    ListModel *listModel = _dataArray[tap.view.tag];
    detail.url = listModel.url;
    detail.modalTransitionStyle = UIModalPresentationFormSheet;
    [self presentViewController:detail animated:YES completion:^{
        
    }];
}

- (void)reloadMyData {
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = _imageArray[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[_dataArray[i] firstImg]] placeholderImage:nil];
    }
    _titleLabel.text = [_dataArray[0] title];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/width(_scrollView.frame);
    _titleLabel.text = [_dataArray[index] title];
    _pageControl.currentPage = index;
}

#pragma mark -
#pragma mark -- TableView
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20+44, width(self.view.frame), height(self.view.frame)-(20+44+44	)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData:NO];
    }];
    _tableView.header = refreshHeader;
    
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getData:YES];
    }];
    _tableView.footer = refreshFooter;
    
//    [refreshHeader beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row%5 == 4 && indexPath.row/5 < _adListArray.count) {
        SpecialViewController *specialView = [SpecialViewController new];
        specialView.titleName = [_adListArray[(indexPath.row/5)%_adListArray.count] title];
        specialView.id = [_adListArray[(indexPath.row/5)%_adListArray.count] tagId];
        [self.navigationController pushViewController:specialView animated:YES];
    } else {
        DetailViewController *detailView = [DetailViewController new];
        ListModel *listModel = _dataArray[indexPath.row];
        detailView.url = listModel.id;
        
        detailView.modalTransitionStyle = UIModalPresentationFormSheet;
        [self presentViewController:detailView animated:YES completion:^{
            
        }];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    ConsultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    int count = (int)_adListArray.count;
    if (indexPath.row%5 == 4 && indexPath.row/5 < count) {
        
        cell.adModel = _adListArray[indexPath.row/5];
        cell.isYES = NO;
        
    } else {
        cell.model = _dataArray[indexPath.row];
        cell.isYES = YES;
    }
    
    
    return  cell;
}


#pragma mark -
#pragma mark -- 获取数据
- (void)getData:(BOOL)isMore {
    
    NSInteger page = 1;
    if (isMore) {
        page = _dataArray.count/20 + 1;
    }
    
    NSString *url = [NSString stringWithFormat:PATH,page];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (!isMore) {
            [_dataArray removeAllObjects];
            [_adListArray removeAllObjects];
            [_imageArray removeAllObjects];
        }
        
        MessageModel *messageModel = [[MessageModel alloc] initWithData:responseObject error:nil];
        
        [_dataArray addObjectsFromArray:messageModel.message.list];
        
        [_adListArray addObjectsFromArray:messageModel.message.adList];
        
        [_tableView reloadData];
        [self addImageView];
        [self reloadMyData];
        
        !isMore ? [_tableView.header endRefreshing] : [_tableView.footer endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        !isMore ? [_tableView.header endRefreshing] : [_tableView.footer endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
