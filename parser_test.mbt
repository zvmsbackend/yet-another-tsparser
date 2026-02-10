///| Parser expression tests

///|
fn parse_source(
  text : String,
  script_kind? : ScriptKind = TS,
  is_module? : Bool = false,
) -> SourceFile raise ParseError {
  let parser = Parser::new(text, script_kind~, is_module~)
  parser.parse_source_file("test.ts", text)
}

///|
test "expr - binary precedence" {
  let source = parse_source("1 + b * c")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: Plus, right: {kind: BinaryExpr({left: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:6(4-5)}), span: 1:5-1:6(4-5)}, operator: Asterisk, right: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:10(8-9)}), span: 1:9-1:10(8-9)}}), span: 1:5-1:10(4-9)}}), span: 1:1-1:10(0-9)}), span: 1:1-1:10(0-9)}], start: 1:1-1:1(0-0), end: 1:10-1:10(9-9), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "1 + b * c", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - assignment and logical" {
  let source = parse_source("a &&= b; c ??= d; e ||= f")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: AmpersandAmpersandEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:8(6-7)}), span: 1:7-1:8(6-7)}}), span: 1:1-1:8(0-7)}), span: 1:1-1:8(0-7)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), span: 1:10-1:11(9-10)}, operator: QuestionQuestionEquals, right: {kind: Identifier({text: "d", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:16-1:17(15-16)}), span: 1:16-1:17(15-16)}}), span: 1:10-1:17(9-16)}), span: 1:10-1:17(9-16)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "e", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:19-1:20(18-19)}), span: 1:19-1:20(18-19)}, operator: BarBarEquals, right: {kind: Identifier({text: "f", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:25-1:26(24-25)}), span: 1:25-1:26(24-25)}}), span: 1:19-1:26(18-25)}), span: 1:19-1:26(18-25)}], start: 1:1-1:1(0-0), end: 1:26-1:26(25-25), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a &&= b; c ??= d; e ||= f", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - optional chaining" {
  let source = parse_source("foo?.bar?.baz()")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: PropertyAccessExpr({expression: {kind: PropertyAccessExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: true, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:9(5-8)}}), span: 1:1-1:9(0-8)}, is_null_coalescing: true, name: {text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:14(10-13)}}), span: 1:1-1:14(0-13)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:14-1:14(13-13), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:16(0-15)}), span: 1:1-1:16(0-15)}], start: 1:1-1:1(0-0), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "foo?.bar?.baz()", script_kind: TS, is_module: false}
    ),
  )
}

///|

///|
test "expr - template literal" {
  let source = parse_source("`hello ${name}`")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: TemplateExpr({head: {text: "hello ", raw_text: "hello ", is_unterminated: false, has_extended_unicode_escape: false}, template_spans: {elements: [{expression: {kind: Identifier({text: "name", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:14(9-13)}), span: 1:10-1:14(9-13)}, literal: TemplateTail({text: "", raw_text: "", is_unterminated: false, has_extended_unicode_escape: false})}], start: 1:1-1:1(0-0), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:16(0-15)}), span: 1:1-1:16(0-15)}], start: 1:1-1:1(0-0), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "`hello ${name}`", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - tagged template long" {
  let source = parse_source("tag`hello ${name}`")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: TaggedTemplateExpr({tag: {kind: Identifier({text: "tag", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, type_arguments: None, template: {kind: TemplateExpr({head: {text: "hello ", raw_text: "hello ", is_unterminated: false, has_extended_unicode_escape: false}, template_spans: {elements: [{expression: {kind: Identifier({text: "name", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:17(12-16)}), span: 1:13-1:17(12-16)}, literal: TemplateTail({text: "", raw_text: "", is_unterminated: false, has_extended_unicode_escape: false})}], start: 1:4-1:4(3-3), end: 1:19-1:19(18-18), has_trailing_comma: false, is_missing_list: false}}), span: 1:4-1:19(3-18)}}), span: 1:1-1:19(0-18)}), span: 1:1-1:19(0-18)}], start: 1:1-1:1(0-0), end: 1:19-1:19(18-18), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "tag`hello ${name}`", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - template multi span" {
  let source = parse_source("`a ${b} c ${d}`")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: TemplateExpr({head: {text: "a ", raw_text: "a ", is_unterminated: false, has_extended_unicode_escape: false}, template_spans: {elements: [{expression: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}, literal: TemplateMiddle({text: " c ", raw_text: " c ", is_unterminated: false, has_extended_unicode_escape: false})}, {expression: {kind: Identifier({text: "d", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:14(12-13)}), span: 1:13-1:14(12-13)}, literal: TemplateTail({text: "", raw_text: "", is_unterminated: false, has_extended_unicode_escape: false})}], start: 1:1-1:1(0-0), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:16(0-15)}), span: 1:1-1:16(0-15)}], start: 1:1-1:1(0-0), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "`a ${b} c ${d}`", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - ternary and coalesce" {
  let source = parse_source("a ? b : c ?? d")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ConditionalExpr({condition: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, when_true: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:6(4-5)}), span: 1:5-1:6(4-5)}, when_false: {kind: BinaryExpr({left: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:10(8-9)}), span: 1:9-1:10(8-9)}, operator: QuestionQuestion, right: {kind: Identifier({text: "d", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:15(13-14)}), span: 1:14-1:15(13-14)}}), span: 1:9-1:15(8-14)}}), span: 1:1-1:15(0-14)}), span: 1:1-1:15(0-14)}], start: 1:1-1:1(0-0), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a ? b : c ?? d", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - instanceof and in" {
  let source = parse_source("a instanceof B; a in b")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: InstanceOf, right: {kind: Identifier({text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:15(13-14)}), span: 1:14-1:15(13-14)}}), span: 1:1-1:15(0-14)}), span: 1:1-1:15(0-14)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:17-1:18(16-17)}), span: 1:17-1:18(16-17)}, operator: In, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:22-1:23(21-22)}), span: 1:22-1:23(21-22)}}), span: 1:17-1:23(16-22)}), span: 1:17-1:23(16-22)}], start: 1:1-1:1(0-0), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a instanceof B; a in b", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - new and optional chain" {
  let source = parse_source("new Foo().bar?.baz(1, ...args)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: NewExpr({expression: {kind: CallExpr({expression: {kind: PropertyAccessExpr({expression: {kind: PropertyAccessExpr({expression: {kind: CallExpr({expression: {kind: Identifier({text: "Foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:8(4-7)}), span: 1:5-1:8(4-7)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:8-1:8(7-7), end: 1:10-1:10(9-9), has_trailing_comma: false, is_missing_list: false}}), span: 1:5-1:10(4-9)}, is_null_coalescing: false, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:14(10-13)}}), span: 1:5-1:14(4-13)}, is_null_coalescing: true, name: {text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:16-1:19(15-18)}}), span: 1:5-1:19(4-18)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [{kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:20-1:21(19-20)}), span: 1:20-1:21(19-20)}, {kind: SpreadElement({kind: Identifier({text: "args", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:26-1:30(25-29)}), span: 1:26-1:30(25-29)}), span: 1:23-1:30(22-29)}], start: 1:19-1:19(18-18), end: 1:31-1:31(30-30), has_trailing_comma: false, is_missing_list: false}}), span: 1:5-1:31(4-30)}, type_arguments: None, arguments: None}), span: 1:1-1:31(0-30)}), span: 1:1-1:31(0-30)}], start: 1:1-1:1(0-0), end: 1:31-1:31(30-30), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "new Foo().bar?.baz(1, ...args)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - array and object literals" {
  let source = parse_source(
    "[1, , 3, ...xs]; ({ a: 1, b: 2, c() { return 3 } })",
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ArrayLiteralExpr({elements: [{kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:2-1:3(1-2)}), span: 1:2-1:3(1-2)}, {kind: OmittedExpr, span: 1:5-1:6(4-5)}, {kind: NumericLiteral({text: "3", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:7-1:8(6-7)}), span: 1:7-1:8(6-7)}, {kind: SpreadElement({kind: Identifier({text: "xs", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:15(12-14)}), span: 1:13-1:15(12-14)}), span: 1:10-1:15(9-14)}], start: 1:1-1:1(0-0), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}), span: 1:1-1:16(0-15)}), span: 1:1-1:16(0-15)}, {kind: ExprStmt({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [PropertyAssignment({name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:21-1:22(20-21)}), initializer: {kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:24-1:25(23-24)}), span: 1:24-1:25(23-24)}}), PropertyAssignment({name: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:27-1:28(26-27)}), initializer: {kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:30-1:31(29-30)}), span: 1:30-1:31(29-30)}}), MethodDecl({doc_comment: None, decorators: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, is_generator: false, name: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:33-1:34(32-33)}), is_optional: false, type_parameters: None, parameters: {elements: [], start: 1:34-1:34(33-33), end: 1:36-1:36(35-35), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([{kind: ReturnStmt(Some({kind: NumericLiteral({text: "3", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:46-1:47(45-46)}), span: 1:46-1:47(45-46)})), span: 1:39-1:47(38-46)}])})], start: 1:19-1:19(18-18), end: 1:51-1:51(50-50), has_trailing_comma: false, is_missing_list: false}), span: 1:19-1:51(18-50)}), span: 1:18-1:52(17-51)}), span: 1:18-1:52(17-51)}], start: 1:1-1:1(0-0), end: 1:52-1:52(51-51), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "[1, , 3, ...xs]; ({ a: 1, b: 2, c() { return 3 } })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - unary and postfix" {
  let source = parse_source("++a; b--; !c; ~d")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: PrefixUnaryExpr({operator: PlusPlus, operand: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:3-1:4(2-3)}), span: 1:3-1:4(2-3)}}), span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, {kind: ExprStmt({kind: PostfixUnaryExpr({operand: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}, operator: MinusMinus}), span: 1:6-1:9(5-8)}), span: 1:6-1:9(5-8)}, {kind: ExprStmt({kind: PrefixUnaryExpr({operator: Exclamation, operand: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:13(11-12)}), span: 1:12-1:13(11-12)}}), span: 1:11-1:13(10-12)}), span: 1:11-1:13(10-12)}, {kind: ExprStmt({kind: PrefixUnaryExpr({operator: Tilde, operand: {kind: Identifier({text: "d", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:16-1:17(15-16)}), span: 1:16-1:17(15-16)}}), span: 1:15-1:17(14-16)}), span: 1:15-1:17(14-16)}], start: 1:1-1:1(0-0), end: 1:17-1:17(16-16), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "++a; b--; !c; ~d", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - unary keywords" {
  let source = parse_source("delete foo.bar; typeof foo; void 0")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: DeleteExpr({kind: PropertyAccessExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:11(7-10)}), span: 1:8-1:11(7-10)}, is_null_coalescing: false, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:15(11-14)}}), span: 1:8-1:15(7-14)}), span: 1:1-1:15(0-14)}), span: 1:1-1:15(0-14)}, {kind: ExprStmt({kind: TypeOfExpr({kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:24-1:27(23-26)}), span: 1:24-1:27(23-26)}), span: 1:17-1:27(16-26)}), span: 1:17-1:27(16-26)}, {kind: ExprStmt({kind: VoidExpr({kind: NumericLiteral({text: "0", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:34-1:35(33-34)}), span: 1:34-1:35(33-34)}), span: 1:29-1:35(28-34)}), span: 1:29-1:35(28-34)}], start: 1:1-1:1(0-0), end: 1:35-1:35(34-34), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "delete foo.bar; typeof foo; void 0", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - top level await in module" {
  let source = parse_source(
    (
      #|import "mod";
      #|await foo
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ImportDecl({import_clause: None, module_specifier: {kind: StringLiteral({text: "mod", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:8-1:13(7-12)}), span: 1:8-1:13(7-12)}, attributes: None, phase: Normal}), span: 1:1-1:13(0-12)}, {kind: ExprStmt({kind: AwaitExpr({kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:7-2:10(20-23)}), span: 2:7-2:10(20-23)}), span: 2:1-2:10(14-23)}), span: 2:1-2:10(14-23)}], start: 1:1-1:1(0-0), end: 2:10-2:10(23-23), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "import \"mod\";\nawait foo", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "expr - top level await in script error" {
  let error = try? parse_source("await foo")
  inspect(
    error,
    content="Err(Parse error at 1:1-1:10(0-9): 'await' expressions are only allowed at the top level of a file when that file is a module, but this file has no imports or exports. Consider adding an empty 'export {}' to make this file a module.)",
  )
}

