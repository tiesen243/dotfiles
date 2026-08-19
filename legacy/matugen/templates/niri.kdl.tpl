overview {
  backdrop-color "{{colors.surface_bright.default.hex}}"
}

layout {
  focus-ring {
    active-gradient from="{{colors.primary.default.hex}}" to="{{colors.tertiary.default.hex}}" angle=135
    inactive-gradient from="{{colors.on_primary.default.hex}}" to="{{colors.on_tertiary.default.hex}}" angle=135
  }

  border {
    active-gradient from="{{colors.primary.default.hex}}" to="{{colors.tertiary.default.hex}}" angle=135
    inactive-gradient from="{{colors.on_primary.default.hex}}" to="{{colors.on_tertiary.default.hex}}" angle=135
  }

  shadow {
    color "{{colors.shadow.default.hex}}"
  }
}
