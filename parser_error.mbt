///|
pub enum ParseErrorKind {
  UnexpectedToken(LexKind)
  UnexpectedPrimary(LexKind)
  ExpectedToken(expected~ : LexKind, actual~ : LexKind)
  ExpectedNumericLiteralAfterMinus(LexKind)
  ExpectedStringLiteralInImportType(LexKind)
  ExpectedStringLiteralInModuleSpecifier(LexKind)
  ExpectedTemplateLiteralTypeSpan(LexKind)
  ExpectedTemplateSpan(LexKind)
  InvalidBinaryOperator(LexKind)
  InvalidNamespaceNameStringLiteral(LexKind)
  StringLiteralModuleNameOnlyInDeclare
  InvalidModuleBody
  ModuleBodyRequiredWithoutDeclare
  DecoratorsNotAllowedHere
  LineBreakAfterThrow
  LineBreakAfterTypeKeyword
  ForAwaitMustUseOf(LexKind)
  TopLevelAwaitOnlyInModule
  MissingFunctionBodyOrSemicolon(LexKind)
  LeadingCommaInImportAttributes
  LeadingCommaInNamedImports
  LeadingCommaInNamedExports
  MissingDeclarationAfterModifiers(LexKind)
  DuplicateModifier(ModifierKind)
  InvalidVarianceOrder(previous~ : ModifierKind, current~ : ModifierKind)
  YieldOnlyInGenerator
  RestParameterMustBeLastInParameterList
  RestBindingMustBeLastInPattern
  DeclarationFileStatementNotAllowed
  ExportAssignmentOnlyInDeclarationFile
  ExportAssignmentCannotBeUsedWithOtherExports
  ExportNamespaceOnlyInDeclarationFile
  ExportNamespaceOnlyInModule
  AwaitOnlyInAsyncFunction
  AwaitUsingOnlyInAsyncFunction
  ForAwaitOnlyInAsyncFunction
  ForAwaitOnlyInModule
  AwaitUsingOnlyInModule
  IdentifierAfterNumericLiteral
  InvalidChar(Char)
  UnterminatedString
  InvalidSlice(end~ : Int)
  MultipleAccessibilityModifiers
  InvalidModifierForClassMember(ModifierKind)
  InvalidModifierForParameter(ModifierKind)
  InvalidModifierForTopLevel(ModifierKind)
  InvalidModifierForTypeParameter(ModifierKind)
  AbstractAndStaticCannotCombine
  AbstractMembersCannotBePrivate
  AbstractAndAsyncCannotCombine
  AccessorAndAbstractCannotCombine
  AbstractOnlyValidOnClasses
  ConstOnlyValidOnEnums
  InferTypeOnlyInConditionalExtends
} derive(Eq)

///|
pub suberror ParseError {
  ParseError(span~ : Span, kind~ : ParseErrorKind)
} derive(Eq)

///|
pub impl Show for ParseError with to_string(self) {
  let ParseError(span~, kind~) = self
  "Parse error at \{span.to_string()}: \{kind.to_string()}"
}

