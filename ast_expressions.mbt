///| Expr nodes for TypeScript AST

///| Literal nodes for TypeScript AST

///|
/// Numeric literal
pub struct NumericLiteral {
  text : String
  is_unterminated : Bool
  has_extended_unicode_escape : Bool
  is_octal_literal : Bool
  span : Span
} derive(Eq, Show)

///|
pub fn NumericLiteral::new(text : String, span : Span) -> NumericLiteral {
  {
    text,
    is_unterminated: false,
    has_extended_unicode_escape: false,
    is_octal_literal: false,
    span,
  }
}

///|
/// BigInt literal
pub struct BigIntLiteral {
  text : String
  is_unterminated : Bool
  has_extended_unicode_escape : Bool
  span : Span
} derive(Eq, Show)

///|
pub fn BigIntLiteral::new(text : String, span : Span) -> BigIntLiteral {
  { text, is_unterminated: false, has_extended_unicode_escape: false, span }
}

///|
/// String literal
pub struct StringLiteral {
  text : String
  is_unterminated : Bool
  has_extended_unicode_escape : Bool
  is_octal_literal : Bool
  span : Span
} derive(Eq, Show)

///|
pub fn StringLiteral::new(text : String, span : Span) -> StringLiteral {
  {
    text,
    is_unterminated: false,
    has_extended_unicode_escape: false,
    is_octal_literal: false,
    span,
  }
}

///|
/// Regular Expr literal
pub struct RegularExprLiteral {
  text : String
  is_unterminated : Bool
  has_extended_unicode_escape : Bool
  span : Span
} derive(Eq, Show)

///|
pub fn RegularExprLiteral::new(
  text : String,
  span : Span,
) -> RegularExprLiteral {
  { text, is_unterminated: false, has_extended_unicode_escape: false, span }
}

///|
/// Template literal
pub struct NoSubstitutionTemplateLiteral {
  text : String
  raw_text : String
  is_unterminated : Bool
  has_extended_unicode_escape : Bool
} derive(Eq, Show)

///|
pub fn NoSubstitutionTemplateLiteral::new(
  text : String,
  raw_text : String,
) -> NoSubstitutionTemplateLiteral {
  { text, raw_text, is_unterminated: false, has_extended_unicode_escape: false }
}

///|
/// Template head
pub struct TemplateHead {
  text : String
  raw_text : String
  is_unterminated : Bool
  has_extended_unicode_escape : Bool
} derive(Eq, Show)

///|
pub fn TemplateHead::new(text : String, raw_text : String) -> TemplateHead {
  { text, raw_text, is_unterminated: false, has_extended_unicode_escape: false }
}

///|
/// Template middle
pub struct TemplateMiddle {
  text : String
  raw_text : String
  is_unterminated : Bool
  has_extended_unicode_escape : Bool
} derive(Eq, Show)

///|
pub fn TemplateMiddle::new(text : String, raw_text : String) -> TemplateMiddle {
  { text, raw_text, is_unterminated: false, has_extended_unicode_escape: false }
}

///|
/// Template tail
pub struct TemplateTail {
  text : String
  raw_text : String
  is_unterminated : Bool
  has_extended_unicode_escape : Bool
} derive(Eq, Show)

///|
pub fn TemplateTail::new(text : String, raw_text : String) -> TemplateTail {
  { text, raw_text, is_unterminated: false, has_extended_unicode_escape: false }
}

///|
/// Qualified name (e.g., A.B.C)
pub struct QualifiedName {
  left : EntityName
  right : Identifier
} derive(Eq, Show)

///|
pub fn QualifiedName::new(
  left : EntityName,
  right : Identifier,
) -> QualifiedName {
  { left, right }
}

///|
/// EntityName - either an Identifier or QualifiedName
pub enum EntityName {
  Identifier(Identifier)
  QualifiedName(QualifiedName)
} derive(Eq, Show)

///|
/// Property name - can be various types
pub enum PropertyName {
  Identifier(Identifier)
  StringLiteral(StringLiteral)
  NumericLiteral(NumericLiteral)
  ComputedPropertyName(Expr)
  PrivateIdentifier(String)
} derive(Eq, Show)

