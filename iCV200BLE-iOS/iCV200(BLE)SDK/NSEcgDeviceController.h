//
//  NSEcgDeviceController.h
//
//

#import <Foundation/Foundation.h>

typedef void (^Completion_ECG_Device_Changed_Handler)(void);
typedef void (^Completion_Unsupport_BLE_Handler)(void);
typedef void (^Completion_Last_Device_Found_Handler)(void);

typedef NS_ENUM(NSInteger, iCV200BLEStatus) {
    iCV200BLEStatus_Unknown,
    iCV200BLEStatus_Scaning,
    iCV200BLEStatus_DisConnected,
    iCV200BLEStatus_Connecting,
    iCV200BLEStatus_Connected,
    unSupportThisDevice
};

NS_ASSUME_NONNULL_BEGIN
@protocol NSEcgDeviceDelegate;

@interface NSEcgDeviceController:NSObject{
    id <NSEcgDeviceDelegate> delegate;              //Receive ECG etc data.
    iCV200BLEStatus status;                         //The device status.
    float rate;                                     //ECG points per second.
    float uVpb;                                     //Value is float type and unit is uV.
    NSUInteger acfreq;                              //set filter AC Power for your local area.
    BOOL onFilter;                                  //
    float high_freq;                                //highPassFreq High pass frequency
    NSUInteger low_freq;                            //lowPassFreq Low pass frequency
    NSMutableArray *available_devices_array;
    NSString *current_connected_device_name;
    Completion_ECG_Device_Changed_Handler device_changed_handler;
    Completion_Unsupport_BLE_Handler unsupport_handler;
    Completion_Last_Device_Found_Handler last_device_found_handler;
}
@property (nonatomic) id <NSEcgDeviceDelegate> delegate;
@property (nonatomic,readonly) iCV200BLEStatus status;
@property (nonatomic,readonly) float rate;
@property (nonatomic,readonly) float uVpb;
@property (nonatomic) NSUInteger acfreq;
@property (nonatomic) BOOL onFilter;
@property (nonatomic) float high_freq;
@property (nonatomic) NSUInteger low_freq;
@property (readonly) NSMutableArray *available_devices_array;
@property (readonly) NSString *current_connected_device_name;
@property (nonatomic) Completion_ECG_Device_Changed_Handler device_changed_handler;
@property (nonatomic) Completion_Unsupport_BLE_Handler unsupport_handler;
@property (nonatomic) Completion_Last_Device_Found_Handler last_device_found_handler;

-(void)start_scan;
-(void)cancel_scan;

-(BOOL)connect_deviceWithName:(NSString *)device_name;
-(BOOL)connect_last_device;

-(BOOL)start_get;
-(BOOL)stop_get;

-(NSArray <NSString *>*)list_demo_ecg;
-(NSString *)load_current_demo_ecg_name;

-(BOOL)save_as_default_demo:(NSString *)ecg_name;

@end


@protocol NSEcgDeviceDelegate <NSObject>

@required
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
- (void)dataReceivedWithData:(NSArray <NSArray <NSNumber *>*>* _Null_unspecified)data;

// This function will be called when a heart beat rate is calculated. Show this rate on monitor
// param hbr The heart beat rate
// Notice this call back in thread.
- (void)heartBeatRateDetectedWithHbr:(int32_t)hbr;

//Notice this call back in thread
// This function is called to notify 8 lead connectivity status
// 0 == cr is connected else disconnect.
- (void)leadsConnectivityStatusUpdatedWithCr:(int16_t)cr cl:(int16_t)cl c1:(int16_t)c1 c2:(int16_t)c2 c3:(int16_t)c3 c4:(int16_t)c4 c5:(int16_t)c5 c6:(int16_t)c6;

@optional
- (void)dataErrorDetectedWithError:(NSError * _Null_unspecified)error;

@end

NS_ASSUME_NONNULL_END
