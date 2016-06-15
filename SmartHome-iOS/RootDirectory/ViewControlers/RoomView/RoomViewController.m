//
//  RoomViewController.m
//  SmartHome
//
//  Created by YuanRyan on 4/26/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "RoomViewController.h"
#import "EditNameView.h"

#define kDeviceListViewWidth    300
#define kDeviceCellIdentify     @"DeviceCollectionCell"

@interface RoomViewController ()

@property (nonatomic, strong) DeviceModel *selectedDevice;
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation RoomViewController

@synthesize deviceListView, deviceControlView;
@synthesize nodataView;

- (NodataView *)nodataView
{
    if(nil == nodataView)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:self options:nil];
        nodataView = [nibs lastObject];
        nodataView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [nodataView reloadWithTitle:@"暂无设备信息" tip:@"请先添加"];
    }
    return nodataView;
}


#pragma mark - Properties methods

- (DeviceListView *)deviceListView
{
    if(nil == deviceListView)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DeviceListView" owner:self options:nil];
        deviceListView = [nibs lastObject];
        deviceListView.delegate = self;
        deviceListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return deviceListView;
}

- (DeviceControlView *)deviceControlView
{
    if(nil == deviceControlView)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DeviceControlView" owner:self options:nil];
        deviceControlView = [nibs lastObject];
        deviceControlView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return deviceControlView;
}

#pragma mark - Private methods
- (void)showRightContainView:(BOOL)show
{
    if(show)
    {
        if(self.rightViewWConstraint.constant == 0)
        {
            [UIView animateWithDuration:0.3f animations:^{
                self.rightViewWConstraint.constant = kDeviceListViewWidth;
                [self.contentCollectionView reloadData];
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    else
    {
        if(self.rightViewWConstraint.constant == kDeviceListViewWidth)
        {
            [UIView animateWithDuration:0.3f animations:^{
                self.rightViewWConstraint.constant = 0;
                [self.contentCollectionView reloadData];
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }
    }
}

- (void)toggleDeviceListView
{
    if(self.rightViewWConstraint.constant == 0)
        [self showDeviceListView:YES];
    else if(self.rightViewWConstraint.constant == kDeviceListViewWidth)
        [self showDeviceListView:NO];
}

- (void)showDeviceListView:(BOOL)show
{
    self.rightView.hidden = NO;
    self.rightBottomView.hidden = YES;
    [self.deviceListView reloadData];
    [self showRightContainView:show];
}

- (void)toggleDeivceControlView
{
    if(self.rightViewWConstraint.constant == 0)
        [self showDeviceControlView:YES];
    else if(self.rightViewWConstraint.constant == kDeviceListViewWidth)
        [self showDeviceControlView:NO];
}

- (void)showDeviceControlView:(BOOL)show
{
    self.rightView.hidden = YES;
    self.rightBottomView.hidden = NO;
    [self showRightContainView:show];
}

#pragma mark - Private methods
- (IBAction)longPressedWithGesture:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        self.isEdit = !(self.isEdit);
        [self.contentCollectionView reloadData];
    }
}

#pragma mark - Notification methods
- (void)roomDeviceChangedWithNotification:(NSNotification *)notification
{
    if(self.roomModel.devices.count == 0)
    {
        self.tipView.hidden = NO;
        self.contentCollectionView.hidden = YES;
    }
    else
    {
        self.tipView.hidden = YES;
        self.contentCollectionView.hidden = NO;
    }
    [self.contentCollectionView reloadData];
    
    DeviceModel *changedDevice = [[RoomDataManager sharedManager] deviceForAddress:self.selectedDevice.address];
    if(changedDevice)
    {
        [self.deviceControlView reloadWithDeviceModel:changedDevice];
    }
}

#pragma mark - BaseViewController methods

- (void)rightItemTapped
{
    self.selectedDevice = nil;
    [self.contentCollectionView reloadData];
    
    if(self.rightBottomView.hidden == NO)
    {
        [self showDeviceListView:YES];
    }
    else
        [self toggleDeviceListView];
}

- (void)leftItemTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:self.roomModel.name];
    [self setLeftNaviItemWithTitle:nil imageName:@"icon_back"];
    [self setRightNaviItemWithTitle:nil imageName:@"icon_add"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomDeviceChangedWithNotification:) name:kRoomDeviceChangedNotification object:nil];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"DeviceCollectionCell" bundle:nil] forCellWithReuseIdentifier:kDeviceCellIdentify];
    
    self.deviceListView.frame = self.rightView.bounds;
    [self.rightView addSubview:self.deviceListView];
    
    self.deviceControlView.frame = self.rightBottomView.bounds;
    [self.rightBottomView addSubview:self.deviceControlView];
    //hide right views as default
    self.rightViewWConstraint.constant = 0;
    //no data tip view
    self.nodataView.frame = self.tipView.bounds;
    [self.tipView addSubview:self.nodataView];
    
    [self roomDeviceChangedWithNotification:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.roomModel.devices.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceCollectionCell *deviceCell = [collectionView dequeueReusableCellWithReuseIdentifier:kDeviceCellIdentify forIndexPath:indexPath];
    DeviceModel *dm = [self.roomModel.devices objectAtIndex:indexPath.row];
    BOOL selected = NO;
    if([dm.address isEqualToString:self.selectedDevice.address])
        selected = YES;
    else
        selected = NO;
    kWeakSelf
    [deviceCell reloadWithDeviceModel:dm
                             selected:selected
                          deleteBlock:^(DeviceCollectionCell *cell) {
                              if([dm.address isEqualToString:self.selectedDevice.address])
                              {
                                  [self showDeviceControlView:NO];
                              }
                              
                              [[RoomDataManager sharedManager] removeDevice:dm inRoom:weakSelf.roomModel];
                              [weakSelf.contentCollectionView reloadData];
                              [[NSNotificationCenter defaultCenter] postNotificationName:kListDeviceChangedNotification object:nil];
                          }
                            editBlock:^(DeviceCollectionCell *cell) {
                                [weakSelf didAddDeviceWithListView:nil device:dm];
                            }];
    if(self.isEdit)
    {
        deviceCell.deleteButton.hidden = NO;
        deviceCell.editButton.hidden = NO;
        [deviceCell addShakeAnimation];
    }
    else
    {
        deviceCell.deleteButton.hidden = YES;
        deviceCell.editButton.hidden = YES;
        [deviceCell removeShakeAnimation];
    }
    return deviceCell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)(collectionView.collectionViewLayout);
    
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat contentWidth = viewWidth-self.rightViewWConstraint.constant;
    CGFloat inset = 10.f;
    if(self.rightViewWConstraint.constant == 0)
    {
        //展示4列
        inset = (contentWidth-layout.itemSize.width*4)/5;
    }
    else
    {
        //展示3列
        inset = (contentWidth-layout.itemSize.width*3)/4;
    }
    
    return floor(inset);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)(collectionView.collectionViewLayout);
    
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat contentWidth = viewWidth-self.rightViewWConstraint.constant;
    CGFloat inset = 10.f;
    if(self.rightViewWConstraint.constant == 0)
    {
        //展示4列
        inset = (contentWidth-layout.itemSize.width*4)/5;
    }
    else
    {
        //展示3列
        inset = (contentWidth-layout.itemSize.width*3)/4;
    }
    
    return floor(inset);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)(collectionView.collectionViewLayout);
    
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat contentWidth = viewWidth-self.rightViewWConstraint.constant;
    CGFloat inset = 10.f;
    if(self.rightViewWConstraint.constant == 0)
    {
        //展示4列
        inset = (contentWidth-layout.itemSize.width*4)/5;
    }
    else
    {
        //展示3列
        inset = (contentWidth-layout.itemSize.width*3)/4;
    }
    
    return UIEdgeInsetsMake(inset, inset, inset, inset);

}