///|
/// Binding name - used in destructuring
pub enum BindingName {
  Identifier(Identifier)
  ObjectBindingPattern(NodeArray[BindingElement])
  ArrayBindingPattern(NodeArray[ArrayBindingElement])
} derive(Eq, Show)

///|
/// Expression AST node
pub struct Expr {
  kind : ExprKind
  span : Span
} derive(Eq, Show)

///|
pub fn Expr::new(kind : ExprKind, span : Span) -> Expr {
  { kind, span }
}

///|
/// Expression node kinds
pub enum ExprKind {
  Identifier(Identifier)
  NumericLiteral(NumericLiteral)
  StringLiteral(StringLiteral)
  BinaryExpr(BinaryExpr)
  PrefixUnaryExpr(PrefixUnaryExpr)
  PostfixUnaryExpr(PostfixUnaryExpr)
  PropertyAccessExpr(PropertyAccessExpr)
  ElementAccessExpr(ElementAccessExpr)
  CallExpr(CallExpr)
  NewExpr(NewExpr)
  ImportExpr(NodeArray[Expr])
  ArrayLiteralExpr(NodeArray[Expr])
  ObjectLiteralExpr(NodeArray[ObjectLiteralElementLike])
  FunctionExpr(FunctionExpr)
  ArrowFunction(ArrowFunction)
  ConditionalExpr(ConditionalExpr)
  TemplateExpr(TemplateExpr)
  TaggedTemplateExpr(TaggedTemplateExpr)
  AsExpr(AsExpr)
  ParenthesizedExpr(Expr)
  SatisfiesExpr(SatisfiesExpr)
  TypeAssertionExpr(TypeAssertionExpr)
  NonNullExpr(Expr)
  MetaProperty(MetaPropertyKind)
  CommaListExpr(NodeArray[Expr])
  ThisExpr
  SuperExpr
  NullLiteral
  TrueLiteral
  FalseLiteral
  RegularExprLiteral(RegularExprLiteral)
  NoSubstitutionTemplateLiteral(NoSubstitutionTemplateLiteral)
  DeleteExpr(Expr)
  TypeOfExpr(Expr)
  VoidExpr(Expr)
  AwaitExpr(Expr)
  YieldExpr(YieldExpr)
  SpreadElement(Expr)
  OmittedExpr
  ClassExpr(ClassExpr)
} derive(Eq, Show)

///|
pub enum ArrayBindingElement {
  BindingElement(BindingElement)
  OmittedExpr
} derive(Eq, Show)

///|
pub struct BindingElement {
  property_name : PropertyName?
  is_rest : Bool
  name : BindingName
  initializer : Expr?
} derive(Eq, Show)

///|
pub fn BindingElement::new(
  name : BindingName,
  property_name : PropertyName?,
  is_rest : Bool,
  initializer : Expr?,
) -> BindingElement {
  { property_name, is_rest, name, initializer }
}

///|
/// Binary Expr (e.g., a + b, x === y)
pub struct BinaryExpr {
  left : Expr
  operator : BinaryOperator
  right : Expr
} derive(Eq, Show)

///|
pub fn BinaryExpr::new(
  left : Expr,
  operator : BinaryOperator,
  right : Expr,
) -> BinaryExpr {
  { left, operator, right }
}

///|
/// Prefix unary Expr (e.g., ++x, -y, !z)
pub struct PrefixUnaryExpr {
  operator : UnaryOperator
  operand : Expr
} derive(Eq, Show)

///|
pub fn PrefixUnaryExpr::new(
  operator : UnaryOperator,
  operand : Expr,
) -> PrefixUnaryExpr {
  { operator, operand }
}

///|
/// Postfix unary Expr (e.g., x++, y--)
pub struct PostfixUnaryExpr {
  operand : Expr
  operator : UnaryOperator
} derive(Eq, Show)

///|
pub fn PostfixUnaryExpr::new(
  operand : Expr,
  operator : UnaryOperator,
) -> PostfixUnaryExpr {
  { operand, operator }
}

///|
/// Property access Expr (e.g., obj.prop)
pub struct PropertyAccessExpr {
  expression : Expr
  is_null_coalescing : Bool
  name : Identifier
} derive(Eq, Show)

