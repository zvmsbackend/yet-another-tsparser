///| Decl nodes for TypeScript AST

///|
/// Variable Decl (e.g., const x = 1)
pub struct VariableDecl {
  kind : VariableDeclKind
  name : BindingName
  type_node : TypeNode?
  initializer : Expr?
} derive(Eq, Show)

///|
pub fn VariableDecl::new(
  kind : VariableDeclKind,
  name : BindingName,
  type_node : TypeNode?,
  initializer : Expr?,
) -> VariableDecl {
  { kind, name, type_node, initializer }
}

///|
pub enum VariableDeclKind {
  Let
  Const
  Var
} derive(Eq, Show)

///|
/// Using Decl (e.g., using x = foo())
pub struct UsingDecl {
  name : Identifier
  type_node : TypeNode?
  initializer : Expr?
} derive(Eq, Show)

///|
pub fn UsingDecl::new(
  name : Identifier,
  type_node : TypeNode?,
  initializer : Expr?,
) -> UsingDecl {
  { name, type_node, initializer }
}

///|
/// Param Decl
pub struct ParameterDecl {
  modifiers : ParameterModifiers
  is_rest : Bool
  name : BindingName
  is_optional : Bool
  type_node : TypeNode?
  initializer : Expr?
  span : Span
} derive(Eq, Show)

///|
pub fn ParameterDecl::new(
  name : BindingName,
  modifiers : ParameterModifiers,
  is_rest : Bool,
  is_optional : Bool,
  type_node : TypeNode?,
  initializer : Expr?,
  span : Span,
) -> ParameterDecl {
  { modifiers, is_rest, name, is_optional, type_node, initializer, span }
}

///|
/// Type Param Decl
pub struct TypeParameterDecl {
  modifiers : TypeParameterModifiers
  name : Identifier
  constraint : TypeNode?
  default_type : TypeNode?
} derive(Eq, Show)

///|
pub fn TypeParameterDecl::new(
  name : Identifier,
  modifiers : TypeParameterModifiers,
  constraint : TypeNode?,
  default_type : TypeNode?,
) -> TypeParameterDecl {
  { modifiers, name, constraint, default_type }
}

///|
/// Function Decl
pub struct FunctionDecl {
  doc_comment : String?
  modifiers : TopLevelModifiers
  is_async : Bool
  is_generator : Bool
  name : Identifier?
  type_parameters : NodeArray[TypeParameterDecl]?
  parameters : NodeArray[ParameterDecl]
  type_node : TypeNode?
  body : Array[Stmt]?
} derive(Eq, Show)

///|
pub fn FunctionDecl::new(
  doc_comment : String?,
  modifiers : TopLevelModifiers,
  is_async : Bool,
  is_generator : Bool,
  name : Identifier?,
  type_parameters : NodeArray[TypeParameterDecl]?,
  parameters : NodeArray[ParameterDecl],
  type_node : TypeNode?,
  body : Array[Stmt]?,
) -> FunctionDecl {
  {
    doc_comment,
    modifiers,
    is_async,
    is_generator,
    name,
    type_parameters,
    parameters,
    type_node,
    body,
  }
}

///|
/// Class Decl
pub struct ClassDecl {
  doc_comment : String?
  decorators : NodeArray[Expr]?
  modifiers : TopLevelModifiers
  name : Identifier?
  type_parameters : NodeArray[TypeParameterDecl]?
  heritage_clauses : NodeArray[HeritageClause]?
  members : NodeArray[ClassElement]
} derive(Eq, Show)

///|
pub fn ClassDecl::new(
  doc_comment : String?,
  decorators : NodeArray[Expr]?,
  modifiers : TopLevelModifiers,
  name : Identifier?,
  type_parameters : NodeArray[TypeParameterDecl]?,
  heritage_clauses : NodeArray[HeritageClause]?,
  members : NodeArray[ClassElement],
) -> ClassDecl {
  {
    doc_comment,
    decorators,
    modifiers,
    name,
    type_parameters,
    heritage_clauses,
    members,
  }
}

///|
/// Heritage clause (extends/implements)
pub struct HeritageClause {
  kind : HeritageKind
  types : NodeArray[ExprWithTypeArguments]
} derive(Eq, Show)

///|
pub fn HeritageClause::new(
  kind : HeritageKind,
  types : NodeArray[ExprWithTypeArguments],
) -> HeritageClause {
  { kind, types }
}