#pragma mark - UICollectionViewDelegate methods

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([MqttDataManager sharedManager].session.status != MQTTSessionStatusConnected)
        return NO;
    DeviceModel *dm = [self.roomModel.devices objectAtIndex:indexPath.row];
    if(dm.deviceStatus == kDeviceStatusOffline)
        return NO;
    else
        return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([MqttDataManager sharedManager].session.status != MQTTSessionStatusConnected)
    {
      [SVProgressHUD showErrorWithStatus:kConnectingError];
        return;
    }
    [self showDeviceControlView:YES];
    DeviceModel *dm = [self.roomModel.devices objectAtIndex:indexPath.row];
    [self.deviceControlView reloadWithDeviceModel:dm];
    
    self.selectedDevice = dm;
    [collectionView reloadData];
}

#pragma mark - DeviceListViewDelegate methods
- (void)didAddDeviceWithListView:(DeviceListView *)listView device:(DeviceModel *)dm
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EditNameView" owner:self options:nil];
    EditNameView *env = [nibs lastObject];
    [env reloadWithTitle:kRenameDevice
             DefaultName:dm.name
             placeholder:kRenameDeviceTip
            confirmBlock:^(NSString *name) {
                dm.name = name;
                
                [[RoomDataManager sharedManager] addDevice:dm inRoom:self.roomModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:kListDeviceChangedNotification object:nil];
            }];
    [[RYRootBlurViewManager sharedManger] showWithBlurImage:[UIImage imageNamed:@"Transparent_bg"]
                                                contentView:env
                                                   position:CGPointZero
                                               adaptKeyboard:YES
                                                  touchHide:NO];
    
}
@end
