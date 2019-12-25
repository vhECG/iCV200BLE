//
//  NSLastiCV200BLE.h
//  iCV200Ble
//
//  Created by Han Mingjie on 2019/12/6.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSLastiCV200BLE : NSObject

+(void)saveConnectedPeripheral:(CBPeripheral *)peripheral;
+(BOOL)hasConnection;
+(NSString *)lastConnectionDeviceName;
+(NSString *)lastConnectionDeviceUUID;

+(BOOL)removeLastConnection;
@end
NS_ASSUME_NONNULL_END
