//
//  ViewController.m
//  iCV200BLE-iOS
//
//  Created by Han Mingjie on 2019/12/11.
//  Copyright © 2019 vhECG. All rights reserved.
//

#import "ViewController.h"
#import "NSEcgDeviceController.h"
#import "iCV200BleController.h"
#import "NSLastiCV200BLE.h"

//static NSEcgDeviceController *device;
static iCV200BleController *device;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,NSEcgDeviceDelegate>{
    UIActivityIndicatorView *activity_view;
}
@property (nonatomic,strong) IBOutlet UITableView *devices_tableview;
@end

@implementation ViewController
@synthesize devices_tableview;

-(void)connect_iCV200_BLE:(NSString *)device_name{
    [activity_view stopAnimating];
    //Connect the first Device.
    [device connect_deviceWithName:device_name];
}

-(IBAction)scan_start:(id)sender{
    if (nil == device){
        device = [[iCV200BleController alloc] init];
        device.delegate = self;
        device.acfreq = 50.f;
        device.onFilter = YES;
        device.high_freq = 0.05f;
        device.low_freq = 70.f;
    }
    
    device.device_changed_handler = ^{
        NSLog(@"Found iCV200(BLE) device:%@",device.available_devices_array);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->devices_tableview reloadData];
        });
    };
    device.last_device_found_handler = ^{
        NSLog(@"The last connected device found.");
    };
    //device.delegate =
    [device start_scan];
    NSLog(@"Scan device started.");
    //show scaning animated.
    if (nil == activity_view){
        activity_view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activity_view setFrame:CGRectMake(0.f, 0.f, 100.f, 100.f)];
        activity_view.layer.cornerRadius = 6.f;
        activity_view.layer.masksToBounds = YES;
        activity_view.layer.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.7].CGColor;
        [activity_view setCenter:self.view.center];
        [self.view addSubview:activity_view];
    }
    [activity_view startAnimating];
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSLastiCV200BLE removeLastConnection];
    
    devices_tableview.delegate = self;
    devices_tableview.dataSource = self;
}


#pragma mark - NSEcgDeviceDelegate start
- (void)dataReceivedWithData:(NSArray * _Null_unspecified)data{
    //Receive ECG data from iCV200(BLE)
    NSLog(@"Received ECG data.");
    return;
}

- (void)heartBeatRateDetectedWithHbr:(int32_t)hbr{
    //
    NSLog(@"Received hbr.");
    return;
}

- (void)leadsConnectivityStatusUpdatedWithCr:(int16_t)cr cl:(int16_t)cl c1:(int16_t)c1 c2:(int16_t)c2 c3:(int16_t)c3 c4:(int16_t)c4 c5:(int16_t)c5 c6:(int16_t)c6{
    //Notice the line status.
    return;
}

#pragma mark - NSEcgDeviceDelegate end



#pragma mark - UITableViewDelegate,UITableViewDataSource Start
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return device.available_devices_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cell_identifier_string = @"iCV200(BLE)_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier_string];
    if (nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_identifier_string];
    }
    cell.textLabel.text = [device.available_devices_array objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self connect_iCV200_BLE:[device.available_devices_array objectAtIndex:indexPath.row]];
    return;
}
#pragma mark - UITableViewDelegate,UITableViewDataSource End



@end
