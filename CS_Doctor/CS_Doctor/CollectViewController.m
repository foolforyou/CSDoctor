//
//  CollectViewController.m
//  CS_Doctor
//
//  Created by qianfeng on 15/10/11.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import "CollectViewController.h"
#import "DetailModel.h"
#import "JWCache.h"
#import "UIView+Common.h"
#import "DetailViewController.h"

@interface CollectViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSArray *_keyArray;
    DetailModel *_detail;
}

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    [self createTableView];
    [self setCacheData];
    [self createDownView];
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
}

- (void)buttonClick:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setCacheData {
    [JWCache cacheDirectory];
    _keyArray = [JWCache giveMeAllKey];
    
    if (_keyArray.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有收藏过东西" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    NSLog(@"%ld",_keyArray.count);
    
    for (NSString *strKey in _keyArray) {
        NSData *responseObject = [JWCache objectForKey:strKey];
        [self setData:responseObject];
    }
    [_tableView reloadData];
}

- (void)setData:(NSData *)responseObject {
    _detail = [[DetailModel alloc] initWithData:responseObject error:nil];
    [_dataArray addObject:_detail];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, width(self.view.frame), height(self.view.frame)-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailView = [DetailViewController new];
    detailView.url = _keyArray[indexPath.row];
    
    detailView.modalTransitionStyle = UIModalPresentationFormSheet;
    [self presentViewController:detailView animated:YES completion:^{
        
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    DetailModel *detail = _dataArray[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",detail.message.title];
    
    return  cell;
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
