//
//  ConsultModel.h
//  CS_Doctor
//
//  Created by qianfeng on 15/9/30.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import "JSONModel.h"

@protocol ListModel
@end
@interface ListModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *numOfHits;
@property (nonatomic, copy) NSString <Optional> *appImg;
@property (nonatomic, copy) NSString <Optional> *appTitlePic;
@property (nonatomic, copy) NSString <Optional> *appTop;
@property (nonatomic, copy) NSString <Optional> *url;
@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *resultSource;
@property (nonatomic, copy) NSString <Optional> *author;

@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, copy) NSString <Optional> *imgpath;
@property (nonatomic, copy) NSString <Optional> *numOfLiked;
@property (nonatomic, copy) NSString <Optional> *myDescription;
@property (nonatomic, copy) NSString <Optional> *articleDate;
@property (nonatomic, copy) NSString <Optional> *firstImg;
@property (nonatomic, copy) NSString <Optional> *numOfShared;
@property (nonatomic, copy) NSString <Optional> *comrowcount;

@end

@protocol AdListModel
@end
@interface AdListModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *adSort;
@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, copy) NSString <Optional> *addescription;
@property (nonatomic, copy) NSString <Optional> *outLink;
@property (nonatomic, copy) NSString <Optional> *departId;

@property (nonatomic, copy) NSString <Optional> *adImg;
@property (nonatomic, copy) NSString <Optional> *tagUrl;
@property (nonatomic, copy) NSString <Optional> *adPos;
@property (nonatomic, copy) NSString <Optional> *tagId;
@property (nonatomic, copy) NSString <Optional> *fromAsms;

@end

@interface ConsultModel : JSONModel

@property (nonatomic, strong) NSArray <ListModel> *list;
@property (nonatomic, strong) NSArray <AdListModel, Optional> *adList;

@end

@interface MessageModel : JSONModel

@property (nonatomic, strong) ConsultModel *message;

@end
