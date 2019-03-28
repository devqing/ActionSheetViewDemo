//
//  ViewController.m
//  KBActionSheetViewDemo
//
//  Created by liuweiqing on 16/4/27.
//  Copyright © 2016年 RT. All rights reserved.
//

#import "ViewController.h"
#import "KBActionSheetView.h"






#define lwq 0

#define UI_WIDTH [UIScreen mainScreen].bounds.size.width
#define UI_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<KBActionSheetViewDelegate>

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
}

- (void)buttonClick1
{
    KBActionSheetView *sheet = [KBActionSheetView actionSheetWithTitle:nil buttonTitles:@[@"照相机",@"相册"] redButtonIndex:-1 delegate:self];
    
    [sheet show];
}
- (void)buttonClick2
{
    KBActionSheetView *sheet = [KBActionSheetView actionSheetWithTitle:@"头像选择" buttonTitles:@[@"照相机",@"相册"] redButtonIndex:-1 delegate:self];
    
    [sheet show];
}
- (void)buttonClick3
{
    KBActionSheetView *sheet = [KBActionSheetView actionSheetWithTitle:@"退出登录" buttonTitles:@[@"确定",@"重新登录"] redButtonIndex:0 delegate:self];
    
    [sheet show];
}
- (void)actionSheetView:(KBActionSheetView *)actionSheetView didClickTitleAtIndex:(NSInteger)index
{
    NSLog(@"%d",index);
}

#pragma mark --getter&setter
- (UIButton *)button1
{
    if (_button1 == nil) {
        _button1 = [[UIButton alloc] initWithFrame:CGRectMake((UI_WIDTH-100)/2, 100, 100, 35)];
        _button1.backgroundColor = [UIColor grayColor];
        [_button1 setTitle:@"无title" forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(buttonClick1) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

- (UIButton *)button2
{
    if (_button2 == nil) {
        _button2 = [[UIButton alloc] initWithFrame:CGRectMake((UI_WIDTH-100)/2, 150, 100, 35)];
        _button2.backgroundColor = [UIColor blueColor];
        [_button2 setTitle:@"有title" forState:UIControlStateNormal];
        [_button2 addTarget:self action:@selector(buttonClick2) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}

- (UIButton *)button3
{
    if (_button3 == nil) {
        _button3 = [[UIButton alloc] initWithFrame:CGRectMake((UI_WIDTH-100)/2, 200, 100, 35)];
        _button3.backgroundColor = [UIColor orangeColor];
        [_button3 setTitle:@"有redbutton" forState:UIControlStateNormal];
        [_button3 addTarget:self action:@selector(buttonClick3) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
}

@end