///|
test "expr - top level await with empty export" {
  let source = parse_source(
    (
      #|export {};
      #|await foo
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExportDecl({modifiers: Some({elements: [export], start: 1:1-1:1(0-0), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}), is_type_only: false, export_clause: Some(NamedExports({elements: [], start: 1:8-1:8(7-7), end: 1:10-1:10(9-9), has_trailing_comma: false, is_missing_list: false})), module_specifier: None, attributes: None}), span: 1:1-2:1(0-11)}, {kind: ExprStmt({kind: AwaitExpr({kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:7-2:10(17-20)}), span: 2:7-2:10(17-20)}), span: 2:1-2:10(11-20)}), span: 2:1-2:10(11-20)}], start: 1:1-1:1(0-0), end: 2:10-2:10(20-20), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "export {};\nawait foo", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "expr - literals and keywords" {
  let source = parse_source("true; false; null; \"hi\"; 'ok'")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: TrueLiteral, span: 1:1-1:5(0-4)}), span: 1:1-1:5(0-4)}, {kind: ExprStmt({kind: FalseLiteral, span: 1:7-1:12(6-11)}), span: 1:7-1:12(6-11)}, {kind: ExprStmt({kind: NullLiteral, span: 1:14-1:18(13-17)}), span: 1:14-1:18(13-17)}, {kind: ExprStmt({kind: StringLiteral({text: "hi", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:20-1:24(19-23)}), span: 1:20-1:24(19-23)}), span: 1:20-1:24(19-23)}, {kind: ExprStmt({kind: StringLiteral({text: "ok", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:26-1:30(25-29)}), span: 1:26-1:30(25-29)}), span: 1:26-1:30(25-29)}], start: 1:1-1:1(0-0), end: 1:30-1:30(29-29), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "true; false; null; \"hi\"; 'ok'", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - this and super" {
  let source = parse_source("this; super; super.foo()")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ThisExpr, span: 1:1-1:5(0-4)}), span: 1:1-1:5(0-4)}, {kind: ExprStmt({kind: SuperExpr, span: 1:7-1:12(6-11)}), span: 1:7-1:12(6-11)}, {kind: ExprStmt({kind: CallExpr({expression: {kind: PropertyAccessExpr({expression: {kind: SuperExpr, span: 1:14-1:19(13-18)}, is_null_coalescing: false, name: {text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:20-1:23(19-22)}}), span: 1:14-1:23(13-22)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:23-1:23(22-22), end: 1:25-1:25(24-24), has_trailing_comma: false, is_missing_list: false}}), span: 1:14-1:25(13-24)}), span: 1:14-1:25(13-24)}], start: 1:1-1:1(0-0), end: 1:25-1:25(24-24), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "this; super; super.foo()", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - property access" {
  let source = parse_source("obj.prop; obj.long.chain")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: PropertyAccessExpr({expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: false, name: {text: "prop", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:9(4-8)}}), span: 1:1-1:9(0-8)}), span: 1:1-1:9(0-8)}, {kind: ExprStmt({kind: PropertyAccessExpr({expression: {kind: PropertyAccessExpr({expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:14(10-13)}), span: 1:11-1:14(10-13)}, is_null_coalescing: false, name: {text: "long", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:19(14-18)}}), span: 1:11-1:19(10-18)}, is_null_coalescing: false, name: {text: "chain", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:20-1:25(19-24)}}), span: 1:11-1:25(10-24)}), span: 1:11-1:25(10-24)}], start: 1:1-1:1(0-0), end: 1:25-1:25(24-24), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "obj.prop; obj.long.chain", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - element access" {
  let source = parse_source("obj[\"prop\"]; obj[index]")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ElementAccessExpr({expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: false, argument_expression: {kind: StringLiteral({text: "prop", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:5-1:11(4-10)}), span: 1:5-1:11(4-10)}}), span: 1:1-1:12(0-11)}), span: 1:1-1:12(0-11)}, {kind: ExprStmt({kind: ElementAccessExpr({expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:17(13-16)}), span: 1:14-1:17(13-16)}, is_null_coalescing: false, argument_expression: {kind: Identifier({text: "index", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:23(17-22)}), span: 1:18-1:23(17-22)}}), span: 1:14-1:24(13-23)}), span: 1:14-1:24(13-23)}], start: 1:1-1:1(0-0), end: 1:24-1:24(23-23), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "obj[\"prop\"]; obj[index]", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - optional access" {
  let source = parse_source("obj?.prop; obj?.[index]")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: PropertyAccessExpr({expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: true, name: {text: "prop", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:10(5-9)}}), span: 1:1-1:10(0-9)}), span: 1:1-1:10(0-9)}, {kind: ExprStmt({kind: ElementAccessExpr({expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:15(11-14)}), span: 1:12-1:15(11-14)}, is_null_coalescing: true, argument_expression: {kind: Identifier({text: "index", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:23(17-22)}), span: 1:18-1:23(17-22)}}), span: 1:12-1:24(11-23)}), span: 1:12-1:24(11-23)}], start: 1:1-1:1(0-0), end: 1:24-1:24(23-23), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "obj?.prop; obj?.[index]", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - call and optional call" {
  let source = parse_source("fn(1, 2); fn?.(arg)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "fn", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:3(0-2)}), span: 1:1-1:3(0-2)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [{kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:4-1:5(3-4)}), span: 1:4-1:5(3-4)}, {kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:7-1:8(6-7)}), span: 1:7-1:8(6-7)}], start: 1:3-1:3(2-2), end: 1:9-1:9(8-8), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:9(0-8)}), span: 1:1-1:9(0-8)}, {kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "fn", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:13(10-12)}), span: 1:11-1:13(10-12)}, is_null_coalescing: true, type_arguments: None, arguments: {elements: [{kind: Identifier({text: "arg", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:16-1:19(15-18)}), span: 1:16-1:19(15-18)}], start: 1:15-1:15(14-14), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}}), span: 1:11-1:20(10-19)}), span: 1:11-1:20(10-19)}], start: 1:1-1:1(0-0), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "fn(1, 2); fn?.(arg)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - call with type arguments" {
  let source = parse_source("fn<string, number>(x, y)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "fn", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:3(0-2)}), span: 1:1-1:3(0-2)}, is_null_coalescing: false, type_arguments: Some({elements: [{kind: KeywordType(String), span: 1:4-1:10(3-9)}, {kind: KeywordType(Number), span: 1:12-1:18(11-17)}], start: 1:3-1:3(2-2), end: 1:19-1:19(18-18), has_trailing_comma: false, is_missing_list: false}), arguments: {elements: [{kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:20-1:21(19-20)}), span: 1:20-1:21(19-20)}, {kind: Identifier({text: "y", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:23-1:24(22-23)}), span: 1:23-1:24(22-23)}], start: 1:19-1:19(18-18), end: 1:25-1:25(24-24), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:25(0-24)}), span: 1:1-1:25(0-24)}], start: 1:1-1:1(0-0), end: 1:25-1:25(24-24), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "fn<string, number>(x, y)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - new with type arguments" {
  let source = parse_source("new Box<string>(value)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: NewExpr({expression: {kind: CallExpr({expression: {kind: Identifier({text: "Box", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:8(4-7)}), span: 1:5-1:8(4-7)}, is_null_coalescing: false, type_arguments: Some({elements: [{kind: KeywordType(String), span: 1:9-1:15(8-14)}], start: 1:8-1:8(7-7), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}), arguments: {elements: [{kind: Identifier({text: "value", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:17-1:22(16-21)}), span: 1:17-1:22(16-21)}], start: 1:16-1:16(15-15), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}}), span: 1:5-1:23(4-22)}, type_arguments: None, arguments: None}), span: 1:1-1:23(0-22)}), span: 1:1-1:23(0-22)}], start: 1:1-1:1(0-0), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "new Box<string>(value)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - spread arguments" {
  let source = parse_source("fn(...args)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "fn", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:3(0-2)}), span: 1:1-1:3(0-2)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [{kind: SpreadElement({kind: Identifier({text: "args", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:11(6-10)}), span: 1:7-1:11(6-10)}), span: 1:4-1:11(3-10)}], start: 1:3-1:3(2-2), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:12(0-11)}), span: 1:1-1:12(0-11)}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "fn(...args)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - bitwise operators" {
  let source = parse_source("a & b; a | b; a ^ b")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: BitwiseAnd, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:6(4-5)}), span: 1:5-1:6(4-5)}}), span: 1:1-1:6(0-5)}), span: 1:1-1:6(0-5)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:9(7-8)}), span: 1:8-1:9(7-8)}, operator: BitwiseOr, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:13(11-12)}), span: 1:12-1:13(11-12)}}), span: 1:8-1:13(7-12)}), span: 1:8-1:13(7-12)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:16(14-15)}), span: 1:15-1:16(14-15)}, operator: BitwiseXor, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:19-1:20(18-19)}), span: 1:19-1:20(18-19)}}), span: 1:15-1:20(14-19)}), span: 1:15-1:20(14-19)}], start: 1:1-1:1(0-0), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a & b; a | b; a ^ b", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - shift operators" {
  let source = parse_source("a << b; a >> b; a >>> b")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: ShiftLeft, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}}), span: 1:1-1:7(0-6)}), span: 1:1-1:7(0-6)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:10(8-9)}), span: 1:9-1:10(8-9)}, operator: ShiftRight, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:15(13-14)}), span: 1:14-1:15(13-14)}}), span: 1:9-1:15(8-14)}), span: 1:9-1:15(8-14)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:17-1:18(16-17)}), span: 1:17-1:18(16-17)}, operator: ShiftRightUnsigned, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:23-1:24(22-23)}), span: 1:23-1:24(22-23)}}), span: 1:17-1:24(16-23)}), span: 1:17-1:24(16-23)}], start: 1:1-1:1(0-0), end: 1:24-1:24(23-23), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a << b; a >> b; a >>> b", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - equality operators" {
  let source = parse_source("a == b; a === b; a != b; a !== b")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: EqualsEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}}), span: 1:1-1:7(0-6)}), span: 1:1-1:7(0-6)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:10(8-9)}), span: 1:9-1:10(8-9)}, operator: EqualsEqualsEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:16(14-15)}), span: 1:15-1:16(14-15)}}), span: 1:9-1:16(8-15)}), span: 1:9-1:16(8-15)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:19(17-18)}), span: 1:18-1:19(17-18)}, operator: ExclamationEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:23-1:24(22-23)}), span: 1:23-1:24(22-23)}}), span: 1:18-1:24(17-23)}), span: 1:18-1:24(17-23)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:26-1:27(25-26)}), span: 1:26-1:27(25-26)}, operator: ExclamationEqualsEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:32-1:33(31-32)}), span: 1:32-1:33(31-32)}}), span: 1:26-1:33(25-32)}), span: 1:26-1:33(25-32)}], start: 1:1-1:1(0-0), end: 1:33-1:33(32-32), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a == b; a === b; a != b; a !== b", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - relational operators" {
  let source = parse_source("a < b; a <= b; a > b; a >= b")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: LessThan, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:6(4-5)}), span: 1:5-1:6(4-5)}}), span: 1:1-1:6(0-5)}), span: 1:1-1:6(0-5)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:9(7-8)}), span: 1:8-1:9(7-8)}, operator: LessThanEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:14(12-13)}), span: 1:13-1:14(12-13)}}), span: 1:8-1:14(7-13)}), span: 1:8-1:14(7-13)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:16-1:17(15-16)}), span: 1:16-1:17(15-16)}, operator: GreaterThan, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:20-1:21(19-20)}), span: 1:20-1:21(19-20)}}), span: 1:16-1:21(15-20)}), span: 1:16-1:21(15-20)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:23-1:24(22-23)}), span: 1:23-1:24(22-23)}, operator: GreaterThanEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:28-1:29(27-28)}), span: 1:28-1:29(27-28)}}), span: 1:23-1:29(22-28)}), span: 1:23-1:29(22-28)}], start: 1:1-1:1(0-0), end: 1:29-1:29(28-28), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a < b; a <= b; a > b; a >= b", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - logical operators" {
  let source = parse_source("a && b; a || b; a ?? b")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: AmpersandAmpersand, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}}), span: 1:1-1:7(0-6)}), span: 1:1-1:7(0-6)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:10(8-9)}), span: 1:9-1:10(8-9)}, operator: BarBar, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:15(13-14)}), span: 1:14-1:15(13-14)}}), span: 1:9-1:15(8-14)}), span: 1:9-1:15(8-14)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:17-1:18(16-17)}), span: 1:17-1:18(16-17)}, operator: QuestionQuestion, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:22-1:23(21-22)}), span: 1:22-1:23(21-22)}}), span: 1:17-1:23(16-22)}), span: 1:17-1:23(16-22)}], start: 1:1-1:1(0-0), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a && b; a || b; a ?? b", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - assignment operators" {
  let source = parse_source("a = b; a += b; a <<= b")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: Equals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:6(4-5)}), span: 1:5-1:6(4-5)}}), span: 1:1-1:6(0-5)}), span: 1:1-1:6(0-5)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:9(7-8)}), span: 1:8-1:9(7-8)}, operator: PlusEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:14(12-13)}), span: 1:13-1:14(12-13)}}), span: 1:8-1:14(7-13)}), span: 1:8-1:14(7-13)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:16-1:17(15-16)}), span: 1:16-1:17(15-16)}, operator: ShiftLeftEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:22-1:23(21-22)}), span: 1:22-1:23(21-22)}}), span: 1:16-1:23(15-22)}), span: 1:16-1:23(15-22)}], start: 1:1-1:1(0-0), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a = b; a += b; a <<= b", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - assignment chaining" {
  let source = parse_source("a = b = c")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: Equals, right: {kind: BinaryExpr({left: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:6(4-5)}), span: 1:5-1:6(4-5)}, operator: Equals, right: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:10(8-9)}), span: 1:9-1:10(8-9)}}), span: 1:5-1:10(4-9)}}), span: 1:1-1:10(0-9)}), span: 1:1-1:10(0-9)}], start: 1:1-1:1(0-0), end: 1:10-1:10(9-9), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a = b = c", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - logical precedence mix" {
  let source = parse_source("a || b && c")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: BarBar, right: {kind: BinaryExpr({left: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}, operator: AmpersandAmpersand, right: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:12(10-11)}), span: 1:11-1:12(10-11)}}), span: 1:6-1:12(5-11)}}), span: 1:1-1:12(0-11)}), span: 1:1-1:12(0-11)}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a || b && c", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - await optional access" {
  let source = parse_source(
    (
      #|import "mod";
      #|await foo?.bar
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ImportDecl({import_clause: None, module_specifier: {kind: StringLiteral({text: "mod", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:8-1:13(7-12)}), span: 1:8-1:13(7-12)}, attributes: None, phase: Normal}), span: 1:1-1:13(0-12)}, {kind: ExprStmt({kind: AwaitExpr({kind: PropertyAccessExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:7-2:10(20-23)}), span: 2:7-2:10(20-23)}, is_null_coalescing: true, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:12-2:15(25-28)}}), span: 2:7-2:15(20-28)}), span: 2:1-2:15(14-28)}), span: 2:1-2:15(14-28)}], start: 1:1-1:1(0-0), end: 2:15-2:15(28-28), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "import \"mod\";\nawait foo?.bar", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "expr - parenthesized grouping" {
  let source = parse_source("(a + b) * c")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: ParenthesizedExpr({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:2-1:3(1-2)}), span: 1:2-1:3(1-2)}, operator: Plus, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}}), span: 1:2-1:7(1-6)}), span: 1:1-1:8(0-7)}, operator: Asterisk, right: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:12(10-11)}), span: 1:11-1:12(10-11)}}), span: 1:1-1:12(0-11)}), span: 1:1-1:12(0-11)}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "(a + b) * c", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - conditional nesting" {
  let source = parse_source("a ? b : c ? d : e")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ConditionalExpr({condition: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, when_true: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:6(4-5)}), span: 1:5-1:6(4-5)}, when_false: {kind: ConditionalExpr({condition: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:10(8-9)}), span: 1:9-1:10(8-9)}, when_true: {kind: Identifier({text: "d", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:14(12-13)}), span: 1:13-1:14(12-13)}, when_false: {kind: Identifier({text: "e", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:17-1:18(16-17)}), span: 1:17-1:18(16-17)}}), span: 1:9-1:18(8-17)}}), span: 1:1-1:18(0-17)}), span: 1:1-1:18(0-17)}], start: 1:1-1:1(0-0), end: 1:18-1:18(17-17), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a ? b : c ? d : e", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - array literal edges" {
  let source = parse_source("[]; [1, 2,]")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ArrayLiteralExpr({elements: [], start: 1:1-1:1(0-0), end: 1:3-1:3(2-2), has_trailing_comma: false, is_missing_list: false}), span: 1:1-1:3(0-2)}), span: 1:1-1:3(0-2)}, {kind: ExprStmt({kind: ArrayLiteralExpr({elements: [{kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}, {kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:9-1:10(8-9)}), span: 1:9-1:10(8-9)}], start: 1:5-1:5(4-4), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}), span: 1:5-1:12(4-11)}), span: 1:5-1:12(4-11)}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "[]; [1, 2,]", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - object literal spreads" {
  let source = parse_source("({ ...obj, [\"k\"]: 1, a: 2 })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [SpreadAssignment({kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:10(6-9)}), span: 1:7-1:10(6-9)}), PropertyAssignment({name: ComputedPropertyName({kind: StringLiteral({text: "k", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:13-1:16(12-15)}), span: 1:13-1:16(12-15)}), initializer: {kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:19-1:20(18-19)}), span: 1:19-1:20(18-19)}}), PropertyAssignment({name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:22-1:23(21-22)}), initializer: {kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:25-1:26(24-25)}), span: 1:25-1:26(24-25)}})], start: 1:2-1:2(1-1), end: 1:28-1:28(27-27), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:28(1-27)}), span: 1:1-1:29(0-28)}), span: 1:1-1:29(0-28)}], start: 1:1-1:1(0-0), end: 1:29-1:29(28-28), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "({ ...obj, [\"k\"]: 1, a: 2 })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - object literal keyword keys" {
  let source = parse_source("({ return: 1, default: 2 })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [PropertyAssignment({name: Identifier({text: "return", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:4-1:10(3-9)}), initializer: {kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:12-1:13(11-12)}), span: 1:12-1:13(11-12)}}), PropertyAssignment({name: Identifier({text: "default", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:22(14-21)}), initializer: {kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:24-1:25(23-24)}), span: 1:24-1:25(23-24)}})], start: 1:2-1:2(1-1), end: 1:27-1:27(26-26), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:27(1-26)}), span: 1:1-1:28(0-27)}), span: 1:1-1:28(0-27)}], start: 1:1-1:1(0-0), end: 1:28-1:28(27-27), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "({ return: 1, default: 2 })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - chained calls and access" {
  let source = parse_source("foo().bar.baz(1)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: PropertyAccessExpr({expression: {kind: PropertyAccessExpr({expression: {kind: CallExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:4-1:4(3-3), end: 1:6-1:6(5-5), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:6(0-5)}, is_null_coalescing: false, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:10(6-9)}}), span: 1:1-1:10(0-9)}, is_null_coalescing: false, name: {text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:14(10-13)}}), span: 1:1-1:14(0-13)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [{kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:15-1:16(14-15)}), span: 1:15-1:16(14-15)}], start: 1:14-1:14(13-13), end: 1:17-1:17(16-16), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:17(0-16)}), span: 1:1-1:17(0-16)}], start: 1:1-1:1(0-0), end: 1:17-1:17(16-16), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "foo().bar.baz(1)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - member access keyword key" {
  let source = parse_source("obj.return")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: PropertyAccessExpr({expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: false, name: {text: "return", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:11(4-10)}}), span: 1:1-1:11(0-10)}), span: 1:1-1:11(0-10)}], start: 1:1-1:1(0-0), end: 1:11-1:11(10-10), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "obj.return", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - regex literal" {
  let source = parse_source("/ab+c/i")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: RegularExprLiteral({text: "/ab+c/i", is_unterminated: false, has_extended_unicode_escape: false, span: 1:1-1:8(0-7)}), span: 1:1-1:8(0-7)}), span: 1:1-1:8(0-7)}], start: 1:1-1:1(0-0), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "/ab+c/i", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - no-sub template literal" {
  let source = parse_source("`plain`")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: NoSubstitutionTemplateLiteral({text: "plain", raw_text: "plain", is_unterminated: false, has_extended_unicode_escape: false}), span: 1:1-1:8(0-7)}), span: 1:1-1:8(0-7)}], start: 1:1-1:1(0-0), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "`plain`", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - function expression" {
  let source = parse_source("(function f(a: number): number { return a })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: FunctionExpr({is_async: false, is_generator: false, name: Some({text: "f", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:12(10-11)}), type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:14(12-13)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 1:16-1:22(15-21)}), initializer: None, span: 1:13-1:22(12-21)}], start: 1:12-1:12(11-11), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(Number), span: 1:25-1:31(24-30)}), body: Some([{kind: ReturnStmt(Some({kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:41-1:42(40-41)}), span: 1:41-1:42(40-41)})), span: 1:34-1:42(33-41)}])}), span: 1:2-1:44(1-43)}), span: 1:1-1:45(0-44)}), span: 1:1-1:45(0-44)}], start: 1:1-1:1(0-0), end: 1:45-1:45(44-44), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "(function f(a: number): number { return a })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - generator function expression" {
  let source = parse_source("(function* gen() { yield 1 })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: FunctionExpr({is_async: false, is_generator: true, name: Some({text: "gen", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:15(11-14)}), type_parameters: None, parameters: {elements: [], start: 1:15-1:15(14-14), end: 1:17-1:17(16-16), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([{kind: ExprStmt({kind: YieldExpr({is_delegate: false, expression: Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:26-1:27(25-26)}), span: 1:26-1:27(25-26)})}), span: 1:20-1:27(19-26)}), span: 1:20-1:27(19-26)}])}), span: 1:2-1:29(1-28)}), span: 1:1-1:30(0-29)}), span: 1:1-1:30(0-29)}], start: 1:1-1:1(0-0), end: 1:30-1:30(29-29), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "(function* gen() { yield 1 })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - class expression" {
  let source = parse_source("(class C { method() { return 1 } })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ClassExpr({name: Some({text: "C", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:9(7-8)}), type_parameters: None, heritage_clauses: None, members: {elements: [MethodDecl({doc_comment: None, decorators: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, is_generator: false, name: Identifier({text: "method", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:18(11-17)}), is_optional: false, type_parameters: None, parameters: {elements: [], start: 1:18-1:18(17-17), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([{kind: ReturnStmt(Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:30-1:31(29-30)}), span: 1:30-1:31(29-30)})), span: 1:23-1:31(22-30)}])})], start: 1:10-1:10(9-9), end: 1:34-1:34(33-33), has_trailing_comma: false, is_missing_list: false}}), span: 1:2-1:35(1-34)}), span: 1:1-1:36(0-35)}), span: 1:1-1:36(0-35)}], start: 1:1-1:1(0-0), end: 1:36-1:36(35-35), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "(class C { method() { return 1 } })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - object literal shorthand" {
  let source = parse_source("({ a, b: 1 })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [ShorthandPropertyAssignment({name: {text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:4-1:5(3-4)}, object_assignment_initializer: None}), PropertyAssignment({name: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:8(6-7)}), initializer: {kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:10-1:11(9-10)}), span: 1:10-1:11(9-10)}})], start: 1:2-1:2(1-1), end: 1:13-1:13(12-12), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:13(1-12)}), span: 1:1-1:14(0-13)}), span: 1:1-1:14(0-13)}], start: 1:1-1:1(0-0), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "({ a, b: 1 })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - numeric literals" {
  let source = parse_source("0; 1.5; 42")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: NumericLiteral({text: "0", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, {kind: ExprStmt({kind: NumericLiteral({text: "1.5", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:4-1:7(3-6)}), span: 1:4-1:7(3-6)}), span: 1:4-1:7(3-6)}, {kind: ExprStmt({kind: NumericLiteral({text: "42", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:9-1:11(8-10)}), span: 1:9-1:11(8-10)}), span: 1:9-1:11(8-10)}], start: 1:1-1:1(0-0), end: 1:11-1:11(10-10), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "0; 1.5; 42", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - exponentiation" {
  let source = parse_source("2 ** 3 ** 2")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: AsteriskAsterisk, right: {kind: BinaryExpr({left: {kind: NumericLiteral({text: "3", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}, operator: AsteriskAsterisk, right: {kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:11-1:12(10-11)}), span: 1:11-1:12(10-11)}}), span: 1:6-1:12(5-11)}}), span: 1:1-1:12(0-11)}), span: 1:1-1:12(0-11)}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "2 ** 3 ** 2", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - exponentiation assignment" {
  let source = parse_source("a **= b")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: AsteriskAsteriskEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:8(6-7)}), span: 1:7-1:8(6-7)}}), span: 1:1-1:8(0-7)}), span: 1:1-1:8(0-7)}], start: 1:1-1:1(0-0), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a **= b", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - optional call with type args" {
  let source = parse_source("fn?.<string>(x)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "fn", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:3(0-2)}), span: 1:1-1:3(0-2)}, is_null_coalescing: true, type_arguments: Some({elements: [{kind: KeywordType(String), span: 1:6-1:12(5-11)}], start: 1:5-1:5(4-4), end: 1:13-1:13(12-12), has_trailing_comma: false, is_missing_list: false}), arguments: {elements: [{kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:15(13-14)}), span: 1:14-1:15(13-14)}], start: 1:13-1:13(12-12), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:16(0-15)}), span: 1:1-1:16(0-15)}], start: 1:1-1:1(0-0), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "fn?.<string>(x)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - object literal accessors" {
  let source = parse_source("({ get x() { return 1 }, set x(v) {} })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [GetAccessor({doc_comment: None, decorators: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:9(7-8)}), parameters: {elements: [], start: 1:9-1:9(8-8), end: 1:11-1:11(10-10), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([{kind: ReturnStmt(Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:21-1:22(20-21)}), span: 1:21-1:22(20-21)})), span: 1:14-1:22(13-21)}])}), SetAccessor({doc_comment: None, decorators: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:30-1:31(29-30)}), parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "v", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:32-1:33(31-32)}), is_optional: false, type_node: None, initializer: None, span: 1:32-1:33(31-32)}], start: 1:31-1:31(30-30), end: 1:34-1:34(33-33), has_trailing_comma: false, is_missing_list: false}, body: Some([])})], start: 1:2-1:2(1-1), end: 1:39-1:39(38-38), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:39(1-38)}), span: 1:1-1:40(0-39)}), span: 1:1-1:40(0-39)}], start: 1:1-1:1(0-0), end: 1:40-1:40(39-39), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "({ get x() { return 1 }, set x(v) {} })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - non-null and optional chain mix" {
  let source = parse_source("foo!.bar?.baz")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: PropertyAccessExpr({expression: {kind: PropertyAccessExpr({expression: {kind: NonNullExpr({kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}), span: 1:1-1:5(0-4)}, is_null_coalescing: false, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:9(5-8)}}), span: 1:1-1:9(0-8)}, is_null_coalescing: true, name: {text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:14(10-13)}}), span: 1:1-1:14(0-13)}), span: 1:1-1:14(0-13)}], start: 1:1-1:1(0-0), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "foo!.bar?.baz", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - element access non-null" {
  let source = parse_source("arr[0]!.prop")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: PropertyAccessExpr({expression: {kind: NonNullExpr({kind: ElementAccessExpr({expression: {kind: Identifier({text: "arr", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: false, argument_expression: {kind: NumericLiteral({text: "0", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:5-1:6(4-5)}), span: 1:5-1:6(4-5)}}), span: 1:1-1:7(0-6)}), span: 1:1-1:8(0-7)}, is_null_coalescing: false, name: {text: "prop", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:13(8-12)}}), span: 1:1-1:13(0-12)}), span: 1:1-1:13(0-12)}], start: 1:1-1:1(0-0), end: 1:13-1:13(12-12), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "arr[0]!.prop", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - optional element call" {
  let source = parse_source("obj?.[key]?.(arg)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: ElementAccessExpr({expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: true, argument_expression: {kind: Identifier({text: "key", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:10(6-9)}), span: 1:7-1:10(6-9)}}), span: 1:1-1:11(0-10)}, is_null_coalescing: true, type_arguments: None, arguments: {elements: [{kind: Identifier({text: "arg", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:17(13-16)}), span: 1:14-1:17(13-16)}], start: 1:13-1:13(12-12), end: 1:18-1:18(17-17), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:18(0-17)}), span: 1:1-1:18(0-17)}], start: 1:1-1:1(0-0), end: 1:18-1:18(17-17), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "obj?.[key]?.(arg)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - optional element access chain" {
  let source = parse_source("obj?.[key]?.prop")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: PropertyAccessExpr({expression: {kind: ElementAccessExpr({expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: true, argument_expression: {kind: Identifier({text: "key", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:10(6-9)}), span: 1:7-1:10(6-9)}}), span: 1:1-1:11(0-10)}, is_null_coalescing: true, name: {text: "prop", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:17(12-16)}}), span: 1:1-1:17(0-16)}), span: 1:1-1:17(0-16)}], start: 1:1-1:1(0-0), end: 1:17-1:17(16-16), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "obj?.[key]?.prop", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - template optional expr" {
  let source = parse_source("`a ${foo?.bar} b`")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: TemplateExpr({head: {text: "a ", raw_text: "a ", is_unterminated: false, has_extended_unicode_escape: false}, template_spans: {elements: [{expression: {kind: PropertyAccessExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:9(5-8)}), span: 1:6-1:9(5-8)}, is_null_coalescing: true, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:14(10-13)}}), span: 1:6-1:14(5-13)}, literal: TemplateTail({text: " b", raw_text: " b", is_unterminated: false, has_extended_unicode_escape: false})}], start: 1:1-1:1(0-0), end: 1:18-1:18(17-17), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:18(0-17)}), span: 1:1-1:18(0-17)}], start: 1:1-1:1(0-0), end: 1:18-1:18(17-17), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "`a ${foo?.bar} b`", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - object literal computed method" {
  let source = parse_source("({ [\"x\"]() { return 1 } })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [MethodDecl({doc_comment: None, decorators: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, is_generator: false, name: ComputedPropertyName({kind: StringLiteral({text: "x", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:5-1:8(4-7)}), span: 1:5-1:8(4-7)}), is_optional: false, type_parameters: None, parameters: {elements: [], start: 1:9-1:9(8-8), end: 1:11-1:11(10-10), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([{kind: ReturnStmt(Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:21-1:22(20-21)}), span: 1:21-1:22(20-21)})), span: 1:14-1:22(13-21)}])})], start: 1:2-1:2(1-1), end: 1:26-1:26(25-25), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:26(1-25)}), span: 1:1-1:27(0-26)}), span: 1:1-1:27(0-26)}], start: 1:1-1:1(0-0), end: 1:27-1:27(26-26), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "({ [\"x\"]() { return 1 } })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - object literal generator method" {
  let source = parse_source("({ *gen() { yield 1 } })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [MethodDecl({doc_comment: None, decorators: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, is_generator: true, name: Identifier({text: "gen", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:8(4-7)}), is_optional: false, type_parameters: None, parameters: {elements: [], start: 1:8-1:8(7-7), end: 1:10-1:10(9-9), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([{kind: ExprStmt({kind: YieldExpr({is_delegate: false, expression: Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:19-1:20(18-19)}), span: 1:19-1:20(18-19)})}), span: 1:13-1:20(12-19)}), span: 1:13-1:20(12-19)}])})], start: 1:2-1:2(1-1), end: 1:24-1:24(23-23), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:24(1-23)}), span: 1:1-1:25(0-24)}), span: 1:1-1:25(0-24)}], start: 1:1-1:1(0-0), end: 1:25-1:25(24-24), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "({ *gen() { yield 1 } })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - array spread trailing comma" {
  let source = parse_source("[...a, b,]")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ArrayLiteralExpr({elements: [{kind: SpreadElement({kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:6(4-5)}), span: 1:5-1:6(4-5)}), span: 1:2-1:6(1-5)}, {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:9(7-8)}), span: 1:8-1:9(7-8)}], start: 1:1-1:1(0-0), end: 1:11-1:11(10-10), has_trailing_comma: false, is_missing_list: false}), span: 1:1-1:11(0-10)}), span: 1:1-1:11(0-10)}], start: 1:1-1:1(0-0), end: 1:11-1:11(10-10), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "[...a, b,]", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - non-null call" {
  let source = parse_source("foo!()")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: NonNullExpr({kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}), span: 1:1-1:5(0-4)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:5-1:5(4-4), end: 1:7-1:7(6-6), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:7(0-6)}), span: 1:1-1:7(0-6)}], start: 1:1-1:1(0-0), end: 1:7-1:7(6-6), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "foo!()", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - type assertion call" {
  let source = parse_source("<Foo>bar()")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: TypeAssertionExpr({type_node: {kind: TypeReference({type_name: Identifier({text: "Foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:2-1:5(1-4)}), type_arguments: None}), span: 1:2-1:5(1-4)}, expression: {kind: CallExpr({expression: {kind: Identifier({text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:9(5-8)}), span: 1:6-1:9(5-8)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:9-1:9(8-8), end: 1:11-1:11(10-10), has_trailing_comma: false, is_missing_list: false}}), span: 1:6-1:11(5-10)}}), span: 1:1-1:11(0-10)}), span: 1:1-1:11(0-10)}], start: 1:1-1:1(0-0), end: 1:11-1:11(10-10), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "<Foo>bar()", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - as with conditional" {
  let source = parse_source("foo as Bar ? a : b")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ConditionalExpr({condition: {kind: AsExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, type_node: {kind: TypeReference({type_name: Identifier({text: "Bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:11(7-10)}), type_arguments: None}), span: 1:8-1:11(7-10)}}), span: 1:1-1:11(0-10)}, when_true: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:15(13-14)}), span: 1:14-1:15(13-14)}, when_false: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:19(17-18)}), span: 1:18-1:19(17-18)}}), span: 1:1-1:19(0-18)}), span: 1:1-1:19(0-18)}], start: 1:1-1:1(0-0), end: 1:19-1:19(18-18), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "foo as Bar ? a : b", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - optional property call with type args" {
  let source = parse_source("foo?.bar<string>(x)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: PropertyAccessExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: true, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:9(5-8)}}), span: 1:1-1:9(0-8)}, is_null_coalescing: false, type_arguments: Some({elements: [{kind: KeywordType(String), span: 1:10-1:16(9-15)}], start: 1:9-1:9(8-8), end: 1:17-1:17(16-16), has_trailing_comma: false, is_missing_list: false}), arguments: {elements: [{kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:19(17-18)}), span: 1:18-1:19(17-18)}], start: 1:17-1:17(16-16), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:20(0-19)}), span: 1:1-1:20(0-19)}], start: 1:1-1:1(0-0), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "foo?.bar<string>(x)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - element access then call" {
  let source = parse_source("obj[\"m\"](1)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: ElementAccessExpr({expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: false, argument_expression: {kind: StringLiteral({text: "m", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:5-1:8(4-7)}), span: 1:5-1:8(4-7)}}), span: 1:1-1:9(0-8)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [{kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:10-1:11(9-10)}), span: 1:10-1:11(9-10)}], start: 1:9-1:9(8-8), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:12(0-11)}), span: 1:1-1:12(0-11)}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "obj[\"m\"](1)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - non-null after call" {
  let source = parse_source("fn()!.prop")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: PropertyAccessExpr({expression: {kind: NonNullExpr({kind: CallExpr({expression: {kind: Identifier({text: "fn", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:3(0-2)}), span: 1:1-1:3(0-2)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:3-1:3(2-2), end: 1:5-1:5(4-4), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:5(0-4)}), span: 1:1-1:6(0-5)}, is_null_coalescing: false, name: {text: "prop", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:11(6-10)}}), span: 1:1-1:11(0-10)}), span: 1:1-1:11(0-10)}], start: 1:1-1:1(0-0), end: 1:11-1:11(10-10), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "fn()!.prop", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - new non-null property" {
  let source = parse_source("new Foo()!.bar")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: NewExpr({expression: {kind: PropertyAccessExpr({expression: {kind: NonNullExpr({kind: CallExpr({expression: {kind: Identifier({text: "Foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:8(4-7)}), span: 1:5-1:8(4-7)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:8-1:8(7-7), end: 1:10-1:10(9-9), has_trailing_comma: false, is_missing_list: false}}), span: 1:5-1:10(4-9)}), span: 1:5-1:11(4-10)}, is_null_coalescing: false, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:15(11-14)}}), span: 1:5-1:15(4-14)}, type_arguments: None, arguments: None}), span: 1:1-1:15(0-14)}), span: 1:1-1:15(0-14)}], start: 1:1-1:1(0-0), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "new Foo()!.bar", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - new type args property" {
  let source = parse_source("new Box<string>().value")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: NewExpr({expression: {kind: PropertyAccessExpr({expression: {kind: CallExpr({expression: {kind: Identifier({text: "Box", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:8(4-7)}), span: 1:5-1:8(4-7)}, is_null_coalescing: false, type_arguments: Some({elements: [{kind: KeywordType(String), span: 1:9-1:15(8-14)}], start: 1:8-1:8(7-7), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}), arguments: {elements: [], start: 1:16-1:16(15-15), end: 1:18-1:18(17-17), has_trailing_comma: false, is_missing_list: false}}), span: 1:5-1:18(4-17)}, is_null_coalescing: false, name: {text: "value", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:19-1:24(18-23)}}), span: 1:5-1:24(4-23)}, type_arguments: None, arguments: None}), span: 1:1-1:24(0-23)}), span: 1:1-1:24(0-23)}], start: 1:1-1:1(0-0), end: 1:24-1:24(23-23), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "new Box<string>().value", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - object literal spread and shorthand" {
  let source = parse_source("({ a, ...b, c: 1 })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [ShorthandPropertyAssignment({name: {text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:4-1:5(3-4)}, object_assignment_initializer: None}), SpreadAssignment({kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), span: 1:10-1:11(9-10)}), PropertyAssignment({name: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:14(12-13)}), initializer: {kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:16-1:17(15-16)}), span: 1:16-1:17(15-16)}})], start: 1:2-1:2(1-1), end: 1:19-1:19(18-18), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:19(1-18)}), span: 1:1-1:20(0-19)}), span: 1:1-1:20(0-19)}], start: 1:1-1:1(0-0), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "({ a, ...b, c: 1 })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - optional call spread" {
  let source = parse_source("fn?.(...args)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "fn", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:3(0-2)}), span: 1:1-1:3(0-2)}, is_null_coalescing: true, type_arguments: None, arguments: {elements: [{kind: SpreadElement({kind: Identifier({text: "args", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:13(8-12)}), span: 1:9-1:13(8-12)}), span: 1:6-1:13(5-12)}], start: 1:5-1:5(4-4), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:14(0-13)}), span: 1:1-1:14(0-13)}], start: 1:1-1:1(0-0), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "fn?.(...args)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - nested parentheses access" {
  let source = parse_source("((foo)).bar")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: PropertyAccessExpr({expression: {kind: ParenthesizedExpr({kind: ParenthesizedExpr({kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:3-1:6(2-5)}), span: 1:3-1:6(2-5)}), span: 1:2-1:7(1-6)}), span: 1:1-1:8(0-7)}, is_null_coalescing: false, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:12(8-11)}}), span: 1:1-1:12(0-11)}), span: 1:1-1:12(0-11)}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "((foo)).bar", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - optional element access" {
  let source = parse_source("obj?.[key]")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ElementAccessExpr({expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: true, argument_expression: {kind: Identifier({text: "key", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:10(6-9)}), span: 1:7-1:10(6-9)}}), span: 1:1-1:11(0-10)}), span: 1:1-1:11(0-10)}], start: 1:1-1:1(0-0), end: 1:11-1:11(10-10), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "obj?.[key]", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - optional chain element access" {
  let source = parse_source("foo?.bar?.[baz]")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ElementAccessExpr({expression: {kind: PropertyAccessExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: true, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:9(5-8)}}), span: 1:1-1:9(0-8)}, is_null_coalescing: true, argument_expression: {kind: Identifier({text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:15(11-14)}), span: 1:12-1:15(11-14)}}), span: 1:1-1:16(0-15)}), span: 1:1-1:16(0-15)}], start: 1:1-1:1(0-0), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "foo?.bar?.[baz]", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - parenthesized type assertion call" {
  let source = parse_source("(<T>fn)(value)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: ParenthesizedExpr({kind: TypeAssertionExpr({type_node: {kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:3-1:4(2-3)}), type_arguments: None}), span: 1:3-1:4(2-3)}, expression: {kind: Identifier({text: "fn", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:7(4-6)}), span: 1:5-1:7(4-6)}}), span: 1:2-1:7(1-6)}), span: 1:1-1:8(0-7)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [{kind: Identifier({text: "value", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:14(8-13)}), span: 1:9-1:14(8-13)}], start: 1:8-1:8(7-7), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:15(0-14)}), span: 1:1-1:15(0-14)}], start: 1:1-1:1(0-0), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "(<T>fn)(value)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - object literal method" {
  let source = parse_source("({ method(a) { return a } })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [MethodDecl({doc_comment: None, decorators: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, is_generator: false, name: Identifier({text: "method", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:4-1:10(3-9)}), is_optional: false, type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:12(10-11)}), is_optional: false, type_node: None, initializer: None, span: 1:11-1:12(10-11)}], start: 1:10-1:10(9-9), end: 1:13-1:13(12-12), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([{kind: ReturnStmt(Some({kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:23-1:24(22-23)}), span: 1:23-1:24(22-23)})), span: 1:16-1:24(15-23)}])})], start: 1:2-1:2(1-1), end: 1:28-1:28(27-27), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:28(1-27)}), span: 1:1-1:29(0-28)}), span: 1:1-1:29(0-28)}], start: 1:1-1:1(0-0), end: 1:29-1:29(28-28), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "({ method(a) { return a } })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - class expression heritage" {
  let source = parse_source("(class D extends Base { })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ClassExpr({name: Some({text: "D", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:9(7-8)}), type_parameters: None, heritage_clauses: Some({elements: [{kind: Extends, types: {elements: [{expression: {kind: Identifier({text: "Base", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:22(17-21)}), span: 1:18-1:22(17-21)}, type_arguments: None}], start: 1:10-1:10(9-9), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}}], start: 1:2-1:2(1-1), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}), members: {elements: [], start: 1:23-1:23(22-22), end: 1:25-1:25(24-24), has_trailing_comma: false, is_missing_list: false}}), span: 1:2-1:26(1-25)}), span: 1:1-1:27(0-26)}), span: 1:1-1:27(0-26)}], start: 1:1-1:1(0-0), end: 1:27-1:27(26-26), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "(class D extends Base { })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - arrow functions" {
  let source = parse_source("(a, b) => a + b; x => ({ y: x })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ArrowFunction({is_async: false, type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:2-1:3(1-2)}), is_optional: false, type_node: None, initializer: None, span: 1:2-1:3(1-2)}, {modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:6(4-5)}), is_optional: false, type_node: None, initializer: None, span: 1:5-1:6(4-5)}], start: 1:1-1:1(0-0), end: 1:7-1:7(6-6), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Expr({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:12(10-11)}), span: 1:11-1:12(10-11)}, operator: Plus, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:16(14-15)}), span: 1:15-1:16(14-15)}}), span: 1:11-1:16(10-15)})}), span: 1:1-1:16(0-15)}), span: 1:1-1:16(0-15)}, {kind: ExprStmt({kind: ArrowFunction({is_async: false, type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:19(17-18)}), is_optional: false, type_node: None, initializer: None, span: 1:18-1:19(17-18)}], start: 1:18-1:18(17-17), end: 1:19-1:19(18-18), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Expr({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [PropertyAssignment({name: Identifier({text: "y", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:26-1:27(25-26)}), initializer: {kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:29-1:30(28-29)}), span: 1:29-1:30(28-29)}})], start: 1:24-1:24(23-23), end: 1:32-1:32(31-31), has_trailing_comma: false, is_missing_list: false}), span: 1:24-1:32(23-31)}), span: 1:23-1:33(22-32)})}), span: 1:18-1:33(17-32)}), span: 1:18-1:33(17-32)}], start: 1:1-1:1(0-0), end: 1:33-1:33(32-32), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "(a, b) => a + b; x => ({ y: x })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - type assertions" {
  let source = parse_source(
    (
      #|foo as Bar;
      #|<Baz>foo
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: AsExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, type_node: {kind: TypeReference({type_name: Identifier({text: "Bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:11(7-10)}), type_arguments: None}), span: 1:8-1:11(7-10)}}), span: 1:1-1:11(0-10)}), span: 1:1-1:11(0-10)}, {kind: ExprStmt({kind: TypeAssertionExpr({type_node: {kind: TypeReference({type_name: Identifier({text: "Baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:2-2:5(13-16)}), type_arguments: None}), span: 2:2-2:5(13-16)}, expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:6-2:9(17-20)}), span: 2:6-2:9(17-20)}}), span: 2:1-2:9(12-20)}), span: 2:1-2:9(12-20)}], start: 1:1-1:1(0-0), end: 2:9-2:9(20-20), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "foo as Bar;\n<Baz>foo", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - coalesce with optional access" {
  let source = parse_source("foo?.bar ?? baz")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: PropertyAccessExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: true, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:9(5-8)}}), span: 1:1-1:9(0-8)}, operator: QuestionQuestion, right: {kind: Identifier({text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:16(12-15)}), span: 1:13-1:16(12-15)}}), span: 1:1-1:16(0-15)}), span: 1:1-1:16(0-15)}], start: 1:1-1:1(0-0), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "foo?.bar ?? baz", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - optional access with coalesce right" {
  let source = parse_source("foo ?? bar?.baz")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, operator: QuestionQuestion, right: {kind: PropertyAccessExpr({expression: {kind: Identifier({text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:11(7-10)}), span: 1:8-1:11(7-10)}, is_null_coalescing: true, name: {text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:16(12-15)}}), span: 1:8-1:16(7-15)}}), span: 1:1-1:16(0-15)}), span: 1:1-1:16(0-15)}], start: 1:1-1:1(0-0), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "foo ?? bar?.baz", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - optional call chain" {
  let source = parse_source("foo?.bar?.baz?.(1)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: PropertyAccessExpr({expression: {kind: PropertyAccessExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: true, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:9(5-8)}}), span: 1:1-1:9(0-8)}, is_null_coalescing: true, name: {text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:14(10-13)}}), span: 1:1-1:14(0-13)}, is_null_coalescing: true, type_arguments: None, arguments: {elements: [{kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:17-1:18(16-17)}), span: 1:17-1:18(16-17)}], start: 1:16-1:16(15-15), end: 1:19-1:19(18-18), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:19(0-18)}), span: 1:1-1:19(0-18)}], start: 1:1-1:1(0-0), end: 1:19-1:19(18-18), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "foo?.bar?.baz?.(1)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - optional element chain" {
  let source = parse_source("foo?.[bar]?.[baz]")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ElementAccessExpr({expression: {kind: ElementAccessExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, is_null_coalescing: true, argument_expression: {kind: Identifier({text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:10(6-9)}), span: 1:7-1:10(6-9)}}), span: 1:1-1:11(0-10)}, is_null_coalescing: true, argument_expression: {kind: Identifier({text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:17(13-16)}), span: 1:14-1:17(13-16)}}), span: 1:1-1:18(0-17)}), span: 1:1-1:18(0-17)}], start: 1:1-1:1(0-0), end: 1:18-1:18(17-17), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "foo?.[bar]?.[baz]", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - non-null chain access" {
  let source = parse_source("foo!.bar!.baz")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: PropertyAccessExpr({expression: {kind: NonNullExpr({kind: PropertyAccessExpr({expression: {kind: NonNullExpr({kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}), span: 1:1-1:5(0-4)}, is_null_coalescing: false, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:9(5-8)}}), span: 1:1-1:9(0-8)}), span: 1:1-1:10(0-9)}, is_null_coalescing: false, name: {text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:14(10-13)}}), span: 1:1-1:14(0-13)}), span: 1:1-1:14(0-13)}], start: 1:1-1:1(0-0), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "foo!.bar!.baz", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - as then property" {
  let source = parse_source("(foo as Bar).baz")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: PropertyAccessExpr({expression: {kind: ParenthesizedExpr({kind: AsExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:2-1:5(1-4)}), span: 1:2-1:5(1-4)}, type_node: {kind: TypeReference({type_name: Identifier({text: "Bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:12(8-11)}), type_arguments: None}), span: 1:9-1:12(8-11)}}), span: 1:2-1:12(1-11)}), span: 1:1-1:13(0-12)}, is_null_coalescing: false, name: {text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:17(13-16)}}), span: 1:1-1:17(0-16)}), span: 1:1-1:17(0-16)}], start: 1:1-1:1(0-0), end: 1:17-1:17(16-16), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "(foo as Bar).baz", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - nested as expressions" {
  let source = parse_source("foo as Bar as Baz")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: AsExpr({expression: {kind: AsExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, type_node: {kind: TypeReference({type_name: Identifier({text: "Bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:11(7-10)}), type_arguments: None}), span: 1:8-1:11(7-10)}}), span: 1:1-1:11(0-10)}, type_node: {kind: TypeReference({type_name: Identifier({text: "Baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:18(14-17)}), type_arguments: None}), span: 1:15-1:18(14-17)}}), span: 1:1-1:18(0-17)}), span: 1:1-1:18(0-17)}], start: 1:1-1:1(0-0), end: 1:18-1:18(17-17), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "foo as Bar as Baz", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - type assertion then as" {
  let source = parse_source("<Foo>bar as Baz")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: AsExpr({expression: {kind: TypeAssertionExpr({type_node: {kind: TypeReference({type_name: Identifier({text: "Foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:2-1:5(1-4)}), type_arguments: None}), span: 1:2-1:5(1-4)}, expression: {kind: Identifier({text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:9(5-8)}), span: 1:6-1:9(5-8)}}), span: 1:1-1:9(0-8)}, type_node: {kind: TypeReference({type_name: Identifier({text: "Baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:16(12-15)}), type_arguments: None}), span: 1:13-1:16(12-15)}}), span: 1:1-1:16(0-15)}), span: 1:1-1:16(0-15)}], start: 1:1-1:1(0-0), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "<Foo>bar as Baz", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - parenthesized as non-null" {
  let source = parse_source("((foo as Bar))!.baz")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: PropertyAccessExpr({expression: {kind: NonNullExpr({kind: ParenthesizedExpr({kind: ParenthesizedExpr({kind: AsExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:3-1:6(2-5)}), span: 1:3-1:6(2-5)}, type_node: {kind: TypeReference({type_name: Identifier({text: "Bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:13(9-12)}), type_arguments: None}), span: 1:10-1:13(9-12)}}), span: 1:3-1:13(2-12)}), span: 1:2-1:14(1-13)}), span: 1:1-1:15(0-14)}), span: 1:1-1:16(0-15)}, is_null_coalescing: false, name: {text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:17-1:20(16-19)}}), span: 1:1-1:20(0-19)}), span: 1:1-1:20(0-19)}], start: 1:1-1:1(0-0), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "((foo as Bar))!.baz", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - array spread mix" {
  let source = parse_source("[1, ...xs, 3]")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ArrayLiteralExpr({elements: [{kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:2-1:3(1-2)}), span: 1:2-1:3(1-2)}, {kind: SpreadElement({kind: Identifier({text: "xs", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:10(7-9)}), span: 1:8-1:10(7-9)}), span: 1:5-1:10(4-9)}, {kind: NumericLiteral({text: "3", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:12-1:13(11-12)}), span: 1:12-1:13(11-12)}], start: 1:1-1:1(0-0), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}), span: 1:1-1:14(0-13)}), span: 1:1-1:14(0-13)}], start: 1:1-1:1(0-0), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "[1, ...xs, 3]", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - array holes and spread" {
  let source = parse_source("[,,...rest]")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ArrayLiteralExpr({elements: [{kind: OmittedExpr, span: 1:2-1:3(1-2)}, {kind: OmittedExpr, span: 1:3-1:4(2-3)}, {kind: SpreadElement({kind: Identifier({text: "rest", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:11(6-10)}), span: 1:7-1:11(6-10)}), span: 1:4-1:11(3-10)}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}), span: 1:1-1:12(0-11)}), span: 1:1-1:12(0-11)}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "[,,...rest]", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - object literal nested" {
  let source = parse_source("({ a: { b: 1 }, c: 2 })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [PropertyAssignment({name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:4-1:5(3-4)}), initializer: {kind: ObjectLiteralExpr({elements: [PropertyAssignment({name: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:10(8-9)}), initializer: {kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:12-1:13(11-12)}), span: 1:12-1:13(11-12)}})], start: 1:7-1:7(6-6), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}), span: 1:7-1:15(6-14)}}), PropertyAssignment({name: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:17-1:18(16-17)}), initializer: {kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:20-1:21(19-20)}), span: 1:20-1:21(19-20)}})], start: 1:2-1:2(1-1), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:23(1-22)}), span: 1:1-1:24(0-23)}), span: 1:1-1:24(0-23)}], start: 1:1-1:1(0-0), end: 1:24-1:24(23-23), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "({ a: { b: 1 }, c: 2 })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - object literal computed property" {
  let source = parse_source("({ [a + b]: c })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [PropertyAssignment({name: ComputedPropertyName({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:6(4-5)}), span: 1:5-1:6(4-5)}, operator: Plus, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:10(8-9)}), span: 1:9-1:10(8-9)}}), span: 1:5-1:10(4-9)}), initializer: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:14(12-13)}), span: 1:13-1:14(12-13)}})], start: 1:2-1:2(1-1), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:16(1-15)}), span: 1:1-1:17(0-16)}), span: 1:1-1:17(0-16)}], start: 1:1-1:1(0-0), end: 1:17-1:17(16-16), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "({ [a + b]: c })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - object literal computed getter" {
  let source = parse_source("({ get [\"x\"]() { return 1 } })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [GetAccessor({doc_comment: None, decorators: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, name: ComputedPropertyName({kind: StringLiteral({text: "x", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:9-1:12(8-11)}), span: 1:9-1:12(8-11)}), parameters: {elements: [], start: 1:13-1:13(12-12), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([{kind: ReturnStmt(Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:25-1:26(24-25)}), span: 1:25-1:26(24-25)})), span: 1:18-1:26(17-25)}])})], start: 1:2-1:2(1-1), end: 1:30-1:30(29-29), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:30(1-29)}), span: 1:1-1:31(0-30)}), span: 1:1-1:31(0-30)}], start: 1:1-1:1(0-0), end: 1:31-1:31(30-30), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "({ get [\"x\"]() { return 1 } })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - object literal computed setter" {
  let source = parse_source("({ set [\"x\"](v) {} })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [SetAccessor({doc_comment: None, decorators: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, name: ComputedPropertyName({kind: StringLiteral({text: "x", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:9-1:12(8-11)}), span: 1:9-1:12(8-11)}), parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "v", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:15(13-14)}), is_optional: false, type_node: None, initializer: None, span: 1:14-1:15(13-14)}], start: 1:13-1:13(12-12), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}, body: Some([])})], start: 1:2-1:2(1-1), end: 1:21-1:21(20-20), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:21(1-20)}), span: 1:1-1:22(0-21)}), span: 1:1-1:22(0-21)}], start: 1:1-1:1(0-0), end: 1:22-1:22(21-21), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "({ set [\"x\"](v) {} })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - object literal trailing comma" {
  let source = parse_source("({ a: 1, b: 2, })")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: ObjectLiteralExpr({elements: [PropertyAssignment({name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:4-1:5(3-4)}), initializer: {kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:7-1:8(6-7)}), span: 1:7-1:8(6-7)}}), PropertyAssignment({name: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), initializer: {kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:13-1:14(12-13)}), span: 1:13-1:14(12-13)}})], start: 1:2-1:2(1-1), end: 1:17-1:17(16-16), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:17(1-16)}), span: 1:1-1:18(0-17)}), span: 1:1-1:18(0-17)}], start: 1:1-1:1(0-0), end: 1:18-1:18(17-17), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "({ a: 1, b: 2, })", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - call with spread" {
  let source = parse_source("fn(a, ...rest)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "fn", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:3(0-2)}), span: 1:1-1:3(0-2)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [{kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:4-1:5(3-4)}), span: 1:4-1:5(3-4)}, {kind: SpreadElement({kind: Identifier({text: "rest", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:14(9-13)}), span: 1:10-1:14(9-13)}), span: 1:7-1:14(6-13)}], start: 1:3-1:3(2-2), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:15(0-14)}), span: 1:1-1:15(0-14)}], start: 1:1-1:1(0-0), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "fn(a, ...rest)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - parenthesized call" {
  let source = parse_source("(foo)()")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: ParenthesizedExpr({kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:2-1:5(1-4)}), span: 1:2-1:5(1-4)}), span: 1:1-1:6(0-5)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:6-1:6(5-5), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:8(0-7)}), span: 1:1-1:8(0-7)}], start: 1:1-1:1(0-0), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "(foo)()", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - new with parenthesized access" {
  let source = parse_source("new (foo.bar)()")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: NewExpr({expression: {kind: CallExpr({expression: {kind: ParenthesizedExpr({kind: PropertyAccessExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:9(5-8)}), span: 1:6-1:9(5-8)}, is_null_coalescing: false, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:13(9-12)}}), span: 1:6-1:13(5-12)}), span: 1:5-1:14(4-13)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:14-1:14(13-13), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}}), span: 1:5-1:16(4-15)}, type_arguments: None, arguments: None}), span: 1:1-1:16(0-15)}), span: 1:1-1:16(0-15)}], start: 1:1-1:1(0-0), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "new (foo.bar)()", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - conditional with as branches" {
  let source = parse_source("cond ? foo as Bar : baz as Qux")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ConditionalExpr({condition: {kind: Identifier({text: "cond", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:5(0-4)}), span: 1:1-1:5(0-4)}, when_true: {kind: AsExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:11(7-10)}), span: 1:8-1:11(7-10)}, type_node: {kind: TypeReference({type_name: Identifier({text: "Bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:18(14-17)}), type_arguments: None}), span: 1:15-1:18(14-17)}}), span: 1:8-1:18(7-17)}, when_false: {kind: AsExpr({expression: {kind: Identifier({text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:21-1:24(20-23)}), span: 1:21-1:24(20-23)}, type_node: {kind: TypeReference({type_name: Identifier({text: "Qux", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:28-1:31(27-30)}), type_arguments: None}), span: 1:28-1:31(27-30)}}), span: 1:21-1:31(20-30)}}), span: 1:1-1:31(0-30)}), span: 1:1-1:31(0-30)}], start: 1:1-1:1(0-0), end: 1:31-1:31(30-30), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "cond ? foo as Bar : baz as Qux", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - numeric literal variants" {
  let source = parse_source("0xff; 0b1010; 0o755")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: NumericLiteral({text: "0xff", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:1-1:5(0-4)}), span: 1:1-1:5(0-4)}), span: 1:1-1:5(0-4)}, {kind: ExprStmt({kind: NumericLiteral({text: "0b1010", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:7-1:13(6-12)}), span: 1:7-1:13(6-12)}), span: 1:7-1:13(6-12)}, {kind: ExprStmt({kind: NumericLiteral({text: "0o755", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:15-1:20(14-19)}), span: 1:15-1:20(14-19)}), span: 1:15-1:20(14-19)}], start: 1:1-1:1(0-0), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "0xff; 0b1010; 0o755", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - bigint literal" {
  let source = parse_source("9007199254740991n")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: NumericLiteral({text: "9007199254740991n", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:1-1:18(0-17)}), span: 1:1-1:18(0-17)}), span: 1:1-1:18(0-17)}], start: 1:1-1:1(0-0), end: 1:18-1:18(17-17), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "9007199254740991n", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - numeric separators" {
  let source = parse_source("1_000_000; 0b1010_0101")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: NumericLiteral({text: "1_000_000", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:1-1:10(0-9)}), span: 1:1-1:10(0-9)}), span: 1:1-1:10(0-9)}, {kind: ExprStmt({kind: NumericLiteral({text: "0b1010_0101", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:12-1:23(11-22)}), span: 1:12-1:23(11-22)}), span: 1:12-1:23(11-22)}], start: 1:1-1:1(0-0), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "1_000_000; 0b1010_0101", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - numeric exponent signs" {
  let source = parse_source("1e-3; 2E+5")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: NumericLiteral({text: "1e-3", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:1-1:5(0-4)}), span: 1:1-1:5(0-4)}), span: 1:1-1:5(0-4)}, {kind: ExprStmt({kind: NumericLiteral({text: "2E+5", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:7-1:11(6-10)}), span: 1:7-1:11(6-10)}), span: 1:7-1:11(6-10)}], start: 1:1-1:1(0-0), end: 1:11-1:11(10-10), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "1e-3; 2E+5", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - string escapes" {
  let source = parse_source("\"\\u{1F600}\\n\\x41\\u0042\"")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: StringLiteral({text: "\\u{1F600}\\n\\x41\\u0042", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:1-1:24(0-23)}), span: 1:1-1:24(0-23)}), span: 1:1-1:24(0-23)}], start: 1:1-1:1(0-0), end: 1:24-1:24(23-23), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "\"\\u{1F600}\\n\\x41\\u0042\"", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - regexp escaped slash" {
  let source = parse_source("/a\\/b/.test(x)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: PropertyAccessExpr({expression: {kind: RegularExprLiteral({text: "/a\\/b/", is_unterminated: false, has_extended_unicode_escape: false, span: 1:1-1:7(0-6)}), span: 1:1-1:7(0-6)}, is_null_coalescing: false, name: {text: "test", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:12(7-11)}}), span: 1:1-1:12(0-11)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [{kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:14(12-13)}), span: 1:13-1:14(12-13)}], start: 1:12-1:12(11-11), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:15(0-14)}), span: 1:1-1:15(0-14)}], start: 1:1-1:1(0-0), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "/a\\/b/.test(x)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - regexp char class flags" {
  let source = parse_source("/[a-z]+/gi")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: RegularExprLiteral({text: "/[a-z]+/gi", is_unterminated: false, has_extended_unicode_escape: false, span: 1:1-1:11(0-10)}), span: 1:1-1:11(0-10)}), span: 1:1-1:11(0-10)}], start: 1:1-1:1(0-0), end: 1:11-1:11(10-10), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "/[a-z]+/gi", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - sequence expression" {
  let source = parse_source("a(), b(), c")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CommaListExpr({elements: [{kind: CallExpr({expression: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:2-1:2(1-1), end: 1:4-1:4(3-3), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:4(0-3)}, {kind: CallExpr({expression: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:7-1:7(6-6), end: 1:9-1:9(8-8), has_trailing_comma: false, is_missing_list: false}}), span: 1:6-1:9(5-8)}, {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:12(10-11)}), span: 1:11-1:12(10-11)}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}), span: 1:1-1:12(0-11)}), span: 1:1-1:12(0-11)}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a(), b(), c", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - parenthesized sequence" {
  let source = parse_source("(a(), b)")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: CommaListExpr({elements: [{kind: CallExpr({expression: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:2-1:3(1-2)}), span: 1:2-1:3(1-2)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:3-1:3(2-2), end: 1:5-1:5(4-4), has_trailing_comma: false, is_missing_list: false}}), span: 1:2-1:5(1-4)}, {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:8(6-7)}), span: 1:7-1:8(6-7)}], start: 1:2-1:2(1-1), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:8(1-7)}), span: 1:1-1:9(0-8)}), span: 1:1-1:9(0-8)}], start: 1:1-1:1(0-0), end: 1:9-1:9(8-8), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "(a(), b)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - tagged template short" {
  let source = parse_source("tag`a ${b}`")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: TaggedTemplateExpr({tag: {kind: Identifier({text: "tag", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:4(0-3)}), span: 1:1-1:4(0-3)}, type_arguments: None, template: {kind: TemplateExpr({head: {text: "a ", raw_text: "a ", is_unterminated: false, has_extended_unicode_escape: false}, template_spans: {elements: [{expression: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:10(8-9)}), span: 1:9-1:10(8-9)}, literal: TemplateTail({text: "", raw_text: "", is_unterminated: false, has_extended_unicode_escape: false})}], start: 1:4-1:4(3-3), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}}), span: 1:4-1:12(3-11)}}), span: 1:1-1:12(0-11)}), span: 1:1-1:12(0-11)}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "tag`a ${b}`", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - new without args" {
  let source = parse_source("new Foo")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: NewExpr({expression: {kind: Identifier({text: "Foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:8(4-7)}), span: 1:5-1:8(4-7)}, type_arguments: None, arguments: None}), span: 1:1-1:8(0-7)}), span: 1:1-1:8(0-7)}], start: 1:1-1:1(0-0), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "new Foo", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - nested new" {
  let source = parse_source("new new Foo()")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: NewExpr({expression: {kind: NewExpr({expression: {kind: CallExpr({expression: {kind: Identifier({text: "Foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:12(8-11)}), span: 1:9-1:12(8-11)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:12-1:12(11-11), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}}), span: 1:9-1:14(8-13)}, type_arguments: None, arguments: None}), span: 1:5-1:14(4-13)}, type_arguments: None, arguments: None}), span: 1:1-1:14(0-13)}), span: 1:1-1:14(0-13)}], start: 1:1-1:1(0-0), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "new new Foo()", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - super calls" {
  let source = parse_source("super(); super[\"x\"]()")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: SuperExpr, span: 1:1-1:6(0-5)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:6-1:6(5-5), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:8(0-7)}), span: 1:1-1:8(0-7)}, {kind: ExprStmt({kind: CallExpr({expression: {kind: ElementAccessExpr({expression: {kind: SuperExpr, span: 1:10-1:15(9-14)}, is_null_coalescing: false, argument_expression: {kind: StringLiteral({text: "x", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:16-1:19(15-18)}), span: 1:16-1:19(15-18)}}), span: 1:10-1:20(9-19)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:20-1:20(19-19), end: 1:22-1:22(21-21), has_trailing_comma: false, is_missing_list: false}}), span: 1:10-1:22(9-21)}), span: 1:10-1:22(9-21)}], start: 1:1-1:1(0-0), end: 1:22-1:22(21-21), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "super(); super[\"x\"]()", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - meta properties" {
  let source = parse_source("new.target; import.meta")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: MetaProperty(NewTarget), span: 1:1-1:11(0-10)}), span: 1:1-1:11(0-10)}, {kind: ExprStmt({kind: MetaProperty(ImportMeta), span: 1:13-1:24(12-23)}), span: 1:13-1:24(12-23)}], start: 1:1-1:1(0-0), end: 1:24-1:24(23-23), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "new.target; import.meta", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - dynamic import" {
  let source = parse_source("import(\"mod\")")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ImportExpr({elements: [{kind: StringLiteral({text: "mod", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:8-1:13(7-12)}), span: 1:8-1:13(7-12)}], start: 1:7-1:7(6-6), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}), span: 1:1-1:14(0-13)}), span: 1:1-1:14(0-13)}], start: 1:1-1:1(0-0), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "import(\"mod\")", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - await import" {
  let source = parse_source(
    (
      #|import "mod";
      #|await import("mod")
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ImportDecl({import_clause: None, module_specifier: {kind: StringLiteral({text: "mod", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:8-1:13(7-12)}), span: 1:8-1:13(7-12)}, attributes: None, phase: Normal}), span: 1:1-1:13(0-12)}, {kind: ExprStmt({kind: AwaitExpr({kind: ImportExpr({elements: [{kind: StringLiteral({text: "mod", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:14-2:19(27-32)}), span: 2:14-2:19(27-32)}], start: 2:13-2:13(26-26), end: 2:20-2:20(33-33), has_trailing_comma: false, is_missing_list: false}), span: 2:7-2:20(20-33)}), span: 2:1-2:20(14-33)}), span: 2:1-2:20(14-33)}], start: 1:1-1:1(0-0), end: 2:20-2:20(33-33), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "import \"mod\";\nawait import(\"mod\")", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "expr - async function expression" {
  let source = parse_source("async function f() { return 1 }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, is_async: true, is_generator: false, name: Some({text: "f", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:16-1:17(15-16)}), type_parameters: None, parameters: {elements: [], start: 1:17-1:17(16-16), end: 1:19-1:19(18-18), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([{kind: ReturnStmt(Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:29-1:30(28-29)}), span: 1:29-1:30(28-29)})), span: 1:22-1:30(21-29)}])}), span: 1:1-1:32(0-31)}], start: 1:1-1:1(0-0), end: 1:32-1:32(31-31), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "async function f() { return 1 }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - async arrow expression" {
  let source = parse_source("async (x) => x")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ArrowFunction({is_async: true, type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:9(7-8)}), is_optional: false, type_node: None, initializer: None, span: 1:8-1:9(7-8)}], start: 1:7-1:7(6-6), end: 1:10-1:10(9-9), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Expr({kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:15(13-14)}), span: 1:14-1:15(13-14)})}), span: 1:1-1:15(0-14)}), span: 1:1-1:15(0-14)}], start: 1:1-1:1(0-0), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "async (x) => x", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - async generator function expression" {
  let source = parse_source("async function* gen() { yield 1 }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, is_async: true, is_generator: true, name: Some({text: "gen", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:17-1:20(16-19)}), type_parameters: None, parameters: {elements: [], start: 1:20-1:20(19-19), end: 1:22-1:22(21-21), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([{kind: ExprStmt({kind: YieldExpr({is_delegate: false, expression: Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:31-1:32(30-31)}), span: 1:31-1:32(30-31)})}), span: 1:25-1:32(24-31)}), span: 1:25-1:32(24-31)}])}), span: 1:1-1:34(0-33)}], start: 1:1-1:1(0-0), end: 1:34-1:34(33-33), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "async function* gen() { yield 1 }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - destructuring assignment" {
  let source = parse_source(
    (
      #|([a, b] = arr);
      #|({ a, b: c } = obj)
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ParenthesizedExpr({kind: BinaryExpr({left: {kind: ArrayLiteralExpr({elements: [{kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:3-1:4(2-3)}), span: 1:3-1:4(2-3)}, {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}], start: 1:2-1:2(1-1), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}), span: 1:2-1:8(1-7)}, operator: Equals, right: {kind: Identifier({text: "arr", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:14(10-13)}), span: 1:11-1:14(10-13)}}), span: 1:2-1:14(1-13)}), span: 1:1-1:15(0-14)}), span: 1:1-1:15(0-14)}, {kind: ExprStmt({kind: ParenthesizedExpr({kind: BinaryExpr({left: {kind: ObjectLiteralExpr({elements: [ShorthandPropertyAssignment({name: {text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:4-2:5(19-20)}, object_assignment_initializer: None}), PropertyAssignment({name: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:7-2:8(22-23)}), initializer: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:10-2:11(25-26)}), span: 2:10-2:11(25-26)}})], start: 2:2-2:2(17-17), end: 2:13-2:13(28-28), has_trailing_comma: false, is_missing_list: false}), span: 2:2-2:13(17-28)}, operator: Equals, right: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:16-2:19(31-34)}), span: 2:16-2:19(31-34)}}), span: 2:2-2:19(17-34)}), span: 2:1-2:20(16-35)}), span: 2:1-2:20(16-35)}], start: 1:1-1:1(0-0), end: 2:20-2:20(35-35), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "([a, b] = arr);\n({ a, b: c } = obj)", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - await in async arrow" {
  let source = parse_source("async x => await x")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: ArrowFunction({is_async: true, type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:8(6-7)}), is_optional: false, type_node: None, initializer: None, span: 1:7-1:8(6-7)}], start: 1:7-1:7(6-6), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Expr({kind: AwaitExpr({kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:19(17-18)}), span: 1:18-1:19(17-18)}), span: 1:12-1:19(11-18)})}), span: 1:1-1:19(0-18)}), span: 1:1-1:19(0-18)}], start: 1:1-1:1(0-0), end: 1:19-1:19(18-18), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "async x => await x", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - delete and void" {
  let source = parse_source("delete obj[\"k\"]; void foo(); void (bar())")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: DeleteExpr({kind: ElementAccessExpr({expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:11(7-10)}), span: 1:8-1:11(7-10)}, is_null_coalescing: false, argument_expression: {kind: StringLiteral({text: "k", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:12-1:15(11-14)}), span: 1:12-1:15(11-14)}}), span: 1:8-1:16(7-15)}), span: 1:1-1:16(0-15)}), span: 1:1-1:16(0-15)}, {kind: ExprStmt({kind: VoidExpr({kind: CallExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:23-1:26(22-25)}), span: 1:23-1:26(22-25)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:26-1:26(25-25), end: 1:28-1:28(27-27), has_trailing_comma: false, is_missing_list: false}}), span: 1:23-1:28(22-27)}), span: 1:18-1:28(17-27)}), span: 1:18-1:28(17-27)}, {kind: ExprStmt({kind: VoidExpr({kind: ParenthesizedExpr({kind: CallExpr({expression: {kind: Identifier({text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:36-1:39(35-38)}), span: 1:36-1:39(35-38)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:39-1:39(38-38), end: 1:41-1:41(40-40), has_trailing_comma: false, is_missing_list: false}}), span: 1:36-1:41(35-40)}), span: 1:35-1:42(34-41)}), span: 1:30-1:42(29-41)}), span: 1:30-1:42(29-41)}], start: 1:1-1:1(0-0), end: 1:42-1:42(41-41), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "delete obj[\"k\"]; void foo(); void (bar())", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - coalesce with parentheses" {
  let source = parse_source("a ?? (b || c); (a && b) ?? c")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: QuestionQuestion, right: {kind: ParenthesizedExpr({kind: BinaryExpr({left: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:8(6-7)}), span: 1:7-1:8(6-7)}, operator: BarBar, right: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:13(11-12)}), span: 1:12-1:13(11-12)}}), span: 1:7-1:13(6-12)}), span: 1:6-1:14(5-13)}}), span: 1:1-1:14(0-13)}), span: 1:1-1:14(0-13)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: ParenthesizedExpr({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:17-1:18(16-17)}), span: 1:17-1:18(16-17)}, operator: AmpersandAmpersand, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:22-1:23(21-22)}), span: 1:22-1:23(21-22)}}), span: 1:17-1:23(16-22)}), span: 1:16-1:24(15-23)}, operator: QuestionQuestion, right: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:28-1:29(27-28)}), span: 1:28-1:29(27-28)}}), span: 1:16-1:29(15-28)}), span: 1:16-1:29(15-28)}], start: 1:1-1:1(0-0), end: 1:29-1:29(28-28), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a ?? (b || c); (a && b) ?? c", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - imports" {
  let source = parse_source(
    (
      #|import x from "mod";
      #|import { a as b, type c } from "m";
      #|import * as ns from "m";
      #|import "side"
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ImportDecl({import_clause: Some({is_type_only: false, name: Some({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:9(7-8)}), named_bindings: None}), module_specifier: {kind: StringLiteral({text: "mod", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:15-1:20(14-19)}), span: 1:15-1:20(14-19)}, attributes: None, phase: Normal}), span: 1:1-2:1(0-21)}, {kind: ImportDecl({import_clause: Some({is_type_only: false, name: None, named_bindings: Some(NamedImports({elements: [{is_type_only: false, property_name: Some({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:10-2:11(30-31)}), name: {text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:15-2:16(35-36)}}, {is_type_only: true, property_name: None, name: {text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:23-2:24(43-44)}}], start: 2:8-2:8(28-28), end: 2:26-2:26(46-46), has_trailing_comma: false, is_missing_list: false}))}), module_specifier: {kind: StringLiteral({text: "m", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:32-2:35(52-55)}), span: 2:32-2:35(52-55)}, attributes: None, phase: Normal}), span: 2:1-3:1(21-57)}, {kind: ImportDecl({import_clause: Some({is_type_only: false, name: None, named_bindings: Some(NamespaceImport({text: "ns", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:13-3:15(69-71)}))}), module_specifier: {kind: StringLiteral({text: "m", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 3:21-3:24(77-80)}), span: 3:21-3:24(77-80)}, attributes: None, phase: Normal}), span: 3:1-4:1(57-82)}, {kind: ImportDecl({import_clause: None, module_specifier: {kind: StringLiteral({text: "side", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 4:8-4:14(89-95)}), span: 4:8-4:14(89-95)}, attributes: None, phase: Normal}), span: 4:1-4:14(82-95)}], start: 1:1-1:1(0-0), end: 4:14-4:14(95-95), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "import x from \"mod\";\nimport { a as b, type c } from \"m\";\nimport * as ns from \"m\";\nimport \"side\"", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - import type named" {
  let source = parse_source(
    (
      #|import type { Foo, Bar as Baz } from "m";
      #|import type { T as TT } from "./exportT";
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ImportDecl({import_clause: Some({is_type_only: true, name: None, named_bindings: Some(NamedImports({elements: [{is_type_only: false, property_name: None, name: {text: "Foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:18(14-17)}}, {is_type_only: false, property_name: Some({text: "Bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:20-1:23(19-22)}), name: {text: "Baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:27-1:30(26-29)}}], start: 1:13-1:13(12-12), end: 1:32-1:32(31-31), has_trailing_comma: false, is_missing_list: false}))}), module_specifier: {kind: StringLiteral({text: "m", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:38-1:41(37-40)}), span: 1:38-1:41(37-40)}, attributes: None, phase: Type}), span: 1:1-2:1(0-42)}, {kind: ImportDecl({import_clause: Some({is_type_only: true, name: None, named_bindings: Some(NamedImports({elements: [{is_type_only: false, property_name: Some({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:15-2:16(56-57)}), name: {text: "TT", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:20-2:22(61-63)}}], start: 2:13-2:13(54-54), end: 2:24-2:24(65-65), has_trailing_comma: false, is_missing_list: false}))}), module_specifier: {kind: StringLiteral({text: "./exportT", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:30-2:41(71-82)}), span: 2:30-2:41(71-82)}, attributes: None, phase: Type}), span: 2:1-2:42(42-83)}], start: 1:1-1:1(0-0), end: 2:42-2:42(83-83), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "import type { Foo, Bar as Baz } from \"m\";\nimport type { T as TT } from \"./exportT\";", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - import type namespace" {
  let source = parse_source("import type * as ns from \"m\";")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ImportDecl({import_clause: Some({is_type_only: true, name: None, named_bindings: Some(NamespaceImport({text: "ns", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:20(17-19)}))}), module_specifier: {kind: StringLiteral({text: "m", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:26-1:29(25-28)}), span: 1:26-1:29(25-28)}, attributes: None, phase: Type}), span: 1:1-1:30(0-29)}], start: 1:1-1:1(0-0), end: 1:30-1:30(29-29), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "import type * as ns from \"m\";", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - import type default" {
  let source = parse_source("import type Foo from \"m\";")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ImportDecl({import_clause: Some({is_type_only: true, name: Some({text: "Foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:16(12-15)}), named_bindings: None}), module_specifier: {kind: StringLiteral({text: "m", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:22-1:25(21-24)}), span: 1:22-1:25(21-24)}, attributes: None, phase: Type}), span: 1:1-1:26(0-25)}], start: 1:1-1:1(0-0), end: 1:26-1:26(25-25), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "import type Foo from \"m\";", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - import defer" {
  let source = parse_source(
    (
      #|import defer "mod";
      #|import defer Foo from "m";
      #|import defer { Bar as Baz } from "m";
    ),
  )
  let phases : Array[ImportPhase] = []
  for stmt in source.stmts.elements.iter() {
    match stmt.kind {
      ImportDecl(decl) => phases.push(decl.phase)
      _ => ()
    }
  }
  inspect(phases, content="[Defer, Defer, Defer]")
}

///|
test "decl - import type name token" {
  let source = parse_source("import { type } from \"m\";")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ImportDecl({import_clause: Some({is_type_only: false, name: None, named_bindings: Some(NamedImports({elements: [{is_type_only: false, property_name: None, name: {text: "type", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:14(9-13)}}], start: 1:8-1:8(7-7), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}))}), module_specifier: {kind: StringLiteral({text: "m", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:22-1:25(21-24)}), span: 1:22-1:25(21-24)}, attributes: None, phase: Normal}), span: 1:1-1:26(0-25)}], start: 1:1-1:1(0-0), end: 1:26-1:26(25-25), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "import { type } from \"m\";", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - import module specifier expr" {
  let error = try? parse_source("import foo from bar;")
  inspect(
    error,
    content="Err(Parse error at 1:17-1:20(16-19): expected string literal in module specifier, found identifier bar)",
  )
}

///|
test "type - import type missing string literal" {
  let error = try? parse_source("type T = import(foo)")
  inspect(
    error,
    content="Err(Parse error at 1:17-1:20(16-19): expected string literal in import type, found identifier foo)",
  )
}

///|
test "stmt - await using only in module" {
  let error = try? parse_source("await using x = foo")
  inspect(
    error,
    content="Err(Parse error at 1:1-1:20(0-19): 'await using' is only allowed at the top level of a module file)",
  )
}

///|
test "decl - import equals" {
  let source = parse_source(
    (
      #|import type Foo = require("mod");
      #|import Bar = Baz.Qux
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ImportEqualsDecl({is_type_only: true, name: {text: "Foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:16(12-15)}, module_ref: ExternalModuleRef({kind: StringLiteral({text: "mod", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:27-1:32(26-31)}), span: 1:27-1:32(26-31)})}), span: 1:1-2:1(0-34)}, {kind: ImportEqualsDecl({is_type_only: false, name: {text: "Bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:8-2:11(41-44)}, module_ref: EntityName(QualifiedName({left: Identifier({text: "Baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:14-2:17(47-50)}), right: {text: "Qux", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:18-2:21(51-54)}}))}), span: 2:1-2:21(34-54)}], start: 1:1-1:1(0-0), end: 2:21-2:21(54-54), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "import type Foo = require(\"mod\");\nimport Bar = Baz.Qux", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - exports" {
  let source = parse_source(
    (
      #|export { a as b } from "m";
      #|export * as ns from "m";
      #|export as namespace MyLib;
      #|export default function f() {}
    ),
    script_kind=TSDeclarations,
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExportDecl({modifiers: Some({elements: [export], start: 1:1-1:1(0-0), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}), is_type_only: false, export_clause: Some(NamedExports({elements: [{is_type_only: false, property_name: Some({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), name: {text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:16(14-15)}}], start: 1:8-1:8(7-7), end: 1:18-1:18(17-17), has_trailing_comma: false, is_missing_list: false})), module_specifier: Some({kind: StringLiteral({text: "m", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:24-1:27(23-26)}), span: 1:24-1:27(23-26)}), attributes: None}), span: 1:1-2:1(0-28)}, {kind: ExportDecl({modifiers: Some({elements: [export], start: 2:1-2:1(28-28), end: 2:8-2:8(35-35), has_trailing_comma: false, is_missing_list: false}), is_type_only: false, export_clause: Some(NamespaceExport({text: "ns", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:13-2:15(40-42)})), module_specifier: Some({kind: StringLiteral({text: "m", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:21-2:24(48-51)}), span: 2:21-2:24(48-51)}), attributes: None}), span: 2:1-3:1(28-53)}, {kind: NamespaceExportDecl({name: {text: "MyLib", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:21-3:26(73-78)}}), span: 3:1-4:1(53-80)}, {kind: FunctionDecl({doc_comment: None, modifiers: {is_export: true, is_default: true, is_declare: false}, is_async: false, is_generator: false, name: Some({text: "f", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:25-4:26(104-105)}), type_parameters: None, parameters: {elements: [], start: 4:26-4:26(105-105), end: 4:28-4:28(107-107), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([])}), span: 4:1-4:31(80-110)}], start: 1:1-1:1(0-0), end: 4:31-4:31(110-110), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "export { a as b } from \"m\";\nexport * as ns from \"m\";\nexport as namespace MyLib;\nexport default function f() {}", script_kind: TSDeclarations, is_module: true}
    ),
  )
}

///|
test "decl - export assignment alone" {
  let source = parse_source("export = foo;", script_kind=TSDeclarations)
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExportAssignment({modifiers: Some({elements: [export], start: 1:1-1:1(0-0), end: 1:1-1:1(0-0), has_trailing_comma: false, is_missing_list: false}), is_export_equals: true, expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:13(9-12)}), span: 1:10-1:13(9-12)}}), span: 1:1-1:14(0-13)}], start: 1:1-1:1(0-0), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "export = foo;", script_kind: TSDeclarations, is_module: true}
    ),
  )
}

///|
test "decl - export assignment with namespace export allowed" {
  let source = parse_source(
    (
      #|export = foo;
      #|export as namespace MyLib;
    ),
    script_kind=TSDeclarations,
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExportAssignment({modifiers: Some({elements: [export], start: 1:1-1:1(0-0), end: 1:1-1:1(0-0), has_trailing_comma: false, is_missing_list: false}), is_export_equals: true, expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:13(9-12)}), span: 1:10-1:13(9-12)}}), span: 1:1-2:1(0-14)}, {kind: NamespaceExportDecl({name: {text: "MyLib", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:21-2:26(34-39)}}), span: 2:1-2:27(14-40)}], start: 1:1-1:1(0-0), end: 2:27-2:27(40-40), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "export = foo;\nexport as namespace MyLib;", script_kind: TSDeclarations, is_module: true}
    ),
  )
}

///|
test "decl - export assignment cannot be used with other exports error" {
  let error = try? parse_source(
    (
      #|export const bar = 1;
      #|export = foo;
    ),
    script_kind=TSDeclarations,
  )
  inspect(
    error,
    content="Err(Parse error at 2:1-2:9(22-30): an export assignment cannot be used in a module with other exported elements)",
  )
}

///|
test "decl - export assignment after other exports error" {
  let error = try? parse_source(
    (
      #|export function f() {}
      #|export = foo;
    ),
    script_kind=TSDeclarations,
  )
  inspect(
    error,
    content="Err(Parse error at 2:1-2:9(23-31): an export assignment cannot be used in a module with other exported elements)",
  )
}

///|
test "decl - other exports after export assignment error" {
  let error = try? parse_source(
    (
      #|export = foo;
      #|export class C {}
    ),
    script_kind=TSDeclarations,
  )
  inspect(
    error,
    content="Err(Parse error at 2:1-2:13(14-26): an export assignment cannot be used in a module with other exported elements)",
  )
}

///|
test "decl - export type name token" {
  let source = parse_source("export { type } from \"m\";")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExportDecl({modifiers: Some({elements: [export], start: 1:1-1:1(0-0), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}), is_type_only: false, export_clause: Some(NamedExports({elements: [{is_type_only: false, property_name: None, name: {text: "type", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:14(9-13)}}], start: 1:8-1:8(7-7), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false})), module_specifier: Some({kind: StringLiteral({text: "m", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:22-1:25(21-24)}), span: 1:22-1:25(21-24)}), attributes: None}), span: 1:1-1:26(0-25)}], start: 1:1-1:1(0-0), end: 1:26-1:26(25-25), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "export { type } from \"m\";", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - export star from" {
  let source = parse_source("export * from \"m\";")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExportDecl({modifiers: Some({elements: [export], start: 1:1-1:1(0-0), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}), is_type_only: false, export_clause: None, module_specifier: Some({kind: StringLiteral({text: "m", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:15-1:18(14-17)}), span: 1:15-1:18(14-17)}), attributes: None}), span: 1:1-1:19(0-18)}], start: 1:1-1:1(0-0), end: 1:19-1:19(18-18), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "export * from \"m\";", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - modules and namespaces" {
  let source = parse_source(
    (
      #|declare module "m" { export const x = 1 }
      #|namespace A.B { export const y = 2 }
      #|global { interface X { y: number } }
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, name: StringLiteral({text: "m", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:16-1:19(15-18)}), body: Some(ModuleBlock({elements: [{kind: VariableStmt({doc_comment: None, modifiers: Some({elements: [export], start: 1:22-1:22(21-21), end: 1:29-1:29(28-28), has_trailing_comma: false, is_missing_list: false}), declaration_list: {elements: [{kind: Const, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:35-1:36(34-35)}), type_node: None, initializer: Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:39-1:40(38-39)}), span: 1:39-1:40(38-39)})}], start: 1:22-1:22(21-21), end: 1:41-1:41(40-40), has_trailing_comma: false, is_missing_list: false}}), span: 1:22-1:41(21-40)}], start: 1:20-1:20(19-19), end: 1:42-1:42(41-41), has_trailing_comma: false, is_missing_list: false}))}), span: 1:1-2:1(0-42)}, {kind: ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: Identifier({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:11-2:12(52-53)}), body: Some(ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: Identifier({text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:13-2:14(54-55)}), body: Some(ModuleBlock({elements: [{kind: VariableStmt({doc_comment: None, modifiers: Some({elements: [export], start: 2:17-2:17(58-58), end: 2:24-2:24(65-65), has_trailing_comma: false, is_missing_list: false}), declaration_list: {elements: [{kind: Const, name: Identifier({text: "y", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:30-2:31(71-72)}), type_node: None, initializer: Some({kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:34-2:35(75-76)}), span: 2:34-2:35(75-76)})}], start: 2:17-2:17(58-58), end: 2:36-2:36(77-77), has_trailing_comma: false, is_missing_list: false}}), span: 2:17-2:36(58-77)}], start: 2:15-2:15(56-56), end: 2:37-2:37(78-78), has_trailing_comma: false, is_missing_list: false}))}))}), span: 2:1-3:1(42-79)}, {kind: ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: Identifier({text: "global", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:1-3:7(79-85)}), body: Some(ModuleBlock({elements: [{kind: InterfaceDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "X", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:20-3:21(98-99)}, type_parameters: None, heritage_clauses: None, members: {elements: [PropertySignature({doc_comment: None, is_readonly: false, name: Identifier({text: "y", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:24-3:25(102-103)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 3:27-3:33(105-111)})})], start: 3:22-3:22(100-100), end: 3:35-3:35(113-113), has_trailing_comma: false, is_missing_list: false}}), span: 3:10-3:35(88-113)}], start: 3:8-3:8(86-86), end: 3:37-3:37(115-115), has_trailing_comma: false, is_missing_list: false}))}), span: 3:1-3:37(79-115)}], start: 1:1-1:1(0-0), end: 3:37-3:37(115-115), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "declare module \"m\" { export const x = 1 }\nnamespace A.B { export const y = 2 }\nglobal { interface X { y: number } }", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - enum and type alias" {
  let source = parse_source(
    (
      #|enum E { A, B = 2 }
      #|type T = A | B;
      #|interface I { x: number }
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: EnumDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "E", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, members: {elements: [{doc_comment: None, name: Identifier({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), initializer: None}, {doc_comment: None, name: Identifier({text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:14(12-13)}), initializer: Some({kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:17-1:18(16-17)}), span: 1:17-1:18(16-17)})}], start: 1:8-1:8(7-7), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:20(0-19)}, {kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:6-2:7(25-26)}, type_parameters: None, type_node: {kind: UnionType({elements: [{kind: TypeReference({type_name: Identifier({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:10-2:11(29-30)}), type_arguments: None}), span: 2:10-2:11(29-30)}, {kind: TypeReference({type_name: Identifier({text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:14-2:15(33-34)}), type_arguments: None}), span: 2:14-2:15(33-34)}], start: 2:10-2:10(29-29), end: 2:15-2:15(34-34), has_trailing_comma: false, is_missing_list: false}), span: 2:10-2:15(29-34)}}), span: 2:1-3:1(20-36)}, {kind: InterfaceDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "I", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:11-3:12(46-47)}, type_parameters: None, heritage_clauses: None, members: {elements: [PropertySignature({doc_comment: None, is_readonly: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:15-3:16(50-51)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 3:18-3:24(53-59)})})], start: 3:13-3:13(48-48), end: 3:26-3:26(61-61), has_trailing_comma: false, is_missing_list: false}}), span: 3:1-3:26(36-61)}], start: 1:1-1:1(0-0), end: 3:26-3:26(61-61), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "enum E { A, B = 2 }\ntype T = A | B;\ninterface I { x: number }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - type syntax edges" {
  let source = parse_source(
    (
      #|type Fn = (a: number, b?: string, ...rest: boolean[]) => string;
      #|type Tuple = [number, string, A | B];
      #|type Arr = (A | B)[];
      #|type Obj = {
      #|  (x: number): string;
      #|  new (x: number): Obj;
      #|  [k: string]: number;
      #|  get y(): number;
      #|  set y(v: number);
      #|  method(a: string): string;
      #|  prop?: string
      #|}
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "Fn", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:8(5-7)}, type_parameters: None, type_node: {kind: FunctionType({type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:13(11-12)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 1:15-1:21(14-20)}), initializer: None, span: 1:12-1:21(11-20)}, {modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:23-1:24(22-23)}), is_optional: true, type_node: Some({kind: KeywordType(String), span: 1:27-1:33(26-32)}), initializer: None, span: 1:23-1:33(22-32)}, {modifiers: {accessibility: None, is_readonly: false}, is_rest: true, name: Identifier({text: "rest", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:38-1:42(37-41)}), is_optional: false, type_node: Some({kind: ArrayType({kind: KeywordType(Boolean), span: 1:44-1:51(43-50)}), span: 1:44-1:53(43-52)}), initializer: None, span: 1:38-1:53(37-52)}], start: 1:11-1:11(10-10), end: 1:54-1:54(53-53), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(String), span: 1:58-1:64(57-63)})}), span: 1:11-1:64(10-63)}}), span: 1:1-2:1(0-65)}, {kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "Tuple", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:6-2:11(70-75)}, type_parameters: None, type_node: {kind: TupleType({elements: [{label: None, is_optional: false, is_rest: false, type_node: {kind: KeywordType(Number), span: 2:15-2:21(79-85)}, span: 2:15-2:21(79-85)}, {label: None, is_optional: false, is_rest: false, type_node: {kind: KeywordType(String), span: 2:23-2:29(87-93)}, span: 2:23-2:29(87-93)}, {label: None, is_optional: false, is_rest: false, type_node: {kind: UnionType({elements: [{kind: TypeReference({type_name: Identifier({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:31-2:32(95-96)}), type_arguments: None}), span: 2:31-2:32(95-96)}, {kind: TypeReference({type_name: Identifier({text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:35-2:36(99-100)}), type_arguments: None}), span: 2:35-2:36(99-100)}], start: 2:31-2:31(95-95), end: 2:36-2:36(100-100), has_trailing_comma: false, is_missing_list: false}), span: 2:31-2:36(95-100)}, span: 2:31-2:36(95-100)}], start: 2:14-2:14(78-78), end: 2:37-2:37(101-101), has_trailing_comma: false, is_missing_list: false}), span: 2:14-2:37(78-101)}}), span: 2:1-3:1(65-103)}, {kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "Arr", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:6-3:9(108-111)}, type_parameters: None, type_node: {kind: ArrayType({kind: ParenthesizedType({kind: UnionType({elements: [{kind: TypeReference({type_name: Identifier({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:13-3:14(115-116)}), type_arguments: None}), span: 3:13-3:14(115-116)}, {kind: TypeReference({type_name: Identifier({text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:17-3:18(119-120)}), type_arguments: None}), span: 3:17-3:18(119-120)}], start: 3:13-3:13(115-115), end: 3:18-3:18(120-120), has_trailing_comma: false, is_missing_list: false}), span: 3:13-3:18(115-120)}), span: 3:12-3:19(114-121)}), span: 3:12-3:21(114-123)}}), span: 3:1-4:1(103-125)}, {kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "Obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:6-4:9(130-133)}, type_parameters: None, type_node: {kind: TypeLiteral({elements: [CallSignature({type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 5:4-5:5(141-142)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 5:7-5:13(144-150)}), initializer: None, span: 5:4-5:13(141-150)}], start: 5:3-5:3(140-140), end: 5:14-5:14(151-151), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(String), span: 5:16-5:22(153-159)})}), ConstructSignature({type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 6:8-6:9(168-169)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 6:11-6:17(171-177)}), initializer: None, span: 6:8-6:17(168-177)}], start: 6:7-6:7(167-167), end: 6:18-6:18(178-178), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: TypeReference({type_name: Identifier({text: "Obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 6:20-6:23(180-183)}), type_arguments: None}), span: 6:20-6:23(180-183)})}), IndexSignature({is_readonly: false, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "k", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 7:4-7:5(188-189)}), is_optional: false, type_node: Some({kind: KeywordType(String), span: 7:7-7:13(191-197)}), initializer: None, span: 7:4-7:13(188-197)}], start: 7:4-7:4(188-188), end: 7:13-7:13(197-197), has_trailing_comma: false, is_missing_list: false}, type_node: {kind: KeywordType(Number), span: 7:16-7:22(200-206)}}), GetAccessor({doc_comment: None, decorators: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, name: Identifier({text: "y", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 8:7-8:8(214-215)}), parameters: {elements: [], start: 8:8-8:8(215-215), end: 8:10-8:10(217-217), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(Number), span: 8:12-8:18(219-225)}), body: None}), SetAccessor({doc_comment: None, decorators: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, name: Identifier({text: "y", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 9:7-9:8(233-234)}), parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "v", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 9:9-9:10(235-236)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 9:12-9:18(238-244)}), initializer: None, span: 9:9-9:18(235-244)}], start: 9:8-9:8(234-234), end: 9:19-9:19(245-245), has_trailing_comma: false, is_missing_list: false}, body: None}), MethodSignature({doc_comment: None, name: Identifier({text: "method", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 10:3-10:9(249-255)}), is_optional: false, type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 10:10-10:11(256-257)}), is_optional: false, type_node: Some({kind: KeywordType(String), span: 10:13-10:19(259-265)}), initializer: None, span: 10:10-10:19(256-265)}], start: 10:9-10:9(255-255), end: 10:20-10:20(266-266), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(String), span: 10:22-10:28(268-274)})}), PropertySignature({doc_comment: None, is_readonly: false, name: Identifier({text: "prop", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 11:3-11:7(278-282)}), is_optional: true, type_node: Some({kind: KeywordType(String), span: 11:10-11:16(285-291)})})], start: 4:12-4:12(136-136), end: 12:2-12:2(293-293), has_trailing_comma: false, is_missing_list: false}), span: 4:12-12:2(136-293)}}), span: 4:1-12:2(125-293)}], start: 1:1-1:1(0-0), end: 12:2-12:2(293-293), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type Fn = (a: number, b?: string, ...rest: boolean[]) => string;\ntype Tuple = [number, string, A | B];\ntype Arr = (A | B)[];\ntype Obj = {\n  (x: number): string;\n  new (x: number): Obj;\n  [k: string]: number;\n  get y(): number;\n  set y(v: number);\n  method(a: string): string;\n  prop?: string\n}", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - generic function types" {
  let source = parse_source("type Id = <T>(x: T) => T;")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "Id", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:8(5-7)}, type_parameters: None, type_node: {kind: FunctionType({type_parameters: Some({elements: [{modifiers: {variance: None, is_const: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:13(11-12)}, constraint: None, default_type: None}], start: 1:11-1:11(10-10), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}), parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:16(14-15)}), is_optional: false, type_node: Some({kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:19(17-18)}), type_arguments: None}), span: 1:18-1:19(17-18)}), initializer: None, span: 1:15-1:19(14-18)}], start: 1:14-1:14(13-13), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:24-1:25(23-24)}), type_arguments: None}), span: 1:24-1:25(23-24)})}), span: 1:11-1:25(10-24)}}), span: 1:1-1:26(0-25)}], start: 1:1-1:1(0-0), end: 1:26-1:26(25-25), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type Id = <T>(x: T) => T;", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - constructor types" {
  let source = parse_source(
    (
      #|type Ctor = new (x: number) => Foo;
      #|type AbsCtor = abstract new <T>(x: T) => T;
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "Ctor", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:10(5-9)}, type_parameters: None, type_node: {kind: ConstructorType({is_abstract: false, type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:19(17-18)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 1:21-1:27(20-26)}), initializer: None, span: 1:18-1:27(17-26)}], start: 1:17-1:17(16-16), end: 1:28-1:28(27-27), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: TypeReference({type_name: Identifier({text: "Foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:32-1:35(31-34)}), type_arguments: None}), span: 1:32-1:35(31-34)})}), span: 1:13-1:35(12-34)}}), span: 1:1-2:1(0-36)}, {kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "AbsCtor", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:6-2:13(41-48)}, type_parameters: None, type_node: {kind: ConstructorType({is_abstract: true, type_parameters: Some({elements: [{modifiers: {variance: None, is_const: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:30-2:31(65-66)}, constraint: None, default_type: None}], start: 2:29-2:29(64-64), end: 2:32-2:32(67-67), has_trailing_comma: false, is_missing_list: false}), parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:33-2:34(68-69)}), is_optional: false, type_node: Some({kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:36-2:37(71-72)}), type_arguments: None}), span: 2:36-2:37(71-72)}), initializer: None, span: 2:33-2:37(68-72)}], start: 2:32-2:32(67-67), end: 2:38-2:38(73-73), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:42-2:43(77-78)}), type_arguments: None}), span: 2:42-2:43(77-78)})}), span: 2:16-2:43(51-78)}}), span: 2:1-2:44(36-79)}], start: 1:1-1:1(0-0), end: 2:44-2:44(79-79), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type Ctor = new (x: number) => Foo;\ntype AbsCtor = abstract new <T>(x: T) => T;", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - class members" {
  let source = parse_source(
    (
      #|class C {
      #|  static { let x = 1 }
      #|  constructor(public x: number) {}
      #|  get y(): number { return this.x }
      #|  set y(v: number) {}
      #|  method<T>(a: T): T { return a }
      #|}
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ClassDecl({doc_comment: None, decorators: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: Some({text: "C", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:8(6-7)}), type_parameters: None, heritage_clauses: None, members: {elements: [ClassStaticBlockDecl({body: [{kind: VariableStmt({doc_comment: None, modifiers: None, declaration_list: {elements: [{kind: Let, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:16-2:17(25-26)}), type_node: None, initializer: Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:20-2:21(29-30)}), span: 2:20-2:21(29-30)})}], start: 2:12-2:12(21-21), end: 2:22-2:22(31-31), has_trailing_comma: false, is_missing_list: false}}), span: 2:12-2:22(21-31)}]}), Constructor({doc_comment: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, parameters: {elements: [{modifiers: {accessibility: Some(public), is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:22-3:23(54-55)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 3:25-3:31(57-63)}), initializer: None, span: 3:15-3:31(47-63)}], start: 3:14-3:14(46-46), end: 3:32-3:32(64-64), has_trailing_comma: false, is_missing_list: false}, body: Some([])}), GetAccessor({doc_comment: None, decorators: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, name: Identifier({text: "y", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:7-4:8(74-75)}), parameters: {elements: [], start: 4:8-4:8(75-75), end: 4:10-4:10(77-77), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(Number), span: 4:12-4:18(79-85)}), body: Some([{kind: ReturnStmt(Some({kind: PropertyAccessExpr({expression: {kind: ThisExpr, span: 4:28-4:32(95-99)}, is_null_coalescing: false, name: {text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:33-4:34(100-101)}}), span: 4:28-4:34(95-101)})), span: 4:21-4:34(88-101)}])}), SetAccessor({doc_comment: None, decorators: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, name: Identifier({text: "y", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 5:7-5:8(110-111)}), parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "v", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 5:9-5:10(112-113)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 5:12-5:18(115-121)}), initializer: None, span: 5:9-5:18(112-121)}], start: 5:8-5:8(111-111), end: 5:19-5:19(122-122), has_trailing_comma: false, is_missing_list: false}, body: Some([])}), MethodDecl({doc_comment: None, decorators: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, is_generator: false, name: Identifier({text: "method", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 6:3-6:9(128-134)}), is_optional: false, type_parameters: Some({elements: [{modifiers: {variance: None, is_const: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 6:10-6:11(135-136)}, constraint: None, default_type: None}], start: 6:9-6:9(134-134), end: 6:12-6:12(137-137), has_trailing_comma: false, is_missing_list: false}), parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 6:13-6:14(138-139)}), is_optional: false, type_node: Some({kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 6:16-6:17(141-142)}), type_arguments: None}), span: 6:16-6:17(141-142)}), initializer: None, span: 6:13-6:17(138-142)}], start: 6:12-6:12(137-137), end: 6:18-6:18(143-143), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 6:20-6:21(145-146)}), type_arguments: None}), span: 6:20-6:21(145-146)}), body: Some([{kind: ReturnStmt(Some({kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 6:31-6:32(156-157)}), span: 6:31-6:32(156-157)})), span: 6:24-6:32(149-157)}])})], start: 1:9-1:9(8-8), end: 7:1-7:1(160-160), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-7:2(0-161)}], start: 1:1-1:1(0-0), end: 7:2-7:2(161-161), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "class C {\n  static { let x = 1 }\n  constructor(public x: number) {}\n  get y(): number { return this.x }\n  set y(v: number) {}\n  method<T>(a: T): T { return a }\n}", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - function declarations" {
  let source = parse_source(
    (
      #|function fn(): string;
      #|function fn(x: string): string { return x }
      #|function fn2(x: number, y?: number): number { return x }
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, is_async: false, is_generator: false, name: Some({text: "fn", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:12(9-11)}), type_parameters: None, parameters: {elements: [], start: 1:12-1:12(11-11), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(String), span: 1:16-1:22(15-21)}), body: None}), span: 1:1-2:1(0-23)}, {kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, is_async: false, is_generator: false, name: Some({text: "fn", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:10-2:12(32-34)}), type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:13-2:14(35-36)}), is_optional: false, type_node: Some({kind: KeywordType(String), span: 2:16-2:22(38-44)}), initializer: None, span: 2:13-2:22(35-44)}], start: 2:12-2:12(34-34), end: 2:23-2:23(45-45), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(String), span: 2:25-2:31(47-53)}), body: Some([{kind: ReturnStmt(Some({kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:41-2:42(63-64)}), span: 2:41-2:42(63-64)})), span: 2:34-2:42(56-64)}])}), span: 2:1-2:44(23-66)}, {kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, is_async: false, is_generator: false, name: Some({text: "fn2", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:10-3:13(76-79)}), type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:14-3:15(80-81)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 3:17-3:23(83-89)}), initializer: None, span: 3:14-3:23(80-89)}, {modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "y", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:25-3:26(91-92)}), is_optional: true, type_node: Some({kind: KeywordType(Number), span: 3:29-3:35(95-101)}), initializer: None, span: 3:25-3:35(91-101)}], start: 3:13-3:13(79-79), end: 3:36-3:36(102-102), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(Number), span: 3:38-3:44(104-110)}), body: Some([{kind: ReturnStmt(Some({kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:54-3:55(120-121)}), span: 3:54-3:55(120-121)})), span: 3:47-3:55(113-121)}])}), span: 3:1-3:57(67-123)}], start: 1:1-1:1(0-0), end: 3:57-3:57(123-123), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "function fn(): string;\nfunction fn(x: string): string { return x }\nfunction fn2(x: number, y?: number): number { return x }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - interface heritage" {
  let source = parse_source(
    (
      #|interface B {}
      #|interface C {}
      #|interface A extends B, C { x: number }
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: InterfaceDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:12(10-11)}, type_parameters: None, heritage_clauses: None, members: {elements: [], start: 1:13-1:13(12-12), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:15(0-14)}, {kind: InterfaceDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "C", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:11-2:12(25-26)}, type_parameters: None, heritage_clauses: None, members: {elements: [], start: 2:13-2:13(27-27), end: 2:15-2:15(29-29), has_trailing_comma: false, is_missing_list: false}}), span: 2:1-2:15(15-29)}, {kind: InterfaceDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:11-3:12(40-41)}, type_parameters: None, heritage_clauses: Some({elements: [{kind: Extends, types: {elements: [{expression: {kind: Identifier({text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:21-3:22(50-51)}), span: 3:21-3:22(50-51)}, type_arguments: None}, {expression: {kind: Identifier({text: "C", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:24-3:25(53-54)}), span: 3:24-3:25(53-54)}, type_arguments: None}], start: 3:13-3:13(42-42), end: 3:26-3:26(55-55), has_trailing_comma: false, is_missing_list: false}}], start: 3:1-3:1(30-30), end: 3:26-3:26(55-55), has_trailing_comma: false, is_missing_list: false}), members: {elements: [PropertySignature({doc_comment: None, is_readonly: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:28-3:29(57-58)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 3:31-3:37(60-66)})})], start: 3:26-3:26(55-55), end: 3:39-3:39(68-68), has_trailing_comma: false, is_missing_list: false}}), span: 3:1-3:39(30-68)}], start: 1:1-1:1(0-0), end: 3:39-3:39(68-68), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "interface B {}\ninterface C {}\ninterface A extends B, C { x: number }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - ambient declarations" {
  let source = parse_source(
    (
      #|declare const x: number;
      #|declare function f(): void;
      #|declare namespace N { const v: number }
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: VariableStmt({doc_comment: None, modifiers: Some({elements: [declare], start: 1:1-1:1(0-0), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}), declaration_list: {elements: [{kind: Const, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:16(14-15)}), type_node: Some({kind: KeywordType(Number), span: 1:18-1:24(17-23)}), initializer: None}], start: 1:1-1:1(0-0), end: 1:24-1:24(23-23), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-2:1(0-25)}, {kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, is_async: false, is_generator: false, name: Some({text: "f", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:18-2:19(42-43)}), type_parameters: None, parameters: {elements: [], start: 2:19-2:19(43-43), end: 2:21-2:21(45-45), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(Void), span: 2:23-2:27(47-51)}), body: None}), span: 2:1-3:1(25-53)}, {kind: ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, name: Identifier({text: "N", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:19-3:20(71-72)}), body: Some(ModuleBlock({elements: [{kind: VariableStmt({doc_comment: None, modifiers: None, declaration_list: {elements: [{kind: Const, name: Identifier({text: "v", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:29-3:30(81-82)}), type_node: Some({kind: KeywordType(Number), span: 3:32-3:38(84-90)}), initializer: None}], start: 3:23-3:23(75-75), end: 3:39-3:39(91-91), has_trailing_comma: false, is_missing_list: false}}), span: 3:23-3:39(75-91)}], start: 3:21-3:21(73-73), end: 3:40-3:40(92-92), has_trailing_comma: false, is_missing_list: false}))}), span: 3:1-3:40(53-92)}], start: 1:1-1:1(0-0), end: 3:40-3:40(92-92), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "declare const x: number;\ndeclare function f(): void;\ndeclare namespace N { const v: number }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - interface members" {
  let source = parse_source(
    (
      #|interface I {
      #|  (x: number): string;
      #|  new (): I;
      #|  [k: string]: number;
      #|}
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: InterfaceDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "I", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:12(10-11)}, type_parameters: None, heritage_clauses: None, members: {elements: [CallSignature({type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:4-2:5(17-18)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 2:7-2:13(20-26)}), initializer: None, span: 2:4-2:13(17-26)}], start: 2:3-2:3(16-16), end: 2:14-2:14(27-27), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(String), span: 2:16-2:22(29-35)})}), ConstructSignature({type_parameters: None, parameters: {elements: [], start: 3:7-3:7(43-43), end: 3:9-3:9(45-45), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: TypeReference({type_name: Identifier({text: "I", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:11-3:12(47-48)}), type_arguments: None}), span: 3:11-3:12(47-48)})}), IndexSignature({is_readonly: false, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "k", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:4-4:5(53-54)}), is_optional: false, type_node: Some({kind: KeywordType(String), span: 4:7-4:13(56-62)}), initializer: None, span: 4:4-4:13(53-62)}], start: 4:4-4:4(53-53), end: 4:13-4:13(62-62), has_trailing_comma: false, is_missing_list: false}, type_node: {kind: KeywordType(Number), span: 4:16-4:22(65-71)}})], start: 1:13-1:13(12-12), end: 5:2-5:2(74-74), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-5:2(0-74)}], start: 1:1-1:1(0-0), end: 5:2-5:2(74-74), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "interface I {\n  (x: number): string;\n  new (): I;\n  [k: string]: number;\n}", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - export default classes" {
  let source = parse_source(
    (
      #|export default class C {}
      #|export default abstract class D {}
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ClassDecl({doc_comment: None, decorators: None, modifiers: {is_export: true, is_default: true, is_declare: false}, name: Some({text: "C", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:22-1:23(21-22)}), type_parameters: None, heritage_clauses: None, members: {elements: [], start: 1:24-1:24(23-23), end: 1:25-1:25(24-24), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:26(0-25)}, {kind: ExportAssignment({modifiers: Some({elements: [export, default], start: 2:1-2:1(26-26), end: 2:15-2:15(40-40), has_trailing_comma: false, is_missing_list: false}), is_export_equals: false, expression: {kind: Identifier({text: "abstract", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:16-2:24(41-49)}), span: 2:16-2:24(41-49)}}), span: 2:1-2:25(26-50)}, {kind: ClassDecl({doc_comment: None, decorators: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: Some({text: "D", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:31-2:32(56-57)}), type_parameters: None, heritage_clauses: None, members: {elements: [], start: 2:33-2:33(58-58), end: 2:34-2:34(59-59), has_trailing_comma: false, is_missing_list: false}}), span: 2:25-2:35(50-60)}], start: 1:1-1:1(0-0), end: 2:35-2:35(60-60), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "export default class C {}\nexport default abstract class D {}", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - declare const enum" {
  let source = parse_source("declare const enum E { A = 1, B }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: EnumDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, name: {text: "E", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:20-1:21(19-20)}, members: {elements: [{doc_comment: None, name: Identifier({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:24-1:25(23-24)}), initializer: Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:28-1:29(27-28)}), span: 1:28-1:29(27-28)})}, {doc_comment: None, name: Identifier({text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:31-1:32(30-31)}), initializer: None}], start: 1:22-1:22(21-21), end: 1:34-1:34(33-33), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:34(0-33)}], start: 1:1-1:1(0-0), end: 1:34-1:34(33-33), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "declare const enum E { A = 1, B }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - declare namespace dotted" {
  let source = parse_source("declare namespace A.B { const x: number }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, name: Identifier({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:19-1:20(18-19)}), body: Some(ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, name: Identifier({text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:21-1:22(20-21)}), body: Some(ModuleBlock({elements: [{kind: VariableStmt({doc_comment: None, modifiers: None, declaration_list: {elements: [{kind: Const, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:31-1:32(30-31)}), type_node: Some({kind: KeywordType(Number), span: 1:34-1:40(33-39)}), initializer: None}], start: 1:25-1:25(24-24), end: 1:41-1:41(40-40), has_trailing_comma: false, is_missing_list: false}}), span: 1:25-1:41(24-40)}], start: 1:23-1:23(22-22), end: 1:42-1:42(41-41), has_trailing_comma: false, is_missing_list: false}))}))}), span: 1:1-1:42(0-41)}], start: 1:1-1:1(0-0), end: 1:42-1:42(41-41), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "declare namespace A.B { const x: number }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - const enum" {
  let source = parse_source("const enum E { A = \"a\", B = 2 }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: EnumDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "E", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:13(11-12)}, members: {elements: [{doc_comment: None, name: Identifier({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:16-1:17(15-16)}), initializer: Some({kind: StringLiteral({text: "a", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:20-1:23(19-22)}), span: 1:20-1:23(19-22)})}, {doc_comment: None, name: Identifier({text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:25-1:26(24-25)}), initializer: Some({kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:29-1:30(28-29)}), span: 1:29-1:30(28-29)})}], start: 1:14-1:14(13-13), end: 1:32-1:32(31-31), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:32(0-31)}], start: 1:1-1:1(0-0), end: 1:32-1:32(31-31), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "const enum E { A = \"a\", B = 2 }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - variable stmts" {
  let source = parse_source(
    (
      #|const a = 1;
      #|let b: string;
      #|var c = foo
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: VariableStmt({doc_comment: None, modifiers: None, declaration_list: {elements: [{kind: Const, name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:8(6-7)}), type_node: None, initializer: Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:11-1:12(10-11)}), span: 1:11-1:12(10-11)})}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-2:1(0-13)}, {kind: VariableStmt({doc_comment: None, modifiers: None, declaration_list: {elements: [{kind: Let, name: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:5-2:6(17-18)}), type_node: Some({kind: KeywordType(String), span: 2:8-2:14(20-26)}), initializer: None}], start: 2:1-2:1(13-13), end: 2:14-2:14(26-26), has_trailing_comma: false, is_missing_list: false}}), span: 2:1-3:1(13-28)}, {kind: VariableStmt({doc_comment: None, modifiers: None, declaration_list: {elements: [{kind: Var, name: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:5-3:6(32-33)}), type_node: None, initializer: Some({kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:9-3:12(36-39)}), span: 3:9-3:12(36-39)})}], start: 3:1-3:1(28-28), end: 3:12-3:12(39-39), has_trailing_comma: false, is_missing_list: false}}), span: 3:1-3:12(28-39)}], start: 1:1-1:1(0-0), end: 3:12-3:12(39-39), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "const a = 1;\nlet b: string;\nvar c = foo", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - using stmts" {
  let source = parse_source(
    (
      #|using r = open();
      #|await using s = make();
    ),
    is_module=true,
  )
  let names : Array[String] = []
  let awaits : Array[Bool] = []
  for stmt in source.stmts.elements.iter() {
    match stmt.kind {
      UsingStmt(decl) => {
        awaits.push(decl.is_await)
        for item in decl.declaration_list.elements.iter() {
          names.push(item.name.text)
        }
      }
      _ => ()
    }
  }
  inspect(names, content="[\"r\", \"s\"]")
  inspect(awaits, content="[false, true]")
}

