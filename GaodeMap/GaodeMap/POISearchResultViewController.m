//
//  POISearchResultViewController.m
//  GaodeMap
//
//  Created by 周松 on 2017/7/27.
//  Copyright © 2017年 能环宝. All rights reserved.
//

#import "POISearchResultViewController.h"
#import "POISearchTableViewCell.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "POISearchModel.h"
#import <MAMapKit/MAMapKit.h>

@interface POISearchResultViewController ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate,MAMapViewDelegate>
///结果显示
@property (nonatomic,strong) UITableView *resultTableView;
///搜索引擎
@property (nonatomic,strong) AMapSearchAPI *POISearch;
///模型数组
@property (nonatomic,strong) NSMutableArray *modelArray;

@end
static NSString *reuseId = @"poireuseIdCell";
@implementation POISearchResultViewController
#pragma mark --懒加载
- (NSMutableArray *)modelArray {
    if (_modelArray == nil) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (UITableView *)resultTableView {
    if (_resultTableView == nil) {
        _resultTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        [self.view addSubview:_resultTableView];
    }
    return _resultTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建POI检索引擎
    _POISearch = [[AMapSearchAPI alloc]init];
    _POISearch.delegate = self;
    
    //创建POI周边检索请求
    AMapPOIAroundSearchRequest *aroundRequest = [[AMapPOIAroundSearchRequest alloc]init];
    aroundRequest.location = [AMapGeoPoint locationWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    aroundRequest.keywords         = self.keyWord;
    aroundRequest.sortrule         = 0; /* 按照距离排序. */
    //是否返回扩展信息
    aroundRequest.requireExtension = YES;
    //是否返回子POI
    aroundRequest.requireSubPOIs   = YES;
    //发起请求,开始POI周边检索
    [_POISearch AMapPOIAroundSearch:aroundRequest];
    
    [self.resultTableView registerClass:[POISearchTableViewCell class] forCellReuseIdentifier:reuseId];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //autoresizingMask 用于根据父视图进行调整,自动调整高度
    self.resultTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -- AMapSearchDelegate
///POI查询回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        return;
    }
    //遍历数组
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull poi, NSUInteger idx, BOOL * _Nonnull stop) {
        POISearchModel *searchModel = [[POISearchModel alloc]initWithAMapPOI:poi];
        [self.modelArray addObject:searchModel];
    }];
    [self.resultTableView reloadData];
}

#pragma mark -- UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    POISearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end









