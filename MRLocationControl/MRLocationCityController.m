//
//  MRLocationCityController.m
//  MRLocationControl
//
//  Created by MrXir on 2018/1/3.
//  Copyright © 2018年 MRXIR Inc. All rights reserved.
//

#import "MRLocationCityController.h"

@interface MRLocationCityController ()

@end

@implementation MRLocationCityController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *dismissItem = self.navigationItem.leftBarButtonItem;
    [dismissItem setTarget:self];
    [dismissItem setAction:@selector(dismiss)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
