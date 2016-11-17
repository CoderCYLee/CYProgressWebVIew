//
//  ViewController.m
//  ProgressWebVIew
//
//  Created by Cyrill on 2016/10/15.
//  Copyright © 2016年 Cyrill. All rights reserved.
//

#import "ViewController.h"
#import "CYWKWebViewController.h"

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
}

- (IBAction)buttonTap:(id)sender {
    
    CYWKWebViewController *vc = [[CYWKWebViewController alloc] init];
    vc.url = [NSURL URLWithString:@"https://developer.apple.com"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
