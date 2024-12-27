# KinoEight for URP

![gif](https://i.imgur.com/KJ4pgJ3.gif)
![gif](https://i.imgur.com/gSs1Lc4.gif)

**[KinoEight]** is an 8-bit-style post-processing effect originally developed for
HDRP. **KinoEight URP** is a simple port of this effect for URP.

[KinoEight]: https://github.com/keijiro/KinoEight

## System Requirements

- Unity 6 or later
- URP 17 or later

## How To Install

This package uses a [scoped registry] to resolve package dependencies. To
install the package:

1. Open the **Project Settings** window and navigate to the **Package Manager**
   section.
2. Add the following entry to the **Scoped Registries** list:
     - Name: `Keijiro`
     - URL: `https://registry.npmjs.com`
     - Scope: `jp.keijiro`
   
   ![Scoped Registry](https://user-images.githubusercontent.com/343936/162576797-ae39ee00-cb40-4312-aacd-3247077e7fa1.png)
3. Open the **Package Manager** window, switch to the **My Registries** tab,
   and install the package.

   ![My Registries](https://user-images.githubusercontent.com/343936/162576825-4a9a443d-62f9-48d3-8a82-a3e80b486f04.png)

For more information, refer to the [scoped registry] documentation.

[scoped registry]: https://docs.unity3d.com/Manual/upm-scoped.html

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
