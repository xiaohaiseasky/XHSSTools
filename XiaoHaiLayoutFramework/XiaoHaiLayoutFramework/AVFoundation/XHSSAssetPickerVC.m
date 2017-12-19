//
//  XHSSAssetPickerViewController.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/23.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSAssetPickerVC.h"
#import "AVFoundationViewController.h"
#import "XHSSImageBrowserVC.h"
#import <Photos/Photos.h>

static NSString * const kXHSSBeginSelecteAssetKey = @"kXHSSBeginSelecteAssetKey";
static NSString * const kXHSSEndSelecteAssetKey = @"kXHSSEndSelecteAssetKey";

@interface XHSSAssetPickerVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation XHSSAssetPickerVC {
    UICollectionView *_assetsListView;
    NSMutableArray *_imagesArr;
    NSMutableArray *_videosArr;
    NSMutableArray *_selectedImgArr;
    NSMutableArray *_selectedVideoArr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setup];
    
//    [self saveImageOrVideo];
}

- (void)setup {
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    _imagesArr = [NSMutableArray array];
    _videosArr = [NSMutableArray array];
    _selectedImgArr = [NSMutableArray array];
    _selectedVideoArr = [NSMutableArray array];
    
    [self addNotification];
}

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _assetsListView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _assetsListView.delegate = self;
    _assetsListView.dataSource = self;
    _assetsListView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_assetsListView];
    
    // 注册cell
    [_assetsListView registerClass:[XHSSCollectionViewImageItem class] forCellWithReuseIdentifier:@"XHSSCollectionViewImageItem"];
    [_assetsListView registerClass:[XHSSCollectionViewVideoItem class] forCellWithReuseIdentifier:@"XHSSCollectionViewVideoItem"];
    [_assetsListView registerClass:[XHSSCollectionSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XHSSCollectionSectionHeader"];
    
    [self loadAssets];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // show image page
        XHSSImageBrowserVC *imageBrowserVC = [[XHSSImageBrowserVC alloc] init];
        imageBrowserVC.imagesArr = _imagesArr;
        imageBrowserVC.currentIndex = indexPath.row;
        [self.navigationController pushViewController:imageBrowserVC animated:YES];
    } else if (indexPath.section == 1) {
        // show video page
        AVFoundationViewController *foundationVC = [[AVFoundationViewController alloc] init];
        foundationVC.videoAsset = _videosArr[indexPath.row];
        [self.navigationController pushViewController:foundationVC animated:YES];
    }
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _imagesArr.count;
    } else {
        return _videosArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if (indexPath.section == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XHSSCollectionViewImageItem" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[XHSSCollectionViewImageItem alloc] init];
        }
        [(XHSSCollectionViewImageItem *)cell setData:_imagesArr[indexPath.row]];
        [(XHSSCollectionViewImageItem *)cell setItemIndexPath:indexPath withCallback:^(XHSSAssetType assetType, BOOL isSelected, NSIndexPath *indexPath) {
            [self selecteAsset:assetType isSelected:isSelected indexPath:indexPath];
        }];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XHSSCollectionViewVideoItem" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[XHSSCollectionViewVideoItem alloc] init];
        }
        [(XHSSCollectionViewVideoItem *)cell setData:[self shotcutImageOfVideo:_videosArr[indexPath.row] atTime:7]];
        [(XHSSCollectionViewVideoItem *)cell setItemIndexPath:indexPath withCallback:^(XHSSAssetType assetType, BOOL isSelected, NSIndexPath *indexPath) {
            [self selecteAsset:assetType isSelected:isSelected indexPath:indexPath];
        }];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width/3 - 10, self.view.frame.size.width/3 - 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *secHeaderOrFooter = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        secHeaderOrFooter = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XHSSCollectionSectionHeader" forIndexPath:indexPath];
        if (secHeaderOrFooter == nil) {
            secHeaderOrFooter = [[XHSSCollectionSectionHeader alloc] init];
        }
        if (indexPath.section == 0) {
            [(XHSSCollectionSectionHeader *)secHeaderOrFooter setTitle:@"图片"];
        } else if (indexPath.section == 1) {
            [(XHSSCollectionSectionHeader *)secHeaderOrFooter setTitle:@"视频"];
        }
    }
    return secHeaderOrFooter;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 30);
}

