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

    [field:SerializeField, Range(0, 1)] public float Dithering = 0.05f;
    [field:SerializeField, Range(1, 32)] public int Downsampling = 1;
    [field:SerializeField, Range(0, 1)] public float Opacity = 1;

    #endregion

    #region Runtime public property

    public Material Material => UpdateMaterial();

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
        internal static readonly int Palette = Shader.PropertyToID("_Palette");
    }

    Material _material;
    readonly Color[] _palette = new Color[8];

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

        _palette[0] = Color1;
        _palette[1] = Color2;
        _palette[2] = Color3;
        _palette[3] = Color4;
        _palette[4] = Color5;
        _palette[5] = Color6;
        _palette[6] = Color7;
        _palette[7] = Color8;

        _material.SetColorArray(IDs.Palette, _palette);
        _material.SetFloat(IDs.Dithering, Dithering);
        _material.SetInteger(IDs.Downsampling, Downsampling);
        _material.SetFloat(IDs.Opacity, Opacity);

        return _material;
    }

    #endregion
}

} // namespace Kino.PostProcessing.Eight.Universal
