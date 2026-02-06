///| Utility functions for converting and validating modifiers

///|
/// Convert NodeArray[ModifierKind] to ClassMemberModifiers with validation
fn parse_class_member_modifiers(
  modifiers : Array[ModifierKind]?,
  span : Span,
) -> ClassMemberModifiers raise ParseError {
  match modifiers {
    None => ClassMemberModifiers::new()
    Some(mods) => {
      let mut accessibility : AccessibilityModifier? = None
      let mut is_static = false
      let mut is_abstract = false
      let mut is_readonly = false
      let mut is_override = false
      let mut is_accessor = false
      let mut is_async = false
      for modifier in mods {
        match modifier {
          ModifierKind::Public => {
            if accessibility is Some(_) {
              raise ParseError(
                span~,
                kind=ParseErrorKind::MultipleAccessibilityModifiers,
              )
            }
            accessibility = Some(AccessibilityModifier::Public)
          }
          ModifierKind::Private => {
            if accessibility is Some(_) {
              raise ParseError(
                span~,
                kind=ParseErrorKind::MultipleAccessibilityModifiers,
              )
            }
            accessibility = Some(AccessibilityModifier::Private)
          }
          ModifierKind::Protected => {
            if accessibility is Some(_) {
              raise ParseError(
                span~,
                kind=ParseErrorKind::MultipleAccessibilityModifiers,
              )
            }
            accessibility = Some(AccessibilityModifier::Protected)
          }
          ModifierKind::Static => {
            if is_static {
              raise ParseError(
                span~,
                kind=ParseErrorKind::DuplicateModifier(ModifierKind::Static),
              )
            }
            is_static = true
          }
          ModifierKind::Abstract => {
            if is_abstract {
              raise ParseError(
                span~,
                kind=ParseErrorKind::DuplicateModifier(ModifierKind::Abstract),
              )
            }
            is_abstract = true
          }
          ModifierKind::Readonly => {
            if is_readonly {
              raise ParseError(
                span~,
                kind=ParseErrorKind::DuplicateModifier(ModifierKind::Readonly),
              )
            }
            is_readonly = true
          }
          ModifierKind::Override => {
            if is_override {
              raise ParseError(
                span~,
                kind=ParseErrorKind::DuplicateModifier(ModifierKind::Override),
              )
            }
            is_override = true
          }
          ModifierKind::Accessor => {
            if is_accessor {
              raise ParseError(
                span~,
                kind=ParseErrorKind::DuplicateModifier(ModifierKind::Accessor),
              )
            }
            is_accessor = true
          }
          ModifierKind::Async => {
            if is_async {
              raise ParseError(
                span~,
                kind=ParseErrorKind::DuplicateModifier(ModifierKind::Async),
              )
            }
            is_async = true
          }
          _ =>
            raise ParseError(
              span~,
              kind=ParseErrorKind::InvalidModifierForClassMember(modifier),
            )
        }
      }
      // Validate invalid combinations
      if is_abstract && is_static {
        raise ParseError(
          span~,
          kind=ParseErrorKind::AbstractAndStaticCannotCombine,
        )
      }
      if is_abstract && accessibility == Some(AccessibilityModifier::Private) {
        raise ParseError(
          span~,
          kind=ParseErrorKind::AbstractMembersCannotBePrivate,
        )
      }
      if is_abstract && is_async {
        raise ParseError(
          span~,
          kind=ParseErrorKind::AbstractAndAsyncCannotCombine,
        )
      }
      if is_accessor && is_abstract {
        raise ParseError(
          span~,
          kind=ParseErrorKind::AccessorAndAbstractCannotCombine,
        )
      }
      {
        accessibility,
        is_static,
        is_abstract,
        is_readonly,
        is_override,
        is_accessor,
        is_async,
      }
    }
  }
}

