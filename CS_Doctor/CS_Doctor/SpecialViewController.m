//
//  SpecialViewController.m
//  CS_Doctor
//
//  Created by qianfeng on 15/10/3.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import "SpecialViewController.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import "ConsultModel.h"
#import "ConsultCell.h"
#import "UIView+Common.h"
#import "DetailViewController.h"

#define PATH @"http://www.dxy.cn/webservices/special/articles?ac=058417c6-2724-4002-92b7-0e4462b31bbb&id=%@&limit=20&mc=69dc8f19553ec87034b82fd369a3d67e36c5def2udidfor7&pge=%ld&vs=9.0.2"

#define GUIDE_PATH @"http://www.dxy.cn/webservices/article/list/channel-tag?ac=058417c6-2724-4002-92b7-0e4462b31bbb&channel=%@&limit=20&mc=69dc8f19553ec87034b82fd369a3d67e36c5def2udidfor7&pge=%ld&tagname=288&vs=9.0.2"

@interface SpecialViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation SpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    _dataArray = [NSMutableArray array];
    [self createTableView];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    
    self.title = @"专题";
//    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor whiteColor]};
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 65, 25);
    [button setImage:[UIImage imageNamed:@"chevron-left"] forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)buttonClick:(UIButton *)button {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark -- UITableView

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIImageView *heardimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width(self.view.frame), 60)];
    heardimageView.backgroundColor = [UIColor blackColor];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"book" ofType:@"jpg"];
    heardimageView.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    _tableView.tableHeaderView = heardimageView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((width(heardimageView.frame)-250)/2, (height(heardimageView.frame)-20)/2, 250, 20)];
    titleLabel.text = _titleName;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [heardimageView addSubview:titleLabel];
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData:NO];
    }];
    _tableView.header = refreshHeader;
    
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getData:YES];
    }];
    _tableView.footer = refreshFooter;
    
    [refreshHeader beginRefreshing];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailView = [DetailViewController new];
    ListModel *listModel = _dataArray[indexPath.row];
    detailView.url = listModel.id;
    detailView.modalTransitionStyle = UIModalPresentationFormSheet;
    [self presentViewController:detailView animated:YES completion:^{
        
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    ConsultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.model = _dataArray[indexPath.row];
    cell.isYES = YES;
    
    return  cell;
}

- (void)getData:(BOOL)isMore {
    NSInteger page = 1;
    
    if (isMore) {
        if (_dataArray.count%20 == 0) {
            page = _dataArray.count/20 + 1;
        } else {
            [_tableView.footer endRefreshing];
            return;
        }
    }
    
    NSString *url = @"";
    if (_isGuide) {
        url = [NSString stringWithFormat:GUIDE_PATH,_id,page];
    } else {
        url = [NSString stringWithFormat:PATH,_id,page];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (!isMore) {
            [_dataArray removeAllObjects];
        }
        
        MessageModel *messageModel = [[MessageModel alloc] initWithData:responseObject error:nil];
        
        [_dataArray addObjectsFromArray:messageModel.message.list];
        
        [_tableView reloadData];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