///|
test "expr - contextual identifiers" {
  let source = parse_source("let [type, as, from, of, using, global] = foo")
  guard source.stmts.elements is [{ kind: VariableStmt(var_stmt), .. }]
  guard var_stmt.declaration_list.elements is [decl]
  guard decl.name is ArrayBindingPattern({ elements: elems, .. })
  let names = elems.map(elem => {
    guard elem is BindingElement({ name, .. })
    guard name is Identifier({ text, .. })
    text
  })
  inspect(
    names,
    content="[\"type\", \"as\", \"from\", \"of\", \"using\", \"global\"]",
  )
}

///|
test "decl - class heritage" {
  let source = parse_source(
    (
      #|class Base {}
      #|class Derived extends Base implements IFoo, Bar.Baz {}
      #|interface IFoo {}
      #|namespace Bar { export interface Baz {} }
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ClassDecl({doc_comment: None, decorators: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: Some({text: "Base", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:11(6-10)}), type_parameters: None, heritage_clauses: None, members: {elements: [], start: 1:12-1:12(11-11), end: 1:13-1:13(12-12), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:14(0-13)}, {kind: ClassDecl({doc_comment: None, decorators: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: Some({text: "Derived", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:7-2:14(20-27)}), type_parameters: None, heritage_clauses: Some({elements: [{kind: Extends, types: {elements: [{expression: {kind: Identifier({text: "Base", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:23-2:27(36-40)}), span: 2:23-2:27(36-40)}, type_arguments: None}], start: 2:15-2:15(28-28), end: 2:28-2:28(41-41), has_trailing_comma: false, is_missing_list: false}}, {kind: Implements, types: {elements: [{expression: {kind: Identifier({text: "IFoo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:39-2:43(52-56)}), span: 2:39-2:43(52-56)}, type_arguments: None}, {expression: {kind: PropertyAccessExpr({expression: {kind: Identifier({text: "Bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:45-2:48(58-61)}), span: 2:45-2:48(58-61)}, is_null_coalescing: false, name: {text: "Baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:49-2:52(62-65)}}), span: 2:45-2:52(58-65)}, type_arguments: None}], start: 2:28-2:28(41-41), end: 2:53-2:53(66-66), has_trailing_comma: false, is_missing_list: false}}], start: 2:1-2:1(14-14), end: 2:53-2:53(66-66), has_trailing_comma: false, is_missing_list: false}), members: {elements: [], start: 2:53-2:53(66-66), end: 2:54-2:54(67-67), has_trailing_comma: false, is_missing_list: false}}), span: 2:1-2:55(14-68)}, {kind: InterfaceDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "IFoo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:11-3:15(79-83)}, type_parameters: None, heritage_clauses: None, members: {elements: [], start: 3:16-3:16(84-84), end: 3:18-3:18(86-86), has_trailing_comma: false, is_missing_list: false}}), span: 3:1-3:18(69-86)}, {kind: ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: Identifier({text: "Bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:11-4:14(97-100)}), body: Some(ModuleBlock({elements: [{kind: InterfaceDecl({doc_comment: None, modifiers: {is_export: true, is_default: false, is_declare: false}, name: {text: "Baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:34-4:37(120-123)}, type_parameters: None, heritage_clauses: None, members: {elements: [], start: 4:38-4:38(124-124), end: 4:40-4:40(126-126), has_trailing_comma: false, is_missing_list: false}}), span: 4:17-4:40(103-126)}], start: 4:15-4:15(101-101), end: 4:42-4:42(128-128), has_trailing_comma: false, is_missing_list: false}))}), span: 4:1-4:42(87-128)}], start: 1:1-1:1(0-0), end: 4:42-4:42(128-128), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "class Base {}\nclass Derived extends Base implements IFoo, Bar.Baz {}\ninterface IFoo {}\nnamespace Bar { export interface Baz {} }", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - export type" {
  let source = parse_source(
    (
      #|export type { A as B } from "m";
      #|export type * from "m"
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ExportDecl({modifiers: Some({elements: [export], start: 1:1-1:1(0-0), end: 1:13-1:13(12-12), has_trailing_comma: false, is_missing_list: false}), is_type_only: true, export_clause: Some(NamedExports({elements: [{is_type_only: false, property_name: Some({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:16(14-15)}), name: {text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:20-1:21(19-20)}}], start: 1:13-1:13(12-12), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false})), module_specifier: Some({kind: StringLiteral({text: "m", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:29-1:32(28-31)}), span: 1:29-1:32(28-31)}), attributes: None}), span: 1:1-2:1(0-33)}, {kind: ExportDecl({modifiers: Some({elements: [export], start: 2:1-2:1(33-33), end: 2:13-2:13(45-45), has_trailing_comma: false, is_missing_list: false}), is_type_only: true, export_clause: None, module_specifier: Some({kind: StringLiteral({text: "m", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:20-2:23(52-55)}), span: 2:20-2:23(52-55)}), attributes: None}), span: 2:1-2:23(33-55)}], start: 1:1-1:1(0-0), end: 2:23-2:23(55-55), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "export type { A as B } from \"m\";\nexport type * from \"m\"", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - export interface and class" {
  let source = parse_source(
    (
      #|export interface I { x: number }
      #|export declare class C { constructor(); }
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: InterfaceDecl({doc_comment: None, modifiers: {is_export: true, is_default: false, is_declare: false}, name: {text: "I", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:19(17-18)}, type_parameters: None, heritage_clauses: None, members: {elements: [PropertySignature({doc_comment: None, is_readonly: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:22-1:23(21-22)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 1:25-1:31(24-30)})})], start: 1:20-1:20(19-19), end: 1:33-1:33(32-32), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:33(0-32)}, {kind: ClassDecl({doc_comment: None, decorators: None, modifiers: {is_export: true, is_default: false, is_declare: true}, name: Some({text: "C", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:22-2:23(54-55)}), type_parameters: None, heritage_clauses: None, members: {elements: [Constructor({doc_comment: None, modifiers: {accessibility: None, is_static: false, is_abstract: false, is_readonly: false, is_override: false, is_accessor: false, is_async: false}, parameters: {elements: [], start: 2:37-2:37(69-69), end: 2:39-2:39(71-71), has_trailing_comma: false, is_missing_list: false}, body: None})], start: 2:24-2:24(56-56), end: 2:41-2:41(73-73), has_trailing_comma: false, is_missing_list: false}}), span: 2:1-2:42(33-74)}], start: 1:1-1:1(0-0), end: 2:42-2:42(74-74), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "export interface I { x: number }\nexport declare class C { constructor(); }", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - function overloads" {
  let source = parse_source(
    (
      #|declare function f(x: number): number;
      #|declare function f(x: string): string;
      #|function f(x: number | string) { return x; }
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, is_async: false, is_generator: false, name: Some({text: "f", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:19(17-18)}), type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:20-1:21(19-20)}), is_optional: false, type_node: Some({kind: KeywordType(Number), span: 1:23-1:29(22-28)}), initializer: None, span: 1:20-1:29(19-28)}], start: 1:19-1:19(18-18), end: 1:30-1:30(29-29), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(Number), span: 1:32-1:38(31-37)}), body: None}), span: 1:1-2:1(0-39)}, {kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, is_async: false, is_generator: false, name: Some({text: "f", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:18-2:19(56-57)}), type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:20-2:21(58-59)}), is_optional: false, type_node: Some({kind: KeywordType(String), span: 2:23-2:29(61-67)}), initializer: None, span: 2:20-2:29(58-67)}], start: 2:19-2:19(57-57), end: 2:30-2:30(68-68), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(String), span: 2:32-2:38(70-76)}), body: None}), span: 2:1-3:1(39-78)}, {kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, is_async: false, is_generator: false, name: Some({text: "f", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:10-3:11(87-88)}), type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:12-3:13(89-90)}), is_optional: false, type_node: Some({kind: UnionType({elements: [{kind: KeywordType(Number), span: 3:15-3:21(92-98)}, {kind: KeywordType(String), span: 3:24-3:30(101-107)}], start: 3:15-3:15(92-92), end: 3:30-3:30(107-107), has_trailing_comma: false, is_missing_list: false}), span: 3:15-3:30(92-107)}), initializer: None, span: 3:12-3:30(89-107)}], start: 3:11-3:11(88-88), end: 3:31-3:31(108-108), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([{kind: ReturnStmt(Some({kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:41-3:42(118-119)}), span: 3:41-3:42(118-119)})), span: 3:34-3:42(111-119)}])}), span: 3:1-3:45(78-122)}], start: 1:1-1:1(0-0), end: 3:45-3:45(122-122), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "declare function f(x: number): number;\ndeclare function f(x: string): string;\nfunction f(x: number | string) { return x; }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - namespace merge" {
  let source = parse_source(
    (
      #|namespace N { export const a = 1 }
      #|namespace N { export function b() {} }
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: Identifier({text: "N", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:12(10-11)}), body: Some(ModuleBlock({elements: [{kind: VariableStmt({doc_comment: None, modifiers: Some({elements: [export], start: 1:15-1:15(14-14), end: 1:22-1:22(21-21), has_trailing_comma: false, is_missing_list: false}), declaration_list: {elements: [{kind: Const, name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:28-1:29(27-28)}), type_node: None, initializer: Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:32-1:33(31-32)}), span: 1:32-1:33(31-32)})}], start: 1:15-1:15(14-14), end: 1:34-1:34(33-33), has_trailing_comma: false, is_missing_list: false}}), span: 1:15-1:34(14-33)}], start: 1:13-1:13(12-12), end: 1:35-1:35(34-34), has_trailing_comma: false, is_missing_list: false}))}), span: 1:1-2:1(0-35)}, {kind: ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: Identifier({text: "N", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:11-2:12(45-46)}), body: Some(ModuleBlock({elements: [{kind: FunctionDecl({doc_comment: None, modifiers: {is_export: true, is_default: false, is_declare: false}, is_async: false, is_generator: false, name: Some({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:31-2:32(65-66)}), type_parameters: None, parameters: {elements: [], start: 2:32-2:32(66-66), end: 2:34-2:34(68-68), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([])}), span: 2:15-2:37(49-71)}], start: 2:13-2:13(47-47), end: 2:39-2:39(73-73), has_trailing_comma: false, is_missing_list: false}))}), span: 2:1-2:39(35-73)}], start: 1:1-1:1(0-0), end: 2:39-2:39(73-73), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "namespace N { export const a = 1 }\nnamespace N { export function b() {} }", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - declare global" {
  let source = parse_source("declare global { interface G { z: string } }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, name: Identifier({text: "global", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:15(8-14)}), body: Some(ModuleBlock({elements: [{kind: InterfaceDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "G", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:28-1:29(27-28)}, type_parameters: None, heritage_clauses: None, members: {elements: [PropertySignature({doc_comment: None, is_readonly: false, name: Identifier({text: "z", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:32-1:33(31-32)}), is_optional: false, type_node: Some({kind: KeywordType(String), span: 1:35-1:41(34-40)})})], start: 1:30-1:30(29-29), end: 1:43-1:43(42-42), has_trailing_comma: false, is_missing_list: false}}), span: 1:18-1:43(17-42)}], start: 1:16-1:16(15-15), end: 1:45-1:45(44-44), has_trailing_comma: false, is_missing_list: false}))}), span: 1:1-1:45(0-44)}], start: 1:1-1:1(0-0), end: 1:45-1:45(44-44), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "declare global { interface G { z: string } }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - generic modifiers" {
  let source = parse_source(
    (
      #|declare function id<T>(x: T): T;
      #|export class Box<T> {}
      #|export interface IFace<T> { value: T }
      #|export type Alias<T> = T | null;
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, is_async: false, is_generator: false, name: Some({text: "id", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:20(17-19)}), type_parameters: Some({elements: [{modifiers: {variance: None, is_const: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:21-1:22(20-21)}, constraint: None, default_type: None}], start: 1:20-1:20(19-19), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}), parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:24-1:25(23-24)}), is_optional: false, type_node: Some({kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:27-1:28(26-27)}), type_arguments: None}), span: 1:27-1:28(26-27)}), initializer: None, span: 1:24-1:28(23-27)}], start: 1:23-1:23(22-22), end: 1:29-1:29(28-28), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:31-1:32(30-31)}), type_arguments: None}), span: 1:31-1:32(30-31)}), body: None}), span: 1:1-2:1(0-33)}, {kind: ClassDecl({doc_comment: None, decorators: None, modifiers: {is_export: true, is_default: false, is_declare: false}, name: Some({text: "Box", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:14-2:17(46-49)}), type_parameters: Some({elements: [{modifiers: {variance: None, is_const: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:18-2:19(50-51)}, constraint: None, default_type: None}], start: 2:17-2:17(49-49), end: 2:20-2:20(52-52), has_trailing_comma: false, is_missing_list: false}), heritage_clauses: None, members: {elements: [], start: 2:21-2:21(53-53), end: 2:22-2:22(54-54), has_trailing_comma: false, is_missing_list: false}}), span: 2:1-2:23(33-55)}, {kind: InterfaceDecl({doc_comment: None, modifiers: {is_export: true, is_default: false, is_declare: false}, name: {text: "IFace", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:18-3:23(73-78)}, type_parameters: Some({elements: [{modifiers: {variance: None, is_const: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:24-3:25(79-80)}, constraint: None, default_type: None}], start: 3:23-3:23(78-78), end: 3:26-3:26(81-81), has_trailing_comma: false, is_missing_list: false}), heritage_clauses: None, members: {elements: [PropertySignature({doc_comment: None, is_readonly: false, name: Identifier({text: "value", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:29-3:34(84-89)}), is_optional: false, type_node: Some({kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:36-3:37(91-92)}), type_arguments: None}), span: 3:36-3:37(91-92)})})], start: 3:27-3:27(82-82), end: 3:39-3:39(94-94), has_trailing_comma: false, is_missing_list: false}}), span: 3:1-3:39(56-94)}, {kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: true, is_default: false, is_declare: false}, name: {text: "Alias", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:13-4:18(107-112)}, type_parameters: Some({elements: [{modifiers: {variance: None, is_const: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:19-4:20(113-114)}, constraint: None, default_type: None}], start: 4:18-4:18(112-112), end: 4:21-4:21(115-115), has_trailing_comma: false, is_missing_list: false}), type_node: {kind: UnionType({elements: [{kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:24-4:25(118-119)}), type_arguments: None}), span: 4:24-4:25(118-119)}, {kind: KeywordType(Null), span: 4:28-4:32(122-126)}], start: 4:24-4:24(118-118), end: 4:32-4:32(126-126), has_trailing_comma: false, is_missing_list: false}), span: 4:24-4:32(118-126)}}), span: 4:1-4:33(95-127)}], start: 1:1-1:1(0-0), end: 4:33-4:33(127-127), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "declare function id<T>(x: T): T;\nexport class Box<T> {}\nexport interface IFace<T> { value: T }\nexport type Alias<T> = T | null;", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - enum commas and const export" {
  let source = parse_source(
    (
      #|enum E { , A = 1, B }
      #|export const enum Flags { , A = 1, B }
      #|export enum Kind { A }
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: EnumDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "E", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, members: {elements: [{doc_comment: None, name: Identifier({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:13(11-12)}), initializer: Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:16-1:17(15-16)}), span: 1:16-1:17(15-16)})}, {doc_comment: None, name: Identifier({text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:19-1:20(18-19)}), initializer: None}], start: 1:8-1:8(7-7), end: 1:22-1:22(21-21), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:22(0-21)}, {kind: EnumDecl({doc_comment: None, modifiers: {is_export: true, is_default: false, is_declare: false}, name: {text: "Flags", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:19-2:24(40-45)}, members: {elements: [{doc_comment: None, name: Identifier({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:29-2:30(50-51)}), initializer: Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:33-2:34(54-55)}), span: 2:33-2:34(54-55)})}, {doc_comment: None, name: Identifier({text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:36-2:37(57-58)}), initializer: None}], start: 2:25-2:25(46-46), end: 2:39-2:39(60-60), has_trailing_comma: false, is_missing_list: false}}), span: 2:1-2:39(22-60)}, {kind: EnumDecl({doc_comment: None, modifiers: {is_export: true, is_default: false, is_declare: false}, name: {text: "Kind", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:13-3:17(73-77)}, members: {elements: [{doc_comment: None, name: Identifier({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:20-3:21(80-81)}), initializer: None}], start: 3:18-3:18(78-78), end: 3:23-3:23(83-83), has_trailing_comma: false, is_missing_list: false}}), span: 3:1-3:23(61-83)}], start: 1:1-1:1(0-0), end: 3:23-3:23(83-83), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "enum E { , A = 1, B }\nexport const enum Flags { , A = 1, B }\nexport enum Kind { A }", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - modules and namespace names" {
  let source = parse_source(
    (
      #|namespace global {}
      #|declare module "pkg";
      #|declare namespace A.B;
      #|export namespace N { export const x = 1 }
      #|declare global;
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: Identifier({text: "global", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:17(10-16)}), body: Some(ModuleBlock({elements: [], start: 1:18-1:18(17-17), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}))}), span: 1:1-2:1(0-20)}, {kind: ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, name: StringLiteral({text: "pkg", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:16-2:21(35-40)}), body: None}), span: 2:1-3:1(20-42)}, {kind: ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, name: Identifier({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:19-3:20(60-61)}), body: Some(ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, name: Identifier({text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:21-3:22(62-63)}), body: None}))}), span: 3:1-4:1(42-65)}, {kind: ModuleDecl({doc_comment: None, modifiers: {is_export: true, is_default: false, is_declare: false}, name: Identifier({text: "N", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:18-4:19(82-83)}), body: Some(ModuleBlock({elements: [{kind: VariableStmt({doc_comment: None, modifiers: Some({elements: [export], start: 4:22-4:22(86-86), end: 4:29-4:29(93-93), has_trailing_comma: false, is_missing_list: false}), declaration_list: {elements: [{kind: Const, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:35-4:36(99-100)}), type_node: None, initializer: Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 4:39-4:40(103-104)}), span: 4:39-4:40(103-104)})}], start: 4:22-4:22(86-86), end: 4:41-4:41(105-105), has_trailing_comma: false, is_missing_list: false}}), span: 4:22-4:41(86-105)}], start: 4:20-4:20(84-84), end: 4:42-4:42(106-106), has_trailing_comma: false, is_missing_list: false}))}), span: 4:1-5:1(65-107)}, {kind: ModuleDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, name: Identifier({text: "global", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 5:9-5:15(115-121)}), body: None}), span: 5:1-5:16(107-122)}], start: 1:1-1:1(0-0), end: 5:16-5:16(122-122), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "namespace global {}\ndeclare module \"pkg\";\ndeclare namespace A.B;\nexport namespace N { export const x = 1 }\ndeclare global;", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "decl - import export attributes" {
  let source = parse_source(
    (
      #|import foo, { bar, baz as qux, } from "lib" assert { kind: "js", };
      #|import data from "data.json" with { "type": "json", "mode": "raw", };
      #|export { type Foo, bar as baz, } from "lib";
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ImportDecl({import_clause: Some({is_type_only: false, name: Some({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:11(7-10)}), named_bindings: Some(NamedImports({elements: [{is_type_only: false, property_name: None, name: {text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:18(14-17)}}, {is_type_only: false, property_name: Some({text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:20-1:23(19-22)}), name: {text: "qux", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:27-1:30(26-29)}}], start: 1:13-1:13(12-12), end: 1:33-1:33(32-32), has_trailing_comma: false, is_missing_list: false}))}), module_specifier: {kind: StringLiteral({text: "lib", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:39-1:44(38-43)}), span: 1:39-1:44(38-43)}, attributes: Some({elements: {elements: [{name: Identifier({text: "kind", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:54-1:58(53-57)}), value: {kind: StringLiteral({text: "js", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:60-1:64(59-63)}), span: 1:60-1:64(59-63)}}], start: 1:45-1:45(44-44), end: 1:67-1:67(66-66), has_trailing_comma: false, is_missing_list: false}}), phase: Normal}), span: 1:1-2:1(0-68)}, {kind: ImportDecl({import_clause: Some({is_type_only: false, name: Some({text: "data", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:8-2:12(75-79)}), named_bindings: None}), module_specifier: {kind: StringLiteral({text: "data.json", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:18-2:29(85-96)}), span: 2:18-2:29(85-96)}, attributes: Some({elements: {elements: [{name: StringLiteral({text: "type", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:37-2:43(104-110)}), value: {kind: StringLiteral({text: "json", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:45-2:51(112-118)}), span: 2:45-2:51(112-118)}}, {name: StringLiteral({text: "mode", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:53-2:59(120-126)}), value: {kind: StringLiteral({text: "raw", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:61-2:66(128-133)}), span: 2:61-2:66(128-133)}}], start: 2:30-2:30(97-97), end: 2:69-2:69(136-136), has_trailing_comma: false, is_missing_list: false}}), phase: Normal}), span: 2:1-3:1(68-138)}, {kind: ExportDecl({modifiers: Some({elements: [export], start: 3:1-3:1(138-138), end: 3:8-3:8(145-145), has_trailing_comma: false, is_missing_list: false}), is_type_only: false, export_clause: Some(NamedExports({elements: [{is_type_only: true, property_name: None, name: {text: "Foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:15-3:18(152-155)}}, {is_type_only: false, property_name: Some({text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:20-3:23(157-160)}), name: {text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:27-3:30(164-167)}}], start: 3:8-3:8(145-145), end: 3:33-3:33(170-170), has_trailing_comma: false, is_missing_list: false})), module_specifier: Some({kind: StringLiteral({text: "lib", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 3:39-3:44(176-181)}), span: 3:39-3:44(176-181)}), attributes: None}), span: 3:1-3:45(138-182)}], start: 1:1-1:1(0-0), end: 3:45-3:45(182-182), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "import foo, { bar, baz as qux, } from \"lib\" assert { kind: \"js\", };\nimport data from \"data.json\" with { \"type\": \"json\", \"mode\": \"raw\", };\nexport { type Foo, bar as baz, } from \"lib\";", script_kind: TS, is_module: true}
    ),
  )
}

///|

///|
test "stmt - empty and block" {
  let source = parse_source(
    (
      #|;
      #|{}
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: EmptyStmt, span: 1:1-2:1(0-2)}, {kind: Block([]), span: 2:1-2:3(2-4)}], start: 1:1-1:1(0-0), end: 2:3-2:3(4-4), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: ";\n{}", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - if else chain" {
  let source = parse_source("if (a) b(); else if (c) d(); else e();")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: IfStmt({expression: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:6(4-5)}), span: 1:5-1:6(4-5)}, then_statement: {kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:9(7-8)}), span: 1:8-1:9(7-8)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:9-1:9(8-8), end: 1:11-1:11(10-10), has_trailing_comma: false, is_missing_list: false}}), span: 1:8-1:11(7-10)}), span: 1:8-1:11(7-10)}, else_statement: Some({kind: IfStmt({expression: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:22-1:23(21-22)}), span: 1:22-1:23(21-22)}, then_statement: {kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "d", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:25-1:26(24-25)}), span: 1:25-1:26(24-25)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:26-1:26(25-25), end: 1:28-1:28(27-27), has_trailing_comma: false, is_missing_list: false}}), span: 1:25-1:28(24-27)}), span: 1:25-1:28(24-27)}, else_statement: Some({kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "e", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:35-1:36(34-35)}), span: 1:35-1:36(34-35)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:36-1:36(35-35), end: 1:38-1:38(37-37), has_trailing_comma: false, is_missing_list: false}}), span: 1:35-1:38(34-37)}), span: 1:35-1:38(34-37)})}), span: 1:18-1:38(17-37)})}), span: 1:1-1:38(0-37)}], start: 1:1-1:1(0-0), end: 1:39-1:39(38-38), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "if (a) b(); else if (c) d(); else e();", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - if empty branches" {
  let source = parse_source("if (ready) ; else ;")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: IfStmt({expression: {kind: Identifier({text: "ready", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:10(4-9)}), span: 1:5-1:10(4-9)}, then_statement: {kind: EmptyStmt, span: 1:12-1:14(11-13)}, else_statement: Some({kind: EmptyStmt, span: 1:19-1:20(18-19)})}), span: 1:1-1:20(0-19)}], start: 1:1-1:1(0-0), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "if (ready) ; else ;", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - loops" {
  let source = parse_source(
    (
      #|while (a) { b(); }
      #|do { c(); } while (d);
      #|for (let i = 0; i < 3; i++) { tick(); }
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: WhileStmt({expression: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:9(7-8)}), span: 1:8-1:9(7-8)}, statement: {kind: Block([{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:14(12-13)}), span: 1:13-1:14(12-13)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:14-1:14(13-13), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}}), span: 1:13-1:16(12-15)}), span: 1:13-1:16(12-15)}]), span: 1:11-1:19(10-18)}}), span: 1:1-1:19(0-18)}, {kind: DoStmt({statement: {kind: Block([{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:6-2:7(24-25)}), span: 2:6-2:7(24-25)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 2:7-2:7(25-25), end: 2:9-2:9(27-27), has_trailing_comma: false, is_missing_list: false}}), span: 2:6-2:9(24-27)}), span: 2:6-2:9(24-27)}]), span: 2:4-2:12(22-30)}, expression: {kind: Identifier({text: "d", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:20-2:21(38-39)}), span: 2:20-2:21(38-39)}}), span: 2:1-2:21(19-39)}, {kind: ForStmt({initializer: Some(VariableDeclList({elements: [{kind: Let, name: Identifier({text: "i", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:10-3:11(51-52)}), type_node: None, initializer: Some({kind: NumericLiteral({text: "0", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 3:14-3:15(55-56)}), span: 3:14-3:15(55-56)})}], start: 3:1-3:1(42-42), end: 3:15-3:15(56-56), has_trailing_comma: false, is_missing_list: false})), condition: Some({kind: BinaryExpr({left: {kind: Identifier({text: "i", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:17-3:18(58-59)}), span: 3:17-3:18(58-59)}, operator: LessThan, right: {kind: NumericLiteral({text: "3", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 3:21-3:22(62-63)}), span: 3:21-3:22(62-63)}}), span: 3:17-3:22(58-63)}), incrementor: Some({kind: PostfixUnaryExpr({operand: {kind: Identifier({text: "i", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:24-3:25(65-66)}), span: 3:24-3:25(65-66)}, operator: PlusPlus}), span: 3:24-3:27(65-68)}), statement: {kind: Block([{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "tick", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:31-3:35(72-76)}), span: 3:31-3:35(72-76)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 3:35-3:35(76-76), end: 3:37-3:37(78-78), has_trailing_comma: false, is_missing_list: false}}), span: 3:31-3:37(72-78)}), span: 3:31-3:37(72-78)}]), span: 3:29-3:40(70-81)}}), span: 3:1-3:40(42-81)}], start: 1:1-1:1(0-0), end: 3:40-3:40(81-81), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "while (a) { b(); }\ndo { c(); } while (d);\nfor (let i = 0; i < 3; i++) { tick(); }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - loops single statement" {
  let source = parse_source(
    (
      #|while (ok) ;
      #|do foo(); while (bar);
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: WhileStmt({expression: {kind: Identifier({text: "ok", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:10(7-9)}), span: 1:8-1:10(7-9)}, statement: {kind: EmptyStmt, span: 1:12-2:1(11-13)}}), span: 1:1-2:1(0-13)}, {kind: DoStmt({statement: {kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:4-2:7(16-19)}), span: 2:4-2:7(16-19)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 2:7-2:7(19-19), end: 2:9-2:9(21-21), has_trailing_comma: false, is_missing_list: false}}), span: 2:4-2:9(16-21)}), span: 2:4-2:9(16-21)}, expression: {kind: Identifier({text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:18-2:21(30-33)}), span: 2:18-2:21(30-33)}}), span: 2:1-2:21(13-33)}], start: 1:1-1:1(0-0), end: 2:23-2:23(35-35), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "while (ok) ;\ndo foo(); while (bar);", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - for in and of" {
  let source = parse_source(
    (
      #|for (;;) break;
      #|for (x in obj) foo();
      #|for (let y of arr) bar();
      #|for (const [a, b] of items) {}
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ForStmt({initializer: None, condition: None, incrementor: None, statement: {kind: BreakStmt(None), span: 1:10-2:1(9-16)}}), span: 1:1-2:1(0-16)}, {kind: ForInStmt({initializer: Expr({kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:6-2:7(21-22)}), span: 2:6-2:7(21-22)}), expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:11-2:14(26-29)}), span: 2:11-2:14(26-29)}, statement: {kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:16-2:19(31-34)}), span: 2:16-2:19(31-34)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 2:19-2:19(34-34), end: 2:21-2:21(36-36), has_trailing_comma: false, is_missing_list: false}}), span: 2:16-2:21(31-36)}), span: 2:16-2:21(31-36)}}), span: 2:1-2:21(16-36)}, {kind: ForOfStmt({initializer: VariableDeclList({elements: [{kind: Let, name: Identifier({text: "y", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:10-3:11(47-48)}), type_node: None, initializer: None}], start: 3:1-3:1(38-38), end: 3:12-3:12(49-49), has_trailing_comma: false, is_missing_list: false}), expression: {kind: Identifier({text: "arr", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:15-3:18(52-55)}), span: 3:15-3:18(52-55)}, statement: {kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:20-3:23(57-60)}), span: 3:20-3:23(57-60)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 3:23-3:23(60-60), end: 3:25-3:25(62-62), has_trailing_comma: false, is_missing_list: false}}), span: 3:20-3:25(57-62)}), span: 3:20-3:25(57-62)}, is_await: false}), span: 3:1-3:25(38-62)}, {kind: ForOfStmt({initializer: VariableDeclList({elements: [{kind: Const, name: ArrayBindingPattern({elements: [BindingElement({property_name: None, is_rest: false, name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:13-4:14(76-77)}), initializer: None}), BindingElement({property_name: None, is_rest: false, name: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:16-4:17(79-80)}), initializer: None})], start: 4:12-4:12(75-75), end: 4:18-4:18(81-81), has_trailing_comma: false, is_missing_list: false}), type_node: None, initializer: None}], start: 4:1-4:1(64-64), end: 4:19-4:19(82-82), has_trailing_comma: false, is_missing_list: false}), expression: {kind: Identifier({text: "items", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:22-4:27(85-90)}), span: 4:22-4:27(85-90)}, statement: {kind: Block([]), span: 4:29-4:31(92-94)}, is_await: false}), span: 4:1-4:31(64-94)}], start: 1:1-1:1(0-0), end: 4:31-4:31(94-94), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "for (;;) break;\nfor (x in obj) foo();\nfor (let y of arr) bar();\nfor (const [a, b] of items) {}", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - for await of" {
  let source = parse_source(
    (
      #|import "mod";
      #|for await (const item of stream) { use(item); }
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ImportDecl({import_clause: None, module_specifier: {kind: StringLiteral({text: "mod", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:8-1:13(7-12)}), span: 1:8-1:13(7-12)}, attributes: None, phase: Normal}), span: 1:1-1:13(0-12)}, {kind: ForOfStmt({initializer: VariableDeclList({elements: [{kind: Const, name: Identifier({text: "item", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:18-2:22(31-35)}), type_node: None, initializer: None}], start: 2:1-2:1(14-14), end: 2:23-2:23(36-36), has_trailing_comma: false, is_missing_list: false}), expression: {kind: Identifier({text: "stream", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:26-2:32(39-45)}), span: 2:26-2:32(39-45)}, statement: {kind: Block([{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "use", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:36-2:39(49-52)}), span: 2:36-2:39(49-52)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [{kind: Identifier({text: "item", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:40-2:44(53-57)}), span: 2:40-2:44(53-57)}], start: 2:39-2:39(52-52), end: 2:45-2:45(58-58), has_trailing_comma: false, is_missing_list: false}}), span: 2:36-2:45(49-58)}), span: 2:36-2:45(49-58)}]), span: 2:34-2:48(47-61)}, is_await: true}), span: 2:1-2:48(14-61)}], start: 1:1-1:1(0-0), end: 2:48-2:48(61-61), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "import \"mod\";\nfor await (const item of stream) { use(item); }", script_kind: TS, is_module: true}
    ),
  )
}

