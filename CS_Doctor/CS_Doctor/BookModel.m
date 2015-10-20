//
//  BookModel.m
//  CS_Doctor
//
//  Created by qianfeng on 15/10/4.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"myDescription"}];
}

@end

@implementation ItemModel

@end