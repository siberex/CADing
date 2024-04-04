# Luggage Tag

Small badge with your contact details to put in your luggage bags and backpacks.

Create `.data.scad` file with your details or edit `language_tag.scad` file directly:

```php
$lines = [
    // Line index, Icon,  icon_offset %height, dx_offset mm
    [0, "user", "John Doe Jr.", 4],
    [1, "instagram", "sib_li", -6.25],
    [2, "", ""], // empty row
    [3, "whatsapp", "+1-234-567-8900"],
    [4, "pointer", "sib.li", -5],
];
```

You can use custom icons (SVG only), I recommend [Font Awesome](https://fontawesome.com/search?q=mastodon&o=r) to get some.

Just put SVG file in the in the icons folder and use it's filename (without extension) in the data (second column).

If needed, put `icon_offset` number (percentage of the line height, fourth colum) to better align it along the text.

Provide `dx_offset` to align further from the left (or put two data lines in a single row).

# Recommended parameters

Intended to be printed with two filaments of different colors.

AMS (automatic filament change) is required for the debossed variant.

Embossed variant could be printed with the manual filament change by the layer height.

- Material: PLA (may be PETG, need to test)

- Step size: 0.1mm or 0.2mm

- Nozzle size: 0.2mm

- `emboss_thickness` parameter (in .scad file): 
    
    Embossed: 2 * step size is recommended
    
    Debossed: Equal to the first layer height is recommended (e.g. 0.15mm first layer for 0.1mm step size)

Debossed variant in PLA could be printed on a flat surface plate facing down.

PETG sticks poorly to the flat surface, use textured surface plate.

### Important slicer settings

Applicable to both OrcaSlicer and PrusaSlicer.

Wall generator: **Arachne**

Use outer brim of at least 5mm. Otherwise PLA will bend at that size and peel off of the table.

Do not use Hilbert Curve as a bottom surface pattern.

Use 0 wall loops for the base object and 5 wall loops for the rim & letters object (rim_thikness divided by nozzle size).

Top surface pattern for the rim & letters object: Concentric.

Use provided `.3mf` for optimal slicing settings, just update objects using Replace with STL context menu and adjust setting specific for your printer model and filament type.