///|
pub impl Show for ParseError with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for ParseErrorKind with to_string(self) {
  match self {
    UnexpectedToken(kind) => "unexpected token: \{kind}"
    UnexpectedPrimary(kind) => "unexpected primary expression: \{kind}"
    ExpectedToken(expected~, actual~) => "expected \{expected}, found \{actual}"
    ExpectedNumericLiteralAfterMinus(kind) =>
      "expected numeric literal after '-', found \{kind}"
    ExpectedStringLiteralInImportType(kind) =>
      "expected string literal in import type, found \{kind}"
    ExpectedStringLiteralInModuleSpecifier(kind) =>
      "expected string literal in module specifier, found \{kind}"
    ExpectedTemplateLiteralTypeSpan(kind) =>
      "expected template literal type span, found \{kind}"
    ExpectedTemplateSpan(kind) =>
      "expected template literal span, found \{kind}"
    InvalidBinaryOperator(kind) => "invalid binary operator: \{kind}"
    InvalidNamespaceNameStringLiteral(kind) =>
      "namespace name cannot be a string literal: \{kind}"
    StringLiteralModuleNameOnlyInDeclare =>
      "string literal module name requires 'declare'"
    InvalidModuleBody => "invalid module body"
    ModuleBodyRequiredWithoutDeclare =>
      "module or namespace body is required unless declared"
    DecoratorsNotAllowedHere => "decorators are not valid here"
    LineBreakAfterThrow => "line break after 'throw' is not allowed"
    LineBreakAfterTypeKeyword => "line break after 'type' is not allowed"
    ForAwaitMustUseOf(kind) => "for-await must use 'of', found \{kind}"
    TopLevelAwaitOnlyInModule =>
      "'await' expressions are only allowed at the top level of a file when that file is a module, but this file has no imports or exports. Consider adding an empty 'export {}' to make this file a module."
    MissingFunctionBodyOrSemicolon(kind) =>
      "expected function body or ';', found \{kind}"
    LeadingCommaInImportAttributes => "leading comma in import attributes"
    LeadingCommaInNamedImports => "leading comma in named imports"
    LeadingCommaInNamedExports => "leading comma in named exports"
    MissingDeclarationAfterModifiers(kind) =>
      "expected declaration after modifiers, found \{kind}"
    DuplicateModifier(kind) => "duplicate modifier: \{kind}"
    InvalidVarianceOrder(previous~, current~) =>
      "invalid variance order: \{previous} before \{current}"
    YieldOnlyInGenerator =>
      "A 'yield' expression is only allowed in a generator body."
    RestParameterMustBeLastInParameterList =>
      "A rest parameter must be last in a parameter list."
    RestBindingMustBeLastInPattern =>
      "A rest binding element must be last in a destructuring pattern."
    DeclarationFileStatementNotAllowed =>
      "statement is not allowed in a declaration file"
    ExportAssignmentOnlyInDeclarationFile =>
      "export assignment is only allowed in a declaration file"
    ExportAssignmentCannotBeUsedWithOtherExports =>
      "an export assignment cannot be used in a module with other exported elements"
    ExportNamespaceOnlyInDeclarationFile =>
      "export as namespace is only allowed in a declaration file"
    ExportNamespaceOnlyInModule =>
      "export as namespace is only allowed in a module file"
    AwaitOnlyInAsyncFunction =>
      "await expressions are only allowed within async functions"
    AwaitUsingOnlyInAsyncFunction =>
      "'await using' is only allowed within async functions"
    ForAwaitOnlyInAsyncFunction =>
      "for-await is only allowed within async functions"
    ForAwaitOnlyInModule => "for-await is only allowed in a module file"
    AwaitUsingOnlyInModule =>
      "'await using' is only allowed at the top level of a module file"
    IdentifierAfterNumericLiteral =>
      "An identifier or keyword cannot immediately follow a numeric literal"
    InvalidChar(c) => "invalid character: \{c}"
    UnterminatedString => "unterminated string literal"
    InvalidSlice(end~) => "invalid slice end: \{end}"
    MultipleAccessibilityModifiers =>
      "Multiple accessibility modifiers are not allowed"
    InvalidModifierForClassMember(modifier) =>
      "'\{modifier}' modifier is not valid on class members"
    InvalidModifierForParameter(modifier) =>
      "'\{modifier}' modifier is not valid on constructor parameters"
    InvalidModifierForTopLevel(modifier) =>
      "'\{modifier}' modifier is not valid on top-level declarations"
    InvalidModifierForTypeParameter(modifier) =>
      "'\{modifier}' modifier is not valid on type parameters"
    AbstractAndStaticCannotCombine =>
      "'abstract' and 'static' modifiers cannot be used together"
    AbstractMembersCannotBePrivate => "'abstract' members cannot be 'private'"
    AbstractAndAsyncCannotCombine =>
      "'abstract' and 'async' modifiers cannot be used together"
    AccessorAndAbstractCannotCombine =>
      "'accessor' and 'abstract' modifiers cannot be used together"
    AbstractOnlyValidOnClasses => "'abstract' modifier is only valid on classes"
    ConstOnlyValidOnEnums => "'const' modifier is only valid on enums"
    InferTypeOnlyInConditionalExtends =>
      "'infer' types can only be used in conditional type extends clauses"
  }
}

///|
pub impl Show for ParseErrorKind with output(self, logger) {
  logger.write_string(self.to_string())
}