///|
test "stmt - switch" {
  let source = parse_source(
    (
      #|switch (x) {
      #|  case 1: foo(); break;
      #|  case 2: { bar(); }
      #|  default: baz();
      #|}
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: SwitchStmt({expression: {kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:10(8-9)}), span: 1:9-1:10(8-9)}, case_block: {clauses: {elements: [CaseClause({expression: {kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:8-2:9(20-21)}), span: 2:8-2:9(20-21)}, stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:11-2:14(23-26)}), span: 2:11-2:14(23-26)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 2:14-2:14(26-26), end: 2:16-2:16(28-28), has_trailing_comma: false, is_missing_list: false}}), span: 2:11-2:16(23-28)}), span: 2:11-2:16(23-28)}, {kind: BreakStmt(None), span: 2:18-3:3(30-39)}], start: 2:8-2:8(20-20), end: 3:3-3:3(39-39), has_trailing_comma: false, is_missing_list: false}}), CaseClause({expression: {kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 3:8-3:9(44-45)}), span: 3:8-3:9(44-45)}, stmts: {elements: [{kind: Block([{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:13-3:16(49-52)}), span: 3:13-3:16(49-52)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 3:16-3:16(52-52), end: 3:18-3:18(54-54), has_trailing_comma: false, is_missing_list: false}}), span: 3:13-3:18(49-54)}), span: 3:13-3:18(49-54)}]), span: 3:11-3:21(47-57)}], start: 3:8-3:8(44-44), end: 4:3-4:3(60-60), has_trailing_comma: false, is_missing_list: false}}), DefaultClause({elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 4:12-4:15(69-72)}), span: 4:12-4:15(69-72)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 4:15-4:15(72-72), end: 4:17-4:17(74-74), has_trailing_comma: false, is_missing_list: false}}), span: 4:12-4:17(69-74)}), span: 4:12-4:17(69-74)}], start: 1:1-1:1(0-0), end: 5:1-5:1(76-76), has_trailing_comma: false, is_missing_list: false})], start: 1:1-1:1(0-0), end: 5:2-5:2(77-77), has_trailing_comma: false, is_missing_list: false}}}), span: 1:1-5:2(0-77)}], start: 1:1-1:1(0-0), end: 5:2-5:2(77-77), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "switch (x) {\n  case 1: foo(); break;\n  case 2: { bar(); }\n  default: baz();\n}", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - try catch finally" {
  let source = parse_source(
    "try { foo(); } catch (e) { bar(); } finally { baz(); }",
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TryStmt({try_block: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:10(6-9)}), span: 1:7-1:10(6-9)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:10-1:10(9-9), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}}), span: 1:7-1:12(6-11)}), span: 1:7-1:12(6-11)}], catch_clause: Some({variable_declaration: Some({kind: Let, name: Identifier({text: "e", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:23-1:24(22-23)}), type_node: None, initializer: None}), block: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:28-1:31(27-30)}), span: 1:28-1:31(27-30)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:31-1:31(30-30), end: 1:33-1:33(32-32), has_trailing_comma: false, is_missing_list: false}}), span: 1:28-1:33(27-32)}), span: 1:28-1:33(27-32)}]}), finally_block: Some([{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "baz", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:47-1:50(46-49)}), span: 1:47-1:50(46-49)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:50-1:50(49-49), end: 1:52-1:52(51-51), has_trailing_comma: false, is_missing_list: false}}), span: 1:47-1:52(46-51)}), span: 1:47-1:52(46-51)}])}), span: 1:1-1:55(0-54)}], start: 1:1-1:1(0-0), end: 1:55-1:55(54-54), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "try { foo(); } catch (e) { bar(); } finally { baz(); }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - try catch without binding" {
  let source = parse_source("try { foo(); } catch { bar(); }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TryStmt({try_block: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:10(6-9)}), span: 1:7-1:10(6-9)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:10-1:10(9-9), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}}), span: 1:7-1:12(6-11)}), span: 1:7-1:12(6-11)}], catch_clause: Some({variable_declaration: None, block: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:24-1:27(23-26)}), span: 1:24-1:27(23-26)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:27-1:27(26-26), end: 1:29-1:29(28-28), has_trailing_comma: false, is_missing_list: false}}), span: 1:24-1:29(23-28)}), span: 1:24-1:29(23-28)}]}), finally_block: None}), span: 1:1-1:32(0-31)}], start: 1:1-1:1(0-0), end: 1:32-1:32(31-31), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "try { foo(); } catch { bar(); }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - return and throw" {
  let source = parse_source("return; return x; throw err")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ReturnStmt(None), span: 1:1-1:9(0-8)}, {kind: ReturnStmt(Some({kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:16-1:17(15-16)}), span: 1:16-1:17(15-16)})), span: 1:9-1:17(8-16)}, {kind: ThrowStmt({kind: Identifier({text: "err", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:25-1:28(24-27)}), span: 1:25-1:28(24-27)}), span: 1:19-1:28(18-27)}], start: 1:1-1:1(0-0), end: 1:28-1:28(27-27), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "return; return x; throw err", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - labeled break continue" {
  let source = parse_source(
    "outer: for (;;) { if (a) break outer; continue outer }",
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: LabeledStmt({label: {text: "outer", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:6(0-5)}, statement: {kind: ForStmt({initializer: None, condition: None, incrementor: None, statement: {kind: Block([{kind: IfStmt({expression: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:23-1:24(22-23)}), span: 1:23-1:24(22-23)}, then_statement: {kind: BreakStmt(Some({text: "outer", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:32-1:37(31-36)})), span: 1:26-1:39(25-38)}, else_statement: None}), span: 1:19-1:39(18-38)}, {kind: ContinueStmt(Some({text: "outer", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:48-1:53(47-52)})), span: 1:39-1:54(38-53)}]), span: 1:17-1:55(16-54)}}), span: 1:8-1:55(7-54)}}), span: 1:1-1:55(0-54)}], start: 1:1-1:1(0-0), end: 1:55-1:55(54-54), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "outer: for (;;) { if (a) break outer; continue outer }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - with and debugger" {
  let source = parse_source("with (obj) foo(); debugger;")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: WithStmt({expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:10(6-9)}), span: 1:7-1:10(6-9)}, statement: {kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:15(11-14)}), span: 1:12-1:15(11-14)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:15-1:15(14-14), end: 1:17-1:17(16-16), has_trailing_comma: false, is_missing_list: false}}), span: 1:12-1:17(11-16)}), span: 1:12-1:17(11-16)}}), span: 1:1-1:17(0-16)}, {kind: DebuggerStmt, span: 1:19-1:28(18-27)}], start: 1:1-1:1(0-0), end: 1:28-1:28(27-27), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "with (obj) foo(); debugger;", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - for in decls" {
  let source = parse_source(
    (
      #|for (let k in obj) { use(k); }
      #|for (var v in other) ;
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ForInStmt({initializer: VariableDeclList({elements: [{kind: Let, name: Identifier({text: "k", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), type_node: None, initializer: None}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}), expression: {kind: Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:18(14-17)}), span: 1:15-1:18(14-17)}, statement: {kind: Block([{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "use", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:22-1:25(21-24)}), span: 1:22-1:25(21-24)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [{kind: Identifier({text: "k", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:26-1:27(25-26)}), span: 1:26-1:27(25-26)}], start: 1:25-1:25(24-24), end: 1:28-1:28(27-27), has_trailing_comma: false, is_missing_list: false}}), span: 1:22-1:28(21-27)}), span: 1:22-1:28(21-27)}]), span: 1:20-1:31(19-30)}}), span: 1:1-1:31(0-30)}, {kind: ForInStmt({initializer: VariableDeclList({elements: [{kind: Var, name: Identifier({text: "v", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:10-2:11(40-41)}), type_node: None, initializer: None}], start: 2:1-2:1(31-31), end: 2:12-2:12(42-42), has_trailing_comma: false, is_missing_list: false}), expression: {kind: Identifier({text: "other", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:15-2:20(45-50)}), span: 2:15-2:20(45-50)}, statement: {kind: EmptyStmt, span: 2:22-2:23(52-53)}}), span: 2:1-2:23(31-53)}], start: 1:1-1:1(0-0), end: 2:23-2:23(53-53), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "for (let k in obj) { use(k); }\nfor (var v in other) ;", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - switch fallthrough" {
  let source = parse_source(
    (
      #|switch (x) {
      #|  case 1:
      #|  case 2: foo(); break;
      #|}
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: SwitchStmt({expression: {kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:10(8-9)}), span: 1:9-1:10(8-9)}, case_block: {clauses: {elements: [CaseClause({expression: {kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:8-2:9(20-21)}), span: 2:8-2:9(20-21)}, stmts: {elements: [], start: 2:8-2:8(20-20), end: 3:3-3:3(25-25), has_trailing_comma: false, is_missing_list: false}}), CaseClause({expression: {kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 3:8-3:9(30-31)}), span: 3:8-3:9(30-31)}, stmts: {elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:11-3:14(33-36)}), span: 3:11-3:14(33-36)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 3:14-3:14(36-36), end: 3:16-3:16(38-38), has_trailing_comma: false, is_missing_list: false}}), span: 3:11-3:16(33-38)}), span: 3:11-3:16(33-38)}, {kind: BreakStmt(None), span: 3:18-4:1(40-47)}], start: 3:8-3:8(30-30), end: 4:1-4:1(47-47), has_trailing_comma: false, is_missing_list: false}})], start: 1:1-1:1(0-0), end: 4:2-4:2(48-48), has_trailing_comma: false, is_missing_list: false}}}), span: 1:1-4:2(0-48)}], start: 1:1-1:1(0-0), end: 4:2-4:2(48-48), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "switch (x) {\n  case 1:\n  case 2: foo(); break;\n}", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - try finally" {
  let source = parse_source("try { foo(); } finally { bar(); }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TryStmt({try_block: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:10(6-9)}), span: 1:7-1:10(6-9)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:10-1:10(9-9), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}}), span: 1:7-1:12(6-11)}), span: 1:7-1:12(6-11)}], catch_clause: None, finally_block: Some([{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:26-1:29(25-28)}), span: 1:26-1:29(25-28)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:29-1:29(28-28), end: 1:31-1:31(30-30), has_trailing_comma: false, is_missing_list: false}}), span: 1:26-1:31(25-30)}), span: 1:26-1:31(25-30)}])}), span: 1:1-1:34(0-33)}], start: 1:1-1:1(0-0), end: 1:34-1:34(33-33), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "try { foo(); } finally { bar(); }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - continue in loop" {
  let source = parse_source("while (ok) { continue; }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: WhileStmt({expression: {kind: Identifier({text: "ok", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:8-1:10(7-9)}), span: 1:8-1:10(7-9)}, statement: {kind: Block([{kind: ContinueStmt(None), span: 1:14-1:24(13-23)}]), span: 1:12-1:25(11-24)}}), span: 1:1-1:25(0-24)}], start: 1:1-1:1(0-0), end: 1:25-1:25(24-24), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "while (ok) { continue; }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - labeled block" {
  let source = parse_source("label: { foo(); }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: LabeledStmt({label: {text: "label", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:6(0-5)}, statement: {kind: Block([{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:13(9-12)}), span: 1:10-1:13(9-12)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:13-1:13(12-12), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}}), span: 1:10-1:15(9-14)}), span: 1:10-1:15(9-14)}]), span: 1:8-1:18(7-17)}}), span: 1:1-1:18(0-17)}], start: 1:1-1:1(0-0), end: 1:18-1:18(17-17), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "label: { foo(); }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - for with missing clauses" {
  let source = parse_source(
    (
      #|for (i = 0;;) { tick(); }
      #|for (; i < 10;) { i++; }
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ForStmt({initializer: Some(Expr({kind: BinaryExpr({left: {kind: Identifier({text: "i", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}, operator: Equals, right: {kind: NumericLiteral({text: "0", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:10-1:11(9-10)}), span: 1:10-1:11(9-10)}}), span: 1:6-1:11(5-10)})), condition: None, incrementor: None, statement: {kind: Block([{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "tick", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:17-1:21(16-20)}), span: 1:17-1:21(16-20)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:21-1:21(20-20), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}}), span: 1:17-1:23(16-22)}), span: 1:17-1:23(16-22)}]), span: 1:15-1:26(14-25)}}), span: 1:1-1:26(0-25)}, {kind: ForStmt({initializer: None, condition: Some({kind: BinaryExpr({left: {kind: Identifier({text: "i", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:8-2:9(33-34)}), span: 2:8-2:9(33-34)}, operator: LessThan, right: {kind: NumericLiteral({text: "10", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:12-2:14(37-39)}), span: 2:12-2:14(37-39)}}), span: 2:8-2:14(33-39)}), incrementor: None, statement: {kind: Block([{kind: ExprStmt({kind: PostfixUnaryExpr({operand: {kind: Identifier({text: "i", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:19-2:20(44-45)}), span: 2:19-2:20(44-45)}, operator: PlusPlus}), span: 2:19-2:22(44-47)}), span: 2:19-2:22(44-47)}]), span: 2:17-2:25(42-50)}}), span: 2:1-2:25(26-50)}], start: 1:1-1:1(0-0), end: 2:25-2:25(50-50), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "for (i = 0;;) { tick(); }\nfor (; i < 10;) { i++; }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "stmt - switch default only" {
  let source = parse_source("switch (kind) { default: noop(); }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: SwitchStmt({expression: {kind: Identifier({text: "kind", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:13(8-12)}), span: 1:9-1:13(8-12)}, case_block: {clauses: {elements: [DefaultClause({elements: [{kind: ExprStmt({kind: CallExpr({expression: {kind: Identifier({text: "noop", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:26-1:30(25-29)}), span: 1:26-1:30(25-29)}, is_null_coalescing: false, type_arguments: None, arguments: {elements: [], start: 1:30-1:30(29-29), end: 1:32-1:32(31-31), has_trailing_comma: false, is_missing_list: false}}), span: 1:26-1:32(25-31)}), span: 1:26-1:32(25-31)}], start: 1:1-1:1(0-0), end: 1:34-1:34(33-33), has_trailing_comma: false, is_missing_list: false})], start: 1:1-1:1(0-0), end: 1:35-1:35(34-34), has_trailing_comma: false, is_missing_list: false}}}), span: 1:1-1:35(0-34)}], start: 1:1-1:1(0-0), end: 1:35-1:35(34-34), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "switch (kind) { default: noop(); }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - typeof" {
  let source = parse_source("type T = typeof obj")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: TypeQuery({expr_name: EntityName(Identifier({text: "obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:17-1:20(16-19)})), type_arguments: None}), span: 1:10-1:20(9-19)}}), span: 1:1-1:20(0-19)}], start: 1:1-1:1(0-0), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = typeof obj", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - typeof qualified" {
  let source = parse_source("type T = typeof A.B.C")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: TypeQuery({expr_name: EntityName(QualifiedName({left: QualifiedName({left: Identifier({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:17-1:18(16-17)}), right: {text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:19-1:20(18-19)}}), right: {text: "C", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:21-1:22(20-21)}})), type_arguments: None}), span: 1:10-1:22(9-21)}}), span: 1:1-1:22(0-21)}], start: 1:1-1:1(0-0), end: 1:22-1:22(21-21), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = typeof A.B.C", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - keyof" {
  let source = parse_source("type K = keyof T")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "K", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: TypeOperator({operator: KeyOf, type_node: {kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:16-1:17(15-16)}), type_arguments: None}), span: 1:16-1:17(15-16)}}), span: 1:10-1:17(9-16)}}), span: 1:1-1:17(0-16)}], start: 1:1-1:1(0-0), end: 1:17-1:17(16-16), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type K = keyof T", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - readonly array" {
  let source = parse_source("type T = readonly string[]")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: TypeOperator({operator: Readonly, type_node: {kind: ArrayType({kind: KeywordType(String), span: 1:19-1:25(18-24)}), span: 1:19-1:27(18-26)}}), span: 1:10-1:27(9-26)}}), span: 1:1-1:27(0-26)}], start: 1:1-1:1(0-0), end: 1:27-1:27(26-26), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = readonly string[]", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - unique symbol" {
  let source = parse_source("type T = unique symbol")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: TypeOperator({operator: Unique, type_node: {kind: KeywordType(Symbol), span: 1:17-1:23(16-22)}}), span: 1:10-1:23(9-22)}}), span: 1:1-1:23(0-22)}], start: 1:1-1:1(0-0), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = unique symbol", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - this type" {
  let source = parse_source("type T = this")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: ThisType, span: 1:10-1:14(9-13)}}), span: 1:1-1:14(0-13)}], start: 1:1-1:1(0-0), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = this", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - literal types" {
  let source = parse_source("type T = true | false | 42 | \"hello\"")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: UnionType({elements: [{kind: LiteralType({kind: TrueLiteral, span: 1:10-1:14(9-13)}), span: 1:10-1:14(9-13)}, {kind: LiteralType({kind: FalseLiteral, span: 1:17-1:22(16-21)}), span: 1:17-1:22(16-21)}, {kind: LiteralType({kind: NumericLiteral({text: "42", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:25-1:27(24-26)}), span: 1:25-1:27(24-26)}), span: 1:25-1:27(24-26)}, {kind: LiteralType({kind: StringLiteral({text: "hello", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:30-1:37(29-36)}), span: 1:30-1:37(29-36)}), span: 1:30-1:37(29-36)}], start: 1:10-1:10(9-9), end: 1:37-1:37(36-36), has_trailing_comma: false, is_missing_list: false}), span: 1:10-1:37(9-36)}}), span: 1:1-1:37(0-36)}], start: 1:1-1:1(0-0), end: 1:37-1:37(36-36), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = true | false | 42 | \"hello\"", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - negative number literal" {
  let source = parse_source("type T = -1")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: LiteralType({kind: PrefixUnaryExpr({operator: Minus, operand: {kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:11-1:12(10-11)}), span: 1:11-1:12(10-11)}}), span: 1:10-1:12(9-11)}), span: 1:10-1:12(9-11)}}), span: 1:1-1:12(0-11)}], start: 1:1-1:1(0-0), end: 1:12-1:12(11-11), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = -1", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - conditional type" {
  let source = parse_source("type T = A extends B ? C : D")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: ConditionalType({check_type: {kind: TypeReference({type_name: Identifier({text: "A", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), type_arguments: None}), span: 1:10-1:11(9-10)}, extends_type: {kind: TypeReference({type_name: Identifier({text: "B", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:20-1:21(19-20)}), type_arguments: None}), span: 1:20-1:21(19-20)}, true_type: {kind: TypeReference({type_name: Identifier({text: "C", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:24-1:25(23-24)}), type_arguments: None}), span: 1:24-1:25(23-24)}, false_type: {kind: TypeReference({type_name: Identifier({text: "D", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:28-1:29(27-28)}), type_arguments: None}), span: 1:28-1:29(27-28)}}), span: 1:10-1:29(9-28)}}), span: 1:1-1:29(0-28)}], start: 1:1-1:1(0-0), end: 1:29-1:29(28-28), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = A extends B ? C : D", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - indexed access type" {
  let source = parse_source("type T = Obj[\"key\"]")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: IndexedAccessType({object_type: {kind: TypeReference({type_name: Identifier({text: "Obj", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:13(9-12)}), type_arguments: None}), span: 1:10-1:13(9-12)}, index_type: {kind: LiteralType({kind: StringLiteral({text: "key", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:14-1:19(13-18)}), span: 1:14-1:19(13-18)}), span: 1:14-1:19(13-18)}}), span: 1:10-1:20(9-19)}}), span: 1:1-1:20(0-19)}], start: 1:1-1:1(0-0), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = Obj[\"key\"]", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - indexed access with keyof" {
  let source = parse_source("type V = T[keyof T]")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "V", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: IndexedAccessType({object_type: {kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), type_arguments: None}), span: 1:10-1:11(9-10)}, index_type: {kind: TypeOperator({operator: KeyOf, type_node: {kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:19(17-18)}), type_arguments: None}), span: 1:18-1:19(17-18)}}), span: 1:12-1:19(11-18)}}), span: 1:10-1:20(9-19)}}), span: 1:1-1:20(0-19)}], start: 1:1-1:1(0-0), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type V = T[keyof T]", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - mapped type" {
  let source = parse_source("type T = { [K in keyof U]: string }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: MappedType({is_readonly: false, type_parameter: {modifiers: {variance: None, is_const: false}, name: {text: "K", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:14(12-13)}, constraint: Some({kind: TypeOperator({operator: KeyOf, type_node: {kind: TypeReference({type_name: Identifier({text: "U", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:24-1:25(23-24)}), type_arguments: None}), span: 1:24-1:25(23-24)}}), span: 1:18-1:25(17-24)}), default_type: None}, name_type: None, is_optional: false, type_node: Some({kind: KeywordType(String), span: 1:28-1:34(27-33)})}), span: 1:10-1:36(9-35)}}), span: 1:1-1:36(0-35)}], start: 1:1-1:1(0-0), end: 1:36-1:36(35-35), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = { [K in keyof U]: string }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - mapped type optional" {
  let source = parse_source("type T = { [K in keyof U]?: number }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: MappedType({is_readonly: false, type_parameter: {modifiers: {variance: None, is_const: false}, name: {text: "K", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:14(12-13)}, constraint: Some({kind: TypeOperator({operator: KeyOf, type_node: {kind: TypeReference({type_name: Identifier({text: "U", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:24-1:25(23-24)}), type_arguments: None}), span: 1:24-1:25(23-24)}}), span: 1:18-1:25(17-24)}), default_type: None}, name_type: None, is_optional: true, type_node: Some({kind: KeywordType(Number), span: 1:29-1:35(28-34)})}), span: 1:10-1:37(9-36)}}), span: 1:1-1:37(0-36)}], start: 1:1-1:1(0-0), end: 1:37-1:37(36-36), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = { [K in keyof U]?: number }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - mapped type readonly" {
  let source = parse_source("type T = { readonly [K in keyof U]: boolean }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: MappedType({is_readonly: true, type_parameter: {modifiers: {variance: None, is_const: false}, name: {text: "K", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:22-1:23(21-22)}, constraint: Some({kind: TypeOperator({operator: KeyOf, type_node: {kind: TypeReference({type_name: Identifier({text: "U", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:33-1:34(32-33)}), type_arguments: None}), span: 1:33-1:34(32-33)}}), span: 1:27-1:34(26-33)}), default_type: None}, name_type: None, is_optional: false, type_node: Some({kind: KeywordType(Boolean), span: 1:37-1:44(36-43)})}), span: 1:10-1:46(9-45)}}), span: 1:1-1:46(0-45)}], start: 1:1-1:1(0-0), end: 1:46-1:46(45-45), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = { readonly [K in keyof U]: boolean }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - infer type" {
  let source = parse_source("type T = U extends Array<infer V> ? V : never")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: ConditionalType({check_type: {kind: TypeReference({type_name: Identifier({text: "U", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), type_arguments: None}), span: 1:10-1:11(9-10)}, extends_type: {kind: TypeReference({type_name: Identifier({text: "Array", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:20-1:25(19-24)}), type_arguments: Some({elements: [{kind: InferType({modifiers: {variance: None, is_const: false}, name: {text: "V", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:32-1:33(31-32)}, constraint: None, default_type: None}), span: 1:26-1:33(25-32)}], start: 1:25-1:25(24-24), end: 1:34-1:34(33-33), has_trailing_comma: false, is_missing_list: false})}), span: 1:20-1:34(19-33)}, true_type: {kind: TypeReference({type_name: Identifier({text: "V", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:37-1:38(36-37)}), type_arguments: None}), span: 1:37-1:38(36-37)}, false_type: {kind: KeywordType(Never), span: 1:41-1:46(40-45)}}), span: 1:10-1:46(9-45)}}), span: 1:1-1:46(0-45)}], start: 1:1-1:1(0-0), end: 1:46-1:46(45-45), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = U extends Array<infer V> ? V : never", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - infer type with constraint" {
  let source = parse_source(
    "type T = U extends Array<infer V extends string> ? V : never",
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: ConditionalType({check_type: {kind: TypeReference({type_name: Identifier({text: "U", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), type_arguments: None}), span: 1:10-1:11(9-10)}, extends_type: {kind: TypeReference({type_name: Identifier({text: "Array", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:20-1:25(19-24)}), type_arguments: Some({elements: [{kind: InferType({modifiers: {variance: None, is_const: false}, name: {text: "V", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:32-1:33(31-32)}, constraint: Some({kind: KeywordType(String), span: 1:42-1:48(41-47)}), default_type: None}), span: 1:26-1:48(25-47)}], start: 1:25-1:25(24-24), end: 1:49-1:49(48-48), has_trailing_comma: false, is_missing_list: false})}), span: 1:20-1:49(19-48)}, true_type: {kind: TypeReference({type_name: Identifier({text: "V", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:52-1:53(51-52)}), type_arguments: None}), span: 1:52-1:53(51-52)}, false_type: {kind: KeywordType(Never), span: 1:56-1:61(55-60)}}), span: 1:10-1:61(9-60)}}), span: 1:1-1:61(0-60)}], start: 1:1-1:1(0-0), end: 1:61-1:61(60-60), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = U extends Array<infer V extends string> ? V : never", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - infer type with generic constraint" {
  let source = parse_source(
    "type T = U extends (arg: infer P extends Array<number>) => any ? P : never",
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: ConditionalType({check_type: {kind: TypeReference({type_name: Identifier({text: "U", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), type_arguments: None}), span: 1:10-1:11(9-10)}, extends_type: {kind: FunctionType({type_parameters: None, parameters: {elements: [{modifiers: {accessibility: None, is_readonly: false}, is_rest: false, name: Identifier({text: "arg", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:21-1:24(20-23)}), is_optional: false, type_node: Some({kind: InferType({modifiers: {variance: None, is_const: false}, name: {text: "P", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:32-1:33(31-32)}, constraint: Some({kind: TypeReference({type_name: Identifier({text: "Array", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:42-1:47(41-46)}), type_arguments: Some({elements: [{kind: KeywordType(Number), span: 1:48-1:54(47-53)}], start: 1:47-1:47(46-46), end: 1:55-1:55(54-54), has_trailing_comma: false, is_missing_list: false})}), span: 1:42-1:55(41-54)}), default_type: None}), span: 1:26-1:55(25-54)}), initializer: None, span: 1:21-1:55(20-54)}], start: 1:20-1:20(19-19), end: 1:56-1:56(55-55), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(Any), span: 1:60-1:63(59-62)})}), span: 1:20-1:63(19-62)}, true_type: {kind: TypeReference({type_name: Identifier({text: "P", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:66-1:67(65-66)}), type_arguments: None}), span: 1:66-1:67(65-66)}, false_type: {kind: KeywordType(Never), span: 1:70-1:75(69-74)}}), span: 1:10-1:75(9-74)}}), span: 1:1-1:75(0-74)}], start: 1:1-1:1(0-0), end: 1:75-1:75(74-74), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = U extends (arg: infer P extends Array<number>) => any ? P : never", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - multiple infer types in conditional" {
  let source = parse_source(
    "type T = U extends Map<infer K, infer V> ? [K, V] : never",
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: ConditionalType({check_type: {kind: TypeReference({type_name: Identifier({text: "U", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), type_arguments: None}), span: 1:10-1:11(9-10)}, extends_type: {kind: TypeReference({type_name: Identifier({text: "Map", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:20-1:23(19-22)}), type_arguments: Some({elements: [{kind: InferType({modifiers: {variance: None, is_const: false}, name: {text: "K", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:30-1:31(29-30)}, constraint: None, default_type: None}), span: 1:24-1:31(23-30)}, {kind: InferType({modifiers: {variance: None, is_const: false}, name: {text: "V", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:39-1:40(38-39)}, constraint: None, default_type: None}), span: 1:33-1:40(32-39)}], start: 1:23-1:23(22-22), end: 1:41-1:41(40-40), has_trailing_comma: false, is_missing_list: false})}), span: 1:20-1:41(19-40)}, true_type: {kind: TupleType({elements: [{label: None, is_optional: false, is_rest: false, type_node: {kind: TypeReference({type_name: Identifier({text: "K", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:45-1:46(44-45)}), type_arguments: None}), span: 1:45-1:46(44-45)}, span: 1:45-1:46(44-45)}, {label: None, is_optional: false, is_rest: false, type_node: {kind: TypeReference({type_name: Identifier({text: "V", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:48-1:49(47-48)}), type_arguments: None}), span: 1:48-1:49(47-48)}, span: 1:48-1:49(47-48)}], start: 1:44-1:44(43-43), end: 1:50-1:50(49-49), has_trailing_comma: false, is_missing_list: false}), span: 1:44-1:50(43-49)}, false_type: {kind: KeywordType(Never), span: 1:53-1:58(52-57)}}), span: 1:10-1:58(9-57)}}), span: 1:1-1:58(0-57)}], start: 1:1-1:1(0-0), end: 1:58-1:58(57-57), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = U extends Map<infer K, infer V> ? [K, V] : never", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - nested conditional with infer" {
  let source = parse_source(
    "type T = U extends Array<infer V extends Array<infer W>> ? W : never",
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: ConditionalType({check_type: {kind: TypeReference({type_name: Identifier({text: "U", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), type_arguments: None}), span: 1:10-1:11(9-10)}, extends_type: {kind: TypeReference({type_name: Identifier({text: "Array", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:20-1:25(19-24)}), type_arguments: Some({elements: [{kind: InferType({modifiers: {variance: None, is_const: false}, name: {text: "V", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:32-1:33(31-32)}, constraint: Some({kind: TypeReference({type_name: Identifier({text: "Array", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:42-1:47(41-46)}), type_arguments: Some({elements: [{kind: InferType({modifiers: {variance: None, is_const: false}, name: {text: "W", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:54-1:55(53-54)}, constraint: None, default_type: None}), span: 1:48-1:55(47-54)}], start: 1:47-1:47(46-46), end: 1:56-1:56(55-55), has_trailing_comma: false, is_missing_list: false})}), span: 1:42-1:56(41-55)}), default_type: None}), span: 1:26-1:56(25-55)}], start: 1:25-1:25(24-24), end: 1:57-1:57(56-56), has_trailing_comma: false, is_missing_list: false})}), span: 1:20-1:57(19-56)}, true_type: {kind: TypeReference({type_name: Identifier({text: "W", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:60-1:61(59-60)}), type_arguments: None}), span: 1:60-1:61(59-60)}, false_type: {kind: KeywordType(Never), span: 1:64-1:69(63-68)}}), span: 1:10-1:69(9-68)}}), span: 1:1-1:69(0-68)}], start: 1:1-1:1(0-0), end: 1:69-1:69(68-68), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = U extends Array<infer V extends Array<infer W>> ? W : never", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - error: infer outside conditional type" {
  let source = try? parse_source("type T = infer U")
  inspect(
    source,
    content="Err(Parse error at 1:10-1:16(9-15): 'infer' types can only be used in conditional type extends clauses)",
  )
}

