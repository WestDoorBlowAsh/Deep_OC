//
//  DKVideoTool.m
//  DeepOC
//
//  Created by 邓凯 on 2018/11/29.
//  Copyright © 2018年 邓凯. All rights reserved.
//

#import "DKVideoTool.h"
#import "DKFileTool.h"
#import <AVFoundation/AVFoundation.h>

@interface DKVideoTool ()
{
    dispatch_queue_t audio_compression_queue, video_compression_queue;
}


@end

@implementation DKVideoTool

- (void)compressVideo:(NSURL *)videoUrl withOutputUrl:(NSURL *)outputUrl {
    NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:outputUrl.path error:nil];
    NSUInteger size = [attrs fileSize];
    NSLog(@"original video size at %@ is %.2f M", videoUrl.path, size/(1024*1024.0));
    
    AVAsset *asset = [AVAsset assetWithURL:videoUrl];
    AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:asset error:nil];
    AVAssetWriter *writer = [AVAssetWriter assetWriterWithURL:outputUrl fileType:AVFileTypeMPEG4 error:nil];
    
    // video part
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    AVAssetReaderTrackOutput *videoOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTrack outputSettings:[self videoCompressSettings]];
    AVAssetWriterInput *videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:[self videoCompressSettings]];
    if ([reader canAddOutput:videoOutput]) {
        [reader addOutput:videoOutput];
    }
    if ([writer canAddInput:videoInput]) {
        [writer addInput:videoInput];
    }
    
    // audio part
    AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    AVAssetReaderTrackOutput *audioOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:[self audioCompressSettings]]; // outputSetting可能不对
    AVAssetWriterInput *audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:[self audioCompressSettings]];
    if ([reader canAddOutput:audioOutput]) {
        [reader addOutput:audioOutput];
    }
    if ([writer canAddInput:audioInput]) {
        [writer addInput:audioInput];
    }
    
    [reader startReading];
    [writer startWriting];
    [writer startSessionAtSourceTime:kCMTimeZero];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    video_compression_queue = dispatch_queue_create("com.dk.video_compression_queue", NULL);
    [videoInput requestMediaDataWhenReadyOnQueue:video_compression_queue usingBlock:^{
        while ([videoInput isReadyForMoreMediaData]) {
            CMSampleBufferRef sampleBuffer;
            if ([reader status] == AVAssetReaderStatusReading && (sampleBuffer = [videoOutput copyNextSampleBuffer])) {
                BOOL result = [videoInput appendSampleBuffer:sampleBuffer];
                CFRetain(sampleBuffer);
                if (!result) {
                    [reader cancelReading];
                    break;
                } else {
                    [videoInput markAsFinished];
                    dispatch_group_leave(group);
                    break;
                }
            }
        }
    }];
    
    dispatch_group_enter(group);
    [audioInput requestMediaDataWhenReadyOnQueue:audio_compression_queue usingBlock:^{
        while ([audioInput isReadyForMoreMediaData]) {
            CMSampleBufferRef sampleBuffer;
            if ([reader status] == AVAssetReaderStatusReading && (sampleBuffer = [audioOutput copyNextSampleBuffer])) {
                BOOL result = [audioInput appendSampleBuffer:sampleBuffer];
                CFRelease(sampleBuffer);
                if (!result) {
                    [reader cancelReading];
                    break;
                }
            } else {
                [audioInput markAsFinished];
                dispatch_group_leave(group);
                break;
            }
        }
    }];
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([reader status] == AVAssetReaderStatusReading) {
            [reader cancelReading];
        }
        switch (writer.status) {
            case AVAssetWriterStatusWriting:
            {
                NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:outputUrl.path error:nil];
                NSUInteger size = [attrs fileSize];
                [writer finishWritingWithCompletionHandler:^{
                    NSLog(@"output at %@ is %.2f M ", outputUrl.path, size/(1024*1024.0));
                }];
                break;
            }
            default:
                break;
        }
    });
}

- (NSDictionary *)videoCompressSettings {
    NSDictionary *compressionProperties =
    @{
      AVVideoAverageBitRateKey: @(200 * 8 * 1024),
      AVVideoExpectedSourceFrameRateKey: @25,
      AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
      };
    
    NSDictionary *videoCompressionSettings =
    @{
      AVVideoCodecKey: AVVideoCodecTypeH264,
      AVVideoWidthKey: @960,
      AVVideoHeightKey: @540,
      AVVideoCompressionPropertiesKey: compressionProperties,
      AVVideoScalingModeKey: AVVideoScalingModeResizeAspectFill,
      };
    return videoCompressionSettings;
}

- (NSDictionary *)audioCompressSettings {
    AudioChannelLayout stereoChannelLayout =
    {
        .mChannelLayoutTag = kAudioChannelLayoutTag_Stereo,
        .mChannelBitmap = 0,
        .mNumberChannelDescriptions = 0,
    };
    NSData *channelLayoutAsData = [NSData dataWithBytes:&stereoChannelLayout length:offsetof(AudioChannelLayout, mChannelDescriptions)];
    NSDictionary *audioCompressSettings =
    @{
      AVFormatIDKey: @(kAudioFormatMPEG4AAC),
      AVEncoderBitRateKey: @96000,
      AVSampleRateKey: @44100,
      AVChannelLayoutKey: channelLayoutAsData,
      AVNumberOfChannelsKey: @2,
      };
    return audioCompressSettings;
}

@end
