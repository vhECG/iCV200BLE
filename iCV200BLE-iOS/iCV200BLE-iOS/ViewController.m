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

static iCV200BleController *device;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,NSEcgDeviceDelegate>{
    UIActivityIndicatorView *activity_view;
}
@property (nonatomic,strong) IBOutlet UITableView *devices_tableview;
@property (nonatomic,strong) IBOutlet UIButton *dis_connect_button;
@property (nonatomic,strong) IBOutlet UIButton *scan_device_button;
@end

@implementation ViewController
@synthesize devices_tableview;
@synthesize dis_connect_button;
@synthesize scan_device_button;

-(void)connect_iCV200_BLE:(NSString *)device_name{
    //stop show animate
    [activity_view stopAnimating];
    
    
    //Connect the selected device.
    [device connect_deviceWithName:device_name];
    
    dis_connect_button.enabled = YES;
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
    
    NSLog(@"Scan device started.");
    [device start_scan];
    
    
    //show scaning animated.
    if (nil == activity_view){
        activity_view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activity_view setFrame:CGRectMake(0.f, 0.f, 100.f, 100.f)];
        activity_view.layer.cornerRadius = 6.f;
        activity_view.layer.masksToBounds = YES;
        activity_view.layer.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.7].CGColor;
        [activity_view setCenter:scan_device_button.center];
        [self.view addSubview:activity_view];
    }
    [activity_view startAnimating];
    scan_device_button.enabled = NO;
    return;
}

-(IBAction)disconnected:(id)sender{
    //Stop get ECG
    //The connected iCV200(BLE) keep power ON while get ECG.
    //It is power Off after stop get.
    [device stop_get];
    
    
    dis_connect_button.enabled = NO;
    scan_device_button.enabled = YES;
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSLastiCV200BLE removeLastConnection];
    
    devices_tableview.delegate = self;
    devices_tableview.dataSource = self;
    dis_connect_button.enabled = NO;
    scan_device_button.enabled = YES;
}


#pragma mark - NSEcgDeviceDelegate start
// This function will be called when there is data parsed
// param data The parsed data in type of [[CGFloat]]
// [data objectAtIndex:0] is I
// [data objectAtIndex:1] is II
// [data objectAtIndex:2] is III
// [data objectAtIndex:3] is aVR
// [data objectAtIndex:4] is avL
// [data objectAtIndex:5] is avF
// [data objectAtIndex:6] is V1
// [data objectAtIndex:7] is V2
// [data objectAtIndex:8] is V3
// [data objectAtIndex:9] is V4
// [data objectAtIndex:10] is V5
// [data objectAtIndex:11] is V6
// Notice this call back function in thread.
- (void)dataReceivedWithData:(NSArray <NSArray <NSNumber *>*>* _Null_unspecified)data{
    //Receive ECG data from iCV200(BLE)
    NSLog(@"Received ECG data.");
    return;
}


// This function will be called when a heart beat rate is calculated. Show this rate on monitor
// param hbr The heart beat rate
// Notice this call back in thread.
- (void)heartBeatRateDetectedWithHbr:(int32_t)hbr{
    NSLog(@"Received hbr:%d",hbr);
    return;
}


//Notice this call back in thread
// This function is called to notify 8 lead connectivity status
// 0 == cr is connected else disconnect.
- (void)leadsConnectivityStatusUpdatedWithCr:(int16_t)cr cl:(int16_t)cl c1:(int16_t)c1 c2:(int16_t)c2 c3:(int16_t)c3 c4:(int16_t)c4 c5:(int16_t)c5 c6:(int16_t)c6{
    //Notice the line status.
    if (0 != cr){
        NSLog(@"CR Connection fall off.");
    }
    if (0 != cl){
        NSLog(@"CL Connection fall off.");
    }
    if (0 != c1){
        NSLog(@"C1 Connection fall off.");
    }
    if (0 != c2){
        NSLog(@"C2 Connection fall off.");
    }
    if (0 != c3){
        NSLog(@"C3 Connection fall off.");
    }
    if (0 != c4){
        NSLog(@"C4 Connection fall off.");
    }
    if (0 != c5){
        NSLog(@"C5 Connection fall off.");
    }
    if (0 != c6){
        NSLog(@"C6 Connection fall off.");
    }

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
