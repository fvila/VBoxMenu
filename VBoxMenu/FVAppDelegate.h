//
//  FVAppDelegate.h
//  VBoxMenu
//
//  Created by Francesc Vila on 06/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FVAppDelegate : NSObject <NSApplicationDelegate>
{
    NSStatusItem *statusItem;
    NSSize itemSize;
}

@property (assign) IBOutlet NSMenu *statusMenu;


@end
