//
//  MRSearchBar.h
//  MRSearchBar
//
//  Created by MR on 2017/12/15.
//  Copyright © 2017年 MR. All rights reserved.
//


#import <UIKit/UIKit.h>

@class MRSearchBar;

typedef void(^MRSearchBarDidBeginEditingHandler)(MRSearchBar *searchBar, UITextField *textField);

typedef void(^MRSearchBarDidEndEditingHandler)(MRSearchBar *searchBar, UITextField *textField);

typedef void(^MRSearchBarDidChangeEditingHandler)(MRSearchBar *searchBar, UITextField *textField);

typedef void(^MRSearchBarDidPressCancelKeyHandler)(MRSearchBar *searchBar, UITextField *textField);

typedef void(^MRSearchBarDidPressSearchKeyHandler)(MRSearchBar *searchBar, UITextField *textField);


/** An easy to yse search bar */
@interface MRSearchBar : UIView

@property (nonatomic, weak) IBOutlet UIView *backgroundView;

@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UITextField *textField;

@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@property (nonatomic, copy) MRSearchBarDidBeginEditingHandler didBeginEditingHandler;

@property (nonatomic, copy) MRSearchBarDidEndEditingHandler didEndEditingHandler;

@property (nonatomic, copy) MRSearchBarDidChangeEditingHandler didChangeEditingHandler;

@property (nonatomic, copy) MRSearchBarDidPressCancelKeyHandler didPressCancelKeyHandler;

@property (nonatomic, copy) MRSearchBarDidPressSearchKeyHandler didPressSearchKeyHandler;

- (instancetype)initWithFrame:(CGRect)frame;

@end