///|
/// Convert NodeArray[ModifierKind] to ParameterModifiers with validation
fn parse_parameter_modifiers(
  modifiers : NodeArray[ModifierKind]?,
  span : Span,
) -> ParameterModifiers raise ParseError {
  match modifiers {
    None => ParameterModifiers::new()
    Some(mods) => {
      let mut accessibility : AccessibilityModifier? = None
      let mut is_readonly = false
      for modifier in mods.elements.iter() {
        match modifier {
          ModifierKind::Public => {
            if accessibility is Some(_) {
              raise ParseError(
                span~,
                kind=ParseErrorKind::MultipleAccessibilityModifiers,
              )
            }
            accessibility = Some(AccessibilityModifier::Public)
          }
          ModifierKind::Private => {
            if accessibility is Some(_) {
              raise ParseError(
                span~,
                kind=ParseErrorKind::MultipleAccessibilityModifiers,
              )
            }
            accessibility = Some(AccessibilityModifier::Private)
          }
          ModifierKind::Protected => {
            if accessibility is Some(_) {
              raise ParseError(
                span~,
                kind=ParseErrorKind::MultipleAccessibilityModifiers,
              )
            }
            accessibility = Some(AccessibilityModifier::Protected)
          }
          ModifierKind::Readonly => {
            if is_readonly {
              raise ParseError(
                span~,
                kind=ParseErrorKind::DuplicateModifier(ModifierKind::Readonly),
              )
            }
            is_readonly = true
          }
          _ =>
            raise ParseError(
              span~,
              kind=ParseErrorKind::InvalidModifierForParameter(modifier),
            )
        }
      }
      { accessibility, is_readonly }
    }
  }
}

///|
/// Convert NodeArray[ModifierKind] to TopLevelModifiers with validation
fn parse_top_level_modifiers(
  modifiers : NodeArray[ModifierKind]?,
  allow_abstract : Bool,
  allow_const : Bool,
  span : Span,
) -> TopLevelModifiers raise ParseError {
  match modifiers {
    None => TopLevelModifiers::new()
    Some(mods) => {
      let mut is_export = false
      let mut is_default = false
      let mut is_declare = false
      for modifier in mods.elements.iter() {
        match modifier {
          ModifierKind::Export => {
            if is_export {
              raise ParseError(
                span~,
                kind=ParseErrorKind::DuplicateModifier(ModifierKind::Export),
              )
            }
            is_export = true
          }
          ModifierKind::Default => {
            if is_default {
              raise ParseError(
                span~,
                kind=ParseErrorKind::DuplicateModifier(ModifierKind::Default),
              )
            }
            is_default = true
          }
          ModifierKind::Declare => {
            if is_declare {
              raise ParseError(
                span~,
                kind=ParseErrorKind::DuplicateModifier(ModifierKind::Declare),
              )
            }
            is_declare = true
          }
          ModifierKind::Abstract =>
            if !allow_abstract {
              raise ParseError(
                span~,
                kind=ParseErrorKind::AbstractOnlyValidOnClasses,
              )
            }
          ModifierKind::Const =>
            if !allow_const {
              raise ParseError(
                span~,
                kind=ParseErrorKind::ConstOnlyValidOnEnums,
              )
            }
          ModifierKind::Async => () // Handled separately by FunctionDecl
          _ =>
            raise ParseError(
              span~,
              kind=ParseErrorKind::InvalidModifierForTopLevel(modifier),
            )
        }
      }
      { is_export, is_default, is_declare }
    }
  }
}

///|
/// Convert NodeArray[ModifierKind] to TypeParameterModifiers with validation
fn parse_type_parameter_modifiers(
  modifiers : NodeArray[ModifierKind]?,
  span : Span,
) -> TypeParameterModifiers raise ParseError {
  match modifiers {
    None => TypeParameterModifiers::new()
    Some(mods) => {
      let mut has_in = false
      let mut has_out = false
      let mut is_const = false
      for modifier in mods.elements.iter() {
        match modifier {
          ModifierKind::In => {
            if has_in {
              raise ParseError(
                span~,
                kind=ParseErrorKind::DuplicateModifier(ModifierKind::In),
              )
            }
            has_in = true
          }
          ModifierKind::Out => {
            if has_out {
              raise ParseError(
                span~,
                kind=ParseErrorKind::DuplicateModifier(ModifierKind::Out),
              )
            }
            has_out = true
          }
          ModifierKind::Const => {
            if is_const {
              raise ParseError(
                span~,
                kind=ParseErrorKind::DuplicateModifier(ModifierKind::Const),
              )
            }
            is_const = true
          }
          _ =>
            raise ParseError(
              span~,
              kind=ParseErrorKind::InvalidModifierForTypeParameter(modifier),
            )
        }
      }
      // Set variance based on flags
      let variance = if has_in && has_out {
        Some(VarianceModifier::InOut)
      } else if has_in {
        Some(VarianceModifier::In)
      } else if has_out {
        Some(VarianceModifier::Out)
      } else {
        None
      }
      { variance, is_const }
    }
  }
}
