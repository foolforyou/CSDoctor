//
//  DetailModel.h
//  CS_Doctor
//
//  Created by qianfeng on 15/10/9.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import "JSONModel.h"

@protocol CSDisTagModel
@end
@interface CSDisTagModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *tagName;
@property (nonatomic, copy) NSString <Optional> *url;

@end

@interface CSMessageModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *body;

@property (nonatomic, copy) NSString <Optional> *title;

@property (nonatomic, copy) NSString <Optional> *pubDate;

@property (nonatomic, strong) NSMutableArray <CSDisTagModel> *disTag;

@end

@interface DetailModel : JSONModel

@property (nonatomic, strong) CSMessageModel *message;

@end