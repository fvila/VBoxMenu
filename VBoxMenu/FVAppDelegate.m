//
//  FVAppDelegate.m
//  VBoxMenu
//
//  Created by Francesc Vila on 06/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FVAppDelegate.h"

@implementation FVAppDelegate

@synthesize statusMenu = _statusMenu;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)awakeFromNib
{
    NSString *imageName = [[NSBundle mainBundle] pathForResource:@"virtualbox" ofType:@"png"];
    NSImage *statusImage = [[NSImage alloc] initWithContentsOfFile:imageName];

    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    
    itemSize.width = [[NSStatusBar systemStatusBar] thickness] - 1;
    itemSize.height = [[NSStatusBar systemStatusBar] thickness] - 1;
        
    [statusImage setScalesWhenResized:YES];
    [statusImage setSize:itemSize];
    
    [statusItem setImage:statusImage];
    
    [statusItem setMenu:_statusMenu];
    [statusItem setHighlightMode:YES];
    
    [self reloadVMS];
}

-(void) reloadVMS
{
    NSString *cmdName = [[NSBundle mainBundle] pathForResource:@"listvms" ofType:@"sh"];
    
    NSPipe *pipe = [NSPipe pipe];
    NSTask *task = [[NSTask alloc] init];
    NSString *cmd = [NSString stringWithString:@"/bin/sh"];
    NSArray *args = [NSArray arrayWithObject:cmdName];
    
    [task setLaunchPath:cmd];
    [task setArguments:args];
    [task setStandardOutput:pipe];
    [task launch];
    [task waitUntilExit];
    
    NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
    NSString *outputCmd = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *vms = [outputCmd componentsSeparatedByString:@"\n"];
    
    [_statusMenu removeAllItems];
    
    for (id object in vms)
    {
        NSString *currentItem = (NSString*) object;
        
        if([currentItem length] == 0)
            break;
        
        NSMenuItem *menu = [[NSMenuItem alloc] initWithTitle:currentItem
                                                      action:@selector(menuCallback:) 
                                               keyEquivalent:@""];
        
        NSPipe *pipeinfo = [NSPipe pipe];
        NSTask *taskInfo = [[NSTask alloc] init];
        NSString* cmdNameInfo = [[NSBundle mainBundle] pathForResource:@"vminfo" ofType:@"sh"];
        NSString* quotedCurrentItem = [NSString stringWithFormat:@"%@",currentItem];
        NSArray *arrayInfo = [NSArray arrayWithObjects:cmdNameInfo,quotedCurrentItem,nil];
        
        [taskInfo setLaunchPath:cmd];
        [taskInfo setArguments:arrayInfo];
        [taskInfo setStandardOutput:pipeinfo];
        [taskInfo launch];
        [taskInfo waitUntilExit];
        
        NSData *datainfo = [[pipeinfo fileHandleForReading] readDataToEndOfFile];
        NSString *osName = [[NSString alloc] initWithData:datainfo encoding:NSUTF8StringEncoding];
        NSString *osImageName = [NSString stringWithFormat:@"os_%@",osName];
        
        NSString *completeImagePath = [[NSBundle mainBundle] pathForResource:osImageName ofType:@"png"];
        NSImage *osImage = [[NSImage alloc] initWithContentsOfFile:completeImagePath];
        
        [osImage setScalesWhenResized:YES];
        [osImage setSize:itemSize];
        
        [menu setImage:osImage];
        
        [_statusMenu addItem:menu];
    }
    
    NSMenuItem *menu = [[NSMenuItem alloc] initWithTitle:@"Reload"
                                                  action:@selector(menuCallback:) 
                                           keyEquivalent:@""];
    
    NSMenuItem *separator = [NSMenuItem separatorItem];
    
    [_statusMenu addItem:separator];
    [_statusMenu addItem:menu];
    
    menu = [[NSMenuItem alloc] initWithTitle:@"Quit"
                                      action:@selector(menuCallback:) 
                               keyEquivalent:@""];
    [_statusMenu addItem:menu];
}

-(void) startVM:(NSString*) vmname
{
    NSString *cmdName = [[NSBundle mainBundle] pathForResource:@"startvm" ofType:@"sh"];
    
    NSString *cmd = [NSString stringWithString:@"/bin/sh"];
    NSArray *args = [NSArray arrayWithObjects:cmdName,vmname,nil];
    
    [NSTask launchedTaskWithLaunchPath:cmd arguments:args];
}

-(void) menuCallback: (id)sender
{
    NSString *menuName = [(NSMenuItem*)sender title];
    
    if (menuName == @"Quit")
    {
        [NSApp terminate:self];
    }
    else if (menuName == @"Reload")
    {
        [self reloadVMS];
    }
    else 
    {
        [self startVM:menuName];
    }
}

@end