///|
test "type - error: infer in check type position" {
  let source = try? parse_source("type T = infer U extends string ? U : never")
  inspect(
    source,
    content="Err(Parse error at 1:10-1:16(9-15): 'infer' types can only be used in conditional type extends clauses)",
  )
}

///|
test "type - error: infer in type alias directly" {
  let source = try? parse_source("type T<U> = infer U")
  inspect(
    source,
    content="Err(Parse error at 1:13-1:19(12-18): 'infer' types can only be used in conditional type extends clauses)",
  )
}

///|
test "type - import type" {
  let source = parse_source("type T = import(\"./module\").MyType")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: ImportType({argument: {kind: StringLiteral({text: "./module", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:17-1:27(16-26)}), span: 1:17-1:27(16-26)}, qualifier: Some(Identifier({text: "MyType", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:29-1:35(28-34)})), type_arguments: None}), span: 1:10-1:35(9-34)}}), span: 1:1-1:35(0-34)}], start: 1:1-1:1(0-0), end: 1:35-1:35(34-34), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = import(\"./module\").MyType", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - rest type in tuple" {
  let source = parse_source("type T = [string, ...number[]]")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: TupleType({elements: [{label: None, is_optional: false, is_rest: false, type_node: {kind: KeywordType(String), span: 1:11-1:17(10-16)}, span: 1:11-1:17(10-16)}, {label: None, is_optional: false, is_rest: true, type_node: {kind: ArrayType({kind: KeywordType(Number), span: 1:22-1:28(21-27)}), span: 1:22-1:30(21-29)}, span: 1:19-1:30(18-29)}], start: 1:10-1:10(9-9), end: 1:31-1:31(30-30), has_trailing_comma: false, is_missing_list: false}), span: 1:10-1:31(9-30)}}), span: 1:1-1:31(0-30)}], start: 1:1-1:1(0-0), end: 1:31-1:31(30-30), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = [string, ...number[]]", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - nested keyof conditional" {
  let source = parse_source("type T = keyof U extends string ? true : false")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: ConditionalType({check_type: {kind: TypeOperator({operator: KeyOf, type_node: {kind: TypeReference({type_name: Identifier({text: "U", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:16-1:17(15-16)}), type_arguments: None}), span: 1:16-1:17(15-16)}}), span: 1:10-1:17(9-16)}, extends_type: {kind: KeywordType(String), span: 1:26-1:32(25-31)}, true_type: {kind: LiteralType({kind: TrueLiteral, span: 1:35-1:39(34-38)}), span: 1:35-1:39(34-38)}, false_type: {kind: LiteralType({kind: FalseLiteral, span: 1:42-1:47(41-46)}), span: 1:42-1:47(41-46)}}), span: 1:10-1:47(9-46)}}), span: 1:1-1:47(0-46)}], start: 1:1-1:1(0-0), end: 1:47-1:47(46-46), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = keyof U extends string ? true : false", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - mapped type with as clause" {
  let source = parse_source("type T = { [K in keyof U as NewKey]: string }")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: MappedType({is_readonly: false, type_parameter: {modifiers: {variance: None, is_const: false}, name: {text: "K", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:14(12-13)}, constraint: Some({kind: TypeOperator({operator: KeyOf, type_node: {kind: TypeReference({type_name: Identifier({text: "U", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:24-1:25(23-24)}), type_arguments: None}), span: 1:24-1:25(23-24)}}), span: 1:18-1:25(17-24)}), default_type: None}, name_type: Some({kind: TypeReference({type_name: Identifier({text: "NewKey", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:29-1:35(28-34)}), type_arguments: None}), span: 1:29-1:35(28-34)}), is_optional: false, type_node: Some({kind: KeywordType(String), span: 1:38-1:44(37-43)})}), span: 1:10-1:46(9-45)}}), span: 1:1-1:46(0-45)}], start: 1:1-1:1(0-0), end: 1:46-1:46(45-45), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = { [K in keyof U as NewKey]: string }", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - template literal type" {
  let source = parse_source("type T = `hello ${string}`")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: TemplateLiteralType({head: {text: "hello ", raw_text: "hello ", is_unterminated: false, has_extended_unicode_escape: false}, template_spans: {elements: [{type_node: {kind: KeywordType(String), span: 1:19-1:25(18-24)}, literal: TemplateTail({text: "", raw_text: "", is_unterminated: false, has_extended_unicode_escape: false})}], start: 1:10-1:10(9-9), end: 1:27-1:27(26-26), has_trailing_comma: false, is_missing_list: false}}), span: 1:10-1:27(9-26)}}), span: 1:1-1:27(0-26)}], start: 1:1-1:1(0-0), end: 1:27-1:27(26-26), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = `hello ${string}`", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - template literal type missing span" {
  let error = try? parse_source("type T = `${Foo")
  inspect(
    error,
    content="Err(Parse error at 1:16-1:16(15-15): expected template literal type span, found end of file)",
  )
}

