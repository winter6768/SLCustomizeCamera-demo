//
//  SLSingleViewController.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/7.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLSingleViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "CALayer+SLCameraAnimation.h"
#import "UIImage+Orientation.h"

#import "SLCompareViewController.h"
#import "SLPSImageViewController.h"
#import "SLAlbumsViewController.h"

@interface SLSingleViewController ()
{
    /** 是否使用前置摄像头 */
    BOOL usingFrontFacingCamera;
    
    UIView *view_light;
    
    CALayer *layer_grid;
    
    UIButton *btn_light;
}

@property(nonatomic,strong)AVCaptureSession *session;

@property(nonatomic,strong)AVCaptureDeviceInput *deviceInput;

@property(nonatomic,strong)AVCaptureStillImageOutput *stillImageOutput;

@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation SLSingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:49/255.0 green:46/255.0 blue:63/255.0 alpha:1];

    [self initAVCaptureSession];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.session)
    {
        [self.session startRunning];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.session)
    {
        [self.session stopRunning];
    }
}

#pragma mark - 初始化
-(void)initAVCaptureSession
{
    self.session = [[AVCaptureSession alloc]init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    NSError *error;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [device lockForConfiguration:nil];
    
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.deviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:device error:&error];
    
    if (error)
    {
        NSLog(@"%@",error);
    }
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    [self.stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
    
    if ([self.session canAddInput:self.deviceInput])
    {
        [self.session addInput:self.deviceInput];
    }
    
    if ([self.session canAddOutput:self.stillImageOutput])
    {
        [self.session addOutput:self.stillImageOutput];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.previewLayer.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.width);
    self.previewLayer.masksToBounds = YES;
    [self.view.layer addSublayer:self.previewLayer];
}

-(void)setupUI
{
    //    闪光灯
    btn_light = [UIButton new];
    btn_light.frame = CGRectMake(10, 0, 50, 50);
    [btn_light setImage:[UIImage imageNamed:@"cameraLightAuto"] forState:UIControlStateNormal];
    [btn_light addTarget:self action:@selector(cameraLight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_light];
    
    //    镜头转换
    UIButton *btn_turn = [UIButton new];
    btn_turn.frame = CGRectMake(self.view.frame.size.width / 2.0 - 25, 0, 50, 50);
    [btn_turn setImage:[UIImage imageNamed:@"cameraTurn"] forState:UIControlStateNormal];
    [btn_turn addTarget:self action:@selector(cameraTurn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_turn];
    
    //    九宫格
    UIButton *btn_grid = [UIButton new];
    btn_grid.frame = CGRectMake(self.view.frame.size.width - 60, 0, 50, 50);
    [btn_grid setImage:[UIImage imageNamed:@"cameraGridOff"] forState:UIControlStateNormal];
    [btn_grid addTarget:self action:@selector(cameraGrid:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_grid];
    
    CGFloat bottomSpaceHeight = self.view.frame.size.height - self.previewLayer.frame.origin.y - self.previewLayer.frame.size.height;
    
    bottomSpaceHeight = self.compareShootBlock ? bottomSpaceHeight : bottomSpaceHeight - 50;
    
    //    拍摄
    UIButton *btn_shoot = [UIButton new];
    btn_shoot.frame = CGRectMake(0, 0, 80, 80);
    btn_shoot.center = CGPointMake(self.view.center.x, self.view.frame.size.height - bottomSpaceHeight / 2.0);
    [btn_shoot setImage:[UIImage imageNamed:@"cameraShoot"] forState:UIControlStateNormal];
    [btn_shoot addTarget:self action:@selector(cameraShoot:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_shoot];
    
    //    关闭
    UIButton *btn_close = [UIButton new];
    btn_close.frame = CGRectMake(0, 0, 50, 50);
    btn_close.center = CGPointMake(self.view.frame.size.width / 4.0 - btn_shoot.frame.size.width / 4.0, btn_shoot.center.y);
    [btn_close setImage:[UIImage imageNamed:@"cameraClose"] forState:UIControlStateNormal];
    [btn_close addTarget:self action:@selector(cameraClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_close];
    
    if (self.compareShootBlock)
    {
        return;
    }
    
    //    单图
    UIButton *btn_single = [UIButton new];
    btn_single.frame = CGRectMake(0, self.previewLayer.frame.origin.y + self.previewLayer.frame.size.height, 50, 50);
    btn_single.center = CGPointMake(self.view.center.x, btn_single.center.y);
    [btn_single setTitle:@"单图" forState:UIControlStateNormal];
    [btn_single setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_single.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:btn_single];
    
    //    对比图
    UIButton *btn_compare = [UIButton new];
    btn_compare.frame = CGRectMake(btn_single.frame.size.width + btn_single.frame.origin.x, btn_single.frame.origin.y, 70, 50);
    [btn_compare setTitle:@"对比图" forState:UIControlStateNormal];
    [btn_compare setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    [btn_compare addTarget:self action:@selector(cameraCompare:) forControlEvents:UIControlEventTouchUpInside];
    btn_compare.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:btn_compare];
    
    //    相册
    UIImageView *image_photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 46, 46)];
    image_photo.center = CGPointMake(self.view.frame.size.width / 4.0 * 3 + btn_shoot.frame.size.width / 4.0, btn_shoot.center.y);
    image_photo.userInteractionEnabled = YES;
    image_photo.backgroundColor = [UIColor lightGrayColor];
    [image_photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraAlbums:)]];
    [self.view addSubview:image_photo];
}

#pragma mark - 闪光灯
-(void)cameraLight:(UIButton *)button
{
    if (!view_light)
    {
        CGFloat x = button.frame.origin.x * 2 + button.frame.size.width;
        
        view_light = [[UIView alloc]initWithFrame:CGRectMake(x, 0, self.view.frame.size.width - x, 50)];
        view_light.backgroundColor = self.view.backgroundColor;
        view_light.alpha = 0;
        [self.view addSubview:view_light];
        
        CGFloat width = view_light.frame.size.width / 3.0;
        NSArray *arr_item = @[@"自动",@"打开",@"关闭"];
        
        for (int i = 0; i < arr_item.count; i ++)
        {
            UIButton *btn = [UIButton new];
            btn.frame = CGRectMake(width * i, 0, width, view_light.frame.size.height);
            [btn setTitle:arr_item[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(cameraLightSelect:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [view_light addSubview:btn];
        }
    }
    
    [view_light.subviews enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * stop) {
        
        obj.selected = (obj.tag == [self currentFlashMode]);
    }];
    
    [UIView animateWithDuration:.3 animations:^{
        
        view_light.alpha = !view_light.alpha;
    }];
}

-(void)cameraLightSelect:(UIButton *)button
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    
    UIImage *image = button.currentImage;
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([device hasFlash])
    {
        if (button.tag == 0)
        {
            device.flashMode = AVCaptureFlashModeAuto;
            image = [UIImage imageNamed:@"cameraLightAuto"];
        }
        else if (button.tag == 1)
        {
            device.flashMode = AVCaptureFlashModeOn;
            image = [UIImage imageNamed:@"cameraLightOn"];
        }
        else if (button.tag == 2)
        {
            device.flashMode = AVCaptureFlashModeOff;
            image = [UIImage imageNamed:@"cameraLightOff"];
        }
    }
    else
    {
        NSLog(@"设备不支持闪光灯");
    }
    
    [device unlockForConfiguration];
    
    
    [UIView animateWithDuration:.3 animations:^{
        
        view_light.alpha = 0;
        [btn_light setImage:image forState:UIControlStateNormal];
    }];
}

-(NSInteger)currentFlashMode
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([device hasFlash])
    {
        if (device.flashMode == AVCaptureFlashModeOff)
        {
            return 2;
        }
        else if (device.flashMode == AVCaptureFlashModeOn)
        {
            return 1;
        }
        else if (device.flashMode == AVCaptureFlashModeAuto)
        {
            return 0;
        }
    }
    
    return -1;
}

#pragma mark - 转换摄像头
-(void)cameraTurn:(UIButton *)button
{
    [self.previewLayer SLCameraAnimation];
    
    AVCaptureDevicePosition position = usingFrontFacingCamera ? AVCaptureDevicePositionBack :AVCaptureDevicePositionFront;
    
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo])
    {
        if ([device position] == position)
        {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs)
            {
                [[self.previewLayer session] removeInput:oldInput];
            }
            
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    
    usingFrontFacingCamera = !usingFrontFacingCamera;
}

#pragma mark - 九宫格
-(void)cameraGrid:(UIButton *)button
{
    if (!layer_grid)
    {
        layer_grid = [CALayer layer];
        layer_grid.frame = self.previewLayer.bounds;
        layer_grid.hidden = YES;
        [self.previewLayer addSublayer:layer_grid];
        
        CGFloat width = layer_grid.frame.size.width;
        
        for (int i = 1; i < 3; i ++)
        {
            CALayer *layer_h = [CALayer layer];
            layer_h.backgroundColor = [UIColor whiteColor].CGColor;
            layer_h.frame = CGRectMake(0, width / 3.0 * i, width, .5);
            [layer_grid addSublayer:layer_h];
            
            CALayer *layer_v = [CALayer layer];
            layer_v.backgroundColor = [UIColor whiteColor].CGColor;
            layer_v.frame = CGRectMake(width / 3.0 * i, 0, .5, width);
            [layer_grid addSublayer:layer_v];
        }
    }
    
    layer_grid.hidden = !layer_grid.hidden;
    [button setImage:layer_grid.hidden ? [UIImage imageNamed:@"cameraGridOff"] : [UIImage imageNamed:@"cameraGridOn"] forState:UIControlStateNormal];
}

#pragma mark - 拍摄
-(void)cameraShoot:(UIButton *)button
{
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:jpegData];
        
        image = [self cropImageUsingPreviewBounds:image];
        
        if (self.compareShootBlock)
        {
            self.compareShootBlock(image);
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            SLPSImageViewController *psImage = [[SLPSImageViewController alloc]init];
            psImage.image = image;
            [self.navigationController pushViewController:psImage animated:YES];
        }
    }];
}

