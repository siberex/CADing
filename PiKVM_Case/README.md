# PiKVM Case

FreeCAD model. WORK IN PROGRESS.

Casing for [PiKVM v1](https://pikvm.org/) — project by Maxim Devaev which converts your Raspberry Pi to the fully-featured [IP KVM](https://en.wikipedia.org/wiki/KVM_switch#KVM_over_IP_(IPKVM)) (aka little box that allows you to control your PC remotely without software layer like RDP, so you can control BIOS and even trigger Reset button).

Uses HDMI to CSI bridge based on the [Toshiba TC358743XBG](https://toshiba.semicon-storage.com/eu/semiconductor/product/interface-bridge-ics-for-mobile-peripheral-devices/hdmir-interface-bridge-ics/detail.TC358743XBG.html) chip.

This casing is using Raspberry Pi 3B with Pico H.


# Bill of Materials

- Raspberry Pi 3B

- TC358743 HDMI to CSI adapter, [C790](https://wiki.blicube.com/blikvm/en/hdmi-csi-i2s/) or similar 

- [CSI-2 flex cable (15-pin)](https://www.arducam.com/raspberry-pi-camera-pinout/)

- Raspberry Pico H (or Pico with soldered pin headers)

- 14× short dupont jumper wires female-female

- 8× long dupont jumper wires female-female (to connect ATX)

- 1N5819 diode

- x4 Omron G3VM-61A1 opto-couplers

- x4 390 Ohm resistors through-the-hole

- x2 4.7 kOhm resistors through-the-hole

- USB-A to Micro-USB cable

TODO: Screws, hex spacers...


# PiKVM setup

1. [Raspberry Pi 3 set up](https://docs.pikvm.org/v1/#setting-up-the-hardware)

2. [Pico board set up](https://docs.pikvm.org/pico_hid/). 

    TLDR: [grab firmware here](https://github.com/pikvm/kvmd/releases) and flash.

3. Optional ATX board set up (see below)


# ATX board

Check out exported gerber files in the [ATX_PCB](./ATX_PCB/) dir.

Both single-sided and double-sided versions are available.

Single-sided version is also exported [in PDF format](./ATX_PCB/pdf_single_layer/back.pdf) for printing at home.

Components are named to closely mimic [the original schematic](https://docs.pikvm.org/v1/v1_scheme.png).

TODO: Share publicly [EasyEDA project](https://easyeda.com/editor#id=10361afddc3f4134ae8cebcdb68e18ef|33e11979f03a4932974794a9883380c7)


# Acknolegements

## 3D assets used

- [Raspberry Pi 3 model](https://www.thingiverse.com/thing:1701186) by Alexandre Willame, based on:
    - [Raspberry Pi 3 Model B Reference Design](https://grabcad.com/library/raspberry-pi-3-reference-design-model-b-rpi-raspberrypi-raspberry-pi-2) by Mechatronics Art.
    - [Raspberry Pi 3](https://grabcad.com/library/raspberry-pi-3-3) by Mena Cos.
    - [Raspberry Pi 3](https://grabcad.com/library/raspberry-pi-3-2) by Bilal.

- [Raspberry Pico model](https://grabcad.com/library/raspberry-pi-pico-r3-1) by 
Hasanain Shuja.

- [HDMI SMT Socket model](https://grabcad.com/library/hdmi-socket-smt-1) by [Volodymyr Rovinskyi](https://g-mak.com.ua/en).

## Auxilary 3D models used

- [JST 2.54x3P](https://grabcad.com/library/jst-2-54-2p-6p-1)

- [Hexagonal spacers M2.5](https://grabcad.com/library/hexagonal-spacers-m2-5-f-f-hex-5-1)

- [Pin Header 2.54×20](https://grabcad.com/library/pin-header-2-54-4)

- [Arduino Female Pin Header for KiCAD](https://grabcad.com/library/arduino-female-pin-header-for-kicad-1)
