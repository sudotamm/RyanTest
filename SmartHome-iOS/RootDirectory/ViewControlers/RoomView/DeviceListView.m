//
//  DeviceListView.m
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "DeviceListView.h"
#import "DeviceTableCell.h"

#define kDeviceCellIdentify     @"DeviceCollectionCell"

@interface DeviceListView()

@property (nonatomic, strong) NSMutableArray *availbleArray;

@end

@implementation DeviceListView


#pragma mark - Public methods

- (void)reloadData
{
    self.availbleArray = [[RoomDataManager sharedManager] availableArray];
    [self.contentTableView reloadData];
}

#pragma mark - Notification methods
- (void)deviceListChangedWithNotification:(NSNotification *)notification
{
    [self reloadData];
}

#pragma mark - UIView methods

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentTableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceListChangedWithNotification:) name:kListDeviceChangedNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.availbleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cellIdentify";
    DeviceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if(nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DeviceTableCell" owner:self options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    if(self.availbleArray.count == 1)
    {
        cell.topLineImgView.hidden = YES;
        cell.bottomLineImgView.hidden = YES;
    }
    else
    {
        if(indexPath.row == 0)
        {
            cell.topLineImgView.hidden = YES;
            cell.bottomLineImgView.hidden = NO;
        }
        else if(indexPath.row == self.availbleArray.count-1)
        {
            cell.topLineImgView.hidden = NO;
            cell.bottomLineImgView.hidden = YES;
        }
        else
        {
            cell.topLineImgView.hidden = NO;
            cell.bottomLineImgView.hidden = NO;
        }
    }
    DeviceModel *dm = [self.availbleArray objectAtIndex:indexPath.row];
    [cell reloadWithDeviceModel:dm];
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35.f)];
    v.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 10.f, v.frame.size.width-30.f, v.frame.size.height-10.f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    label.textColor = [UIColor colorWithRed:167.f/255 green:185.f/255 blue:199.f/255 alpha:1.f];
    label.text = @"可添加设备列表";
    label.font = [UIFont systemFontOfSize:16.f];
    [v addSubview:label];
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeviceModel *dm = [self.availbleArray objectAtIndex:indexPath.row];
    if(dm.deviceType == kDeviceTypeUnkonw)
        return;
    [self.delegate didAddDeviceWithListView:self device:dm];
}
@end