#pragma mark - notification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kXHSSBeginSelecteAssetKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kXHSSEndSelecteAssetKey object:nil];
}

- (void)receiveNotification:(NSNotification*)notification {
    if ([notification.name isEqualToString:kXHSSBeginSelecteAssetKey]) {
        
    } else if ([notification.name isEqualToString:kXHSSEndSelecteAssetKey]) {
        AVFoundationViewController *foundationVC = [[AVFoundationViewController alloc] init];
        foundationVC.videoAssetsArr = _selectedVideoArr;
//        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.navigationController pushViewController:foundationVC animated:YES];
    }
}
#pragma mark - action
- (void)selecteAsset:(XHSSAssetType)assetType isSelected:(BOOL)isSelected indexPath:(NSIndexPath*)indexPath {
    switch (assetType) {
        case XHSSAssetTypeImage:
            if (isSelected) {
                [_selectedImgArr addObject:_imagesArr[indexPath.row]];
            } else {
                [_selectedImgArr removeObject:_imagesArr[indexPath.row]];
            }
            NSLog(@"_selectedImageArr.count = %ld", _selectedImgArr.count);
            break;
        case XHSSAssetTypeVideo:
            if (isSelected) {
                [_selectedVideoArr addObject:_videosArr[indexPath.row]];
            } else {
                [_selectedVideoArr removeObject:_videosArr[indexPath.row]];
            }
            NSLog(@"_selectedVideoArr.count = %ld", _selectedVideoArr.count);
            break;
        case XHSSAssetTypeAudio:
            
            break;
        default:
            break;
    }
}

#pragma mark - video
- (void)loadAssets {
    if (self.assetCollection == nil) {
        [self accessAllPhotos];
    } else {
        [self loadAssetsOfAlbum:self.assetCollection isFetchAll:NO group:dispatch_group_create()];
    }
}

- (void)loadAssetsOfAlbum:(PHAssetCollection *)album isFetchAll:(BOOL)isFetchAll group:(dispatch_group_t)group {
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        // sort by date
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:album options:fetchOptions];
        for (NSInteger i = 0; i < result.count; i++) {
            PHAsset *asset = result[i];
            
            switch (asset.mediaType) {
                case PHAssetMediaTypeImage:
                    [self fetchImageFormAsset:asset];
                    break;
                case PHAssetMediaTypeVideo:
                    [self fetchVideoformAsset:asset];
                    break;
                case PHAssetMediaTypeAudio:
                    NSLog(@"相册中包含的音频资源");
                    break;
                default:
                    NSLog(@"相册中包含的未知类型资源");
                    break;
            }
        }
        if (!isFetchAll) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_assetsListView reloadData];
            });
        }
    });
}

// fetch images
- (void)fetchImageFormAsset:(PHAsset *)asset {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    imageRequestOptions.synchronous = YES;
    // image
    PHImageManager *imageManager = [PHImageManager defaultManager]; // [[PHImageManager alloc] init];
    [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
            if (result) {
                [_imagesArr addObject:result];
            }
        }
    }];
}

// fetch videos
- (void)fetchVideoformAsset:(PHAsset *)asset {
    PHVideoRequestOptions *videoRequestOptions = [[PHVideoRequestOptions alloc] init];
    videoRequestOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    // video
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestAVAssetForVideo:asset options:videoRequestOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        if (asset) {
            [_videosArr addObject:asset]; //AVURLAsset
        }
    }];
}

