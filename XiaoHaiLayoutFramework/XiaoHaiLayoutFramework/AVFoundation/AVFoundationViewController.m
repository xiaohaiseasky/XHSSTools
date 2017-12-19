//
//  AVFoundationViewController.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/20.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "AVFoundationViewController.h"
#import "UIView+HNAXHSSLayoutTool.h"
#import "XHSSVideoPlayerCnotrolView.h"
#import <Photos/Photos.h>
#import <GLKit/GLKit.h>


@interface AVFoundationViewController ()

@property (nonatomic, strong) AVMutableComposition *composition;
@property (nonatomic, strong) AVMutableCompositionTrack *compositionTrack;
@property (nonatomic, assign) CGFloat composeTime;
@property (nonatomic, assign) int32_t titmeScale;
@property (nonatomic, assign) NSInteger currentVideoIndex;

@end

@implementation AVFoundationViewController {
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    UIView *_playerView;
    AVPlayerLayer *_playerLayer;
    
    //
    XHSSVideoPlayerCnotrolView *_playerControlView;
    
    //
    XHSSWaitingView *_waitingView;
    
    ///////////////////////////////////////////////////////////
    CGFloat _startTime;
    CGFloat _endTime;
    
    ///////////////////////////////////////////////////////////

}

#pragma mark - init
-(void)dealloc {
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    [self setUP];
}

- (void)setUP {
    [self setupUI];
}

- (void)setupUI {
    _playerView = [[UIView alloc] init];
    _playerView.widthEqualToView(self.view).heightEqualToNum(200).centerEqualToViewCenterPoint(self.view);
    _playerView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_playerView];
    
    _playerControlView = [[XHSSVideoPlayerCnotrolView alloc] init];
    _playerControlView.frame = CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200);
//    _playerControlView.duration = self.videoAsset.duration.value/self.videoAsset.duration.timescale;
//    __weak typeof(self) weakSelf = self;
//    _playerControlView.valueChangeCallback = ^(float leftValue, CGFloat rightValue, UIImageView *imageView) {
//        imageView.image = [weakSelf shotcutImageOfVideo:weakSelf.videoAsset atTime:leftValue > 0 ? leftValue : rightValue];
//        _startTime = leftValue < 0 ? : leftValue;
//        _endTime = rightValue < 0 ? : rightValue;
//    };
    __weak typeof(self) weakSelf = self;
    _playerControlView.doneCallback = ^{
        [weakSelf addVideoAtIndex:weakSelf.currentVideoIndex toComposition:weakSelf.composition];
    };
    [self editVideoAtIndex:_currentVideoIndex];
    [self.view addSubview:_playerControlView];
    
    _waitingView = [[XHSSWaitingView alloc] init];
    _waitingView.frame = CGRectMake(0, self.view.frame.size.height-100, 100, 100);
//    [self.view addSubview:_waitingView];
    
    /// test
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(200, 100, 100, 50);
    btn1.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(beginClipVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(200, 100, 100, 50);
    btn2.backgroundColor = [UIColor redColor];
    [btn2 addTarget:self action:@selector(beginClipVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)beginClipVideo {
    // clip video
    [self clipVideo:self.videoAsset];
}

#pragma mark -
#pragma mark - 循环处理选择的多个 video
- (void)editVideoAtIndex:(NSInteger)index {
    AVAsset *videoAsset = self.videoAssetsArr[index];
    
    if (!videoAsset) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _playerControlView.valueChangeCallback = ^(float leftValue, CGFloat rightValue, UIImageView *imageView) {
        imageView.image = [weakSelf shotcutImageOfVideo:videoAsset atTime:leftValue > 0 ? leftValue : rightValue];
        _startTime = leftValue < 0 ? : leftValue;
        _endTime = rightValue < 0 ? : rightValue;
    };
    _playerControlView.duration = videoAsset.duration.value/videoAsset.duration.timescale;
}

- (void)addVideoAtIndex:(NSInteger)index toComposition:(AVMutableComposition*)composition {
    AVAsset *videoAsset = self.videoAssetsArr[index];
    [self addVideo:videoAsset formTime:_startTime toTime:_endTime toComposition:composition];
    
    self.currentVideoIndex = ++index;
    if (index < self.videoAssetsArr.count) {
        [self editVideoAtIndex:index];
    } else {
        // 预览
        
        // 直接输出
        [self exportVideo:nil videoComposition:nil composition:composition];
    }
}

#pragma mark -
#pragma mark - 创建 composition
- (AVMutableComposition*)composition {
    if (_composition == nil) {
        _composition = [AVMutableComposition composition];
        _composeTime = 0;
        _titmeScale = 0;
    }
    return _composition;
}

- (AVMutableCompositionTrack*)compositionTrack {
    if (_compositionTrack == nil) {
        _compositionTrack = [_composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    }
    return _compositionTrack;
}

#pragma mark - 
#pragma mark - 将单个 video 加到 composition
- (void)addVideo:(AVAsset*)videoAsset formTime:(CGFloat)startTime toTime:(CGFloat)endTime toComposition:(AVMutableComposition*)composition {
    
    AVMutableCompositionTrack *compositionTrack = self.compositionTrack;
    // [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CMTimeRange videoRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    videoRange = CMTimeRangeMake(CMTimeMakeWithSeconds(_startTime, videoAsset.duration.timescale), CMTimeMakeWithSeconds(_endTime, videoAsset.duration.timescale));
    NSError *addToCompositionTrackError = nil;
    BOOL addSuccess = [compositionTrack insertTimeRange:videoRange ofTrack:videoTrack atTime:CMTimeMakeWithSeconds(self.composeTime, self.titmeScale) error:&addToCompositionTrackError];
    if (!addSuccess) {
        NSLog(@"add video to compositionTrack failed : %@", addToCompositionTrackError);
    }
    
    self.composeTime += videoRange.duration.value/videoRange.duration.timescale;
    
    
    
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject]];
    [layerInstruction setTransform:CGAffineTransformMakeTranslation(0, 0) atTime:kCMTimeZero];
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    [instruction setTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(startTime, videoAsset.duration.timescale), CMTimeMakeWithSeconds(endTime, videoAsset.duration.timescale))];
    instruction.layerInstructions = @[layerInstruction];
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.instructions = @[instruction];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    videoComposition.renderSize = CGSizeMake(_playerView.bounds.size.width, _playerView.bounds.size.height);
    
}

