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

- Material: PLA (may be PETG, need to test)

- Step size: 0.1mm

- Nozzle size: 0.2mm

- `emboss_thickness` parameter: 
    Embossed: 2 * step size is recommended
    Debossed: Equal to the first layer sise is recommended

Debossed variant should be printed on a flat surface table facing down.

! Use outer brim of at least 5mm.

Otherwise PLA will bend at that size and peel off of the table.
