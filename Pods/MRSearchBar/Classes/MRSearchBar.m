//
//  MRSearchBar.m
//  MRSearchBar
//
//  Created by MR on 2017/12/15.
//  Copyright © 2017年 MR. All rights reserved.
//

#import "MRSearchBar.h"

@interface MRSearchBar ()<UITextFieldDelegate>

@end

@implementation MRSearchBar

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    id obj = [[NSBundle mainBundle] loadNibNamed:@"MRSearchBar" owner:self options:nil].lastObject;
    if ([obj isKindOfClass:[MRSearchBar class]]) {
        [obj setFrame:frame];
        return obj;
    }
    return nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textField.layer.cornerRadius = self.textField.bounds.size.height / 2;
    
    UIButton *searchScope = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [UIImage imageNamed:[self pathForResource:@"tui-search" type:@"png"]];
    [searchScope setImage:image forState:UIControlStateNormal];
    searchScope.tintColor = [UIColor grayColor];
    searchScope.frame = CGRectMake(0, 0, 28, 28);
    self.textField.leftView = searchScope;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    
    NSString *text = @"Search";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:text];
    [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, text.length)];
    [placeholder addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, text.length)];
    self.textField.attributedPlaceholder = placeholder;
    
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.enablesReturnKeyAutomatically = YES;
    [self.textField addTarget:self action:@selector(textFieldDidChangeEditing:) forControlEvents:UIControlEventEditingChanged];
    self.textField.delegate = self;
    
    [self.cancelButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - text field event and delegate handle

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    __weak typeof(self) _self = self;
    if (self.didBeginEditingHandler != NULL) {
        self.didBeginEditingHandler(_self, textField);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    __weak typeof(self) _self = self;
    if (self.didEndEditingHandler != NULL) {
        self.didEndEditingHandler(_self, textField);
    }
}

- (void)textFieldDidChangeEditing:(UITextField *)textField
{
    __weak typeof(self) _self = self;
    if (self.didChangeEditingHandler != NULL) {
        self.didChangeEditingHandler(_self, textField);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    __weak typeof(self) _self = self;
    if (self.didPressSearchKeyHandler != NULL) {
        self.didPressSearchKeyHandler(_self, textField);
    }
    return YES;
}

#pragma mark - action handle

- (void)didClickCancelButton:(UIButton *)button
{
    __weak typeof(self) _self = self;
    if (self.didPressCancelKeyHandler != NULL) {
        self.didPressCancelKeyHandler(_self, _self.textField);
    }
    [self.textField endEditing:YES];
}

#pragma mark - unit

- (NSString *)pathForResource:(NSString *)resource type:(NSString *)type
{
    NSBundle *imageBundle = nil;
    NSBundle *bundle = [NSBundle bundleForClass:[MRSearchBar class]];
    NSURL *url = [bundle URLForResource:@"MRSearchBar" withExtension:@"bundle"];
    imageBundle = [NSBundle bundleWithURL:url];
    return [imageBundle pathForResource:resource ofType:type];
}

@end

