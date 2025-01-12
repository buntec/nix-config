#!/usr/bin/osascript

tell application "UTM"
    --- specify a boot ISO
    set iso to POSIX file "/Users/christophbunte/Downloads/nixos-minimal-24.11.711934.4005c3ff7505-aarch64-linux.iso"

    --- create an Apple VM for booting Linux (only supported on macOS 13+)
    make new virtual machine with properties {backend:apple, configuration:{name:"NixOS", cpu cores: 6, drives:{{removable:true, source:iso}, {interface: NVMe, guest size:262144}}}}
end tell
