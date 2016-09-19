//
//  SLImageViewerView.m
//  SLCustomizeCamera-demo
//
//  Created by 杨艳东 on 16/9/18.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "SLImageViewerView.h"
#import "UIImage+Orientation.h"

@interface SLImageViewerView ()<UIScrollViewDelegate>
{
    /** 展示的图片 */
    UIImageView *showImageView;
}
@end

@implementation SLImageViewerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.exclusiveTouch = YES; // 只能同时触发一个事件或手势
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 2.0f;
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = selected ? 2 : 0;
}

-(void)setContentImage:(UIImage *)contentImage
{
    _contentImage = contentImage;
    
    if (showImageView)
    {
        self.zoomScale = 1;
        showImageView.image = contentImage;
        
        [UIView animateWithDuration:.4 animations:^{
            
            showImageView.frame = [self resizedFrameForImageSize:contentImage.size];
        }];

        [self adjustContentSize];
        return;
    }
    
    showImageView = [[UIImageView alloc] init];
    showImageView.image = contentImage;
    showImageView.frame = [self resizedFrameForImageSize:contentImage.size];

    [self adjustContentSize];
    [self addSubview:showImageView];
}

-(CGRect)resizedFrameForImageSize:(CGSize)size
{
    CGFloat showWidth  = MIN(size.width, self.frame.size.width);
    CGFloat showHeight = showWidth * size.height / size.width;
    
    return CGRectMake(0, 0, showWidth, showHeight);
}

-(void)setDirectionType:(NSInteger)directionType
{
    _directionType = directionType;
    
    CGAffineTransform transform = directionType ? CGAffineTransformMakeRotation(M_PI_2 * directionType) : CGAffineTransformIdentity;
    
    [UIView animateWithDuration:.5 animations:^{
       
        self.transform = transform;
    }];
    
}

-(UIImage *)editedImage
{
    UIImageOrientation orientation = self.contentImage.imageOrientation;;
    
    switch (self.directionType)
    {
        case 0:
            orientation = UIImageOrientationUp;
            break;
            
        case 1:
            orientation = UIImageOrientationRight;
            break;
            
        case 2:
            orientation = UIImageOrientationDown;
            break;
            
        case 3:
            orientation = UIImageOrientationLeft;
            break;
    }
    
    
    CGImageRef takenCGImage = self.contentImage.CGImage;
    size_t width = CGImageGetWidth(takenCGImage);
    size_t height = CGImageGetHeight(takenCGImage);
    
    CGFloat image_width = self.contentSize.width;
    CGFloat image_height = self.contentSize.height;
    CGRect cropRect = CGRectMake(self.contentOffset.x / image_width * width,
                                 self.contentOffset.y / image_height * height,
                                 self.frame.size.width / image_width * width,
                                 self.frame.size.height / image_height * height);
    
    CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
    UIImage *image = [UIImage imageWithCGImage:cropCGImage scale:self.contentImage.scale orientation:orientation];
    CGImageRelease(cropCGImage);
    
    image = [image fixOrientation];
    
    return image;
}

#pragma mark - scroll delegete
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self adjustContentSize];
}

-(void)adjustContentSize
{
    CGFloat width  = MAX(showImageView.frame.size.width, self.frame.size.width);
    CGFloat height = MAX(showImageView.frame.size.height, self.frame.size.height);
    
    self.contentSize = CGSizeMake(width, height);
    
    showImageView.center = CGPointMake(width / 2.0, height / 2.0);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return showImageView;
}


@end
