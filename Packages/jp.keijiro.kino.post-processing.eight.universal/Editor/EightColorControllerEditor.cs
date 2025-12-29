using UnityEditor;
using UnityEngine;
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
        return root;
    }
}

} // namespace Kino.PostProcessing.Eight.Universal.Editor
