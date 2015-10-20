//
//  MyViewController.m
//  CS_Doctor
//
//  Created by qianfeng on 15/10/5.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import "MyViewController.h"
#import "UIView+Common.h"
#import "CollectViewController.h"

@interface MyViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    UIImageView *_imageView;
    UIButton *_collectButton;
    UILabel *_bodyLabel;
}

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTableView];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width(self.view.frame), 230)];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"png"];
    _imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    [self.view addSubview:_imageView];
    
    [self createButton];
}

- (void)createButton {
    _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectButton.frame = CGRectMake((width(self.view.frame)-150)/2, (height(_imageView.frame)-40)/2, 150, 40);
    [_collectButton setTitle:@"我的收藏" forState:UIControlStateNormal];
    [_collectButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_collectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _collectButton.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.5];
    _collectButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _collectButton.layer.borderWidth = 1.0;
    _collectButton.layer.cornerRadius = 3.0;
    [_collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_collectButton];
    
    _bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX(_collectButton)-30, maxY(_collectButton)+20, width(_collectButton.frame)+60, 20)];
    _bodyLabel.text = @"点击我的收藏可观看自己的收藏";
    _bodyLabel.textColor = [UIColor whiteColor];
    _bodyLabel.textAlignment = NSTextAlignmentCenter;
    _bodyLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_bodyLabel];
}

- (void)collectButtonClick:(UIButton *)button {
    CollectViewController *collect = [CollectViewController new];
    collect.modalTransitionStyle = UIModalPresentationFormSheet;
    [self presentViewController:collect animated:YES completion:^{
        
    }];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width(self.view.frame), height(self.view.frame)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        if (scrollView.contentOffset.y < 0) {
            [UIView animateWithDuration:0.01 animations:^{
                _imageView.frame = CGRectMake(scrollView.contentOffset.y/2, 0, width(self.view.frame)-scrollView.contentOffset.y, 230-scrollView.contentOffset.y);
            }];
        } else if (scrollView.contentOffset.y > 0) {
            [UIView animateWithDuration:0.01 animations:^{
                _imageView.frame = CGRectMake(0, 0, width(self.view.frame), 230-scrollView.contentOffset.y);
                _collectButton.transform = CGAffineTransformMakeTranslation(0, -scrollView.contentOffset.y/3*2);
                _bodyLabel.transform = CGAffineTransformMakeTranslation(0, -scrollView.contentOffset.y/4*3);
            }];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0 || indexPath.row == 3) {
            return 100;
        }
        
        return 50;
    }
    
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        imageView.layer.cornerRadius = 20.0;
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:@"icon"];
        cell.accessoryView = imageView;
        
        cell.textLabel.text = @"医随心疗";
        
//        cell.detailTextLabel.text = @"软件版本：1.0(2015-10-05)";
        
        return  cell;
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.textLabel.text = @"客服邮箱：cs_foolforyou@sina.com";
        return cell;
    }
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        cell.detailTextLabel.text = @"免责声明：数据皆来自互联网与丁香园等，请勿传播！";
        return cell;
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width(cell.frame), 80)];
        titleLabel.text = @"丁香园是中国最大的面向医生、医疗机构、医药从业者及生命科学领域的专业社会化网络，提供以上领域的交流平台、专业知识、最新科研进展及技术服务";
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        cell.accessoryView = titleLabel;
        return cell;
    }
    
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
