//
//  ConsultCell.h
//  CS_Doctor
//
//  Created by qianfeng on 15/9/30.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsultModel.h"

@interface ConsultCell : UITableViewCell

@property (nonatomic, strong) ListModel *model;
@property (nonatomic, strong) AdListModel *adModel;

@property (nonatomic, assign) BOOL isYES;

@end
