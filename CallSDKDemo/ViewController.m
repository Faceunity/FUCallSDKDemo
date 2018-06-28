//
//  ViewController.m
//  CallSDKDemo
//
//  Created by wilderliao on 16/11/24.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self performSegueWithIdentifier:@"toCallLogin" sender:nil];
}


@end
