using UnityEngine;
using UnityEngine.Rendering;

namespace Kino.PostProcessing.Eight.Universal {

[ExecuteInEditMode]
public sealed partial class EightColorController : MonoBehaviour
{
    #region Editable properties

    [field:SerializeField, ColorUsage(false)] public Color Color1 { get; set; } = new Color(0, 0, 0, 0);
    [field:SerializeField, ColorUsage(false)] public Color Color2 { get; set; } = new Color(1, 0, 0, 0);
    [field:SerializeField, ColorUsage(false)] public Color Color3 { get; set; } = new Color(0, 1, 0, 0);
    [field:SerializeField, ColorUsage(false)] public Color Color4 { get; set; } = new Color(1, 1, 0, 0);

    [field:SerializeField, ColorUsage(false)] public Color Color5 { get; set; } = new Color(0, 0, 1, 0);
    [field:SerializeField, ColorUsage(false)] public Color Color6 { get; set; } = new Color(1, 0, 1, 0);
    [field:SerializeField, ColorUsage(false)] public Color Color7 { get; set; } = new Color(0, 1, 1, 0);
    [field:SerializeField, ColorUsage(false)] public Color Color8 { get; set; } = new Color(1, 1, 1, 0);

    [field:SerializeField, ColorUsage(false)] public Color Color9  { get; set; } = new Color(0.3f, 0.3f, 0.3f);
    [field:SerializeField, ColorUsage(false)] public Color Color10 { get; set; } = new Color(0.5f, 0.0f, 0.0f);
    [field:SerializeField, ColorUsage(false)] public Color Color11 { get; set; } = new Color(0.0f, 0.5f, 0.0f);
    [field:SerializeField, ColorUsage(false)] public Color Color12 { get; set; } = new Color(0.5f, 0.5f, 0.0f);

    [field:SerializeField, ColorUsage(false)] public Color Color13 { get; set; } = new Color(0.0f, 0.0f, 0.5f);
    [field:SerializeField, ColorUsage(false)] public Color Color14 { get; set; } = new Color(0.5f, 0.0f, 0.5f);
    [field:SerializeField, ColorUsage(false)] public Color Color15 { get; set; } = new Color(0.0f, 0.5f, 0.5f);
    [field:SerializeField, ColorUsage(false)] public Color Color16 { get; set; } = new Color(0.6f, 0.6f, 0.6f);

    [field:SerializeField] public bool Extended { get; set; }
    [field:SerializeField, Range(0, 1)] public float Dithering { get; set; } = 0.05f;
    [field:SerializeField, Range(1, 32)] public int Downsampling { get; set; } = 1;
    [field:SerializeField, Range(0, 1)] public float Opacity { get; set; } = 1;

    #endregion

    #region Runtime public property

    public Material Material => UpdateMaterial();
    public int PassIndex => Extended ? 1 : 0;

    #endregion

    #region Project asset reference

    [SerializeField, HideInInspector] Shader _shader = null;

    #endregion

    #region Private members

    static class IDs
    {
        internal static readonly int Dithering = Shader.PropertyToID("_Dithering");
        internal static readonly int Downsampling = Shader.PropertyToID("_Downsampling");
        internal static readonly int Opacity = Shader.PropertyToID("_Opacity");
        internal static readonly int PaletteRgb = Shader.PropertyToID("_PaletteRGB");
        internal static readonly int PaletteLab = Shader.PropertyToID("_PaletteLab");
    }

    Material _material;
    (Color[] rgb, Vector4[] lab) _palette = (new Color[16], new Vector4[16]);

    static Vector3 LinearToOKLab(Vector4 c)
    {
        var lms = new Vector3
          (0.4122214708f * c.x + 0.5363325363f * c.y + 0.0514459929f * c.z,
           0.2119034982f * c.x + 0.6806995451f * c.y + 0.1073969566f * c.z,
           0.0883024619f * c.x + 0.2817188376f * c.y + 0.6299787005f * c.z);

        lms = new Vector3(Mathf.Pow(lms.x, 1f / 3),
                          Mathf.Pow(lms.y, 1f / 3),
                          Mathf.Pow(lms.z, 1f / 3));

        return new Vector3
          (0.2104542553f * lms.x + 0.7936177850f * lms.y - 0.0040720468f * lms.z,
           1.9779984951f * lms.x - 2.4285922050f * lms.y + 0.4505937099f * lms.z,
           0.0259040371f * lms.x + 0.7827717662f * lms.y - 0.8086757660f * lms.z);
    }

    #endregion

    #region MonoBehaviour implementation

    void OnDestroy()
      => CoreUtils.Destroy(_material);

    void OnDisable()
      => OnDestroy();

    void Update() {} // Just for providing the component enable switch.

    #endregion

    #region Controller implementation

    public Material UpdateMaterial()
    {
        if (_material == null)
            _material = CoreUtils.CreateEngineMaterial(_shader);

        _palette.rgb[0] = Color1;
        _palette.rgb[1] = Color2;
        _palette.rgb[2] = Color3;
        _palette.rgb[3] = Color4;
        _palette.rgb[4] = Color5;
        _palette.rgb[5] = Color6;
        _palette.rgb[6] = Color7;
        _palette.rgb[7] = Color8;
        _palette.rgb[8] = Color9;
        _palette.rgb[9] = Color10;
        _palette.rgb[10] = Color11;
        _palette.rgb[11] = Color12;
        _palette.rgb[12] = Color13;
        _palette.rgb[13] = Color14;
        _palette.rgb[14] = Color15;
        _palette.rgb[15] = Color16;

        for (var i = 0; i < _palette.lab.Length; i++)
            _palette.lab[i] = LinearToOKLab(_palette.rgb[i].linear);

        _material.SetColorArray(IDs.PaletteRgb, _palette.rgb);
        _material.SetVectorArray(IDs.PaletteLab, _palette.lab);
        _material.SetFloat(IDs.Dithering, Dithering);
        _material.SetInteger(IDs.Downsampling, Downsampling);
        _material.SetFloat(IDs.Opacity, Opacity);

        return _material;
    }

    #endregion
}

} // namespace Kino.PostProcessing.Eight.Universal