///|
test "type - minus literal without number" {
  let error = try? parse_source("type T = -foo")
  inspect(
    error,
    content="Err(Parse error at 1:11-1:14(10-13): expected numeric literal after '-', found identifier foo)",
  )
}

///|
test "type - template literal type multiline" {
  let source = parse_source(
    (
      #|type T = `hello
      #|  ${string} world`
    ),
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: TemplateLiteralType({head: {text: "hello\n  ", raw_text: "hello\n  ", is_unterminated: false, has_extended_unicode_escape: false}, template_spans: {elements: [{type_node: {kind: KeywordType(String), span: 2:5-2:11(20-26)}, literal: TemplateTail({text: " world", raw_text: " world", is_unterminated: false, has_extended_unicode_escape: false})}], start: 1:10-1:10(9-9), end: 2:19-2:19(34-34), has_trailing_comma: false, is_missing_list: false}}), span: 1:10-2:19(9-34)}}), span: 1:1-2:19(0-34)}], start: 1:1-1:1(0-0), end: 2:19-2:19(34-34), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = `hello\n  ${string} world`", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - template literal type with union" {
  let source = parse_source("type T = `color: ${ \"red\" | \"blue\" }`")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: TemplateLiteralType({head: {text: "color: ", raw_text: "color: ", is_unterminated: false, has_extended_unicode_escape: false}, template_spans: {elements: [{type_node: {kind: UnionType({elements: [{kind: LiteralType({kind: StringLiteral({text: "red", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:21-1:26(20-25)}), span: 1:21-1:26(20-25)}), span: 1:21-1:26(20-25)}, {kind: LiteralType({kind: StringLiteral({text: "blue", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:29-1:35(28-34)}), span: 1:29-1:35(28-34)}), span: 1:29-1:35(28-34)}], start: 1:21-1:21(20-20), end: 1:35-1:35(34-34), has_trailing_comma: false, is_missing_list: false}), span: 1:21-1:35(20-34)}, literal: TemplateTail({text: "", raw_text: "", is_unterminated: false, has_extended_unicode_escape: false})}], start: 1:10-1:10(9-9), end: 1:38-1:38(37-37), has_trailing_comma: false, is_missing_list: false}}), span: 1:10-1:38(9-37)}}), span: 1:1-1:38(0-37)}], start: 1:1-1:1(0-0), end: 1:38-1:38(37-37), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = `color: ${ \"red\" | \"blue\" }`", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - template literal type simple" {
  let source = parse_source("type T = `hello`")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: LiteralType({kind: StringLiteral({text: "hello", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:10-1:17(9-16)}), span: 1:10-1:17(9-16)}), span: 1:10-1:17(9-16)}}), span: 1:1-1:17(0-16)}], start: 1:1-1:1(0-0), end: 1:17-1:17(16-16), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = `hello`", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "type - nested template literal type" {
  let source = parse_source(
    "type T = `outer ${ `inner ${ string } loop` } end`",
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}, type_parameters: None, type_node: {kind: TemplateLiteralType({head: {text: "outer ", raw_text: "outer ", is_unterminated: false, has_extended_unicode_escape: false}, template_spans: {elements: [{type_node: {kind: TemplateLiteralType({head: {text: "inner ", raw_text: "inner ", is_unterminated: false, has_extended_unicode_escape: false}, template_spans: {elements: [{type_node: {kind: KeywordType(String), span: 1:30-1:36(29-35)}, literal: TemplateTail({text: " loop", raw_text: " loop", is_unterminated: false, has_extended_unicode_escape: false})}], start: 1:20-1:20(19-19), end: 1:44-1:44(43-43), has_trailing_comma: false, is_missing_list: false}}), span: 1:20-1:44(19-43)}, literal: TemplateTail({text: " end", raw_text: " end", is_unterminated: false, has_extended_unicode_escape: false})}], start: 1:10-1:10(9-9), end: 1:51-1:51(50-50), has_trailing_comma: false, is_missing_list: false}}), span: 1:10-1:51(9-50)}}), span: 1:1-1:51(0-50)}], start: 1:1-1:1(0-0), end: 1:51-1:51(50-50), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "type T = `outer ${ `inner ${ string } loop` } end`", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - nested template literal" {
  let source = parse_source("let x = `outer ${ `inner ${ name } loop` } end`")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: VariableStmt({doc_comment: None, modifiers: None, declaration_list: {elements: [{kind: Let, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:6(4-5)}), type_node: None, initializer: Some({kind: TemplateExpr({head: {text: "outer ", raw_text: "outer ", is_unterminated: false, has_extended_unicode_escape: false}, template_spans: {elements: [{expression: {kind: TemplateExpr({head: {text: "inner ", raw_text: "inner ", is_unterminated: false, has_extended_unicode_escape: false}, template_spans: {elements: [{expression: {kind: Identifier({text: "name", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:29-1:33(28-32)}), span: 1:29-1:33(28-32)}, literal: TemplateTail({text: " loop", raw_text: " loop", is_unterminated: false, has_extended_unicode_escape: false})}], start: 1:19-1:19(18-18), end: 1:41-1:41(40-40), has_trailing_comma: false, is_missing_list: false}}), span: 1:19-1:41(18-40)}, literal: TemplateTail({text: " end", raw_text: " end", is_unterminated: false, has_extended_unicode_escape: false})}], start: 1:9-1:9(8-8), end: 1:48-1:48(47-47), has_trailing_comma: false, is_missing_list: false}}), span: 1:9-1:48(8-47)})}], start: 1:1-1:1(0-0), end: 1:48-1:48(47-47), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:48(0-47)}], start: 1:1-1:1(0-0), end: 1:48-1:48(47-47), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "let x = `outer ${ `inner ${ name } loop` } end`", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - template span missing" {
  let error = try? parse_source("`head ${foo bar`")
  inspect(
    error,
    content="Err(Parse error at 1:16-1:17(15-16): unterminated string literal)",
  )
}