///|
pub struct ExprWithTypeArguments {
  expression : Expr
  type_arguments : NodeArray[TypeNode]?
} derive(Eq, Show)

///|
pub fn ExprWithTypeArguments::new(
  expression : Expr,
  type_arguments : NodeArray[TypeNode]?,
) -> ExprWithTypeArguments {
  { expression, type_arguments }
}

///|
/// Class elements
pub enum ClassElement {
  PropertyDecl(PropertyDecl)
  MethodDecl(MethodDecl)
  Constructor(ConstructorDecl)
  GetAccessor(GetAccessorDecl)
  SetAccessor(SetAccessorDecl)
  IndexSignature(IndexSignatureDecl)
  SemicolonClassElement
  ClassStaticBlockDecl(ClassStaticBlockDecl)
} derive(Eq, Show)

///|
pub struct PropertyDecl {
  doc_comment : String?
  decorators : NodeArray[Expr]?
  modifiers : ClassMemberModifiers
  name : PropertyName
  is_optional : Bool
  is_definite : Bool
  type_node : TypeNode?
  initializer : Expr?
} derive(Eq, Show)

///|
pub fn PropertyDecl::new(
  doc_comment : String?,
  decorators : NodeArray[Expr]?,
  modifiers : ClassMemberModifiers,
  name : PropertyName,
  is_optional : Bool,
  is_definite : Bool,
  type_node : TypeNode?,
  initializer : Expr?,
) -> PropertyDecl {
  {
    doc_comment,
    decorators,
    modifiers,
    name,
    is_optional,
    is_definite,
    type_node,
    initializer,
  }
}

///|
pub struct MethodDecl {
  doc_comment : String?
  decorators : NodeArray[Expr]?
  modifiers : ClassMemberModifiers
  is_generator : Bool
  name : PropertyName
  is_optional : Bool
  type_parameters : NodeArray[TypeParameterDecl]?
  parameters : NodeArray[ParameterDecl]
  type_node : TypeNode?
  body : Array[Stmt]?
} derive(Eq, Show)

///|
pub fn MethodDecl::new(
  doc_comment : String?,
  decorators : NodeArray[Expr]?,
  modifiers : ClassMemberModifiers,
  is_generator : Bool,
  name : PropertyName,
  is_optional : Bool,
  type_parameters : NodeArray[TypeParameterDecl]?,
  parameters : NodeArray[ParameterDecl],
  type_node : TypeNode?,
  body : Array[Stmt]?,
) -> MethodDecl {
  {
    doc_comment,
    decorators,
    modifiers,
    is_generator,
    name,
    is_optional,
    type_parameters,
    parameters,
    type_node,
    body,
  }
}

///|
pub struct ConstructorDecl {
  doc_comment : String?
  modifiers : ClassMemberModifiers
  parameters : NodeArray[ParameterDecl]
  body : Array[Stmt]?
} derive(Eq, Show)

///|
pub fn ConstructorDecl::new(
  doc_comment : String?,
  modifiers : ClassMemberModifiers,
  parameters : NodeArray[ParameterDecl],
  body : Array[Stmt]?,
) -> ConstructorDecl {
  { doc_comment, modifiers, parameters, body }
}

///|
pub struct GetAccessorDecl {
  doc_comment : String?
  decorators : NodeArray[Expr]?
  modifiers : ClassMemberModifiers
  name : PropertyName
  parameters : NodeArray[ParameterDecl]
  type_node : TypeNode?
  body : Array[Stmt]?
} derive(Eq, Show)

///|
pub fn GetAccessorDecl::new(
  doc_comment : String?,
  decorators : NodeArray[Expr]?,
  modifiers : ClassMemberModifiers,
  name : PropertyName,
  parameters : NodeArray[ParameterDecl],
  type_node : TypeNode?,
  body : Array[Stmt]?,
) -> GetAccessorDecl {
  { doc_comment, decorators, modifiers, name, parameters, type_node, body }
}

///|
pub struct SetAccessorDecl {
  doc_comment : String?
  decorators : NodeArray[Expr]?
  modifiers : ClassMemberModifiers
  name : PropertyName
  parameters : NodeArray[ParameterDecl]
  body : Array[Stmt]?
} derive(Eq, Show)

///|
pub fn SetAccessorDecl::new(
  doc_comment : String?,
  decorators : NodeArray[Expr]?,
  modifiers : ClassMemberModifiers,
  name : PropertyName,
  parameters : NodeArray[ParameterDecl],
  body : Array[Stmt]?,
) -> SetAccessorDecl {
  { doc_comment, decorators, modifiers, name, parameters, body }
}

