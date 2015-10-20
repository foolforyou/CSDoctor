//
//  BookModel.h
//  CS_Doctor
//
//  Created by qianfeng on 15/10/4.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import "JSONModel.h"

@interface BookModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *currentPrice;

@property (nonatomic, copy) NSString <Optional> *author;

@property (nonatomic, copy) NSString <Optional> *title;

@property (nonatomic, copy) NSString <Optional> *originalPrice;

@property (nonatomic, copy) NSString <Optional> *myDescription;

@property (nonatomic, copy) NSString <Optional> *length;

@property (nonatomic, copy) NSString <Optional> *cover;

@end

@interface ItemModel : JSONModel

@property (nonatomic, strong) BookModel *item;

@end
