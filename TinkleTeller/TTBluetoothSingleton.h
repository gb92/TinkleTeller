//
//  TTBluetoothSingleton.h
//  TinkleTeller
//
//  Created by Gavin Benedict on 2/22/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TTBluetoothDeviceListDelegate.h"

@interface TTBluetoothSingleton : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;

@property (strong, nonatomic) CBPeripheral  * connectedPeripheral;

@property (strong, nonatomic) NSMutableArray *discoveredDevices;

@property (weak, nonatomic) id deviceListDelegate;
+(TTBluetoothSingleton *) getInstance;

-(void) connectToPeripheral:(CBPeripheral *)peripheral;



@end
