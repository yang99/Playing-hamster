//
//  ViewController.m
//  杨垚-打地鼠
//
//  Created by rimi on 15/4/20.
//  Copyright (c) 2015年 yangyao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate,UIAlertViewDelegate>

{
    UIImageView   *_imgeView;
    UILabel       *_label;
    NSInteger     _count;
    NSInteger     _time;
}
- (void)initiasizeUserInterface;
- (void)proccessTimer;
- (void)imgeViewPressed;
- (void)buttonPressed:(UIButton *)sender;
- (void)buttonPressedStart:(UIButton *)sender;

@property (nonatomic,strong)NSTimer            *timer;

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"打地鼠";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initiasizeUserInterface];
}

- (void)initiasizeUserInterface{
    
//背景图片
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), CGRectGetMaxY(self.view.bounds)+70)];
    imageV.center = self.view.center;
    imageV.image = [UIImage imageNamed:@"grass.tiff"];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageV];
    [imageV release];
    
//地鼠动画
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:14];
    for (int i = 1; i<15; i++) {
        //先得到图片名称
        NSString *name = [NSString stringWithFormat:@"DS%d.png",i];
        UIImage *image = [UIImage imageNamed:name];
        [array addObject:image];
     }
    
    _imgeView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    _imgeView.contentMode = UIViewContentModeScaleAspectFit;
    _imgeView.animationDuration = 1.0;
    _imgeView.animationImages = array;

    
    [UIView animateWithDuration:1.0 animations:^{
        _imgeView.center = CGPointMake(arc4random()%600, arc4random()%300);
    } completion:^(BOOL finished) {
        [UIView setAnimationRepeatAutoreverses:YES];
        [UIView setAnimationRepeatCount:-1];
        
    [self.view addSubview:_imgeView];
          }];
    
//时间触发
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.6
                                              target:self
                                            selector:@selector(proccessTimer)
                                            userInfo:nil
                                            repeats:YES];
//手势
    _count = 0;
    _time = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(imgeViewPressed)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    _imgeView.userInteractionEnabled=YES;
    [_imgeView addGestureRecognizer:tap];
    [tap release];
    [array release];

//计数
    _label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 100, CGRectGetMidY(self.view.bounds), 100, 40)];
    _label.text = @"0";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor orangeColor];
    _label.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:_label];

    
    UIButton *buton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) + 100, CGRectGetMidY(self.view.bounds) + 100, 100, 40)];
    [buton setTitle:@"再次挑战" forState:UIControlStateNormal];
    buton.backgroundColor = [UIColor orangeColor];
    [buton.layer setCornerRadius:6.0];
    buton.tag = 100;
    [buton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buton];
    [buton release];
    
    UIButton *butonStart = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 200, CGRectGetMidY(self.view.bounds) + 100, 100, 40)];
    [butonStart setTitle:@"开始挑战" forState:UIControlStateNormal];
    butonStart.backgroundColor = [UIColor orangeColor];
    [butonStart.layer setCornerRadius:6.0];
    butonStart.tag = 101;
    [butonStart addTarget:self action:@selector(buttonPressedStart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butonStart];
    [butonStart release];
}



//时间调用
- (void)proccessTimer{
        _time++;
         CGFloat touchX = arc4random()%600;
        CGFloat touchY = arc4random()%350;
        CGPoint center = CGPointMake(touchX,touchY);
        _imgeView.center = center;

}


//点击手势
- (void)imgeViewPressed{
    if ([_label.text isEqualToString:@"0"]) {
        _label.text = @" ";
    }
    _label.text = [NSString stringWithFormat:@"%ld",_count];
    _count++;
    if (_count == 11) {
        [_imgeView stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜你" message:@"挑战成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.message = [NSString stringWithFormat:@"消耗时间%ld秒",_time];
        [alert show];
        [alert release];
        _imgeView.userInteractionEnabled = NO;
     }
 }


- (void)buttonPressed:(UIButton *)sender{
    UIButton *button = (UIButton *)[self.view viewWithTag:101];
    sender.hidden = YES;
    button.hidden = YES;
    [_imgeView startAnimating];
    _count = 0;
    _imgeView.userInteractionEnabled = YES;
    _label.text = [NSString stringWithFormat:@"%ld",_count];
    [self imgeViewPressed];
}

- (void)buttonPressedStart:(UIButton *)sender{
    UIButton *button = (UIButton *)[self.view viewWithTag:100];
    sender.hidden = YES;
    button.hidden = YES;
    [_imgeView startAnimating];
     _count = 0;
    _label.text = [NSString stringWithFormat:@"%ld",_count];
    _imgeView.userInteractionEnabled = YES;
    [self imgeViewPressed];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   UIButton *buttonStart = (UIButton *)[self.view viewWithTag:101];
   UIButton *button = (UIButton *)[self.view viewWithTag:100];
    button.hidden = NO;
    buttonStart.hidden = NO;
    _count = 0;
    _label.text = [NSString stringWithFormat:@"%ld",_count];
}

- (void)dealloc
{
    [super dealloc];
    [_imgeView release];
    [_label release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