- (void)accessAllPhotos {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 所有智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        for (NSInteger i = 0; i < smartAlbums.count; i++) {
            // 获取一个相册PHAssetCollection
            PHCollection *collection = (PHCollection *)smartAlbums[i];
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                [self loadAssetsOfAlbum:assetCollection isFetchAll:YES group:group];
            } else {
                NSAssert1(NO, @"Fetch collection not PHCollection: %@", collection);
            }
        }
        
        dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_assetsListView reloadData];
            });
        });
    });
}

#pragma mark - save Image
- (void)saveImageOrVideo {
    NSError *error = nil;
    __block PHObjectPlaceholder *placeHolder = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        placeHolder = [PHAssetCreationRequest creationRequestForAssetFromImage:[UIImage imageNamed:@""]].placeholderForCreatedAsset;
    } error:&error];
    
    // save video
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"video2" ofType:@"mp4"]]];
    } error:nil];
}

#pragma mark - 获取某个 video 的特定时间缩略图
- (UIImage*)shotcutImageOfVideo:(AVAsset*)videoAsset atTime:(NSTimeInterval)time {
    if (videoAsset == nil) return nil;
    
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:videoAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef imageRef = NULL;
    CFTimeInterval shotcutTime = time;
    NSError *shotcutError = nil;
    
    imageRef = [imageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(shotcutTime, videoAsset.duration.timescale)/*CMTimeMake(shotcutTime*videoAsset.duration.timescale, videoAsset.duration.timescale)*/ actualTime:NULL error:&shotcutError];
    if (!imageRef) {
        NSLog(@"error => %@", shotcutError);
    }
    UIImage *shotcutImage = [UIImage imageWithCGImage:imageRef];
    
    return shotcutImage;
}

@end




#pragma mark - base cell
@interface XHSSCollectionViewBaseItem ()

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) XHSSSelecteAssetCallback selecteAssetCallback;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation XHSSCollectionViewBaseItem {
    UIImageView *_imageView;
    XHSSSelecteTipView *_tipView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup {
    [self addNotification];
    [self setupUI];
}

// notification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kXHSSBeginSelecteAssetKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kXHSSEndSelecteAssetKey object:nil];
}

- (void)receiveNotification:(NSNotification*)notification {
    if ([notification.name isEqualToString:kXHSSBeginSelecteAssetKey]) {
        _tipView.hidden = NO;
        [_imageView.gestureRecognizers firstObject].enabled = YES;
    } else if ([notification.name isEqualToString:kXHSSEndSelecteAssetKey]) {
        _tipView.hidden = YES;
        [_imageView.gestureRecognizers firstObject].enabled = NO;
    }
}

// UI
- (void)setupUI {
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = self.contentView.bounds;
    _imageView.backgroundColor = [UIColor blueColor];
    _imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_imageView];
    
    CGFloat imgViewW = _imageView.frame.size.width;
    CGFloat imgViewH = _imageView.frame.size.width;
    _tipView = [[XHSSSelecteTipView alloc] init];
    _tipView.frame = CGRectMake(imgViewW-imgViewW*0.2, 0, imgViewW*0.2, imgViewH*0.2);
    [self.contentView addSubview:_tipView];
    
    [self addAction];
}

// action
- (void)addAction {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.enabled = NO;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [_imageView addGestureRecognizer:tap];
    [_imageView addGestureRecognizer:longPress];
}

