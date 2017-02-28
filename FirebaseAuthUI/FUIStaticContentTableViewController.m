//
//  Copyright (c) 2017 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "FUIStaticContentTableViewController.h"

#import "FUIAuthUtils.h"

@interface FUIStaticContentTableViewController ()
{
  NSString *_headerText;
  NSString *_footerText;
  NSString *_actionTitle;
  __unsafe_unretained IBOutlet UILabel *_headerLabel;
  __unsafe_unretained IBOutlet UITableView *_tableView;
  __unsafe_unretained IBOutlet UIButton *_footerButton;
  FUIStaticContentTableViewManager *_tableViewManager;
  FUIStaticContentTableViewCellAction _nextAction;
  FUIStaticContentTableViewCellAction _footerAction;
}
@end

@implementation FUIStaticContentTableViewController

- (instancetype)initWithContents:(FUIStaticContentTableViewContent *)contents
                     nextTitle:(NSString *)nextTitle
                    nextAction:(FUIStaticContentTableViewCellAction)nextAction {
  return [self initWithContents:contents nextTitle:nextTitle nextAction:nextAction headerText:nil];
}

- (instancetype)initWithContents:(FUIStaticContentTableViewContent *)contents
                     nextTitle:(NSString *)nextTitle
                    nextAction:(FUIStaticContentTableViewCellAction)nextAction
                    headerText:(NSString *)headerText {
  return [self initWithContents:contents
                      nextTitle:nextTitle
                     nextAction:nextAction
                     headerText:headerText
                     footerText:nil
                   footerAction:nil];
}

- (instancetype)initWithContents:(FUIStaticContentTableViewContent *)contents
                       nextTitle:(NSString *)actionTitle
                      nextAction:(FUIStaticContentTableViewCellAction)nextAction
                      headerText:(NSString *)headerText
                      footerText:(NSString *)footerText
                    footerAction:(FUIStaticContentTableViewCellAction)footerAction {
  if (self = [self initWithNibName:NSStringFromClass([self class])
                            bundle:[FUIAuthUtils frameworkBundle]]) {
    _tableViewManager = [[FUIStaticContentTableViewManager alloc] init];
    _tableViewManager.contents = contents;
    _nextAction = [nextAction copy];
    _footerAction = [footerAction copy];
    _headerText = [headerText copy];
    _footerText = [footerText copy];
    _actionTitle = [actionTitle copy];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _tableViewManager.tableView = _tableView;
  _tableView.delegate = _tableViewManager;
  _tableView.dataSource = _tableViewManager;
  _headerLabel.text = _headerText ? _headerText : @"";
  if (!_footerText) {
    _tableView.tableFooterView.hidden = YES;
  } else {
    [_footerButton setTitle:_footerText forState:UIControlStateNormal];
  }

  UIBarButtonItem *actionButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:_actionTitle
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(onNext)];
  // TODO: add AccessibilityID
  //    actionButtonItem.accessibilityIdentifier = kSaveButtonAccessibilityID;
  self.navigationItem.rightBarButtonItem = actionButtonItem;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self updateHeaderSize];
}

- (void)updateHeaderSize {
  _headerLabel.preferredMaxLayoutWidth = _headerLabel.bounds.size.width;
  CGFloat height = [_tableView.tableHeaderView
                        systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  CGRect frame = _tableView.tableHeaderView.frame;
  frame.size.height = height;
  _tableView.tableHeaderView.frame = frame;
}

- (void)onNext {
  if (_nextAction) {
    _nextAction();
  }
}
- (IBAction)onFooterAction:(id)sender {
  if (_footerAction) {
    _footerAction();
  }
}

@end
