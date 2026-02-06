///| Type nodes for TypeScript AST

///|
/// Type AST node
pub struct TypeNode {
  kind : TypeNodeKind
  span : Span
} derive(Eq, Show)

///|
pub fn TypeNode::new(kind : TypeNodeKind, span : Span) -> TypeNode {
  { kind, span }
}

///|
/// Type node kinds
pub enum TypeNodeKind {
  KeywordType(TypeKeyword)
  TypeReference(TypeReferenceNode)
  ArrayType(TypeNode)
  TupleType(NodeArray[TupleElement])
  UnionType(NodeArray[TypeNode])
  IntersectionType(NodeArray[TypeNode])
  FunctionType(FunctionTypeNode)
  ConstructorType(ConstructorTypeNode)
  TypeLiteral(NodeArray[TypeElement])
  LiteralType(Expr)
  ThisType
  ParenthesizedType(TypeNode)
  TypeQuery(TypeQueryNode)
  TypeOperator(TypeOperatorNode)
  IndexedAccessType(IndexedAccessTypeNode)
  ConditionalType(ConditionalTypeNode)
  MappedType(MappedTypeNode)
  InferType(TypeParameterDecl)
  ImportType(ImportTypeNode)
  TemplateLiteralType(TemplateLiteralTypeNode)
} derive(Eq, Show)

///|
pub struct TemplateLiteralTypeNode {
  head : TemplateHead
  template_spans : NodeArray[TemplateLiteralTypeSpan]
} derive(Eq, Show)

///|
pub fn TemplateLiteralTypeNode::new(
  head : TemplateHead,
  template_spans : NodeArray[TemplateLiteralTypeSpan],
) -> TemplateLiteralTypeNode {
  { head, template_spans }
}

///|
pub struct TemplateLiteralTypeSpan {
  type_node : TypeNode
  literal : TemplateMiddleOrTemplateTail
} derive(Eq, Show)

///|
pub fn TemplateLiteralTypeSpan::new(
  type_node : TypeNode,
  literal : TemplateMiddleOrTemplateTail,
) -> TemplateLiteralTypeSpan {
  { type_node, literal }
}

///|
/// Type query (typeof)
pub struct TypeQueryNode {
  expr_name : TypeQueryExprName
  type_arguments : NodeArray[TypeNode]?
} derive(Eq, Show)

///|
pub fn TypeQueryNode::new(
  expr_name : TypeQueryExprName,
  type_arguments : NodeArray[TypeNode]?,
) -> TypeQueryNode {
  { expr_name, type_arguments }
}

///|
pub enum TypeQueryExprName {
  EntityName(EntityName)
  ImportType(ImportTypeNode)
} derive(Eq, Show)

///|
pub struct TupleElement {
  label : Identifier?
  is_optional : Bool
  is_rest : Bool
  type_node : TypeNode
  span : Span
} derive(Eq, Show)

///|
pub fn TupleElement::new(
  label : Identifier?,
  is_optional : Bool,
  is_rest : Bool,
  type_node : TypeNode,
  span : Span,
) -> TupleElement {
  { label, is_optional, is_rest, type_node, span }
}

///|
/// Type operator (e.g., keyof, readonly, unique)
pub struct TypeOperatorNode {
  operator : TypeOperatorKind
  type_node : TypeNode
} derive(Eq, Show)

///|
pub fn TypeOperatorNode::new(
  operator : TypeOperatorKind,
  type_node : TypeNode,
) -> TypeOperatorNode {
  { operator, type_node }
}

///|
pub enum TypeOperatorKind {
  KeyOf
  Readonly
  Unique
} derive(Eq, Show)

///|
/// Indexed access type (e.g., T[K])
pub struct IndexedAccessTypeNode {
  object_type : TypeNode
  index_type : TypeNode
} derive(Eq, Show)

///|
pub fn IndexedAccessTypeNode::new(
  object_type : TypeNode,
  index_type : TypeNode,
) -> IndexedAccessTypeNode {
  { object_type, index_type }
}

///|
/// Conditional type (e.g., T extends U ? X : Y)
pub struct ConditionalTypeNode {
  check_type : TypeNode
  extends_type : TypeNode
  true_type : TypeNode
  false_type : TypeNode
} derive(Eq, Show)

///|
pub fn ConditionalTypeNode::new(
  check_type : TypeNode,
  extends_type : TypeNode,
  true_type : TypeNode,
  false_type : TypeNode,
) -> ConditionalTypeNode {
  { check_type, extends_type, true_type, false_type }
}

///|
/// Mapped type (e.g., { [K in keyof T]?: U })
pub struct MappedTypeNode {
  is_readonly : Bool
  type_parameter : TypeParameterDecl
  name_type : TypeNode? // for `as` clause (e.g. `[K in keyof T as NewKey]`)
  is_optional : Bool
  type_node : TypeNode?
} derive(Eq, Show)

///|
pub fn MappedTypeNode::new(
  is_readonly : Bool,
  type_parameter : TypeParameterDecl,
  name_type : TypeNode?,
  is_optional : Bool,
  type_node : TypeNode?,
) -> MappedTypeNode {
  { is_readonly, type_parameter, name_type, is_optional, type_node }
}

///|
/// Import type (e.g., import("x").Foo)
pub struct ImportTypeNode {
  argument : Expr
  qualifier : EntityName?
  type_arguments : NodeArray[TypeNode]?
} derive(Eq, Show)

///|
pub fn ImportTypeNode::new(
  argument : Expr,
  qualifier : EntityName?,
  type_arguments : NodeArray[TypeNode]?,
) -> ImportTypeNode {
  { argument, qualifier, type_arguments }
}

///|
pub struct TypeReferenceNode {
  type_name : EntityName
  type_arguments : NodeArray[TypeNode]?
} derive(Eq, Show)

///|
pub fn TypeReferenceNode::new(
  type_name : EntityName,
  type_arguments : NodeArray[TypeNode]?,
) -> TypeReferenceNode {
  { type_name, type_arguments }
}

///|
pub struct FunctionTypeNode {
  type_parameters : NodeArray[TypeParameterDecl]?
  parameters : NodeArray[ParameterDecl]
  type_node : TypeNode?
} derive(Eq, Show)

///|
pub fn FunctionTypeNode::new(
  type_parameters : NodeArray[TypeParameterDecl]?,
  parameters : NodeArray[ParameterDecl],
  type_node : TypeNode?,
) -> FunctionTypeNode {
  { type_parameters, parameters, type_node }
}

///|
pub struct ConstructorTypeNode {
  is_abstract : Bool
  type_parameters : NodeArray[TypeParameterDecl]?
  parameters : NodeArray[ParameterDecl]
  type_node : TypeNode?
} derive(Eq, Show)

///|
pub fn ConstructorTypeNode::new(
  is_abstract : Bool,
  type_parameters : NodeArray[TypeParameterDecl]?,
  parameters : NodeArray[ParameterDecl],
  type_node : TypeNode?,
) -> ConstructorTypeNode {
  { is_abstract, type_parameters, parameters, type_node }
}
