//
//  ViewController.m
//  CA_OC
//
//  Created by jieyueHZJ on 2019/1/14.
//  Copyright © 2019年 jieyueHZJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *layerView;

@property (nonatomic, strong) CALayer *blueLayer;

@property (nonatomic, strong) UIImageView *imgView;

//@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *digitViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.layerView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
    [self.view addSubview:self.layerView];
    
    self.blueLayer = [CALayer layer];
    self.blueLayer.frame = CGRectMake(50, 50, 100, 100);
    self.blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layerView.layer addSublayer:self.blueLayer];
    
    UIImage *maskImage = [UIImage imageNamed:@"Cone.png"];
    self.blueLayer.contents = (__bridge id)maskImage.CGImage;

    [self transform3D_play];
}


- (void)transform3D_play {
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0 / 500.f;
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    self.layerView.layer.transform = transform;
}

- (void)transform_play {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
    self.layerView.layer.affineTransform = transform;
    
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformScale(t, 0.5, 0.5);
    t = CGAffineTransformRotate(t, M_PI_4);
    self.layerView.layer.affineTransform = t;
    
//    
}

- (void)mask_play {
    
    UIImage *image = [UIImage imageNamed:@"Igloo.png"];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 400, 300, 300)];
    [self.view addSubview:self.imgView];
    self.imgView.image = image;
    
    UIImage *maskImage = [UIImage imageNamed:@"Cone.png"];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.imgView.bounds;
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    
    self.imgView.layer.mask = maskLayer;
}

- (void)shadow_play {
    // 指定 阴影. 更复杂的图形用 UIBezierPath
    self.blueLayer.shadowOpacity = 0.5f;
    self.blueLayer.shadowOffset = CGSizeMake(0, 3);
    self.blueLayer.shadowRadius = 50;
    
    CGMutablePathRef squarePath = CGPathCreateMutable();
    CGPathAddRect(squarePath, NULL, self.blueLayer.bounds);
    //    CGPathAddEllipseInRect(squarePath, NULL, self.blueLayer.bounds);
    self.blueLayer.shadowPath = squarePath;
}

@end
