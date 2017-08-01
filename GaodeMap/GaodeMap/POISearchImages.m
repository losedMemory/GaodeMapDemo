//
//  POISearchImages.m
//  GaodeMap
//
//  Created by 周松 on 2017/7/26.
//  Copyright © 2017年 能环宝. All rights reserved.
//

#import "POISearchImages.h"
#import "UIImageView+WebCache.h"
#import <AMapSearchKit/AMapSearchKit.h>
@implementation POISearchImages

- (instancetype)init {
    if (self = [super init]) {
        for (int i = 0; i < 3; i ++ ) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.tag = i;
            [self addSubview:imageView];
        }
    }
    return self;
}

-  (void)setUrls:(NSArray<AMapImage *> *)urls {
    _urls = urls;
    if (urls.count > 0) {
        for (int i = 0; i < urls.count; i ++) {
            UIImageView *imageView = (UIImageView *)self.subviews[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urls[i].url == nil ? @"":urls[i].url]];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = (self.bounds.size.width-2*10)/3;
    CGFloat H = self.bounds.size.height;
    for (UIImageView *imageView in self.subviews) {
        imageView.frame = CGRectMake(X, Y, W, H);
        X += 10 + W;
    }

}

@end
