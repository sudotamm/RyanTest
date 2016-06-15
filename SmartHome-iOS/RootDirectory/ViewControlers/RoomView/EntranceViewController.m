//
//  EntranceViewController.m
//  SmartHome
//
//  Created by YuanRyan on 4/29/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

#import "EntranceViewController.h"
#import "RoomViewController.h"
#import "EntranceTableCell.h"
#import "EditNameView.h"

@interface EntranceViewController ()

@property (nonatomic, strong) RoomModel *delRoom;

@end

@implementation EntranceViewController

@synthesize nodataView;

- (NodataView *)nodataView
{
    if(nil == nodataView)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:self options:nil];
        nodataView = [nibs lastObject];
        nodataView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [nodataView reloadWithTitle:@"暂无房间信息" tip:@"请先添加"];
    }
    return nodataView;
}



#pragma mark - Notification methods
- (void)roomListChangedWithNotification:(NSNotification *)notification
{
    if([RoomDataManager sharedManager].home.rooms.count == 0)
    {
        self.tipView.hidden = NO;
        self.contentTableView.hidden = YES;
    }
    else
    {
        self.tipView.hidden = YES;
        self.contentTableView.hidden = NO;
    }
    
    [self.contentTableView reloadData];
}

#pragma mark - BaseViewController methods
- (void)rightItemTapped
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EditNameView" owner:self options:nil];
    EditNameView *env = [nibs lastObject];
    [env reloadWithTitle:kRenameRoom
             DefaultName:kDefaultRoomName
             placeholder:kRenameRoomTip
            confirmBlock:^(NSString *name) {
                RoomModel *rm = [[RoomModel alloc] initWithRYDict:nil];
                rm.name = name;
                [[RoomDataManager sharedManager] addRoom:rm inHome:[RoomDataManager sharedManager].home];
            }];
    [[RYRootBlurViewManager sharedManger] showWithBlurImage:[UIImage imageNamed:@"Transparent_bg"]
                                                contentView:env
                                                   position:CGPointZero
                                              adaptKeyboard:YES
                                                  touchHide:NO];
}

#pragma mark - UIViewController methods
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self roomListChangedWithNotification:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"我爱我家"];
    [self setRightNaviItemWithTitle:nil imageName:@"icon_add"];
    self.navigationItem.hidesBackButton = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomListChangedWithNotification:) name:kRoomListChangedNotification object:nil];
    
    self.nodataView.frame = self.tipView.bounds;
    [self.tipView addSubview:self.nodataView];
    
    [self roomListChangedWithNotification:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EntranceToRoom"])
    {
        RoomViewController *rvc = (RoomViewController *)(segue.destinationViewController);
        rvc.roomModel = sender;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [RoomDataManager sharedManager].home.rooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntranceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntranceTableCell"];
    RoomModel *rm = [[RoomDataManager sharedManager].home.rooms objectAtIndex:indexPath.row];
    [cell reloadWithRoomModel:rm index:indexPath.row];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        RoomModel *rm = [[RoomDataManager sharedManager].home.rooms objectAtIndex:indexPath.row];
        self.delRoom = rm;
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"删除房间" message:@"删除房间后不可恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [av show];
    }
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoomModel *rm = [[RoomDataManager sharedManager].home.rooms objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"EntranceToRoom" sender:rm];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[RoomDataManager sharedManager] deleteRoom:self.delRoom inHome:[RoomDataManager sharedManager].home];
    }
}
@end