///|
pub fn PropertyAccessExpr::new(
  expression : Expr,
  name : Identifier,
  is_null_coalescing : Bool,
) -> PropertyAccessExpr {
  { expression, is_null_coalescing, name }
}

///|
/// Elem access Expr (e.g., obj[index])
pub struct ElementAccessExpr {
  expression : Expr
  is_null_coalescing : Bool
  argument_expression : Expr
} derive(Eq, Show)

///|
pub fn ElementAccessExpr::new(
  expression : Expr,
  argument_expression : Expr,
  is_null_coalescing : Bool,
) -> ElementAccessExpr {
  { expression, is_null_coalescing, argument_expression }
}

///|
/// Call Expr (e.g., func(args))
pub struct CallExpr {
  expression : Expr
  is_null_coalescing : Bool
  type_arguments : NodeArray[TypeNode]?
  arguments : NodeArray[Expr]
} derive(Eq, Show)

///|
pub fn CallExpr::new(
  expression : Expr,
  type_arguments : NodeArray[TypeNode]?,
  arguments : NodeArray[Expr],
  is_null_coalescing : Bool,
) -> CallExpr {
  { expression, is_null_coalescing, type_arguments, arguments }
}

///|
/// New Expr (e.g., new Class())
pub struct NewExpr {
  expression : Expr
  type_arguments : NodeArray[TypeNode]?
  arguments : NodeArray[Expr]?
} derive(Eq, Show)

///|
pub fn NewExpr::new(
  expression : Expr,
  type_arguments : NodeArray[TypeNode]?,
  arguments : NodeArray[Expr]?,
) -> NewExpr {
  { expression, type_arguments, arguments }
}

///|
/// Object literal Elem types
pub enum ObjectLiteralElementLike {
  PropertyAssignment(PropertyAssignment)
  ShorthandPropertyAssignment(ShorthandPropertyAssignment)
  SpreadAssignment(Expr)
  MethodDecl(MethodDecl)
  GetAccessor(GetAccessorDecl)
  SetAccessor(SetAccessorDecl)
} derive(Eq, Show)

///|
/// Function expression (e.g., function foo() {}, function*() {})
pub struct FunctionExpr {
  is_async : Bool
  is_generator : Bool
  name : Identifier?
  type_parameters : NodeArray[TypeParameterDecl]?
  parameters : NodeArray[ParameterDecl]
  type_node : TypeNode?
  body : Array[Stmt]?
} derive(Eq, Show)

///|
pub fn FunctionExpr::new(
  is_async : Bool,
  is_generator : Bool,
  name : Identifier?,
  type_parameters : NodeArray[TypeParameterDecl]?,
  parameters : NodeArray[ParameterDecl],
  type_node : TypeNode?,
  body : Array[Stmt]?,
) -> FunctionExpr {
  { is_async, is_generator, name, type_parameters, parameters, type_node, body }
}

///|
/// Arrow function body
pub enum ArrowFunctionBody {
  Expr(Expr)
  Block(Array[Stmt])
} derive(Eq, Show)

///|
/// Arrow function (e.g., x => x + 1, (x) => { return x })
pub struct ArrowFunction {
  is_async : Bool
  type_parameters : NodeArray[TypeParameterDecl]?
  parameters : NodeArray[ParameterDecl]
  type_node : TypeNode?
  body : ArrowFunctionBody
} derive(Eq, Show)

///|
pub fn ArrowFunction::new(
  is_async : Bool,
  type_parameters : NodeArray[TypeParameterDecl]?,
  parameters : NodeArray[ParameterDecl],
  type_node : TypeNode?,
  body : ArrowFunctionBody,
) -> ArrowFunction {
  { is_async, type_parameters, parameters, type_node, body }
}

///|
/// Meta property (e.g., new.target, import.meta)
pub enum MetaPropertyKind {
  NewTarget
  ImportMeta
} derive(Eq, Show)

///|
/// Class expression (e.g., class Foo {}, class extends Base {})
pub struct ClassExpr {
  name : Identifier?
  type_parameters : NodeArray[TypeParameterDecl]?
  heritage_clauses : NodeArray[HeritageClause]?
  members : NodeArray[ClassElement]
} derive(Eq, Show)