- (UIImage *)cropImageUsingPreviewBounds:(UIImage *)image
{
    CGRect previewBounds = self.previewLayer.bounds;
    CGRect outputRect = [self.previewLayer metadataOutputRectOfInterestForRect:previewBounds];
    
    CGImageRef takenCGImage = image.CGImage;
    size_t width = CGImageGetWidth(takenCGImage);
    size_t height = CGImageGetHeight(takenCGImage);
    CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height,
                                 outputRect.size.width * width, outputRect.size.height * height);
    
    CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
    
    
//    系统自带的相机 拍出的照片是原始尺寸，scale 为 1 方向是默认方向
//    CGFloat scale = cropRect.size.height / previewBounds.size.height;
    image = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:image.imageOrientation];
    
    CGImageRelease(cropCGImage);
    
    //  iOS以 home键在右侧为默认图片方向，所以需要先把图片方向转过来
    image = [image fixOrientation];
    
    return image;
}

#pragma mark - 对比图
-(void)cameraCompare:(UIButton *)button
{
    SLCompareViewController *compare = [[SLCompareViewController alloc]init];
    [self.navigationController pushViewController:compare animated:YES];
}

#pragma mark - 相册
-(void)cameraAlbums:(UITapGestureRecognizer *)tap
{
    SLAlbumsViewController *cus = [[SLAlbumsViewController alloc]init];
    [self.navigationController pushViewController:cus animated:YES];
}

#pragma mark - 关闭
-(void)cameraClose:(UIButton *)button
{
    NSArray *arr = self.navigationController.childViewControllers;
    
    if (arr.count > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
