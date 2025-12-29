# KinoEight for URP

![gif](https://i.imgur.com/KJ4pgJ3.gif)
![gif](https://i.imgur.com/gSs1Lc4.gif)

**[KinoEight]** is an 8-bit-style post-processing effect originally developed for
HDRP. **KinoEight URP** is a simple port of this effect for URP.

[KinoEight]: https://github.com/keijiro/KinoEight

## System Requirements

- Unity 6 or later
- URP 17 or later

## How to Install

You can install the KinoEight package
(`jp.keijiro.kino.post-processing.eight.universal`) via the "Keijiro" scoped
registry using the Unity Package Manager. To add the registry to your project,
follow [these instructions].

[these instructions]:
  https://gist.github.com/keijiro/f8c7e8ff29bfe63d86b888901b82644c

## Eight Color effect

![eight color](https://i.imgur.com/gqqSnl6.png)

The **Eight Color** effect reduces the color palette of an image to eight
colors. It includes additional options:

- Dithering: Soften banding artifacts with a low-resolution dithering pattern.
- Downsampling: Pixelate the image by lowering its resolution.

### How to Use

1. Add the **Eight Color Feature** to the **Renderer Features** list in your
   URP Renderer asset.
2. Add the **Eight Color Controller** component to the camera you want to apply
   the effect to.
   - The effect will only be applied to cameras that have the Eight Color
     Controller component.

## Current Limitations

The Tiled Palette effect from the original KinoEight HDRP package is not yet
available in this URP version.
