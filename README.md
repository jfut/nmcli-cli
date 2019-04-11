# nmcli-cli

nmcli-cli is a command line tool that wraps `nmcli` to use for simple use cases.

- Device
  - [nmcli-cli-device-name](#nmcli-cli-device-name)
- IPv4
  - [nmcli-cli-ipv4](#nmcli-cli-ipv4)
  - [nmcli-cli-ipv4-copy](#nmcli-cli-ipv4-copy)
- IPv6
  - [nmcli-cli-ipv6](#nmcli-cli-ipv6)
  - [nmcli-cli-ipv6-copy](#nmcli-cli-ipv6-copy)
- Interface misc tools
  - [nmcli-cli-restart](#nmcli-cli-restart)
  - [nmcli-cli-autoconnect-list](#nmcli-cli-autoconnect-list)
  - [nmcli-cli-autoconnect-set](#nmcli-cli-autoconnect-set)
  - [nmcli-cli-slave-list](#nmcli-cli-slave-list)
- Bonding
  - [nmcli-cli-bond-add](#nmcli-cli-bond-add)
  - [nmcli-cli-bond-delete](#nmcli-cli-bond-delete)
- VLAN
  - [nmcli-cli-vlan-add](#nmcli-cli-vlan-add)
  - [nmcli-cli-vlan-delete](#nmcli-cli-vlan-delete)
- Bridge
  - [nmcli-cli-bridge-add](#nmcli-cli-bridge-add)
  - [nmcli-cli-bridge-delete](#nmcli-cli-bridge-delete)
- Examples
  - [Example: Add Bonding + VLAN + Bridge interface](#example-add-bonding--vlan--bridge-interface)
  - [Example: Delete Brdige + VLAN + Bonding interface](#example-delete-brdige--vlan--bonding-interface)

## Device

### nmcli-cli-device-name

```
Usage:

    nmcli-cli-device-name [-n] [-x] DEVICE [NEW_IF_NAME]

    Options:
        -n No interface check (Default: check interface)
        -x Run command (Default: echo only)

    Examples:
        nmcli-cli-device-name eno1
        nmcli-cli-device-name eno1 "New Name 1"
```

Run examples:

```
# [rename: echo only]
# ===================
# nmcli-cli-device-name eno1
# echo only.
nmcli connection modify "Wired connection 1" connection.id "eno1"

# [rename: dummy interface + echo only]
# =====================================
# nmcli-cli-device-name -n dummy1 "New Name 1"
# echo only.
nmcli connection modify "dummy1" connection.id "New Name 1"

# [rename: run it]
# ================
# nmcli-cli-device-name -x eno1
Applying: nmcli connection modify "Wired connection 1" connection.id "eno1"
```

## IPv4

### nmcli-cli-ipv4

```
Usage:

    nmcli-cli-ipv4 [-n] [-x] NAME dhcp|static|disable IP_SUBNET [GATEWAY] [DNS]

    Options:
        -n No interface check (Default: check interface)
        -x Run command (Default: echo only)

    Examples:
        nmcli-cli-ipv4 eno1 dhcp
        nmcli-cli-ipv4 eno1 static 192.168.1.101/24 192.168.1.1 "192.168.1.1,10.0.0.2"
        nmcli-cli-ipv4 eno1 static 192.168.1.101/24
        nmcli-cli-ipv4 eno1 disable
```

Run examples:

```
# [dhcp: echo only]
# =================
# nmcli-cli-ipv4 eno1 dhcp
nmcli connection modify "eno1" ipv4.dns ""
nmcli connection modify "eno1" ipv4.gateway ""
nmcli connection modify "eno1" ipv4.addresses "" ipv4.method dhcp

# Next steps:
# -> Restart the interface:
#    nmcli-cli-restart "eno1"
#
# -> Create a bond interface:
#    nmcli-cli-bond-add bond1 mode=... "eno1" "ens2f0"
# -> Create a vlan interface:
#    nmcli-cli-vlan-add "eno1.100" 100 "eno1"
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "eno1"

# [disable: dummy interface + echo only]
# ======================================
# ./nmcli-cli-ipv4 -n eno1 disable
# echo only.
nmcli connection modify "eno1" ipv4.dns ""
nmcli connection modify "eno1" ipv4.gateway ""
nmcli connection modify "eno1" ipv4.addresses "" ipv4.method ignore

# Next steps:
# -> Restart the interface:
#    nmcli-cli-restart "eno1"
#
# -> Create a bond interface:
#    nmcli-cli-bond-add bond1 mode=... "eno1" "ens2f0"
# -> Create a vlan interface:
#    nmcli-cli-vlan-add "eno1.100" 100 "eno1"
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "eno1"

# [static: run it]
# ================
# nmcli-cli-ipv4 -x eno1 static 2001:db8:1::101/48 2001:db8:1::1 "2001:db8:1::1,2001:db8:1::2"
Applying: nmcli connection modify "eno1" ipv4.addresses "192.168.1.101/24" ipv4.method manual
Applying: nmcli connection modify "eno1" ipv4.gateway "192.168.1.1"
Applying: nmcli connection modify "eno1" ipv4.dns "192.168.1.1,10.0.0.2"

# Next steps:
# -> Restart the interface:
#    nmcli-cli-restart "eno1"
#
# -> Create a bond interface:
#    nmcli-cli-bond-add bond1 mode=... "eno1" "ens2f0"
# -> Create a vlan interface:
#    nmcli-cli-vlan-add "eno1.100" 100 "eno1"
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "eno1"
```

### nmcli-cli-ipv4-copy

```
Usage:

    nmcli-cli-ipv4-copy [-n] [-x] SRC_IF_NAME DEST_IF_NAME

    Options:
        -n No interface check (Default: check interface)
        -x Run command (Default: echo only)

    Examples:
        nmcli-cli-ipv4-copy eno1 bond1
        nmcli-cli-ipv4-copy bond1 br1
        nmcli-cli-ipv4-copy eno1 (show current configuration)
```

Run examples:

```
# [copy ipv4: echo only]
# ======================
# nmcli-cli-ipv4-copy eno1 bond1
# echo only.
nmcli connection modify "bond1" ipv4.addresses "192.168.1.101/24" ipv4.method manual
nmcli connection modify "bond1" ipv4.gateway "192.168.1.1,10.0.0.2"
nmcli connection modify "bond1" ipv4.dns "192.168.1.1"

# Next steps:
# -> Change IP address
#    nmcli-cli-ipv4 "bond1" ...
# -> Restart the interface:
#    nmcli-cli-restart "bond1"
#
# -> Create a bond interface:
#    nmcli-cli-bond-add bond1 mode=... "bond1" "ens2f0"
# -> Create a vlan interface:
#    nmcli-cli-vlan-add ".100" 100 "bond1"
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "bond1"

# [copy ipv4: run it]
# ===================
# nmcli-cli-ipv4-copy -x bond1 br1
Applying: nmcli connection modify "br1" ipv4.addresses "192.168.1.101/24" ipv4.method manual
Applying: nmcli connection modify "br1" ipv4.gateway "192.168.1.1,10.0.0.2"
Applying: nmcli connection modify "br1" ipv4.dns "192.168.1.1"

# Next steps:
# -> Change IP address
#    nmcli-cli-ipv4 "" ...
# -> Restart the interface:
#    nmcli-cli-restart ""
#
# -> Create a bond interface:
#    nmcli-cli-bond-add bond1 mode=... "bond1" "ens2f0"
# -> Create a vlan interface:
#    nmcli-cli-vlan-add ".100" 100 "bond1"
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "bond1"
```

## IPv6

### nmcli-cli-ipv6

```
Usage:

    nmcli-cli-ipv6 [-n] [-x] NAME dhcp|static|disable IP_SUBNET [GATEWAY] [DNS]

    Options:
        -n No interface check (Default: check interface)
        -x Run command (Default: echo only)

    Examples:
        nmcli-cli-ipv6 eno1 auto
        nmcli-cli-ipv6 eno1 dhcp
        nmcli-cli-ipv6 eno1 static 2001:db8:1::101/48 2001:db8:1::1 "2001:db8:1::1,2001:db8:1::2"
        nmcli-cli-ipv6 eno1 static 2001:db8:1::101/48
        nmcli-cli-ipv6 eno1 link-local
        nmcli-cli-ipv6 eno1 disable
```

Run examples:

```
# [dhcp: echo only]
# =================
# nmcli-cli-ipv6 eno1 dhcp
nmcli connection modify "eno1" ipv6.dns ""
nmcli connection modify "eno1" ipv6.gateway ""
nmcli connection modify "eno1" ipv6.addresses "" ipv6.method dhcp

# Next steps:
# -> Restart the interface:
#    nmcli-cli-restart "eno1"
#
# -> Create a bond interface:
#    nmcli-cli-bond-add bond1 mode=... "eno1" "ens2f0"
# -> Create a vlan interface:
#    nmcli-cli-vlan-add "eno1.100" 100 "eno1"
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "eno1"

# [disable: dummy interface + echo only]
# ======================================
# ./nmcli-cli-ipv6 -n eno1 disable
# echo only.
nmcli connection modify "eno1" ipv6.dns ""
nmcli connection modify "eno1" ipv6.gateway ""
nmcli connection modify "eno1" ipv6.addresses "" ipv6.method ignore

# Next steps:
# -> Restart the interface:
#    nmcli-cli-restart "eno1"
#
# -> Create a bond interface:
#    nmcli-cli-bond-add bond1 mode=... "eno1" "ens2f0"
# -> Create a vlan interface:
#    nmcli-cli-vlan-add "eno1.100" 100 "eno1"
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "eno1"

# [static: run it]
# ================
# nmcli-cli-ipv6 -x eno1 static 2001:db8:1::101/48 2001:db8:1::1 "2001:db8:1::1,2001:db8:1::2"
Applying: nmcli connection modify "eno1" ipv6.addresses "2001:db8:1::101/48" ipv6.method manual
Applying: nmcli connection modify "eno1" ipv6.gateway "2001:db8:1::1"
Applying: nmcli connection modify "eno1" ipv6.dns "2001:db8:1::1,2001:db8:1::2"

# Next steps:
# -> Restart the interface:
#    nmcli-cli-restart "eno1"
#
# -> Create a bond interface:
#    nmcli-cli-bond-add bond1 mode=... "eno1" "ens2f0"
# -> Create a vlan interface:
#    nmcli-cli-vlan-add "eno1.100" 100 "eno1"
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "eno1"
```

### nmcli-cli-ipv6-copy

```
Usage:

    nmcli-cli-ipv6-copy [-n] [-x] SRC_IF_NAME DEST_IF_NAME

    Options:
        -n No interface check (Default: check interface)
        -x Run command (Default: echo only)

    Examples:
        nmcli-cli-ipv6-copy eno1 bond1
        nmcli-cli-ipv6-copy bond1 br1
        nmcli-cli-ipv6-copy eno1 (show current configuration)
```

Run examples:

```
# [copy ipv6: echo only]
# ======================
# nmcli-cli-ipv6-copy eno1 bond1
# echo only.
nmcli connection modify "bond1" ipv6.addresses "2001:db8:1::101/48"
nmcli connection modify "bond1" ipv6.method manual
nmcli connection modify "bond1" ipv6.gateway "2001:db8:1::1"
nmcli connection modify "bond1" ipv6.dns "2001:db8:1::1,2001:db8:1::2"

# Next steps:
# -> Change IP address
#    nmcli-cli-ipv4 "bond1" ...
# -> Restart the interface:
#    nmcli-cli-restart "bond1"
#
# -> Create a bond interface:
#    nmcli-cli-bond-add bond1 mode=... "bond1" "ens2f0"
# -> Create a vlan interface:
#    nmcli-cli-vlan-add ".100" 100 "bond1"
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "bond1"

# [copy ipv6: run it]
# ===================
# nmcli-cli-ipv6-copy -x bond1 br1
Applying: nmcli connection modify "bond1" ipv6.addresses "2001:db8:1::101/48" ipv6.method manual
Applying: nmcli connection modify "bond1" ipv6.gateway "2001:db8:1::1"
Applying: nmcli connection modify "bond1" ipv6.dns "2001:db8:1::1,2001:db8:1::2"

# Next steps:
# -> Change IP address
#    nmcli-cli-ipv4 "br1" ...
# -> Restart the interface:
#    nmcli-cli-restart "br1"
#
# -> Create a bond interface:
#    nmcli-cli-bond-add bond1 mode=... "br1" "ens2f0"
# -> Create a vlan interface:
#    nmcli-cli-vlan-add ".100" 100 "br1"
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "br1"
```

## Interface misc tools

### nmcli-cli-restart

```
Usage:

    nmcli-cli-restart [-n] [-x] IF_NAME

    Options:
        -n No interface check (Default: check interface)
        -x Run command (Default: echo only)

    Examples:
        nmcli-cli-restart eno1
```

Run examples:

```
# [restart: echo only]
# ====================
# nmcli-cli-restart eno1
# echo only.
nmcli connection down "eno1"; nmcli connection up "eno1"

# [restart run it]
# ================
# nmcli-cli-restart -x eno1
Applying: nmcli connection down "eno1"; nmcli connection up "eno1"
Connection 'eno1' successfully deactivated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/555)
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/556)
```

### nmcli-cli-autoconnect-list

```
Usage:

    nmcli-cli-autoconnect-list on|off

    Examples:
        nmcli-cli-autoconnect-list off
        nmcli-cli-autoconnect-list on
```

Run examples:

```
# [autoconnect on list: echo only]
# ================================
# nmcli-cli-autoconnect-list on
bond1
bond1.100
bond-slave-eno1
bond-slave-ens2f0
br1.100
ens2
ens2f1
lo

# [autoconnect off list: echo only]
# =================================
# nmcli-cli-autoconnect-list off
ens1
ens2f0
```

### nmcli-cli-autoconnect-set

```
Usage:

    ./nmcli-cli-autoconnect-set [-n] [-x] IF_NAME ON|OFF

    Options:
        -n No interface check (Default: check interface)
        -x Run command (Default: echo only)

    Examples:
        ./nmcli-cli-autoconnect-set eno1 off
        ./nmcli-cli-autoconnect-set bond1 on
```

Run examples:

```
# [autoconnect on: echo only]
# ===========================
# nmcli-cli-autoconnect-set eno1 on
# echo only.
nmcli connection modify "eno1" connection.autoconnect "on"

# [autoconnect off: run it]
# =========================
# nmcli-cli-autoconnect-set -x eno1 off
Applying: nmcli connection modify "eno1" connection.autoconnect "off"
```

### nmcli-cli-slave-list

```
Usage:
    nmcli-cli-slave-list IF_NAME

    Examples:
        nmcli-cli-slave-list bond1
        nmcli-cli-slave-list vlan.100
        nmcli-cli-slave-list br1
```

Run examples:

```
# [slave list: echo only]
# =======================
# nmcli-cli-slave-list bond1
bond-slave-eno1
bond-slave-ens2f0

# nmcli-cli-slave-list vlan.100
bond1

# nmcli-cli-slave-list br1.100
vlan.100
```

## Bonding

### nmcli-cli-bond-add

```
Usage:

    nmcli-cli-bond-add [-n] [-x] NEW_BOND_IF_NAME BOND_OPTIONS IF_SLAVE1 IF_SLAVE2 [IF_SLAVE3...]

    Options:
        -n No interface check (Default: check interface)
        -x Run command (Default: echo only)

    Examples:
        nmcli-cli-bond-add bond1 mode=active-backup eno1 ens2f0
        nmcli-cli-bond-add bond1 mode=802.3ad,miimon=100,updelay=500,xmit_hash_policy=layer2+3 eno1 eno3 ens2f0
```

Run examples:

```
# [bond add: LACP + echo only]
# ============================
# nmcli-cli-bond-add bond1 mode=802.3ad,miimon=100,updelay=500,xmit_hash_policy=layer2+3 eno1 ens2f0
# echo only.
nmcli connection add type bond bond.options "mode=802.3ad,miimon=100,updelay=500,xmit_hash_policy=layer2+3" autoconnect yes ipv4.method disabled ipv6.method ignore con-name "bond1" ifname "bond1"
nmcli connection modify "eno1" connection.autoconnect no
nmcli connection add type bond-slave autoconnect yes ifname "eno1" master "bond1"
nmcli connection modify "ens2f0" connection.autoconnect no
nmcli connection add type bond-slave autoconnect yes ifname "ens2f0" master "bond1"

# Next steps:
# -> Check bond status
#    cat /proc/net/bonding/bond1
#
# -> Set IP address
#    nmcli-cli-ipv4 "bond1" ...
#    nmcli-cli-ipv6 "bond1" ...
#
# -> Create a vlan interface:
#    nmcli-cli-vlan-add "bond1.100" 100 "bond1"
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "bond1"

# [bond add: dummy interface + Active-Backup + echo only]
# =======================================================
# nmcli-cli-bond-add -n bond1 mode=active-backup dummy1 dummy2
# echo only.
nmcli connection add type bond bond.options "mode=active-backup" autoconnect yes ipv4.method disabled ipv6.method ignore con-name "bond1" ifname "bond1"
nmcli connection modify "dummy1" connection.autoconnect no
nmcli connection add type bond-slave autoconnect yes ifname "dummy1" master "bond1"
nmcli connection modify "dummy2" connection.autoconnect no
nmcli connection add type bond-slave autoconnect yes ifname "dummy2" master "bond1"

# Next steps:
# -> Check bond status
#    cat /proc/net/bonding/bond1
#
# -> Set IP address
#    nmcli-cli-ipv4 "bond1" ...
#    nmcli-cli-ipv6 "bond1" ...
#
# -> Create a vlan interface:
#    nmcli-cli-vlan-add "bond1.100" 100 "bond1"
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "bond1"

# [bond add: 3 interfaces + LACP + run it]
# ========================================
# nmcli-cli-bond-add -x bond1 mode=802.3ad,miimon=100,updelay=500,xmit_hash_policy=layer2+3 eno1 eno3 ens2f0
Applying: nmcli connection add type bond bond.options "mode=802.3ad,miimon=100,updelay=500,xmit_hash_policy=layer2+3" autoconnect yes ipv4.method disabled ipv6.method ignore con-name "bond1" ifname "bond1"
Connection 'bond1' (eaf6cc9a-0a7a-42cd-8b01-febc62d2f63d) successfully added.
Applying: nmcli connection modify "eno1" connection.autoconnect no
Applying: nmcli connection add type bond-slave autoconnect yes ifname "eno1" master "bond1"
Connection 'bond-slave-eno1' (5de09d50-69fc-4672-9a12-413424f16647) successfully added.
Applying: nmcli connection modify "eno3" connection.autoconnect no
Applying: nmcli connection add type bond-slave autoconnect yes ifname "eno3" master "bond1"
Connection 'bond-slave-eno3' (5c8b4d7a-7771-460c-a514-3bb8819a6470) successfully added.
Applying: nmcli connection modify "ens2f0" connection.autoconnect no
Applying: nmcli connection add type bond-slave autoconnect yes ifname "ens2f0" master "bond1"
Connection 'bond-slave-ens2f0' (305d3404-0f46-43b5-a087-e4e194d9597e) successfully added.

# Next steps:
# -> Check bond status
#    cat /proc/net/bonding/bond1
#
# -> Set IP address
#    nmcli-cli-ipv4 "bond1" ...
#    nmcli-cli-ipv6 "bond1" ...
#
# -> Create a vlan interface:
#    nmcli-cli-vlan-add "bond1.100" 100 "bond1"
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "bond1"

```

### nmcli-cli-bond-delete

```
Usage:

    nmcli-cli-bond-delete [-n] [-x] BOND_IF_NAME

    Options:
        -n No interface check (Default: check interface)
        -x Run command (Default: echo only)

    Examples:
        nmcli-cli-bond-delete bond1
```

Run examples:

```
# [delete: echo only]
# ===================
# nmcli-cli-bond-delete bond1
# echo only.
nmcli connection delete "bond-slave-eno1"
nmcli connection delete "bond-slave-eno3"
nmcli connection delete "bond-slave-ens2f0"
nmcli connection delete "bond1"

# [delete: run it]
# ================
Applying: nmcli connection delete "bond-slave-eno1"
Connection 'bond-slave-ens38' (5de09d50-69fc-4672-9a12-413424f16647) successfully deleted.
Applying: nmcli connection delete "bond-slave-eno3"
Connection 'bond-slave-ens39' (5c8b4d7a-7771-460c-a514-3bb8819a6470) successfully deleted.
Applying: nmcli connection delete "bond-slave-ens2f0"
Connection 'bond-slave-ens40' (305d3404-0f46-43b5-a087-e4e194d9597e) successfully deleted.
Applying: nmcli connection delete "bond1"
Connection 'bond1' (eaf6cc9a-0a7a-42cd-8b01-febc62d2f63d) successfully deleted.
```

## VLAN

### nmcli-cli-vlan-add

```
Usage:

    nmcli-cli-vlan-add [-n] [-x] VLAN_IF_NAME VLAN_ID IF_NAME

    Options:
        -n No interface check (Default: check interface)
        -x Run command (Default: echo only)

    Examples:
        nmcli-cli-vlan-add eno1.100 100 eno1
        nmcli-cli-vlan-add vlan.100 100 bond1
```

Run examples:

```
# [vlan add: VLAN ID 100 + echo only]
# ===================================
# nmcli-cli-vlan-add eno1.100 100 eno1
# echo only.
nmcli connection add type vlan ipv4.method disabled ipv6.method ignore con-name "eno1.100" ifname "eno1.100" dev "eno1" id 100

# Next steps:
# -> Check vlan status
#    cat /proc/net/vlan/eno1.100
#
# -> Set IP address
#    nmcli-cli-ipv4 "eno1" ...
#    nmcli-cli-ipv6 "eno1" ...
#
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "eno1"


# [vlan add: dummy interface + VLAN ID 100 + echo only]
# =====================================================
# nmcli-cli-vlan-add -n vlan.100 100 dummy1
# echo only.
nmcli connection add type vlan ipv4.method disabled ipv6.method ignore con-name "vlan.100" ifname "vlan.100" dev "dummy1" id 100

# Next steps:
# -> Check vlan status
#    cat /proc/net/vlan/dummy1.100
#
# -> Set IP address
#    nmcli-cli-ipv4 "dummy1" ...
#    nmcli-cli-ipv6 "dummy1" ...
#
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "dummy1"

# [vlan add: Bonding + VLAN ID 100 + run it]
# ==========================================
# nmcli-cli-vlan-add -x bond1.100 100 bond1
Applying: nmcli connection add type vlan ipv4.method disabled ipv6.method ignore con-name "bond1.100" ifname "bond1.100" dev "bond1" id 100
Connection 'bond1.100' (2fe697fa-3ca9-4546-8d2d-b551ef47e8f4) successfully added.

# Next steps:
# -> Check vlan status
#    cat /proc/net/vlan/bond1.100
#
# -> Set IP address
#    nmcli-cli-ipv4 "bond1" ...
#    nmcli-cli-ipv6 "bond1" ...
#
# -> Create a bridge interface:
#    nmcli-cli-bridge-add br1 "bond1"
```

### nmcli-cli-vlan-delete

```
Usage:

    ./nmcli-cli-vlan-delete [-n] [-x] VLAN_IF_NAME

    Options:
        -n No interface check (Default: check interface)
        -x Run command (Default: echo only)

    Examples:
        ./nmcli-cli-vlan-delete eno1.100
        ./nmcli-cli-vlan-delete bond1.100
        ./nmcli-cli-vlan-delete vlan.100
```

Run examples:

```
# [vlan delete: echo only]
# ========================
# nmcli-cli-vlan-delete eno1.100
# echo only.
nmcli connection delete "eno1.100"

# [vlan delete: run it]
# =====================
# nmcli-cli-vlan-delete -x eno1.100
Applying: nmcli connection delete "bond1.100"
Connection 'bond1.100' (2fe697fa-3ca9-4546-8d2d-b551ef47e8f4) successfully deleted.
```

## Bridge

### nmcli-cli-bridge-add

```
Usage:

    nmcli-cli-bridge-add [-n] [-x] NEW_BRDIGE_IF_NAME IF_SLAVE

    Options:
        -n No interface check (Default: check interface)
        -x Run command (Default: echo only)

    Examples:
        nmcli-cli-bridge-add br1 eno1
        nmcli-cli-bridge-add br1 bond1
```

Run examples:

```
# [bridge add: echo only]
# =======================
nmcli-cli-bridge-add br1 eno1
# echo only.
nmcli connection add type bridge autoconnect yes ipv4.method disabled ipv6.method ignore bridge.stp no bridge.forward-delay 0 con-name "br1" ifname "br1"
nmcli connection modify "eno1" connection.slave-type bridge connection.master "br1"

# Next steps:
# -> Check bridge status
#    brctl show
#
# -> Set IP address
#    nmcli-cli-ipv4 "br1" ...
#    nmcli-cli-ipv6 "br1" ...

# [bridge add: dummy interface + VLAN + echo only]
# ================================================
# nmcli-cli-bridge-add -n br1 dummy1.100
# echo only.
nmcli connection add type bridge autoconnect yes ipv4.method disabled ipv6.method ignore bridge.stp no bridge.forward-delay 0 con-name "br1" ifname "br1"
nmcli connection modify "dummy1.100" connection.slave-type bridge connection.master "br1"

# Next steps:
# -> Check bridge status
#    brctl show
#
# -> Set IP address
#    nmcli-cli-ipv4 "br1" ...
#    nmcli-cli-ipv6 "br1" ...

# [bridge add: Bonding + VLAN + run it]
# =====================================
# nmcli-cli-bridge-add -x br1.100 bond1.100
Applying: nmcli connection add type bridge autoconnect yes ipv4.method disabled ipv6.method ignore bridge.stp no bridge.forward-delay 0 con-name "br1.100" ifname "br1.100"
Connection 'br1.100' (0587e320-3c7c-4808-a93b-c55a5d7c657f) successfully added.
Applying: nmcli connection modify "bond1.100" connection.slave-type bridge connection.master "br1.100"

# Next steps:
# -> Check bridge status
#    brctl show
#
# -> Set IP address
#    nmcli-cli-ipv4 "br1.100" ...
#    nmcli-cli-ipv6 "br1.100" ...
```

### nmcli-cli-bridge-delete

```
Usage:

    nmcli-cli-bridge-delete [-n] [-x] BRIDGE_NAME

    Options:
        -n No interface check (Default: check interface)
        -x Run command (Default: echo only)

    Examples:
        nmcli-cli-bridge-delete br1
        nmcli-cli-bridge-delete br1.100
```

Run examples:

```
# [bridge delete: echo only]
# ==========================
# nmcli-cli-bridge-delete -n br1
# echo only.
nmcli connection delete "br1"

# [bridge delete: run it]
# =======================
# nmcli-cli-bridge-delete -x br1.100
Applying: nmcli connection modify "bond1.100" connection.master "" connection.slave-type ""
Applying: nmcli connection delete "br1.100"
Connection 'br1.100' (0587e320-3c7c-4808-a93b-c55a5d7c657f) successfully deleted.
```

## Examples

### Example: Add Bonding + VLAN + Bridge interface

- Interfaces: eno1 + eno3 + ens2f0
- Bonding: LACP
- VLAN ID: 100
- Bridge: via VLAN interface
- IP: static IPv4 + IPv6

```
# nmcli-cli-bond-add -n bond1 mode=802.3ad,miimon=100,updelay=500,xmit_hash_policy=layer2+3 eno1 eno3 ens2f0
# echo only.
nmcli connection add type bond bond.options "mode=802.3ad,miimon=100,updelay=500,xmit_hash_policy=layer2+3" autoconnect yes ipv4.method disabled ipv6.method ignore con-name "bond1" ifname "bond1"
nmcli connection modify "eno1" connection.autoconnect no
nmcli connection add type bond-slave autoconnect yes ifname "eno1" master "bond1"
nmcli connection modify "eno3" connection.autoconnect no
nmcli connection add type bond-slave autoconnect yes ifname "eno3" master "bond1"
nmcli connection modify "ens2f0" connection.autoconnect no
nmcli connection add type bond-slave autoconnect yes ifname "ens2f0" master "bond1"

# nmcli-cli-vlan-add -n bond1.100 100 bond1
# echo only.
nmcli connection add type vlan ipv4.method disabled ipv6.method ignore con-name "bond1.100" ifname "bond1.100" dev "bond1" id 100

# nmcli-cli-bridge-add -n br1.100 bond1.100
# echo only.
nmcli connection add type bridge autoconnect yes ipv4.method disabled ipv6.method ignore bridge.stp no bridge.forward-delay 0 con-name "br1.100" ifname "br1.100"
nmcli connection modify "bond1.100" connection.slave-type bridge connection.master "br1.100"

# nmcli-cli-ipv4 -n br1.100 static 192.168.1.101/24 192.168.1.1 "192.168.1.1,10.0.0.2"
# echo only.
nmcli connection modify "br1.100" ipv4.addresses "192.168.1.101/24" ipv4.method manual
nmcli connection modify "br1.100" ipv4.gateway "192.168.1.1"
nmcli connection modify "br1.100" ipv4.dns "192.168.1.1,10.0.0.2"

# nmcli-cli-ipv6 -n br1.100 static 2001:db8:1::101/48 2001:db8:1::1 "2001:db8:1::1,2001:db8:1::2"
# echo only.
nmcli connection modify "br1.100" ipv6.addresses "2001:db8:1::101/48" ipv6.method manual
nmcli connection modify "br1.100" ipv6.gateway "2001:db8:1::1"
nmcli connection modify "br1.100" ipv6.dns "2001:db8:1::1,2001:db8:1::2"
```

### Example: Delete Brdige + VLAN + Bonding interface

- Interfaces: br1.100 + bond1.100 + bond1

```
# ./nmcli-cli-bridge-delete -n br1.100
# echo only.
nmcli connection modify "bond1.100" connection.master "" connection.slave-type ""
nmcli connection delete "br1.100"

# ./nmcli-cli-vlan-delete -n bond1.100
# echo only.
nmcli connection delete "bond1.100"

# ./nmcli-cli-bond-delete -n bond1
# echo only.
nmcli connection delete "bond-slave-eno1"
nmcli connection delete "bond-slave-eno3"
nmcli connection delete "bond-slave-ens2f0"
nmcli connection delete "bond1"
```

## License

MIT

## Author

Jun Futagawa (jfut)