///|
pub struct IndexSignatureDecl {
  is_readonly : Bool
  parameters : NodeArray[ParameterDecl]
  type_node : TypeNode
} derive(Eq, Show)

///|
pub fn IndexSignatureDecl::new(
  is_readonly : Bool,
  parameters : NodeArray[ParameterDecl],
  type_node : TypeNode,
) -> IndexSignatureDecl {
  { is_readonly, parameters, type_node }
}

///|
pub struct ClassStaticBlockDecl {
  body : Array[Stmt]
} derive(Eq, Show)

///|
pub fn ClassStaticBlockDecl::new(body : Array[Stmt]) -> ClassStaticBlockDecl {
  { body, }
}

///|
/// Type elements for interfaces and type literals
pub struct PropertySignature {
  doc_comment : String?
  is_readonly : Bool
  name : PropertyName
  is_optional : Bool
  type_node : TypeNode?
} derive(Eq, Show)

///|
pub fn PropertySignature::new(
  doc_comment : String?,
  is_readonly : Bool,
  name : PropertyName,
  is_optional : Bool,
  type_node : TypeNode?,
) -> PropertySignature {
  { doc_comment, is_readonly, name, is_optional, type_node }
}

///|
pub struct MethodSignature {
  doc_comment : String?
  name : PropertyName
  is_optional : Bool
  type_parameters : NodeArray[TypeParameterDecl]?
  parameters : NodeArray[ParameterDecl]
  type_node : TypeNode?
} derive(Eq, Show)

///|
pub fn MethodSignature::new(
  doc_comment : String?,
  name : PropertyName,
  is_optional : Bool,
  type_parameters : NodeArray[TypeParameterDecl]?,
  parameters : NodeArray[ParameterDecl],
  type_node : TypeNode?,
) -> MethodSignature {
  { doc_comment, name, is_optional, type_parameters, parameters, type_node }
}

///|
pub struct CallSignatureDecl {
  type_parameters : NodeArray[TypeParameterDecl]?
  parameters : NodeArray[ParameterDecl]
  type_node : TypeNode?
} derive(Eq, Show)

///|
pub fn CallSignatureDecl::new(
  type_parameters : NodeArray[TypeParameterDecl]?,
  parameters : NodeArray[ParameterDecl],
  type_node : TypeNode?,
) -> CallSignatureDecl {
  { type_parameters, parameters, type_node }
}

///|
pub struct ConstructSignatureDecl {
  type_parameters : NodeArray[TypeParameterDecl]?
  parameters : NodeArray[ParameterDecl]
  type_node : TypeNode?
} derive(Eq, Show)

///|
pub fn ConstructSignatureDecl::new(
  type_parameters : NodeArray[TypeParameterDecl]?,
  parameters : NodeArray[ParameterDecl],
  type_node : TypeNode?,
) -> ConstructSignatureDecl {
  { type_parameters, parameters, type_node }
}

///|
/// TypeElement enum for interface and type literal members
pub enum TypeElement {
  PropertySignature(PropertySignature)
  MethodSignature(MethodSignature)
  CallSignature(CallSignatureDecl)
  ConstructSignature(ConstructSignatureDecl)
  IndexSignature(IndexSignatureDecl)
  GetAccessor(GetAccessorDecl)
  SetAccessor(SetAccessorDecl)
} derive(Eq, Show)

///|
/// Interface Decl
pub struct InterfaceDecl {
  doc_comment : String?
  modifiers : TopLevelModifiers
  name : Identifier
  type_parameters : NodeArray[TypeParameterDecl]?
  heritage_clauses : NodeArray[HeritageClause]?
  members : NodeArray[TypeElement]
} derive(Eq, Show)

///|
pub fn InterfaceDecl::new(
  doc_comment : String?,
  modifiers : TopLevelModifiers,
  name : Identifier,
  type_parameters : NodeArray[TypeParameterDecl]?,
  heritage_clauses : NodeArray[HeritageClause]?,
  members : NodeArray[TypeElement],
) -> InterfaceDecl {
  { doc_comment, modifiers, name, type_parameters, heritage_clauses, members }
}

///|
/// Type alias Decl
pub struct TypeAliasDecl {
  doc_comment : String?
  modifiers : TopLevelModifiers
  name : Identifier
  type_parameters : NodeArray[TypeParameterDecl]?
  type_node : TypeNode
} derive(Eq, Show)

