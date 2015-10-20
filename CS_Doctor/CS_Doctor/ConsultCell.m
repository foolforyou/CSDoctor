//
//  ConsultCell.m
//  CS_Doctor
//
//  Created by qianfeng on 15/9/30.
//  Copyright © 2015年 陈思. All rights reserved.
//

#import "ConsultCell.h"
#import "UIView+Common.h"
#import <UIImageView+WebCache.h>

@interface ConsultCell () {
    UIImageView *_iconImageView;
    UIImageView *_bigImageView;
    UILabel *_titleLabel;
    UILabel *_numOfLikeLabel;
    UILabel *_bodyLabel;
    UILabel *_numLabel;
    UILabel *_timeLabel;
    UIImageView *_ZTImageView;
}

@end

@implementation ConsultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [self customViews];
    }
    return self;
}

- (void)customViews {
    _bigImageView = [UIImageView new];
    [self.contentView addSubview:_bigImageView];
    
    _ZTImageView = [UIImageView new];
    [_bigImageView addSubview:_ZTImageView];
    
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    
    _titleLabel = [UILabel new];
    [self.contentView addSubview:_titleLabel];
    _numOfLikeLabel = [UILabel new];
    [self.contentView addSubview:_numOfLikeLabel];
    _bodyLabel = [UILabel new];
    [self.contentView addSubview:_bodyLabel];
    _numLabel = [UILabel new];
    [self.contentView addSubview:_numLabel];
    _timeLabel = [UILabel new];
    [self.contentView addSubview:_timeLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_isYES) {
        _iconImageView.frame = CGRectMake(15, 15, 100, 60);
        
        _titleLabel.frame = CGRectMake(maxX(_iconImageView)+20, minY(_iconImageView), width(self.contentView.frame)-60-width(_iconImageView.frame), 40);
        _titleLabel.textColor = [UIColor blackColor];
        
        _numOfLikeLabel.frame = CGRectMake(minX(_titleLabel), maxY(_titleLabel)+5, 100, 20);
        
        _bodyLabel.frame = CGRectMake(minX(_iconImageView), maxY(_iconImageView)+10, width(self.contentView.frame)-40, 40);
        
        _numLabel.frame = CGRectMake(minX(_iconImageView), maxY(_bodyLabel)+5, 150, 15);
        
        _timeLabel.frame = CGRectMake(width(self.contentView.frame)-80, minY(_numLabel), 80, 15);
        
        _bigImageView.frame = CGRectZero;
        
        _ZTImageView.frame = CGRectZero;
        
    } else {
        _iconImageView.frame = CGRectZero;
        _numOfLikeLabel.frame = CGRectZero;
        _bodyLabel.frame = CGRectZero;
        _numLabel.frame = CGRectZero;
        _timeLabel.frame = CGRectZero;
        
        _titleLabel.frame = CGRectMake(15, 10, width(self.contentView.frame)-30, 20);
        _titleLabel.textColor = [UIColor purpleColor];
        
        _bigImageView.frame = CGRectMake(minX(_titleLabel), maxY(_titleLabel)+10, width(_titleLabel.frame), 100);
        
        _ZTImageView.frame = CGRectMake(width(_bigImageView.frame)-30, 0, 20, 30);
    }
}

- (void)setModel:(ListModel *)model {
    _model = model;
    [self reloadData];
}

- (void)setAdModel:(AdListModel *)adModel {
    _adModel = adModel;
    [self reloadAdData];
}

- (void)reloadAdData {
    _titleLabel.text = _adModel.title;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:_adModel.adImg] placeholderImage:nil];
    
    _ZTImageView.image = [UIImage imageNamed:@"bookmark"];
}

- (void)reloadData {
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgpath] placeholderImage:nil];
    
    _titleLabel.text = _model.title;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    _numOfLikeLabel.text = [NSString stringWithFormat:@"%@人关注",_model.numOfLiked];
    _numOfLikeLabel.textColor = [UIColor purpleColor];
    _numOfLikeLabel.font = [UIFont systemFontOfSize:15];
    
    _bodyLabel.text = _model.myDescription;
    _bodyLabel.numberOfLines = 0;
    _bodyLabel.textColor = [UIColor grayColor];
    _bodyLabel.font = [UIFont systemFontOfSize:15];
    
    _numLabel.text = [NSString stringWithFormat:@"%@分享",_model.numOfShared];
    _numLabel.textColor = [UIColor grayColor];
    _numLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *timeString = [_model.articleDate substringToIndex:10];
    _timeLabel.text = timeString;
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.font = [UIFont systemFontOfSize:12];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
