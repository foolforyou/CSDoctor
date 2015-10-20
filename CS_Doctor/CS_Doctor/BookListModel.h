//
//  BookListModel.h
//  CS_Doctor
//
//  Created by qianfeng on 15/10/5.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import "JSONModel.h"

@protocol BooksModel
@end
@interface BooksModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *id;

@end

@interface BookListModel : JSONModel

@property (nonatomic, strong) NSMutableArray <BooksModel> *books;

@end