#pragma mark -
#pragma mark - 导出 video
- (void)exportVideo:(AVAsset*)videoAsset videoComposition:(AVMutableVideoComposition*)videoComposition composition:(AVMutableComposition*)composition {
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    if (videoAsset) {
        exportSession = [AVAssetExportSession exportSessionWithAsset:videoAsset presetName:AVAssetExportPresetMediumQuality];
    }
    if (videoComposition) {
        exportSession.videoComposition = videoComposition;
    }
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    //exportSession.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(_startTime, videoAsset.duration.timescale), CMTimeMakeWithSeconds(_endTime, videoAsset.duration.timescale));
    exportSession.outputURL = [NSURL fileURLWithPath:[self pathForVideoToSaveWithFileName:[self fileNameBaseTime]]];
    
    NSLog(@"filePath => %@", [self pathForVideoToSaveWithFileName:[self fileNameBaseTime]]);
    
    __block BOOL success = NO;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //
        });
        //
//        UISaveVideoAtPathToSavedPhotosAlbum(<#NSString * _Nonnull videoPath#>, <#id  _Nullable completionTarget#>, <#SEL  _Nullable completionSelector#>, <#void * _Nullable contextInfo#>)
        
        switch (exportSession.status) {
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"*********未知类型***********");
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"*********等待导出***********");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"*********正在导出***********");
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"*********导出完成***********");
                success = YES;
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"*********导出失败***********");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"*********取消导出***********");
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark -
#pragma mark - 编辑单个 video
- (void)clipVideo:(AVAsset*)videoAsset {
    
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    // AVMutableVideoCompositionLayerInstruction
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack]; // videoTrack composition
    CGAffineTransform transform = videoTrack.preferredTransform;
    transform = CGAffineTransformTranslate(transform, 100, 0);
