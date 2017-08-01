//
//  POISearchTableViewCell.m
//  GaodeMap
//
//  Created by 周松 on 2017/7/26.
//  Copyright © 2017年 能环宝. All rights reserved.
//

#import "POISearchTableViewCell.h"
#import "POISearchModel.h"
#import "POISearchImages.h"
#import "Masonry.h"
@interface POISearchTableViewCell ()
///名字
@property (nonatomic,strong) UILabel *nameLabel;
///类型
@property (nonatomic,strong) UILabel *typeLabel;
///评分
@property (nonatomic,strong) UILabel *ratingLabel;
///电话
@property (nonatomic,strong) UILabel *telLabel;
///地址
@property (nonatomic,strong) UILabel *addressLabel;
///图片
@property (nonatomic,strong) POISearchImages *poiImageView;

@end
static CGFloat marginLeft = 10;
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEGHT  [UIScreen mainScreen].bounds.size.height
@implementation POISearchTableViewCell

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_typeLabel];
    }
    return _typeLabel;
}

- (UILabel *)ratingLabel {
    if (_ratingLabel == nil) {
        _ratingLabel = [[UILabel alloc]init];
        _ratingLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_ratingLabel];
    }
    return _ratingLabel;
}

- (UILabel *)telLabel {
    if (_telLabel == nil) {
        _telLabel = [[UILabel alloc]init];
        _telLabel.textColor = [UIColor blueColor];
        [self.contentView addSubview:_telLabel];
    }
    return _telLabel;
}

- (UILabel *)addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (POISearchImages *)poiImageView {
    if (_poiImageView == nil) {
        _poiImageView = [[POISearchImages alloc]init];
        [self.contentView addSubview:_poiImageView];
    }
    return _poiImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(marginLeft);
        make.top.mas_offset(marginLeft);
        make.right.mas_offset(-marginLeft);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(marginLeft);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(marginLeft * 2);
        make.width.mas_equalTo(SCREEN_WIDTH / 2);
    }];
    
    [self.ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_right).offset(marginLeft);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(marginLeft * 2);
        make.right.mas_equalTo(-marginLeft);
    }];
    
    [self.telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(marginLeft);
        make.top.mas_equalTo(self.typeLabel.mas_bottom).offset(marginLeft * 2);
        make.width.mas_equalTo(SCREEN_WIDTH / 2);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.telLabel.mas_right).offset(marginLeft);
        make.top.mas_equalTo(self.ratingLabel.mas_bottom).offset(marginLeft * 2);
        make.right.mas_equalTo(-marginLeft);
    }];
    
    [self.poiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(marginLeft);
        make.top.mas_equalTo(self.telLabel.mas_bottom).offset(marginLeft * 2);
        make.right.mas_equalTo(-marginLeft);
        make.bottom.mas_offset(-marginLeft);
    }];
}

- (void)setModel:(POISearchModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.typeLabel.text = [NSString stringWithFormat:@"类型:%@",model.type];
    self.ratingLabel.text = [NSString stringWithFormat:@"评分:%@",model.rating];
    self.telLabel.text = [model.tel  isEqual: @""]?@"电话:138138138":[NSString stringWithFormat:@"电话:%@",model.tel];
    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@",model.address];
    self.poiImageView.urls = model.images;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
