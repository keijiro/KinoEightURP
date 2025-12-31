using UnityEditor;
using UnityEngine;
using UnityEditor.UIElements;
using UnityEngine.UIElements;

namespace Kino.PostProcessing.Eight.Universal.Editor {

[CustomEditor(typeof(EightColorController))]
public sealed class EightColorControllerEditor : UnityEditor.Editor
{
    [SerializeField] VisualTreeAsset _uxml = null;

    public override VisualElement CreateInspectorGUI()
    {
        var root = new VisualElement();
        root.Add(_uxml.CloneTree());

        var row3 = root.Q<VisualElement>("palette-row-3");
        var row4 = root.Q<VisualElement>("palette-row-4");
        var extendedProp = serializedObject.FindProperty("<Extended>k__BackingField");

        UpdateVisibility(row3, row4, extendedProp.boolValue);

        root.TrackPropertyValue(extendedProp,
          (p) => { UpdateVisibility(row3, row4, p.boolValue); });

        return root;
    }

    void UpdateVisibility(VisualElement e1, VisualElement e2, bool isVisible)
      => e1.style.display = e2.style.display =
           isVisible ? DisplayStyle.Flex : DisplayStyle.None;
}

} // namespace Kino.PostProcessing.Eight.Universal.Editor
