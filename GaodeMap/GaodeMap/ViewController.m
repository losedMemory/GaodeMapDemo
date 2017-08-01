//
//  ViewController.m
//  GaodeMap
//
//  Created by 周松 on 2017/7/26.
//  Copyright © 2017年 能环宝. All rights reserved.
//

#import "ViewController.h"
#import "LocationViewController.h"
#import "POISearchResultViewController.h"
#import "POISearchBarViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *textArray;

@end
static NSString *reuserId = @"reuseID";
@implementation ViewController
#pragma mark -- 懒加载

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)textArray {
    if (_textArray == nil) {
        _textArray = @[@"定位",@"POI检索"];
    }
    return _textArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuserId];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:69 / 255.0 green:207 / 255.0 blue:79 / 255.0 alpha:1]];
    self.title = @"高德地图使用";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId forIndexPath:indexPath];
    cell.textLabel.text = self.textArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //定位
    if (indexPath.row == 0) {
        LocationViewController *locationVc = [[LocationViewController alloc]init];
        [self.navigationController pushViewController:locationVc animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"定位" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    //POI检索
    if (indexPath.row == 1) {
        POISearchBarViewController *poiBarVc = [[POISearchBarViewController alloc]init];
        [self.navigationController pushViewController:poiBarVc animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"POI" style:UIBarButtonItemStylePlain target:nil action:nil];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
