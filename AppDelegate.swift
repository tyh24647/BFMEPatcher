//
//  AppDelegate.swift
//  BFMEPatcher
//
//  Created by Tyler hostager on 3/31/18.
//  Copyright © 2018 Tyler hostager. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        /*
         AuthorizationRef myAuthorizationRef;
         OSStatus myStatus;
         myStatus = AuthorizationCreate (NULL, kAuthorizationEmptyEnvironment,
         kAuthorizationFlagDefaults, &myAuthorizationRef);
 */
        
        /*
        var authRef = AuthorizationRef()
        var status = OSStatus()
        status = AuthorizationCreate(nil, UnsafePointer<AuthorizationEnvironment>(nilpointer), UnsafePointer<AuthorizationRef>(), &authRef)
        
        var script = NSAppleScript(source: "/bin/bash -c 'osascript -e 'do shell script 'sudo open -a 'Battle for Middle-Earth';' with administrator privileges'")
        script!.compileAndReturnError(AutoreleasingUnsafeMutablePointer<NSDictionary?>?(nilLiteral: {
            NSLog("COMPILATION ERROR: %@" , nilHandleErr.description)
        }()))
 */
        
        
        /*
        var authRef = AuthorizationRef(bitPattern: 1)
        var authStr = AuthorizationString("com.tyh24647.BFMEPatcher.canModifyFiles")
        var authItems: [AuthorizationItem] = [
            AuthorizationItem(name: authStr, valueLength: 0, value: nil, flags: 0)
        ]
        
        var authRights = AuthorizationRights(count: UInt32(authItems.count), items: &authItems)
        var flags: AuthorizationFlags = AuthorizationFlags(rawValue: AuthorizationFlags.RawValue(UInt8(AuthorizationFlags.preAuthorize.rawValue) | UInt8(AuthorizationFlags.extendRights.rawValue)))
        var env = AuthorizationEnvironment(count: UInt32(authItems.count), items: &authItems)
        //var status = AuthorizationCopyRights(authRef!, &authRights, &env, flags, Authori authItems)
        var status = AuthorizationCopyRightsAsync(authRef!, &authRights, &env, flags, { _,_ in
            //
            
            if statusErr > 0 {
                print("\n\n\nstatusErr code \(statusErr)")
            }
            
        })
 */
        
        
        //authItems[0].name = authStr
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