///|
test "expr - satisfies expression" {
  let source = parse_source("const a = x satisfies T")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: VariableStmt({doc_comment: None, modifiers: None, declaration_list: {elements: [{kind: Const, name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:8(6-7)}), type_node: None, initializer: Some({kind: SatisfiesExpr({expression: {kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:12(10-11)}), span: 1:11-1:12(10-11)}, type_node: {kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:23-1:24(22-23)}), type_arguments: None}), span: 1:23-1:24(22-23)}}), span: 1:11-1:24(10-23)})}], start: 1:1-1:1(0-0), end: 1:24-1:24(23-23), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:24(0-23)}], start: 1:1-1:1(0-0), end: 1:24-1:24(23-23), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "const a = x satisfies T", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - as and satisfies chained" {
  let source = parse_source("const a = x as T satisfies U as V")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: VariableStmt({doc_comment: None, modifiers: None, declaration_list: {elements: [{kind: Const, name: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:8(6-7)}), type_node: None, initializer: Some({kind: AsExpr({expression: {kind: SatisfiesExpr({expression: {kind: AsExpr({expression: {kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:12(10-11)}), span: 1:11-1:12(10-11)}, type_node: {kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:16-1:17(15-16)}), type_arguments: None}), span: 1:16-1:17(15-16)}}), span: 1:11-1:17(10-16)}, type_node: {kind: TypeReference({type_name: Identifier({text: "U", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:28-1:29(27-28)}), type_arguments: None}), span: 1:28-1:29(27-28)}}), span: 1:11-1:29(10-28)}, type_node: {kind: TypeReference({type_name: Identifier({text: "V", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:33-1:34(32-33)}), type_arguments: None}), span: 1:33-1:34(32-33)}}), span: 1:11-1:34(10-33)})}], start: 1:1-1:1(0-0), end: 1:34-1:34(33-33), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:34(0-33)}], start: 1:1-1:1(0-0), end: 1:34-1:34(33-33), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "const a = x as T satisfies U as V", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "expr - invalid binary operator" {
  let error = try? parse_source("1 <=> 2")
  inspect(
    error,
    content="Err(Parse error at 1:5-1:6(4-5): unexpected primary expression: '>')",
  )
}

///|
test "expr - invalid binary operator no in" {
  let error = try? parse_source(
    (
      #|for (const k of obj) {}
      #|let x = a <=> b
    ),
  )
  inspect(
    error,
    content="Err(Parse error at 2:13-2:14(36-37): unexpected primary expression: '>')",
  )
}

///|
test "expr - satisfies in for loop init (no_in)" {
  let source = try? parse_source("for (x = y satisfies T; ; ) {}")
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: ForStmt({initializer: Some(Expr({kind: BinaryExpr({left: {kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}, operator: Equals, right: {kind: SatisfiesExpr({expression: {kind: Identifier({text: "y", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), span: 1:10-1:11(9-10)}, type_node: {kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:22-1:23(21-22)}), type_arguments: None}), span: 1:22-1:23(21-22)}}), span: 1:10-1:23(9-22)}}), span: 1:6-1:23(5-22)})), condition: None, incrementor: None, statement: {kind: Block([]), span: 1:29-1:31(28-30)}}), span: 1:1-1:31(0-30)}], start: 1:1-1:1(0-0), end: 1:31-1:31(30-30), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "for (x = y satisfies T; ; ) {}", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "expr - yield in generator" {
  let source = try? parse_source("function* foo() { yield 1; yield* 2; }")
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, is_async: false, is_generator: true, name: Some({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:14(10-13)}), type_parameters: None, parameters: {elements: [], start: 1:14-1:14(13-13), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([{kind: ExprStmt({kind: YieldExpr({is_delegate: false, expression: Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:25-1:26(24-25)}), span: 1:25-1:26(24-25)})}), span: 1:19-1:26(18-25)}), span: 1:19-1:26(18-25)}, {kind: ExprStmt({kind: YieldExpr({is_delegate: true, expression: Some({kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:35-1:36(34-35)}), span: 1:35-1:36(34-35)})}), span: 1:28-1:36(27-35)}), span: 1:28-1:36(27-35)}])}), span: 1:1-1:39(0-38)}], start: 1:1-1:1(0-0), end: 1:39-1:39(38-38), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "function* foo() { yield 1; yield* 2; }", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - for loop with comma in init" {
  let source = try? parse_source("for (i=0, j=0; ; ) {}")
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: ForStmt({initializer: Some(Expr({kind: CommaListExpr({elements: [{kind: BinaryExpr({left: {kind: Identifier({text: "i", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}, operator: Equals, right: {kind: NumericLiteral({text: "0", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:8-1:9(7-8)}), span: 1:8-1:9(7-8)}}), span: 1:6-1:9(5-8)}, {kind: BinaryExpr({left: {kind: Identifier({text: "j", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:12(10-11)}), span: 1:11-1:12(10-11)}, operator: Equals, right: {kind: NumericLiteral({text: "0", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:13-1:14(12-13)}), span: 1:13-1:14(12-13)}}), span: 1:11-1:14(10-13)}], start: 1:6-1:6(5-5), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}), span: 1:6-1:14(5-13)})), condition: None, incrementor: None, statement: {kind: Block([]), span: 1:20-1:22(19-21)}}), span: 1:1-1:22(0-21)}], start: 1:1-1:1(0-0), end: 1:22-1:22(21-21), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "for (i=0, j=0; ; ) {}", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - for loop with valid await" {
  // 'for await' is only allowed with 'of'
  let source = try? parse_source(
    "async function f() { for await (const x of y) {} }",
  )
  inspect(
    source,
    content="Err(Parse error at 1:22-1:33(21-32): for-await is only allowed in a module file)",
  )
}

///|
test "expr - as in for loop init (no_in)" {
  let source = try? parse_source("for (x = y as T; ; ) {}")
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: ForStmt({initializer: Some(Expr({kind: BinaryExpr({left: {kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}, operator: Equals, right: {kind: AsExpr({expression: {kind: Identifier({text: "y", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), span: 1:10-1:11(9-10)}, type_node: {kind: TypeReference({type_name: Identifier({text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:16(14-15)}), type_arguments: None}), span: 1:15-1:16(14-15)}}), span: 1:10-1:16(9-15)}}), span: 1:6-1:16(5-15)})), condition: None, incrementor: None, statement: {kind: Block([]), span: 1:22-1:24(21-23)}}), span: 1:1-1:24(0-23)}], start: 1:1-1:1(0-0), end: 1:24-1:24(23-23), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "for (x = y as T; ; ) {}", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "expr - conditional in for loop init (no_in)" {
  let source = try? parse_source("for (x = c ? t : f; ; ) {}")
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: ForStmt({initializer: Some(Expr({kind: BinaryExpr({left: {kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}, operator: Equals, right: {kind: ConditionalExpr({condition: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), span: 1:10-1:11(9-10)}, when_true: {kind: Identifier({text: "t", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:15(13-14)}), span: 1:14-1:15(13-14)}, when_false: {kind: Identifier({text: "f", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:19(17-18)}), span: 1:18-1:19(17-18)}}), span: 1:10-1:19(9-18)}}), span: 1:6-1:19(5-18)})), condition: None, incrementor: None, statement: {kind: Block([]), span: 1:25-1:27(24-26)}}), span: 1:1-1:27(0-26)}], start: 1:1-1:1(0-0), end: 1:27-1:27(26-26), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "for (x = c ? t : f; ; ) {}", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "expr - yield in for loop init (no_in)" {
  let source = try? parse_source("function* g() { for (x = yield; ; ) {} }")
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, is_async: false, is_generator: true, name: Some({text: "g", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:12(10-11)}), type_parameters: None, parameters: {elements: [], start: 1:12-1:12(11-11), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([{kind: ForStmt({initializer: Some(Expr({kind: BinaryExpr({left: {kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:22-1:23(21-22)}), span: 1:22-1:23(21-22)}, operator: Equals, right: {kind: YieldExpr({is_delegate: false, expression: None}), span: 1:26-1:31(25-30)}}), span: 1:22-1:31(21-30)})), condition: None, incrementor: None, statement: {kind: Block([]), span: 1:37-1:39(36-38)}}), span: 1:17-1:39(16-38)}])}), span: 1:1-1:41(0-40)}], start: 1:1-1:1(0-0), end: 1:41-1:41(40-40), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "function* g() { for (x = yield; ; ) {} }", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - for loop var decl list comma" {
  let source = try? parse_source("for (let i=0, j=0; ; ) {}")
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: ForStmt({initializer: Some(VariableDeclList({elements: [{kind: Let, name: Identifier({text: "i", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), type_node: None, initializer: Some({kind: NumericLiteral({text: "0", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:12-1:13(11-12)}), span: 1:12-1:13(11-12)})}, {kind: Let, name: Identifier({text: "j", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:16(14-15)}), type_node: None, initializer: Some({kind: NumericLiteral({text: "0", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:17-1:18(16-17)}), span: 1:17-1:18(16-17)})}], start: 1:1-1:1(0-0), end: 1:18-1:18(17-17), has_trailing_comma: false, is_missing_list: false})), condition: None, incrementor: None, statement: {kind: Block([]), span: 1:24-1:26(23-25)}}), span: 1:1-1:26(0-25)}], start: 1:1-1:1(0-0), end: 1:26-1:26(25-25), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "for (let i=0, j=0; ; ) {}", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - modifiers starting with identifier" {
  let source = try? parse_source(
    (
      #|declare interface I {}
      #|declare type T = number
      #|declare enum E {}
    ),
  )
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: InterfaceDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, name: {text: "I", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:19-1:20(18-19)}, type_parameters: None, heritage_clauses: None, members: {elements: [], start: 1:21-1:21(20-20), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:23(0-22)}, {kind: TypeAliasDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:14-2:15(36-37)}, type_parameters: None, type_node: {kind: KeywordType(Number), span: 2:18-2:24(40-46)}}), span: 2:1-3:1(23-47)}, {kind: EnumDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: true}, name: {text: "E", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:14-3:15(60-61)}, members: {elements: [], start: 3:16-3:16(62-62), end: 3:18-3:18(64-64), has_trailing_comma: false, is_missing_list: false}}), span: 3:1-3:18(47-64)}], start: 1:1-1:1(0-0), end: 3:18-3:18(64-64), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "declare interface I {}\ndeclare type T = number\ndeclare enum E {}", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - throw statement line break error" {
  let error = try? parse_source(
    (
      #|throw
      #|new Error()
    ),
  )
  inspect(
    error,
    content="Err(Parse error at 2:1-2:4(6-9): line break after 'throw' is not allowed)",
  )
}