///|
pub fn TypeAliasDecl::new(
  doc_comment : String?,
  modifiers : TopLevelModifiers,
  name : Identifier,
  type_parameters : NodeArray[TypeParameterDecl]?,
  type_node : TypeNode,
) -> TypeAliasDecl {
  { doc_comment, modifiers, name, type_parameters, type_node }
}

///|
/// Enum Decl
pub struct EnumDecl {
  doc_comment : String?
  modifiers : TopLevelModifiers
  name : Identifier
  members : NodeArray[EnumMember]
} derive(Eq, Show)

///|
pub fn EnumDecl::new(
  doc_comment : String?,
  modifiers : TopLevelModifiers,
  name : Identifier,
  members : NodeArray[EnumMember],
) -> EnumDecl {
  { doc_comment, modifiers, name, members }
}

///|
pub struct EnumMember {
  doc_comment : String?
  name : PropertyName
  initializer : Expr?
} derive(Eq, Show)

///|
pub fn EnumMember::new(
  doc_comment : String?,
  name : PropertyName,
  initializer : Expr?,
) -> EnumMember {
  { doc_comment, name, initializer }
}

///|
/// Module/Namespace Decl
pub struct ModuleDecl {
  doc_comment : String?
  modifiers : TopLevelModifiers
  name : ModuleName
  body : ModuleBody?
} derive(Eq, Show)

///|
pub fn ModuleDecl::new(
  doc_comment : String?,
  modifiers : TopLevelModifiers,
  name : ModuleName,
  body : ModuleBody?,
) -> ModuleDecl {
  { doc_comment, modifiers, name, body }
}

///|
pub enum ModuleName {
  Identifier(Identifier)
  StringLiteral(StringLiteral)
} derive(Eq, Show)

///|
pub enum ModuleBody {
  ModuleBlock(NodeArray[Stmt])
  ModuleDecl(ModuleDecl)
} derive(Eq, Show)

///|
/// Import/Export declarations
pub enum ImportPhase {
  Normal
  Type
  Defer
} derive(Eq, Show)

///|
pub struct ImportDecl {
  import_clause : ImportClause?
  module_specifier : Expr
  attributes : ImportAttributes?
  phase : ImportPhase
} derive(Eq, Show)

///|
pub fn ImportDecl::new(
  import_clause : ImportClause?,
  module_specifier : Expr,
  attributes : ImportAttributes?,
  phase : ImportPhase,
) -> ImportDecl {
  { import_clause, module_specifier, attributes, phase }
}

///|
pub enum ImportEqualsModuleRef {
  EntityName(EntityName)
  ExternalModuleRef(Expr)
} derive(Eq, Show)

///|
pub struct ImportEqualsDecl {
  is_type_only : Bool
  name : Identifier
  module_ref : ImportEqualsModuleRef
} derive(Eq, Show)

///|
pub fn ImportEqualsDecl::new(
  is_type_only : Bool,
  name : Identifier,
  module_ref : ImportEqualsModuleRef,
) -> ImportEqualsDecl {
  { is_type_only, name, module_ref }
}

///|
pub struct ImportClause {
  is_type_only : Bool
  name : Identifier?
  named_bindings : NamedImportBindings?
} derive(Eq, Show)

///|
pub fn ImportClause::new(
  is_type_only : Bool,
  name : Identifier?,
  named_bindings : NamedImportBindings?,
) -> ImportClause {
  { is_type_only, name, named_bindings }
}

///|
pub enum NamedImportBindings {
  NamespaceImport(Identifier)
  NamedImports(NodeArray[ImportSpecifier])
} derive(Eq, Show)

///|
pub struct ImportSpecifier {
  is_type_only : Bool
  property_name : Identifier?
  name : Identifier
} derive(Eq, Show)

///|
pub fn ImportSpecifier::new(
  is_type_only : Bool,
  property_name : Identifier?,
  name : Identifier,
) -> ImportSpecifier {
  { is_type_only, property_name, name }
}

///|
pub struct ImportAttributes {
  elements : NodeArray[ImportAttribute]
} derive(Eq, Show)

///|
pub fn ImportAttributes::new(
  elements : NodeArray[ImportAttribute],
) -> ImportAttributes {
  { elements, }
}

///|
pub struct ImportAttribute {
  name : ImportAttributeName
  value : Expr
} derive(Eq, Show)

///|
pub fn ImportAttribute::new(
  name : ImportAttributeName,
  value : Expr,
) -> ImportAttribute {
  { name, value }
}

