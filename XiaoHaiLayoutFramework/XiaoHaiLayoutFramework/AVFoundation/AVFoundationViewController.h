//
//  AVFoundationViewController.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/20.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AVFoundationViewController : UIViewController

@property (nonatomic, strong) AVAsset *videoAsset;
@property (nonatomic, strong) NSMutableArray *videoAssetsArr;

@end



/**
 等待加载视图
 */
@interface XHSSWaitingView : UIView

@end




/**
 
 AVCaptureSession
 
 AVCaptureDevice
 AVCaptureDeviceInput
 
 AVCaptureConnection
 
 AVCaptureOutput
 AVCaptureVideoDataOutput
 AVCaptureAudioDataOutput
 AVCaptureStillImageOutput
 
 AVAssetWriter
 AVAssetWriterInput
 
 
 PHPhotoLibrary[ios9] PHAssetCreationRequest , ALAssetsLibrary[ios8~]
 
 */


/**
 NSDictionary *videoCompressionSettings
    AVVideoCodecKey
    AVVideoWidthKey
    AVVideoHeightKey
    AVVideoCompressionPropertiesKey:
        AVVideoAverageBitRateKey
        AVVideoMaxKeyFrameIntervalKey
 
 
 NSDictionary *audioCompressionSettings
    AVFormatIDKey
    AVSampleRateKey
    AVEncoderBitRatePerChannelKey
    AVNumberOfChannelsKey
    AVChannelLayoutKey
 */


/**
 CMSampleBufferRef
 
 CMVideoDimensions
 
 AVCaptureFlashMode
 
 AVCaptureVideoOrientation
 
 CMFormatDescriptionRef
 
 AudioStreamBasicDescription
 
 AudioChannelLayout
 
 CMVideoDimensions
 
 
 CMMotionManager
 
 
 */



/**
 NSFileManager
 
 */