//    [videoCompositionLayerInstruction setTransform:transform atTime:kCMTimeZero];
    
    
    
    // AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *videoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    videoCompositionInstruction.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(_startTime, videoAsset.duration.timescale), CMTimeMakeWithSeconds(_endTime, videoAsset.duration.timescale));
    // CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    videoCompositionInstruction.layerInstructions = @[videoCompositionLayerInstruction];
    
    
    
    // AVVideoCompositionCoreAnimationTool
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLyer = [CALayer layer];
    videoLyer.frame = CGRectMake(0, 0, 320, 320*9/16.0);
    parentLayer.frame = CGRectMake(0, 0, 320, 320*9/16.0);
    [parentLayer addSublayer:videoLyer];
    AVVideoCompositionCoreAnimationTool *videoCompositionAnimationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLyer inLayer:parentLayer];
    
    
    
    // AVMutableVideoComposition
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    CGFloat renderSizeWidth = videoTrack.naturalSize.width; // height
    videoComposition.renderSize = CGSizeMake(renderSizeWidth, renderSizeWidth*9/16.0);
    videoComposition.animationTool = videoCompositionAnimationTool;
    videoComposition.instructions = @[videoCompositionInstruction];
    
}
#pragma mark -
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
#pragma mark -
#pragma mark - 获取文件保存路径
- (NSString*)directoryForVideoToSaveWithSubPath:(NSString*)subPath {
    NSString *sandBoxPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *readyToSaveDirectory = [sandBoxPath stringByAppendingPathComponent:subPath];
    BOOL isExist = [fileManager fileExistsAtPath:readyToSaveDirectory];
    if (!isExist) {
        BOOL createSuccess = [fileManager createDirectoryAtPath:readyToSaveDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if (!createSuccess) {
            NSLog(@"创建目录失败");
            return nil;
        }
    }
    
    return readyToSaveDirectory;
}
- (NSString*)pathForVideoToSaveWithFileName:(NSString*)fileName {
    NSString *saveDirectory = [self directoryForVideoToSaveWithSubPath:@"composedVideo"];
    NSString *fullFileName = [NSString stringWithFormat:@"%@.mp4", fileName];
    return [saveDirectory stringByAppendingPathComponent:fullFileName];
}
- (NSString*)fileNameBaseTime {
    return [NSString stringWithFormat:@"%ld", time(NULL)];
}
#pragma mark -
#pragma mark - 播放 video
- (void)setupPlayerWithVideo:(AVAsset*)videoAsset {
    if (videoAsset == nil) {
        NSLog(@"videoAsset = nil");
        return;
    }
    _playerItem = [AVPlayerItem playerItemWithAsset:videoAsset];
    [self addObserverForPlayerItem];
    
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    [self addNotificationForSelf];
}
- (void)playInView:(UIView*)playView WithPlayer:(AVPlayer*)player {
    AVPlayerLayer *playerLayer = [AVPlayerLayer layer];
    [playView.layer addSublayer:playerLayer];
    playerLayer.frame = playView.layer.bounds;
    playerLayer.backgroundColor = [UIColor purpleColor].CGColor;
    [playerLayer setPlayer:player];
    
    [player play];
}

#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma amrk - player observer
- (void)addObserverForPlayerItem {
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addNotificationForSelf {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
}

- (void)moviePlayDidEnd:(AVPlayerItem *)item {
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    AVPlayerItem *playerItem = (AVPlayerItem*)object;
    if ([keyPath isEqualToString:@"status"]) {
        if (_playerItem.status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"ready to play");
            
            CMTime duration = playerItem.duration;
            CGFloat totalSecond = playerItem.duration.value/playerItem.duration.timescale; // 转换成秒
            
            NSLog(@"movie total duration:%f", CMTimeGetSeconds(duration));
        } else if (_playerItem.status == AVPlayerItemStatusFailed) {
            NSLog(@"player item failed");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        CMTime duration = playerItem.duration;
        CGFloat totalSeconds = CMTimeGetSeconds(duration);
        
    }
}

#if 0
// get video path
- (NSString*)pathOfAsset:(PHAsset*)asset {
    __block NSString* resultVideoPath = @"";
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        NSString *filePath = [info valueForKey:@"PHImageFileSandboxExtensionTokenKey"];
        if (filePath && filePath.length > 0) {
            NSArray *lyricArr = [filePath componentsSeparatedByString:@";"];
            NSString *privatePath = [lyricArr lastObject];
            if (privatePath.length > 8) {
                NSString *videoPath = [privatePath substringFromIndex:8];
                NSLog(@"videoPath = %@",videoPath);
                resultVideoPath = videoPath;
            }
        }
    }];
    return resultVideoPath;
}
#endif


#pragma mark - public api

@end





#pragma mark -
#pragma mark -
/**
 加载等待视图
 */
@interface XHSSWaitingView ()

@end

@implementation XHSSWaitingView {
    CAShapeLayer *_centerLayer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setupView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self setupView];
}


- (void)setupView {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat lineWidth = 3;
    
    CABasicAnimation *rotateAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    rotateAni.fromValue = 0; // @(10); // @(0);
    rotateAni.toValue = @(1); // @(30); // @(M_PI*2);
    rotateAni.duration = 3;
    [_centerLayer addAnimation:rotateAni forKey:@""];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(10, 10)];
    [path addLineToPoint:CGPointMake(10, height-10)];
    [path addLineToPoint:CGPointMake(width-10, height*0.5)];
    [path stroke];
    
    _centerLayer = [CAShapeLayer layer];
    _centerLayer.frame = self.bounds;
    _centerLayer.backgroundColor = [UIColor cyanColor].CGColor;
    _centerLayer.strokeColor = [UIColor greenColor].CGColor;
    _centerLayer.fillColor = [UIColor greenColor].CGColor;
    _centerLayer.lineWidth = lineWidth;
    _centerLayer.path = path.CGPath;
    
    [self.layer addSublayer:_centerLayer];
    
}

- (void)drawRect:(CGRect)rect {
//    CGFloat width = self.frame.size.width;
//    CGFloat height = self.frame.size.height;
//    CGFloat lineWidth = 3;
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, lineWidth);
//    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
//    
//    CGContextBeginPath(context);
//    CGContextAddArc(context, width/2.0, height/2.0, width*0.5-lineWidth*0.5, 0, M_PI*2, YES);
//    CGContextStrokePath(context);
}

@end




