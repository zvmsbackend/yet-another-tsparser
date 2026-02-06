///| Specific enums for AST nodes

///|
/// Unary operator kinds
pub enum UnaryOperator {
  PlusPlus // ++
  MinusMinus // --
  Plus // +
  Minus // -
  Tilde // ~
  Exclamation // !
} derive(Eq, Show)

///|
/// Binary operator kinds (simplified - extend as needed)
pub enum BinaryOperator {
  Equals
  PlusEquals
  MinusEquals
  AsteriskEquals
  AsteriskAsteriskEquals
  SlashEquals
  PercentEquals
  AmpersandEquals
  BarEquals
  CaretEquals
  ShiftLeftEquals
  ShiftRightEquals
  ShiftRightUnsignedEquals
  AmpersandAmpersandEquals
  BarBarEquals
  QuestionQuestionEquals
  Plus
  Minus
  Asterisk
  Slash
  Percent
  AsteriskAsterisk
  ShiftLeft
  ShiftRight
  ShiftRightUnsigned
  LessThan
  GreaterThan
  LessThanEquals
  GreaterThanEquals
  In
  InstanceOf
  EqualsEquals
  ExclamationEquals
  EqualsEqualsEquals
  ExclamationEqualsEquals
  BitwiseAnd
  BitwiseXor
  BitwiseOr
  AmpersandAmpersand
  BarBar
  QuestionQuestion
} derive(Eq, Show)

///|
/// Modifier kinds

///|
/// Accessibility modifiers (mutually exclusive)
pub enum AccessibilityModifier {
  Public
  Private
  Protected
} derive(Eq)

///|
pub impl Show for AccessibilityModifier with output(self, logger) {
  logger.write_string(
    match self {
      Public => "public"
      Private => "private"
      Protected => "protected"
    },
  )
}

///|

///|
/// Variance modifiers for type parameters (mutually exclusive)
pub enum VarianceModifier {
  In
  Out
  InOut
} derive(Eq)

///|
pub impl Show for VarianceModifier with output(self, logger) {
  logger.write_string(
    match self {
      In => "in"
      Out => "out"
      InOut => "in out"
    },
  )
}

///|

///|
/// Modifiers for class members
pub struct ClassMemberModifiers {
  accessibility : AccessibilityModifier?
  is_static : Bool
  is_abstract : Bool
  is_readonly : Bool
  is_override : Bool
  is_accessor : Bool
  is_async : Bool
} derive(Eq, Show, Default)

///|
pub fn ClassMemberModifiers::new() -> ClassMemberModifiers {
  {
    accessibility: None,
    is_static: false,
    is_abstract: false,
    is_readonly: false,
    is_override: false,
    is_accessor: false,
    is_async: false,
  }
}

///|

///|
/// Modifiers for constructor parameters (can be property declarations)
pub struct ParameterModifiers {
  accessibility : AccessibilityModifier?
  is_readonly : Bool
} derive(Eq, Show, Default)

///|
pub fn ParameterModifiers::new() -> ParameterModifiers {
  { accessibility: None, is_readonly: false }
}

///|

///|
/// Modifiers for top-level declarations
pub struct TopLevelModifiers {
  is_export : Bool
  is_default : Bool
  is_declare : Bool
} derive(Eq, Show)

///|
pub fn TopLevelModifiers::new() -> TopLevelModifiers {
  { is_export: false, is_default: false, is_declare: false }
}

///|

///|
/// Modifiers for type parameters
pub struct TypeParameterModifiers {
  variance : VarianceModifier?
  is_const : Bool
} derive(Eq, Show, Default)

///|
pub fn TypeParameterModifiers::new() -> TypeParameterModifiers {
  { variance: None, is_const: false }
}

///|

///|
/// Legacy ModifierKind enum (kept for backward compatibility during migration)
pub enum ModifierKind {
  Abstract
  Accessor
  Async
  Const
  Declare
  Default
  Export
  In
  Public
  Private
  Protected
  Readonly
  Override
  Out
  Static
} derive(Eq)

///|
impl Show for ModifierKind with to_string(self) {
  match self {
    Abstract => "abstract"
    Accessor => "accessor"
    Async => "async"
    Const => "const"
    Declare => "declare"
    Default => "default"
    Export => "export"
    In => "in"
    Public => "public"
    Private => "private"
    Protected => "protected"
    Readonly => "readonly"
    Override => "override"
    Out => "out"
    Static => "static"
  }
}

///|
impl Show for ModifierKind with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
/// Heritage clause kinds
pub enum HeritageKind {
  Extends
  Implements
} derive(Eq, Show)

///|
/// Type keyword kinds
pub enum TypeKeyword {
  Any
  Unknown
  Number
  BigInt
  Object
  Boolean
  String
  Symbol
  Void
  Undefined
  Null
  Never
} derive(Eq, Show)
