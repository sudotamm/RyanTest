//
//  PannelViewController.m
//  RootDirectory
//
//  Created by Ryan on 13-2-28.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "PannelViewController.h"
#import "BaseViewController.h"
#import "MenuTableCell.h"

@interface PannelViewController ()

@end

@implementation PannelViewController

@synthesize naviViewController;

- (RootNaviViewController *)naviViewController
{
    if(nil == naviViewController)
    {
        naviViewController = [[UIStoryboard contentStoryBoard] instantiateInitialViewController];
        naviViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return naviViewController;
}

#pragma mark - Private methods
- (void)loadDefaultPage
{
    NSIndexPath *defaultPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.menuTableView selectRowAtIndexPath:defaultPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.menuTableView didSelectRowAtIndexPath:defaultPath];
}

#pragma mark - Notification methods
- (void)showEntranceViewWithNotification:(NSNotification *)notification
{
    if(self.naviViewController.viewControllers.count > 1)
    {
        UIViewController *entranceVC = [self.naviViewController.viewControllers objectAtIndex:1];
        [self.naviViewController popToViewController:entranceVC animated:NO];
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showEntranceViewWithNotification:) name:kShowEntranceViewNotification object:nil];
    self.menuTableView.tableFooterView = [UIView new];
    
    self.naviViewController.view.frame = self.contentContainView.bounds;
    [self.contentContainView addSubview:self.naviViewController.view];
    
    [self performSelector:@selector(loadDefaultPage) withObject:nil afterDelay:0];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [HomeDataManager sharedManager].menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableCell"];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_menu_selected"]];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    MenuModel *mm = [[HomeDataManager sharedManager].menuArray objectAtIndex:indexPath.row];
    [cell reloadWithMenuModel:mm];
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuModel *mm = [[HomeDataManager sharedManager].menuArray objectAtIndex:indexPath.row];
    if(mm.viewController.length > 0)
    {
        [self.naviViewController popToRootViewControllerAnimated:NO];
        BaseViewController *bvc = [[UIStoryboard contentStoryBoard] instantiateViewControllerWithIdentifier:mm.viewController];
        [self.naviViewController pushViewController:bvc animated:NO];
    }
}
@end
