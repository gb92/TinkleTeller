//
//  TTBluetoothDeviceListDelegate.h
//  TinkleTeller
//
//  Created by Gavin Benedict on 2/22/14.
//
//

#import <Foundation/Foundation.h>

@protocol TTBluetoothDeviceListDelegate <NSObject>

-(void) deviceListUpdated:(NSArray *) deviceList;

@end
