//
//  POISearchBarViewController.m
//  GaodeMap
//
//  Created by 周松 on 2017/7/27.
//  Copyright © 2017年 能环宝. All rights reserved.
//

#import "POISearchBarViewController.h"
#import "Masonry.h"
#import "POISearchResultViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface POISearchBarViewController ()<UITableViewDelegate,UISearchBarDelegate,UITableViewDataSource,MAMapViewDelegate>
///搜索框
@property (nonatomic,weak) UISearchBar *searchBar;
///显示历史记录
@property (nonatomic,strong) UITableView *historyRecordTableView;
///存放搜索历史的数组
@property (nonatomic,strong) NSMutableArray *historyArray;
///搜索历史缓存路径
@property (nonatomic,copy) NSString *searchHistoryCache;
///清空历史记录
@property (nonatomic,strong) UILabel *emptyAllHistoryLabel;

///地图
@property (nonatomic,strong) MAMapView *mapView;
///经纬度对象
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@end

@implementation POISearchBarViewController
#pragma mark -- 懒加载
- (UITableView *)historyRecordTableView {
    if (_historyRecordTableView == nil) {
        _historyRecordTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.view addSubview:_historyRecordTableView];
        _historyRecordTableView.delegate = self;
        _historyRecordTableView.dataSource = self;
    }
    return _historyRecordTableView;
}

- (NSMutableArray *)historyArray {
    if (_historyArray == nil) {
        _historyArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoryCache]];
    }
    return _historyArray;
}

- (MAMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        [_mapView setZoomLevel:17.5 animated:YES];
        //设置用户位置追踪模式
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:NO];
        
    }
    return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [AMapServices sharedServices].enableHTTPS = YES;
    [self.view addSubview:self.mapView];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width-30, 30)];
    //设置搜索框
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(titleView.frame) - 100, CGRectGetHeight(titleView.frame));
    [titleView addSubview:searchBar];
    searchBar.delegate = self;
    //设置占位文字
    [searchBar setPlaceholder:@"搜索吧,骚年"];
    searchBar.layer.cornerRadius = 15;
    searchBar.layer.masksToBounds = YES;
    searchBar.backgroundColor = self.navigationController.navigationBar.tintColor;
    [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
    [searchBar.layer setBorderWidth:5];
    //设置光标颜色
    searchBar.tintColor = [UIColor colorWithRed:69 / 255.0 green:207 / 255.0 blue:79 / 255.0 alpha:1];
    [searchBar setSearchResultsButtonSelected:NO];
    self.navigationItem.titleView = titleView;
    self.searchBar = searchBar;
    
    //设置取消按钮
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(CGRectGetMaxX(self.searchBar.frame) + 10, 0, 40, 30);
    [titleView addSubview:cancleButton];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleSearchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:69 / 255.0 green:207 / 255.0 blue:79 / 255.0 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //设置缓存路径
    self.searchHistoryCache = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"SearchHistory.plist"];
    
    //设置tableView的分割线,可以自定义cell的分割线,这样就避免因为tableView过大造成显示多余的cell
//    self.historyRecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.historyRecordTableView.tableFooterView = [[UIView alloc]init];
    
    //footerView 清空历史记录
    UIView *footerView = [[UIView alloc]init];
    footerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    self.emptyAllHistoryLabel = [[UILabel alloc]init];
    self.emptyAllHistoryLabel.frame = footerView.bounds;
    self.emptyAllHistoryLabel.textColor = [UIColor darkGrayColor];
    self.emptyAllHistoryLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyAllHistoryLabel.font = [UIFont systemFontOfSize:14];
    self.emptyAllHistoryLabel.text = @"清空搜索历史";
    self.emptyAllHistoryLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emptyAllHistoryClick)];
    [self.emptyAllHistoryLabel addGestureRecognizer:tap];
    [footerView addSubview:self.emptyAllHistoryLabel];
    self.historyRecordTableView.tableFooterView = footerView;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.historyRecordTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.historyArray.count == 0) {
        self.emptyAllHistoryLabel.hidden = YES;
    } else {
        self.emptyAllHistoryLabel.hidden = NO;
    }
}

///取消搜索
- (void)cancleSearchButtonClick:(UIButton *)sender {
    //结束编辑,不再成为第一响应者
    [self.searchBar endEditing:YES];
    //点击取消按钮,让searchBar不再显示刚才搜索的内容
    self.searchBar.text = @"";
}
#pragma mark --MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (userLocation) {
        self.coordinate = userLocation.coordinate;
    }
}

#pragma mark -- UITableViewDelegate & UITablViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.historyArray ? self.historyArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserID = @"id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuserID];
    }
    cell.textLabel.text = self.historyArray[indexPath.row];
    //添加关闭按钮
    UIButton *closeButton = [[UIButton alloc]init];
    closeButton.frame = CGRectMake(0, 0, cell.frame.size.height, cell.frame.size.height);
    [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = closeButton;
    //左侧图片
    cell.imageView.image = [UIImage imageNamed:@"search_history"];
    return cell;
}

////组头文字
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return  @"搜索历史";
//}
//组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取当前的cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchBar.text = cell.textLabel.text;
    POISearchResultViewController *resultVc = [[POISearchResultViewController alloc]init];
    resultVc.keyWord = cell.textLabel.text;
    resultVc.coordinate = self.coordinate;
    [self.navigationController pushViewController:resultVc animated:YES];
    //存储搜索历史
    [self saveSearchHistory];
}

//关闭按钮的点击事件
- (void)closeButtonClick:(UIButton *)sender{
    //获取当前的cell
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    //删除信息
    [self.historyArray removeObject:cell.textLabel.text];
    //保存
    [NSKeyedArchiver archiveRootObject:self.historyArray toFile:self.searchHistoryCache];
    //刷新
    [self.historyRecordTableView reloadData];
    //如果数组为空,就隐藏搜索历史视图
    if (self.historyArray.count == 0) {
        self.emptyAllHistoryLabel.hidden = YES;
    }
}

///清空所有记录
- (void)emptyAllHistoryClick {
    [self.historyArray removeAllObjects];
    [NSKeyedArchiver archiveRootObject:self.historyArray toFile:self.searchHistoryCache];
    [self.historyRecordTableView reloadData];
    self.emptyAllHistoryLabel.hidden = YES;
}

#pragma  mark --UISearchDelegate
//要开始进行编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}

//点击键盘上的搜索按钮时调用的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.searchBar resignFirstResponder];
    [self saveSearchHistory];
    //跳转到结果显示的控制器
    POISearchResultViewController *resultVc = [[POISearchResultViewController alloc]init];
    resultVc.keyWord = searchBar.text;
    resultVc.coordinate = self.coordinate;
    [self.navigationController pushViewController:resultVc animated:YES];
}

///保存搜索历史并刷新
- (void)saveSearchHistory{
    UISearchBar *searchBar = self.searchBar;
    //先清除为了防止重复显示,在插入到第一个
    [self.historyArray removeObject:searchBar.text];
    [self.historyArray insertObject:searchBar.text atIndex:0];
    
    //如果多于20条就删除最后一个
    if (self.historyArray.count > 20) {
        [self.historyArray removeLastObject];
    }
    
    //保存信息  注意:不能直接将字符串存入文件中
    [NSKeyedArchiver archiveRootObject:self.historyArray toFile:self.searchHistoryCache];
    
    [self.historyRecordTableView reloadData];
    
}

@end
