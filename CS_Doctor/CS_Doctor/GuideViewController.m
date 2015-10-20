//
//  GuideViewController.m
//  CS_Doctor
//
//  Created by qianfeng on 15/10/3.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import "GuideViewController.h"
#import "SpecialViewController.h"
#import "UIView+Common.h"
#import <GDataXMLNode.h>

#define PATH @"http://www.dxy.cn/webservices/article/list/channel-tag?ac=058417c6-2724-4002-92b7-0e4462b31bbb&channel=290&limit=20&mc=69dc8f19553ec87034b82fd369a3d67e36c5def2udidfor7&pge=1&tagname=288&vs=9.0.2"

@interface GuideViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_idArray;
}

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    _dataArray = [NSMutableArray array];
    _idArray = [NSMutableArray array];
    [self createTableView];
    [self getData];
}

#pragma mark -
#pragma mark -- UITableView

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20+44, width(self.view.frame), height(self.view.frame)-20-44-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecialViewController *spe = [SpecialViewController new];
    spe.isGuide = YES;
    spe.id = _idArray[indexPath.row];
    spe.titleName = _dataArray[indexPath.row];
    [self.navigationController pushViewController:spe animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.image = [UIImage imageNamed:@"chevron-right"];
    cell.accessoryView = imageView;
    
    cell.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    cell.imageView.image = [UIImage imageNamed:@"newspaper"];
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return  cell;
}

#pragma mark -
#pragma mark -- 获取数据

- (void)getData {
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"GuideList" ofType:@"plist"];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:pListPath];
    
    NSDictionary *dic = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:nil];
    
    for (NSString *str in dic) {
        [_dataArray addObject:str];
        [_idArray addObject:dic[str]];
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