- (void)tapAction:(UITapGestureRecognizer*)tap {
    _isSelected = !_isSelected;
    [_tipView setStrokeColor:_isSelected ? [UIColor greenColor] : [UIColor lightGrayColor]];
    if (_selecteAssetCallback) {
        _selecteAssetCallback(_indexPath.section == 0 ? XHSSAssetTypeImage : _indexPath.section == 1 ? XHSSAssetTypeVideo : XHSSAssetTypeAudio, _isSelected, _indexPath);
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer*)longPress {
    [[NSNotificationCenter defaultCenter] postNotificationName:kXHSSBeginSelecteAssetKey object:nil];
}

// public
- (void)setData:(UIImage *)image {
    _imageView.image = image;
}

- (void)setItemIndexPath:(NSIndexPath*)indexPath withCallback:(XHSSSelecteAssetCallback)callback {
    _indexPath = indexPath;
    _selecteAssetCallback = callback;
}

@end


/**
 cell 上选择提示视图
 */
@interface XHSSSelecteTipView ()

@end

@implementation XHSSSelecteTipView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor blackColor];
    self.strokeColor = [UIColor lightGrayColor];
    self.hidden = YES;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 3);
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, width/2.0, height/2.0, width*0.47, 0, M_PI*2, YES);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, width*0.2, height*0.5);
    CGContextAddLineToPoint(context, width*0.5, height*0.77);
    CGContextAddLineToPoint(context, width*0.8, height*0.2);
    CGContextStrokePath(context);
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

@end


#pragma mark - image cell
/**
 image cell
 */
@interface XHSSCollectionViewImageItem ()

@end

@implementation XHSSCollectionViewImageItem

@end



#pragma mark - video cell
/**
 video cell
 */
@interface XHSSCollectionViewVideoItem ()

@end

@implementation XHSSCollectionViewVideoItem

@end


#pragma mark - section header
/**
 section header
 */
@interface XHSSCollectionSectionHeader ()

@end

@implementation XHSSCollectionSectionHeader {
    UILabel *_titleLabel;
    UILabel *_countLabel;
    UIImageView *_finishBtnView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI {
    self.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat titleLabelW = 100;
    CGFloat titleLabelH = height;
    CGFloat titleLabelX = 10;
    CGFloat titleLabelY = 0;
    
    CGFloat countLabelW = 100;
    CGFloat countLabelH = height;
    CGFloat countLabelX = width*0.5-countLabelW*0.5;
    CGFloat countLabelY = 0;
    
    CGFloat finishBtnSpace = 5;
    CGFloat finishBtnW = width - finishBtnSpace*2 - countLabelX - countLabelW;
    CGFloat finishBtnH = height - finishBtnSpace*2;;
    CGFloat finishBtnX = width - finishBtnW - finishBtnSpace;
    CGFloat finishBtnY = finishBtnSpace;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    _titleLabel.textColor = [UIColor blueColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_titleLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.frame = CGRectMake(countLabelX, countLabelY, countLabelW, countLabelH);
    _countLabel.textColor = [UIColor blueColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_countLabel];
    
    _finishBtnView = [[UIImageView alloc] init];
    _finishBtnView.frame = CGRectMake(finishBtnX, finishBtnY, finishBtnW, finishBtnH);
    _finishBtnView.backgroundColor = [UIColor redColor];
    _finishBtnView.layer.cornerRadius = finishBtnH*0.5;
    _finishBtnView.clipsToBounds = YES;
    _finishBtnView.userInteractionEnabled = YES;
    [_finishBtnView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishBtnColick)]];
    [self addSubview:_finishBtnView];
    
    [self addObserver];
    [self showControls:NO];
}

- (void)setTitle:(NSString*)title {
    _titleLabel.text = title;
}

- (void)showControls:(BOOL)isShow {
    _countLabel.hidden = !isShow;
    _finishBtnView.hidden = !isShow;
}

#pragma mark - action
- (void)finishBtnColick {
    [self postNotification];
    [self showControls:NO];
}

#pragma mark - notification 
- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kXHSSBeginSelecteAssetKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kXHSSEndSelecteAssetKey object:nil];
}

- (void)receiveNotification:(NSNotification*)notification {
    if ([notification.name isEqualToString:kXHSSBeginSelecteAssetKey]) {
        [self showControls:YES];
    } else if ([notification.name isEqualToString:kXHSSEndSelecteAssetKey]) {
        
    }
}

- (void)postNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kXHSSEndSelecteAssetKey object:nil];
}

@end