///|
pub enum ImportAttributeName {
  Identifier(Identifier)
  StringLiteral(StringLiteral)
} derive(Eq, Show)

///|
/// Export Decl
pub struct ExportDecl {
  modifiers : NodeArray[ModifierKind]?
  is_type_only : Bool
  export_clause : NamedExportBindings?
  module_specifier : Expr?
  attributes : ImportAttributes?
} derive(Eq, Show)

///|
pub fn ExportDecl::new(
  modifiers : NodeArray[ModifierKind]?,
  is_type_only : Bool,
  export_clause : NamedExportBindings?,
  module_specifier : Expr?,
  attributes : ImportAttributes?,
) -> ExportDecl {
  { modifiers, is_type_only, export_clause, module_specifier, attributes }
}

///|
pub enum NamedExportBindings {
  NamespaceExport(Identifier)
  NamedExports(NodeArray[ExportSpecifier])
} derive(Eq, Show)

///|
pub struct ExportSpecifier {
  is_type_only : Bool
  property_name : Identifier?
  name : Identifier
} derive(Eq, Show)

///|
pub fn ExportSpecifier::new(
  is_type_only : Bool,
  property_name : Identifier?,
  name : Identifier,
) -> ExportSpecifier {
  { is_type_only, property_name, name }
}

///|
pub struct ExportAssignment {
  modifiers : NodeArray[ModifierKind]?
  is_export_equals : Bool
  expression : Expr
} derive(Eq, Show)

///|
pub fn ExportAssignment::new(
  modifiers : NodeArray[ModifierKind]?,
  is_export_equals : Bool,
  expression : Expr,
) -> ExportAssignment {
  { modifiers, is_export_equals, expression }
}

///|
pub struct NamespaceExportDecl {
  name : Identifier
} derive(Eq, Show)

///|
pub fn NamespaceExportDecl::new(name : Identifier) -> NamespaceExportDecl {
  { name, }
}

///|
/// Statement AST node
pub struct Stmt {
  kind : StmtKind
  span : Span
} derive(Eq, Show)

///|
pub fn Stmt::new(kind : StmtKind, span : Span) -> Stmt {
  { kind, span }
}

///|
/// Statement node kinds
pub enum StmtKind {
  Block(Array[Stmt])
  VariableStmt(VariableStmt)
  UsingStmt(UsingStmt)
  ExprStmt(Expr)
  IfStmt(IfStmt)
  DoStmt(DoStmt)
  WhileStmt(WhileStmt)
  ForStmt(ForStmt)
  ForInStmt(ForInStmt)
  ForOfStmt(ForOfStmt)
  ContinueStmt(Identifier?)
  BreakStmt(Identifier?)
  ReturnStmt(Expr?)
  WithStmt(WithStmt)
  SwitchStmt(SwitchStmt)
  LabeledStmt(LabeledStmt)
  ThrowStmt(Expr)
  TryStmt(TryStmt)
  DebuggerStmt
  FunctionDecl(FunctionDecl)
  ClassDecl(ClassDecl)
  InterfaceDecl(InterfaceDecl)
  TypeAliasDecl(TypeAliasDecl)
  EnumDecl(EnumDecl)
  ModuleDecl(ModuleDecl)
  ImportDecl(ImportDecl)
  ImportEqualsDecl(ImportEqualsDecl)
  ExportDecl(ExportDecl)
  ExportAssignment(ExportAssignment)
  NamespaceExportDecl(NamespaceExportDecl)
  EmptyStmt
} derive(Eq, Show)

///|
pub struct VariableStmt {
  doc_comment : String?
  modifiers : NodeArray[ModifierKind]?
  declaration_list : NodeArray[VariableDecl]
} derive(Eq, Show)

///|
pub fn VariableStmt::new(
  doc_comment : String?,
  modifiers : NodeArray[ModifierKind]?,
  declaration_list : NodeArray[VariableDecl],
) -> VariableStmt {
  { doc_comment, modifiers, declaration_list }
}

///|
pub struct UsingStmt {
  modifiers : NodeArray[ModifierKind]?
  declaration_list : NodeArray[UsingDecl]
  is_await : Bool
} derive(Eq, Show)

///|
pub fn UsingStmt::new(
  modifiers : NodeArray[ModifierKind]?,
  declaration_list : NodeArray[UsingDecl],
  is_await : Bool,
) -> UsingStmt {
  { modifiers, declaration_list, is_await }
}
