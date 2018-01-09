//
//  MRLocationCityController.m
//  MRLocationControl
//
//  Created by MrXir on 2018/1/3.
//  Copyright © 2018年 MRXIR Inc. All rights reserved.
//

#import "MRLocationCityController.h"

#import "MRLocationControl.h"

#import <MRFramework/MRFoundation.h>

@interface MRLocationCityController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@property (nonatomic, weak) IBOutlet MRLocationControl *locationControl;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CLPlacemark *placemark;

@end

@implementation MRLocationCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *dismissItem = self.navigationItem.leftBarButtonItem;
    [dismissItem setTarget:self];
    [dismissItem setAction:@selector(dismiss)];
    
    [self.locationControl.titleButton setTitle:@"定位中..." forState:UIControlStateNormal];
    self.locationControl.titleButton.enabled = NO;
    self.locationControl.alwaysDisplayAlertWhenLocationDisabled = YES;
    self.locationControl.alwaysUseLocation = YES;
    self.locationControl.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    self.locationControl.locationCompletion = ^(MRLocationControl *locationControl, CLPlacemark *placemark, NSError *error) {
        
        if (error) {
            NSLog(@"定位失败: %@", error);
        } else {
            
            self.placemark = placemark;
            
            NSLog(@"\n\n地标: %@\n", placemark);
            NSLog(@"\n定位成功: %@", placemark.addressDictionary.stringWithUTF8);
            
            NSString *title = [NSString stringWithFormat:@"%@ • %@ - %@", placemark.country, placemark.locality, placemark.subLocality];
            
            [self.locationControl.titleButton setTitle:title forState:UIControlStateNormal];
            
            self.locationControl.titleButton.enabled = YES;
            
        }
        
    };
    
    [self.locationControl.titleButton addTarget:self action:@selector(selectLocationCity:) forControlEvents:UIControlEventTouchUpInside];
    
    self.searchBar.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)selectLocationCity:(UIButton *)button
{
    self.viewControllerDelegate.selectedCity = self.placemark.locality;
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"上海";
    } else {
        cell.textLabel.text = @"南京";
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *city = cell.textLabel.text;
    
    self.viewControllerDelegate.selectedCity = city;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    NSLog(@"选择: %@", city);
    
}

#pragma mark - search delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

#pragma mark - location life cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.locationControl startLocate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.locationControl stopLoacte];
}


@end
