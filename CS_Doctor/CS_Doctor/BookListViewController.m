//
//  BookListViewController.m
//  CS_Doctor
//
//  Created by qianfeng on 15/10/5.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import "BookListViewController.h"
#import "UIView+Common.h"
#import "BookViewController.h"
#import <AFNetworking.h>
#import "BookListModel.h"

#define PATH @"http://d.dxy.cn/book/api/read?ac=058417c6-2724-4002-92b7-0e4462b31bbb&action=GetBookListBySubjectId&appType=1&mc=69dc8f19553ec87034b82fd369a3d67e36c5def2udidfor7&size=20&subjectId=%@&tpg=1&vs=9.0.2"

@interface BookListViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_nameArray;
}

@end

@implementation BookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray array];
    _nameArray = [NSMutableArray array];
    [self getData];
    [self getUIData];
    [self createTableView];
    
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

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, width(self.view.frame), height(self.view.frame)-(20+44)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width(tableView.frame), 30)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 100, 20)];
    nameLabel.text = _nameArray[section][0];
    [aView addSubview:nameLabel];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
    image.image = [UIImage imageNamed:@"stackoverflow"];
    [aView addSubview:image];
    
    return aView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookViewController *bookView = [BookViewController new];
    bookView.isYES = YES;
    bookView.array = _dataArray[indexPath.section];
    [self.navigationController pushViewController:bookView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _nameArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *ary = _nameArray[section][1];
    return ary.count;
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
    cell.textLabel.text = _nameArray[indexPath.section][1][indexPath.row];
    
    return cell;
}

- (void)getData {
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"Book" ofType:@"plist"];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:pListPath];
    
    NSDictionary *dic = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:nil];
    
    for (NSString *str in dic) {
        NSDictionary *dict = dic[str];
        NSMutableArray *nameListArray = [NSMutableArray array];
        NSMutableArray *idArray = [NSMutableArray array];
        for (NSString *string in dict) {
            [nameListArray addObject:string];
            [idArray addObject:dict[string]];
        }
        NSArray *ary = @[str,nameListArray,idArray];
        [_nameArray addObject:ary];
    }
}

- (void)getUIData {
    
    for (int t = 0; t < _nameArray.count; t++) {
        NSArray *array = _nameArray[t][2];
        
        for (int i = 0; i < array.count; i++) {
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSString *url = [NSString stringWithFormat:PATH,array[i]];
            
            [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                BookListModel *book = [[BookListModel alloc] initWithData:responseObject error:nil];
                
                [_dataArray addObject:book.books];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
        }
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
