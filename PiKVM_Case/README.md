# PiKVM Case

FreeCAD model.

Casing for [PiKVM v1](https://pikvm.org/) — project by Maxim Devaev which converts your Raspberry Pi to the fully-featured [IP KVM](https://en.wikipedia.org/wiki/KVM_switch#KVM_over_IP_(IPKVM)) (aka little box that allows you to control your PC remotely without software layer like RDP, so you can control BIOS and even trigger Reset button).

Uses HDMI to CSI bridge based on the [Toshiba TC358743XBG](https://toshiba.semicon-storage.com/eu/semiconductor/product/interface-bridge-ics-for-mobile-peripheral-devices/hdmir-interface-bridge-ics/detail.TC358743XBG.html) chip.

This casing is using Raspberry Pi 3B with Pico H.

# Printing

Bottom part could be printed without supports.

Top part have to be printed with supports.

0.4 nozzle, 0.2 step size works fine.

Recommended material: PLA Matte

If you want to see LEDs blinking, use short pieces of transparent filament as a light guides (just shove into the holes and trim to the surface).



# Bill of Materials

- Raspberry Pi 3B, 3B+ or Pi 4B

- TC358743 HDMI to CSI adapter, [C790](https://wiki.blicube.com/blikvm/en/hdmi-csi-i2s/) or similar 

- [CSI-2 flex cable (15-pin)](https://www.arducam.com/raspberry-pi-camera-pinout/)

- Raspberry Pico H (or Pico with soldered pin headers)

    With rPi 4B Pico board is optional, [splitter can be used instead](https://wiki.blicube.com/blikvm/en/usb-splitter-guide/)

- 14× Pin headers bent

- 14× short dupont jumper wires female-female

- 8× long dupont jumper wires female-female (to connect ATX)

- 1x 1N5819 diode

- 4x Omron G3VM-61A1 opto-couplers

    Substitutions — any `1 Form A` **MOSFET output** solid state relay:

    - [Mouser](https://eu.mouser.com/c/electromechanical/relays-contactors-solenoids/solid-state-relays-ssr/solid-state-relays-pcb-mount/?output%20type=MOSFET&package%20%2F%20case=DIP-4&relay%20contact%20form=1%20Form%20A%20%28SPST-NO%29&instock=y)
    
    - [LCSC](https://www.lcsc.com/products/Solid-State-Relay-MOS-Output_919.html)

    PC814 or even PC817 could alo be used, but it tends to be less sensitive.

- x4 390 Ohm resistors through-the-hole

- x2 4.7 kOhm resistors through-the-hole

- (Optional) Fan **5V** 40x40x10mm (4010) Fan, recommended 4-pin PWM, like [Noctua NF-A4x10 PWM](https://noctua.at/en/nf-a4x10-5v-pwm).

    Substitutions: PA4010S05HN2, MF40100V2-1D05C-SAA, AF40100V1-1Q04C-S99.
    
    Non-PWM (3-pin) will work fine, 40x40x20mm (4020) will work too, 12V and 2-pin are also acceptable options.

- (Optional) 4x FAN screws

- 4x Heat set inserts M2\*4\*3.5

- 4x M2\*10 (2#\*3/8) screws

- 9x M2\*4 screws

- 4x magnets, D=10mm H=2mm

- USB-A to Micro-USB cable


# PiKVM setup

1. Raspberry Pi setup, depending on the model:

    a. [Pi 3 set up](https://docs.pikvm.org/v1/#setting-up-the-hardware)

    b. [Pi 4 set up](https://docs.pikvm.org/v2/#required-parts) – skip power supply splitter part if using Pico board (recommended)

2. Flash image

    https://docs.pikvm.org/flashing_os/

    https://wiki.blicube.com/blikvm/en/flashing_os/


2. [Pico board set up](https://docs.pikvm.org/pico_hid/#flashing-the-firmware).

    TLDR: [grab firmware here](https://github.com/pikvm/kvmd/releases) and flash.

3. Optional ATX board set up (see below)


## Pin header connections

### [Pico](https://datasheets.raspberrypi.com/pico/Pico-R3-A4-Pinout.pdf)

- pin 4 – 1N5819 diode (+5VCC) `->|-` pico pin 39 (VSYS)
- pin 36 (GPIO 16) – pico pin 36 (3V3_OUT)
- pin 22 (GPIO 25) – pico pin 30 (RUN)
- pin 20 – GND, pico pin 28
- pin 26 (GPIO 7) – pico pin 27 (GP21)
- pin 19 (GPIO 10) – pico pin 26 (GP20)
- pin 21 (GPIO 9) – pico pin 25 (GP19)
- pin 23 (GPIO 11) – pico pin 24 (GP18)


### [C790](https://wiki.geekworm.com/C790)

I2S connector (actual wire colors could differ):

- pin 12 (GPIO 18) – i2s SCK, white
- pin 38 (GPIO 20) – i2s SD, blue
- pin 35 (GPIO 19) – i2s WFS, yellow
- pin 6 – GND, black


### Fan

- pin 2 – +5VCC
- pin 14 – GND (Fan)
- pin 31 (GPIO 6) – Tachometer signal output
- pin 32 (GPIO 12) – PWM signal input


### ATX board

From left to right:

- pin 16 (GPIO 23) – Power switch
- pin 13 (GPIO 27) – Reset switch
- pin 18 (GPIO 24) – Power LED
- pin 15 (GPIO 22) – HDD LED
- pin 25 – GND (ATX)
- pin 1 (or 17) – +3.3VCC


# ATX board

Check out exported gerber files in the [ATX_PCB](./ATX_PCB/) dir.

Both single-sided and double-sided versions are available.

Recommended PCB thickness: from 1 to 1.2 mm.

Single-sided version is also exported [in PDF format](./ATX_PCB/pdf_single_layer/back.pdf) for printing at home.

Components are named to exactly mimic [the original schematic](https://docs.pikvm.org/v1/v1_scheme.png).

TODO: Share publicly [EasyEDA project](https://easyeda.com/editor#id=10361afddc3f4134ae8cebcdb68e18ef|33e11979f03a4932974794a9883380c7)


# ATX breakout board (PC side)

Recommended PCB thickness: 1.2 mm.

PCI bracket models:

- See [../ATX_PCI_bracket] (recommended, both full-size and low-profile brackets are fully compatible with the PCB).
    Pair of M2.5 screws with nuts and washers are needed to assemble.

- https://docs.pikvm.org/stl/atx/ (both models are compatible with the PCB, but low-profile model is WRONG - incorrect tab direction), no screws needed to assemble.

- https://www.thingiverse.com/thing:3089065 (correctly-modeled semi-compatible low-profile PCI bracket, could be used with minor post-print modifications)




# Acknolegements

[PCI Bracket Generator](https://www.thingiverse.com/thing:2836187) by [Roy Allen Sutton](https://github.com/royasutton) used to create PC side ATX board bracket.

## 3D assets used

- [Raspberry Pi 3 model](https://www.thingiverse.com/thing:1701186) by Alexandre Willame, based on:
    - [Raspberry Pi 3 Model B Reference Design](https://grabcad.com/library/raspberry-pi-3-reference-design-model-b-rpi-raspberrypi-raspberry-pi-2) by Mechatronics Art.
    - [Raspberry Pi 3](https://grabcad.com/library/raspberry-pi-3-3) by Mena Cos.
    - [Raspberry Pi 3](https://grabcad.com/library/raspberry-pi-3-2) by Bilal.

- [Raspberry Pi 4 model](https://grabcad.com/library/raspberry-pi-4-model-b-1) by Hasanain Shuja.

- [Raspberry Pico reference model](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html#pinout-and-design-files).

### Auxilary 3D models used

- [4010 fan](https://grabcad.com/library/noctua-fan-nf-a4x10_40mm-1)

- [HDMI SMT Socket model](https://grabcad.com/library/hdmi-socket-smt-1) by [Volodymyr Rovinskyi](https://g-mak.com.ua/en)

- [JST 2.54x3P](https://grabcad.com/library/jst-2-54-2p-6p-1)

- [Pin Header 2.54×20](https://grabcad.com/library/pin-header-2-54-4)

- [Arduino Female Pin Header for KiCAD](https://grabcad.com/library/arduino-female-pin-header-for-kicad-1)

## Other

Cat pattern is inspired by [Halloween Cat Tessellation Collaborative Art Project](https://www.twinkl.com.ng/resource/halloween-cat-tessellation-collaborative-art-project-cfe-m-1655838161) from Twinkl
