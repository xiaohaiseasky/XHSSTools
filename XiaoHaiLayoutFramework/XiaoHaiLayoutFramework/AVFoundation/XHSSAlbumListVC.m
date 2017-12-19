//
//  XHSSAlbumListViewController.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/23.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSAlbumListVC.h"
#import <Photos/Photos.h>
#import "XHSSAssetPickerVC.h"

@interface XHSSAlbumListVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation XHSSAlbumListVC {
    UITableView *_albumListView;
    NSMutableArray *_albumListArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    [self setupUI];
    [self accessAblm];
}

- (void)setupUI {
    _albumListView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _albumListView.delegate = self;
    _albumListView.dataSource = self;
    [self.view addSubview:_albumListView];
}

- (void)setupData {
    _albumListArr = [NSMutableArray array];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XHSSAssetPickerVC *pickerVc = [[XHSSAssetPickerVC alloc] init];
    if (indexPath.section != 0) {
        pickerVc.assetCollection = _albumListArr[indexPath.row];
    }
    [self.navigationController pushViewController:pickerVc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return _albumListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"albumCell"];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"所有图片";
    } else {
        cell.textLabel.text = [(PHAssetCollection *)_albumListArr[indexPath.row] localizedTitle];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", [self assetsNumberOfAlbum:_albumListArr[indexPath.row]]];
    }
    return cell;
}

#pragma mark - access album
- (void)accessAblm {
    PHFetchResult *allAlbumResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (NSInteger i = 0; i < allAlbumResult.count; i++) {
        PHCollection *collection = allAlbumResult[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollectin = (PHAssetCollection *)collection;
            [_albumListArr addObject:assetCollectin];
        } else if ([collection isKindOfClass:[PHCollectionList class]]) {
            PHCollectionList *collectionList = (PHCollectionList *)collection;
        }
    }
    
    [_albumListView reloadData];
}

- (NSInteger)assetsNumberOfAlbum:(PHAssetCollection *)album {
    return [[PHAsset fetchAssetsInAssetCollection:album options:nil] count];
}

@end
