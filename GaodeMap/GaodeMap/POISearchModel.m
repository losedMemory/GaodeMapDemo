//
//  POISearchModel.m
//  GaodeMap
//
//  Created by 周松 on 2017/7/26.
//  Copyright © 2017年 能环宝. All rights reserved.
//

#import "POISearchModel.h"
#import <AMapSearchKit/AMapSearchKit.h>
@implementation POISearchModel

- (instancetype)initWithAMapPOI:(AMapPOI *)shopPOI {
    POISearchModel *poiSearchModel = [[POISearchModel alloc]init];
    poiSearchModel.name = shopPOI.name;
    poiSearchModel.tel = shopPOI.tel;
    poiSearchModel.type = shopPOI.type;
    poiSearchModel.address = shopPOI.address;
    poiSearchModel.rating = [NSString stringWithFormat:@"%.1lf",shopPOI.extensionInfo.rating];
    poiSearchModel.images = shopPOI.images;
    return poiSearchModel;
}

- (NSString *)description {
    NSString *string = [NSString stringWithFormat:@"名字 =%@ 电话 =%@ 类型 =%@ 地址 =%@ 评分 =%@",self.name,self.tel,self.type,self.address,self.rating];
    return string;
}

@end