///|
test "stmt - for await loop non-of error" {
  let error = try? parse_source(
    (
      #|async function f() {
      #|  for await (let x = 0; x < 10; x++) {}
      #|}
    ),
  )
  inspect(
    error,
    content="Err(Parse error at 2:23-2:24(43-44): for-await must use 'of', found ';')",
  )
}

///|
test "stmt - namespace string error" {
  let error = try? parse_source("namespace \"s\" {}")
  inspect(
    error,
    content=(
      #|Err(Parse error at 1:11-1:14(10-13): namespace name cannot be a string literal: string literal "s")
    ),
  )
}

///|
test "stmt - import attributes comma error" {
  let error = try? parse_source("import \"a\" with { , type: \"json\" }")
  inspect(
    error,
    content="Err(Parse error at 1:19-1:20(18-19): leading comma in import attributes)",
  )
}

///|
test "stmt - rest binding must be last in object pattern" {
  let error = try? parse_source("let { ...a, b } = foo")
  inspect(
    error,
    content="Err(Parse error at 1:11-1:12(10-11): A rest binding element must be last in a destructuring pattern.)",
  )
}

///|
test "stmt - rest binding must be last in array pattern" {
  let error = try? parse_source("let [...a, b] = foo")
  inspect(
    error,
    content="Err(Parse error at 1:10-1:11(9-10): A rest binding element must be last in a destructuring pattern.)",
  )
}

///|
test "stmt - export named comma error" {
  let error = try? parse_source("export { , }")
  inspect(
    error,
    content="Err(Parse error at 1:10-1:11(9-10): leading comma in named exports)",
  )
}

///|
test "stmt - export unexpected token" {
  let error = try? parse_source("export 123")
  inspect(
    error,
    content="Err(Parse error at 1:8-1:11(7-10): unexpected token: number literal 123)",
  )
}

///|
test "stmt - decorator on expression error" {
  let error = try? parse_source("@dec 1 + 1")
  inspect(
    error,
    content="Err(Parse error at 1:1-1:5(0-4): decorators are not valid here)",
  )
}

///|
test "decorators - allowed on class and members" {
  let source = parse_source(
    (
      #|@sealed
      #|class C {
      #|  @prop
      #|  prop: string;
      #|  @log
      #|  method() {}
      #|  @get
      #|  get value() { return 1 }
      #|  @set
      #|  set value(v) {}
      #|}
    ),
  )
  let (class_ok, prop_ok, method_ok, get_ok, set_ok) = match
    source.stmts.elements[0].kind {
    ClassDecl(decl) => {
      let members = decl.members.elements
      let (prop_ok, method_ok, get_ok, set_ok) = match members {
        [
          ClassElement::PropertyDecl(prop),
          ClassElement::MethodDecl(mth),
          ClassElement::GetAccessor(get),
          ClassElement::SetAccessor(set),
        ] =>
          (
            prop.decorators is Some(_),
            mth.decorators is Some(_),
            get.decorators is Some(_),
            set.decorators is Some(_),
          )
        _ => (false, false, false, false)
      }
      (decl.decorators is Some(_), prop_ok, method_ok, get_ok, set_ok)
    }
    _ => (false, false, false, false, false)
  }
  inspect(
    (class_ok, prop_ok, method_ok, get_ok, set_ok),
    content="(true, true, true, true, true)",
  )
}

///|
test "stmt - decorator on interface error" {
  let error = try? parse_source("@dec interface I {}")
  inspect(
    error,
    content="Err(Parse error at 1:1-1:5(0-4): decorators are not valid here)",
  )
}

///|
test "stmt - decorator on constructor error" {
  let error = try? parse_source(
    (
      #|class C {
      #|  @dec
      #|  constructor() {}
      #|}
    ),
  )
  inspect(
    error,
    content="Err(Parse error at 2:3-2:7(12-16): decorators are not valid here)",
  )
}

///|
test "stmt - module name error" {
  let error = try? parse_source("module 123 {}")
  inspect(
    error,
    content="Err(Parse error at 1:8-1:11(7-10): unexpected token: number literal 123)",
  )
}

///|
test "decl - rest parameter not last" {
  let error = try? parse_source("function f(...args: number, x: number) {}")
  inspect(
    error,
    content="Err(Parse error at 1:27-1:28(26-27): A rest parameter must be last in a parameter list.)",
  )
}

///|
test "decl - rest parameter not last in function type" {
  let error = try? parse_source(
    "type Fn = (...args: number, x: number) => void;",
  )
  inspect(
    error,
    content="Err(Parse error at 1:27-1:28(26-27): A rest parameter must be last in a parameter list.)",
  )
}

///|
test "expr - yield outside generator error" {
  let error = try? parse_source("function f() { yield 1 }")
  inspect(
    error,
    content="Err(Parse error at 1:16-1:21(15-20): A 'yield' expression is only allowed in a generator body.)",
  )
}

///|
test "expr - yield in arrow inside generator error" {
  let error = try? parse_source("function* f() { () => { yield 1 } }")
  inspect(
    error,
    content="Err(Parse error at 1:25-1:30(24-29): A 'yield' expression is only allowed in a generator body.)",
  )
}

///|
test "expr - yield star in no_in context" {
  let source = try? parse_source("function* f() { for (x = yield * 2; ;) {} }")
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, is_async: false, is_generator: true, name: Some({text: "f", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:11-1:12(10-11)}), type_parameters: None, parameters: {elements: [], start: 1:12-1:12(11-11), end: 1:14-1:14(13-13), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([{kind: ForStmt({initializer: Some(Expr({kind: BinaryExpr({left: {kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:22-1:23(21-22)}), span: 1:22-1:23(21-22)}, operator: Equals, right: {kind: YieldExpr({is_delegate: true, expression: Some({kind: NumericLiteral({text: "2", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 1:34-1:35(33-34)}), span: 1:34-1:35(33-34)})}), span: 1:26-1:35(25-34)}}), span: 1:22-1:35(21-34)})), condition: None, incrementor: None, statement: {kind: Block([]), span: 1:40-1:42(39-41)}}), span: 1:17-1:42(16-41)}])}), span: 1:1-1:44(0-43)}], start: 1:1-1:1(0-0), end: 1:44-1:44(43-43), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "function* f() { for (x = yield * 2; ;) {} }", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - for loop empty init cond" {
  let source = try? parse_source("for (;; i++) {}")
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: ForStmt({initializer: None, condition: None, incrementor: Some({kind: PostfixUnaryExpr({operand: {kind: Identifier({text: "i", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:9-1:10(8-9)}), span: 1:9-1:10(8-9)}, operator: PlusPlus}), span: 1:9-1:12(8-11)}), statement: {kind: Block([]), span: 1:14-1:16(13-15)}}), span: 1:1-1:16(0-15)}], start: 1:1-1:1(0-0), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "for (;; i++) {}", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - for loop binary init" {
  let source = try? parse_source("for (x + y; ;) {}")
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: ForStmt({initializer: Some(Expr({kind: BinaryExpr({left: {kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}, operator: Plus, right: {kind: Identifier({text: "y", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), span: 1:10-1:11(9-10)}}), span: 1:6-1:11(5-10)})), condition: None, incrementor: None, statement: {kind: Block([]), span: 1:16-1:18(15-17)}}), span: 1:1-1:18(0-17)}], start: 1:1-1:1(0-0), end: 1:18-1:18(17-17), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "for (x + y; ;) {}", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - for loop conditional init" {
  let source = try? parse_source("for (a ? b : c; ;) {}")
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: ForStmt({initializer: Some(Expr({kind: ConditionalExpr({condition: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}, when_true: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:11(9-10)}), span: 1:10-1:11(9-10)}, when_false: {kind: Identifier({text: "c", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:15(13-14)}), span: 1:14-1:15(13-14)}}), span: 1:6-1:15(5-14)})), condition: None, incrementor: None, statement: {kind: Block([]), span: 1:20-1:22(19-21)}}), span: 1:1-1:22(0-21)}], start: 1:1-1:1(0-0), end: 1:22-1:22(21-21), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "for (a ? b : c; ;) {}", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "expr - binary operators coverage" {
  let source = try? parse_source(
    (
      #|a - b;
      #|a / b;
    ),
  )
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: Minus, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:6(4-5)}), span: 1:5-1:6(4-5)}}), span: 1:1-1:6(0-5)}), span: 1:1-1:6(0-5)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:1-2:2(7-8)}), span: 2:1-2:2(7-8)}, operator: Slash, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:5-2:6(11-12)}), span: 2:5-2:6(11-12)}}), span: 2:1-2:6(7-12)}), span: 2:1-2:6(7-12)}], start: 1:1-1:1(0-0), end: 2:7-2:7(13-13), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a - b;\na / b;", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - assignment operators coverage" {
  let source = try? parse_source(
    (
      #|a -= b;
      #|a /= b;
      #|a >>= b;
    ),
  )
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: MinusEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}}), span: 1:1-1:7(0-6)}), span: 1:1-1:7(0-6)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:1-2:2(8-9)}), span: 2:1-2:2(8-9)}, operator: SlashEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:6-2:7(13-14)}), span: 2:6-2:7(13-14)}}), span: 2:1-2:7(8-14)}), span: 2:1-2:7(8-14)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:1-3:2(16-17)}), span: 3:1-3:2(16-17)}, operator: ShiftRightEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:7-3:8(22-23)}), span: 3:7-3:8(22-23)}}), span: 3:1-3:8(16-23)}), span: 3:1-3:8(16-23)}], start: 1:1-1:1(0-0), end: 3:9-3:9(24-24), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a -= b;\na /= b;\na >>= b;", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - const enum coverage" {
  let source = try? parse_source(
    (
      #|const enum E {}
      #|export const enum F {}
    ),
  )
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: EnumDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: {text: "E", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:12-1:13(11-12)}, members: {elements: [], start: 1:14-1:14(13-13), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:16(0-15)}, {kind: EnumDecl({doc_comment: None, modifiers: {is_export: true, is_default: false, is_declare: false}, name: {text: "F", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:19-2:20(34-35)}, members: {elements: [], start: 2:21-2:21(36-36), end: 2:23-2:23(38-38), has_trailing_comma: false, is_missing_list: false}}), span: 2:1-2:23(16-38)}], start: 1:1-1:1(0-0), end: 2:23-2:23(38-38), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "const enum E {}\nexport const enum F {}", script_kind: TS, is_module: true})
    ),
  )
}

///|
test "expr - more binary operators" {
  let source = try? parse_source("a % b;")
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: Percent, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:5-1:6(4-5)}), span: 1:5-1:6(4-5)}}), span: 1:1-1:6(0-5)}), span: 1:1-1:6(0-5)}], start: 1:1-1:1(0-0), end: 1:7-1:7(6-6), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a % b;", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - more assignment operators" {
  let source = try? parse_source(
    (
      #|a %= b;
      #|a *= b;
      #|a >>>= b;
    ),
  )
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:1-1:2(0-1)}), span: 1:1-1:2(0-1)}, operator: PercentEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:6-1:7(5-6)}), span: 1:6-1:7(5-6)}}), span: 1:1-1:7(0-6)}), span: 1:1-1:7(0-6)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:1-2:2(8-9)}), span: 2:1-2:2(8-9)}, operator: AsteriskEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:6-2:7(13-14)}), span: 2:6-2:7(13-14)}}), span: 2:1-2:7(8-14)}), span: 2:1-2:7(8-14)}, {kind: ExprStmt({kind: BinaryExpr({left: {kind: Identifier({text: "a", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:1-3:2(16-17)}), span: 3:1-3:2(16-17)}, operator: ShiftRightUnsignedEquals, right: {kind: Identifier({text: "b", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 3:8-3:9(23-24)}), span: 3:8-3:9(23-24)}}), span: 3:1-3:9(16-24)}), span: 3:1-3:9(16-24)}], start: 1:1-1:1(0-0), end: 3:10-3:10(25-25), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "a %= b;\na *= b;\na >>>= b;", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "expr - conditional after as" {
  let source = try? parse_source("(x as any) ? y : z;")
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: ExprStmt({kind: ConditionalExpr({condition: {kind: ParenthesizedExpr({kind: AsExpr({expression: {kind: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:2-1:3(1-2)}), span: 1:2-1:3(1-2)}, type_node: {kind: KeywordType(Any), span: 1:7-1:10(6-9)}}), span: 1:2-1:10(1-9)}), span: 1:1-1:11(0-10)}, when_true: {kind: Identifier({text: "y", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:15(13-14)}), span: 1:14-1:15(13-14)}, when_false: {kind: Identifier({text: "z", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:18-1:19(17-18)}), span: 1:18-1:19(17-18)}}), span: 1:1-1:19(0-18)}), span: 1:1-1:19(0-18)}], start: 1:1-1:1(0-0), end: 1:20-1:20(19-19), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "(x as any) ? y : z;", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - for await in error" {
  let source = try? parse_source(
    (
      #|async function f() {
      #|  for await (let x in y) {}
      #|}
    ),
  )
  inspect(
    source,
    content="Err(Parse error at 2:20-2:22(40-42): for-await must use 'of', found in)",
  )
}

///|
test "expr - await in non-async function error" {
  let error = try? parse_source("function f() { await foo }")
  inspect(
    error,
    content="Err(Parse error at 1:16-1:21(15-20): await expressions are only allowed within async functions)",
  )
}

///|
test "stmt - for await in non-async function error" {
  let error = try? parse_source("function f() { for await (const x of y) {} }")
  inspect(
    error,
    content="Err(Parse error at 1:16-1:27(15-26): for-await is only allowed within async functions)",
  )
}

///|
test "stmt - for await in script error" {
  let error = try? parse_source("for await (const x of y) {}")
  inspect(
    error,
    content="Err(Parse error at 1:1-1:12(0-11): for-await is only allowed in a module file)",
  )
}

///|
test "stmt - function overload missing semicolon" {
  let source = try? parse_source(
    (
      #|function foo()
      #|function bar() {}
    ),
  )
  inspect(
    source,
    content=(
      #|Ok({stmts: {elements: [{kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, is_async: false, is_generator: false, name: Some({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:13(9-12)}), type_parameters: None, parameters: {elements: [], start: 1:13-1:13(12-12), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: None}), span: 1:1-2:1(0-15)}, {kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, is_async: false, is_generator: false, name: Some({text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:10-2:13(24-27)}), type_parameters: None, parameters: {elements: [], start: 2:13-2:13(27-27), end: 2:15-2:15(29-29), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: Some([])}), span: 2:1-2:18(15-32)}], start: 1:1-1:1(0-0), end: 2:18-2:18(32-32), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "function foo()\nfunction bar() {}", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - function overload missing semicolon error" {
  let error = try? parse_source(
    (
      #|function foo()
      #|const x = 1;
    ),
  )
  inspect(
    error,
    content=(
      #|Ok({stmts: {elements: [{kind: FunctionDecl({doc_comment: None, modifiers: {is_export: false, is_default: false, is_declare: false}, is_async: false, is_generator: false, name: Some({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:10-1:13(9-12)}), type_parameters: None, parameters: {elements: [], start: 1:13-1:13(12-12), end: 1:15-1:15(14-14), has_trailing_comma: false, is_missing_list: false}, type_node: None, body: None}), span: 1:1-2:1(0-15)}, {kind: VariableStmt({doc_comment: None, modifiers: None, declaration_list: {elements: [{kind: Const, name: Identifier({text: "x", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:7-2:8(21-22)}), type_node: None, initializer: Some({kind: NumericLiteral({text: "1", is_unterminated: false, has_extended_unicode_escape: false, is_octal_literal: false, span: 2:11-2:12(25-26)}), span: 2:11-2:12(25-26)})}], start: 2:1-2:1(15-15), end: 2:12-2:12(26-26), has_trailing_comma: false, is_missing_list: false}}), span: 2:1-2:13(15-27)}], start: 1:1-1:1(0-0), end: 2:13-2:13(27-27), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "function foo()\nconst x = 1;", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - nested namespace invalid body error" {
  let error = try? parse_source("namespace A.B.C")
  inspect(
    error,
    content="Err(Parse error at 1:1-1:16(0-15): module or namespace body is required unless declared)",
  )
}

///|
test "decl - export namespace only in module" {
  let error = try? parse_source("export as namespace Foo")
  inspect(
    error,
    content="Err(Parse error at 1:1-1:10(0-9): export as namespace is only allowed in a declaration file)",
  )
}

///|
test "stmt - await using only in async function" {
  let error = try? parse_source(
    (
      #|function f() {
      #|  await using x = foo
      #|}
    ),
  )
  inspect(
    error,
    content="Err(Parse error at 2:3-2:16(17-30): 'await using' is only allowed within async functions)",
  )
}

///|
test "stmt - type alias line break error" {
  let source = try? parse_source(
    (
      #|type
      #|A = B;
    ),
  )
  inspect(
    source,
    content="Err(Parse error at 2:1-2:2(5-6): line break after 'type' is not allowed)",
  )
}

///|
test "stmt - import attributes errors" {
  let source = try? parse_source(
    (
      #|import "a"
      #|with {};
      #|import "b" with { 123: 1 };
      #|import "c" with { a: 1, };
    ),
  )
  inspect(
    source,
    content="Err(Parse error at 2:6-2:7(16-17): expected '(', found '{')",
  )
}

///|
test "stmt - import specifier errors" {
  let error = try? parse_source("import a from 123")
  inspect(
    error,
    content="Err(Parse error at 1:15-1:18(14-17): expected string literal in module specifier, found number literal 123)",
  )
  let error = try? parse_source("import { , } from 'a'")
  inspect(
    error,
    content="Err(Parse error at 1:10-1:11(9-10): leading comma in named imports)",
  )
  let error = try? parse_source("import a = 123")
  inspect(
    error,
    content="Err(Parse error at 1:12-1:15(11-14): unexpected token: number literal 123)",
  )
}

///|
test "stmt - export errors" {
  let error = try? parse_source(
    (
      #|export { a, };
      #|export as namespace N foo;
      #|export foo;
    ),
  )
  inspect(
    error,
    content="Err(Parse error at 2:1-2:10(15-24): export as namespace is only allowed in a declaration file)",
  )
}

///|
test "decl - declaration file allowed statements" {
  let source = parse_source(
    (
      #|declare const foo: number;
      #|export declare function bar(): void;
    ),
    script_kind=TSDeclarations,
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: VariableStmt({doc_comment: None, modifiers: Some({elements: [declare], start: 1:1-1:1(0-0), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}), declaration_list: {elements: [{kind: Const, name: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:15-1:18(14-17)}), type_node: Some({kind: KeywordType(Number), span: 1:20-1:26(19-25)}), initializer: None}], start: 1:1-1:1(0-0), end: 1:26-1:26(25-25), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-2:1(0-27)}, {kind: FunctionDecl({doc_comment: None, modifiers: {is_export: true, is_default: false, is_declare: true}, is_async: false, is_generator: false, name: Some({text: "bar", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:25-2:28(51-54)}), type_parameters: None, parameters: {elements: [], start: 2:28-2:28(54-54), end: 2:30-2:30(56-56), has_trailing_comma: false, is_missing_list: false}, type_node: Some({kind: KeywordType(Void), span: 2:32-2:36(58-62)}), body: None}), span: 2:1-2:37(27-63)}], start: 1:1-1:1(0-0), end: 2:37-2:37(63-63), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "declare const foo: number;\nexport declare function bar(): void;", script_kind: TSDeclarations, is_module: true}
    ),
  )
}

///|
test "decl - declaration file statement error" {
  let error = try? parse_source("const foo = 1", script_kind=TSDeclarations)
  inspect(
    error,
    content="Err(Parse error at 1:1-1:6(0-5): statement is not allowed in a declaration file)",
  )
}

///|
test "decl - export assignment only in declaration file error" {
  let error = try? parse_source("export = foo")
  inspect(
    error,
    content="Err(Parse error at 1:1-1:9(0-8): export assignment is only allowed in a declaration file)",
  )
}

///|
test "decl - export namespace only in declaration file error" {
  let error = try? parse_source("export as namespace Foo")
  inspect(
    error,
    content="Err(Parse error at 1:1-1:10(0-9): export as namespace is only allowed in a declaration file)",
  )
}

///|
test "decl - export namespace only in module error" {
  let error = try? parse_source(
    (
      #|export as namespace Foo
      #|declare const bar: number
    ),
    script_kind=TSDeclarations,
  )
  inspect(
    error,
    content="Err(Parse error at 1:1-1:10(0-9): export as namespace is only allowed in a module file)",
  )
}

///|
test "decl - export namespace in module declaration file" {
  let source = parse_source(
    (
      #|export const foo: number;
      #|export as namespace Foo
    ),
    script_kind=TSDeclarations,
  )
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: VariableStmt({doc_comment: None, modifiers: Some({elements: [export], start: 1:1-1:1(0-0), end: 1:8-1:8(7-7), has_trailing_comma: false, is_missing_list: false}), declaration_list: {elements: [{kind: Const, name: Identifier({text: "foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:17(13-16)}), type_node: Some({kind: KeywordType(Number), span: 1:19-1:25(18-24)}), initializer: None}], start: 1:1-1:1(0-0), end: 1:25-1:25(24-24), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-2:1(0-26)}, {kind: NamespaceExportDecl({name: {text: "Foo", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 2:21-2:24(46-49)}}), span: 2:1-2:24(26-49)}], start: 1:1-1:1(0-0), end: 2:24-2:24(49-49), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "export const foo: number;\nexport as namespace Foo", script_kind: TSDeclarations, is_module: true}
    ),
  )
}

///|
test "decl - class variance type parameters" {
  let source = parse_source("class Box<in T, out U> {}")
  inspect(
    source,
    content=(
      #|{stmts: {elements: [{kind: ClassDecl({doc_comment: None, decorators: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: Some({text: "Box", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:7-1:10(6-9)}), type_parameters: Some({elements: [{modifiers: {variance: Some(in), is_const: false}, name: {text: "T", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:14-1:15(13-14)}, constraint: None, default_type: None}, {modifiers: {variance: Some(out), is_const: false}, name: {text: "U", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:21-1:22(20-21)}, constraint: None, default_type: None}], start: 1:10-1:10(9-9), end: 1:23-1:23(22-22), has_trailing_comma: false, is_missing_list: false}), heritage_clauses: None, members: {elements: [], start: 1:24-1:24(23-23), end: 1:25-1:25(24-24), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:26(0-25)}], start: 1:1-1:1(0-0), end: 1:26-1:26(25-25), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "class Box<in T, out U> {}", script_kind: TS, is_module: false}
    ),
  )
}

///|
test "decl - class variance order error" {
  let source = try? parse_source("class Box<out in T> {}")
  inspect(
    source,
    content="Err(Parse error at 1:15-1:17(14-16): invalid variance order: out before in)",
  )
}

///|
test "decl - class variance duplicate error" {
  let source = try? parse_source("class Box<in in T> {}")
  inspect(
    source,
    content="Err(Parse error at 1:14-1:16(13-15): duplicate modifier: in)",
  )
}

///|
test "expr - numeric literal followed by identifier error" {
  let error = try? parse_source("0foo")
  inspect(
    error,
    content="Err(Parse error at 1:2-1:3(1-2): An identifier or keyword cannot immediately follow a numeric literal)",
  )
}

///|
test "expr - numeric literal trailing separator error" {
  let error = try? parse_source("1_")
  inspect(
    error,
    content="Err(Parse error at 1:2-1:3(1-2): numeric separator cannot appear at the end of a numeric literal)",
  )
}

///|
test "stmt - function overload missing body error" {
  let error = try? parse_source("function foo() const x = 1")
  inspect(
    error,
    content="Err(Parse error at 1:16-1:21(15-20): expected function body or ';', found const)",
  )
}

///|
test "stmt - module string literal name without declare error" {
  let error = try? parse_source("module \"abc\" {}")
  inspect(
    error,
    content="Err(Parse error at 1:1-1:14(0-13): string literal module name requires 'declare')",
  )
}

///|
test "stmt - import attributes trailing comma" {
  let source = parse_source(
    (
      #|import "mod" with { a: "x", b: "y", }
    ),
  )
  inspect(source.stmts.elements.length(), content="1")
}

///|
test "stmt - import named trailing comma" {
  let source = parse_source(
    (
      #|import { a, b, } from "mod"
    ),
  )
  inspect(source.stmts.elements.length(), content="1")
}

///|
test "stmt - export named trailing comma" {
  let source = parse_source(
    (
      #|export { a, b, }
    ),
  )
  inspect(source.stmts.elements.length(), content="1")
}

///|
test "stmt - import type as as pattern" {
  let source = parse_source(
    (
      #|import { type as as foo } from "mod"
    ),
  )
  inspect(source.stmts.elements.length(), content="1")
}

///|
test "stmt - import type as as as pattern" {
  let source = parse_source(
    (
      #|import { type as as as } from "mod"
    ),
  )
  inspect(source.stmts.elements.length(), content="1")
}

///|
test "stmt - export type as as pattern" {
  let source = parse_source(
    (
      #|export { type as as foo }
    ),
  )
  inspect(source.stmts.elements.length(), content="1")
}

///|
test "stmt - export type as as as pattern" {
  let source = parse_source(
    (
      #|export { type as as as }
    ),
  )
  inspect(source.stmts.elements.length(), content="1")
}

///|
test "stmt - export using with modifiers" {
  let source = parse_source(
    (
      #|export using x = foo()
    ),
  )
  inspect(source.stmts.elements.length(), content="1")
}

///|
test "stmt - export await using with modifiers" {
  let source = parse_source(
    (
      #|import "mod";
      #|export await using x = foo()
    ),
  )
  inspect(source.stmts.elements.length(), content="2")
}

///|
test "stmt - async modifier class" {
  let error = try? parse_source("async class C {}")
  inspect(
    error,
    content=(
      #|Ok({stmts: {elements: [{kind: ClassDecl({doc_comment: None, decorators: None, modifiers: {is_export: false, is_default: false, is_declare: false}, name: Some({text: "C", has_extended_unicode_escape: false, is_in_jsdoc_namespace: false, span: 1:13-1:14(12-13)}), type_parameters: None, heritage_clauses: None, members: {elements: [], start: 1:15-1:15(14-14), end: 1:16-1:16(15-15), has_trailing_comma: false, is_missing_list: false}}), span: 1:1-1:17(0-16)}], start: 1:1-1:1(0-0), end: 1:17-1:17(16-16), has_trailing_comma: false, is_missing_list: false}, file_name: "test.ts", text: "async class C {}", script_kind: TS, is_module: false})
    ),
  )
}

///|
test "stmt - async modifier using" {
  let source = try? parse_source("async using x = foo()")
  match source {
    Ok(s) => inspect(s.stmts.elements.length(), content="1")
    Err(e) => inspect(e, content="unexpected error")
  }
}

///|
test "stmt - abstract modifier await using" {
  let source = try? parse_source(
    (
      #|import "mod";
      #|abstract await using x = foo()
    ),
  )
  match source {
    Ok(s) => inspect(s.stmts.elements.length(), content="2")
    Err(e) => inspect(e, content="unexpected error")
  }
}

///|
test "stmt - using as identifier not stmt" {
  let source = try? parse_source("using")
  match source {
    Ok(s) => inspect(s.stmts.elements.length(), content="1")
    Err(e) => inspect(e, content="unexpected error")
  }
}

///|
test "stmt - export namespace const enum" {
  let source = parse_source(
    (
      #|export as namespace Foo
      #|export const enum E {}
    ),
    script_kind=TSDeclarations,
  )
  inspect(source.stmts.elements.length(), content="2")
}

///|
test "stmt - import type from string" {
  let source = try? parse_source(
    (
      #|import type from "mod"
    ),
  )
  match source {
    Ok(s) => inspect(s.stmts.elements.length(), content="1")
    Err(e) =>
      inspect(
        e,
        content="Parse error at 1:8-1:12(7-11): expected '{', found type",
      )
  }
}

///|
test "stmt - import defer from string" {
  let source = try? parse_source(
    (
      #|import defer from "mod"
    ),
  )
  match source {
    Ok(s) => inspect(s.stmts.elements.length(), content="1")
    Err(e) => inspect(e, content="unexpected error")
  }
}

///|
test "stmt - import defer comma" {
  let source = try? parse_source(
    (
      #|import defer, { x } from "mod"
    ),
  )
  match source {
    Ok(s) => inspect(s.stmts.elements.length(), content="1")
    Err(e) => inspect(e, content="unexpected error")
  }
}

///|
test "doc comments - trimmed content" {
  let source = parse_source(
    (
      #|/**  foo
      #| *   bar
      #|  baz
      #| */
      #|class C {}
    ),
  )
  guard source.stmts.elements is [{ kind: ClassDecl(cls), .. }]
  inspect(cls.doc_comment, content="Some(\"foo\\nbar\\nbaz\")")
}

///|
test "doc comments - ignored in local scope and dangling" {
  let source = parse_source(
    (
      #|/** top */
      #|function f() {
      #|  /** local */
      #|  const x = 1
      #|}
      #|/** dangling */
      #|1
    ),
  )
  guard source.stmts.elements
    is [{ kind: FunctionDecl(func), .. }, { kind: ExprStmt(_), .. }]
  inspect(func.doc_comment, content="Some(\"top\")")
  match func.body {
    Some(body) => {
      guard body is [{ kind: VariableStmt(var_stmt), .. }]
      inspect(var_stmt.doc_comment, content="None")
    }
    None => inspect((), content="missing body")
  }
}