///|
pub fn ClassExpr::new(
  name : Identifier?,
  type_parameters : NodeArray[TypeParameterDecl]?,
  heritage_clauses : NodeArray[HeritageClause]?,
  members : NodeArray[ClassElement],
) -> ClassExpr {
  { name, type_parameters, heritage_clauses, members }
}

///|
/// Property assignment (e.g., a: expr)
pub struct PropertyAssignment {
  name : PropertyName
  initializer : Expr
} derive(Eq, Show)

///|
pub fn PropertyAssignment::new(
  name : PropertyName,
  initializer : Expr,
) -> PropertyAssignment {
  { name, initializer }
}

///|
/// Shorthand property assignment (e.g., {a})
pub struct ShorthandPropertyAssignment {
  name : Identifier
  object_assignment_initializer : Expr?
} derive(Eq, Show)

///|
pub fn ShorthandPropertyAssignment::new(
  name : Identifier,
) -> ShorthandPropertyAssignment {
  { name, object_assignment_initializer: None }
}

///|
/// Conditional Expr (e.g., cond ? a : b)
pub struct ConditionalExpr {
  condition : Expr
  when_true : Expr
  when_false : Expr
} derive(Eq, Show)

///|
pub fn ConditionalExpr::new(
  condition : Expr,
  when_true : Expr,
  when_false : Expr,
) -> ConditionalExpr {
  { condition, when_true, when_false }
}

///|
/// Template Expr with substitutions
pub struct TemplateExpr {
  head : TemplateHead
  template_spans : NodeArray[TemplateSpan]
} derive(Eq, Show)

///|
pub fn TemplateExpr::new(
  head : TemplateHead,
  template_spans : NodeArray[TemplateSpan],
) -> TemplateExpr {
  { head, template_spans }
}

///|
/// Tagged template Expr (e.g., tag`text`)
pub struct TaggedTemplateExpr {
  tag : Expr
  type_arguments : NodeArray[TypeNode]?
  template : Expr
} derive(Eq, Show)

///|
pub fn TaggedTemplateExpr::new(
  tag : Expr,
  type_arguments : NodeArray[TypeNode]?,
  template : Expr,
) -> TaggedTemplateExpr {
  { tag, type_arguments, template }
}

///|
pub struct TemplateSpan {
  expression : Expr
  literal : TemplateMiddleOrTemplateTail
} derive(Eq, Show)

///|
pub fn TemplateSpan::new(
  expression : Expr,
  literal : TemplateMiddleOrTemplateTail,
) -> TemplateSpan {
  { expression, literal }
}

///|
pub enum TemplateMiddleOrTemplateTail {
  TemplateMiddle(TemplateMiddle)
  TemplateTail(TemplateTail)
} derive(Eq, Show)

///|
/// Type assertion and as expressions
pub struct AsExpr {
  expression : Expr
  type_node : TypeNode
} derive(Eq, Show)

///|
pub fn AsExpr::new(expression : Expr, type_node : TypeNode) -> AsExpr {
  { expression, type_node }
}

///|
/// Satisfies Expr (e.g., expr satisfies T)
pub struct SatisfiesExpr {
  expression : Expr
  type_node : TypeNode
} derive(Eq, Show)

///|
pub fn SatisfiesExpr::new(
  expression : Expr,
  type_node : TypeNode,
) -> SatisfiesExpr {
  { expression, type_node }
}

///|
pub struct TypeAssertionExpr {
  type_node : TypeNode
  expression : Expr
} derive(Eq, Show)

///|
pub fn TypeAssertionExpr::new(
  type_node : TypeNode,
  expression : Expr,
) -> TypeAssertionExpr {
  { type_node, expression }
}

///|
/// Yield Expr
pub struct YieldExpr {
  is_delegate : Bool
  expression : Expr?
} derive(Eq, Show)

///|
pub fn YieldExpr::new(is_delegate : Bool, expression : Expr?) -> YieldExpr {
  { is_delegate, expression }
}

///|
/// End of expression types
