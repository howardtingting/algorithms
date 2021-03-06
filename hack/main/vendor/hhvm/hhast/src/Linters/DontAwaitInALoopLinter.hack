/*
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAST;

use namespace HH\Lib\{C, Str, Vec};
use function Facebook\HHAST\find_position;

final class DontAwaitInALoopLinter extends ASTLinter {
  const type TConfig = shape();
  const type TNode = PrefixUnaryExpression;
  const type TContext = Script;

  <<__Override>>
  public function getLintErrorForNode(
    Script $script,
    PrefixUnaryExpression $node,
  ): ?ASTLintError {
    if (!$node->getOperator() is AwaitToken) {
      return null;
    }

    $boundary = $script->getClosestAncestorOfDescendantOfType<IHasFunctionBody>(
      $node,
    ) ??
      $script;

    $outermost_loop = $boundary->getFirstAncestorOfDescendantWhere(
      $node,
      $a ==> $a is ILoopStatement,
    ) as ?ILoopStatement;

    if (
      $outermost_loop is null ||
      self::isInTerminalStatement($node, $boundary) ||
      !self::isInLoop($outermost_loop, $node)
    ) {
      return null;
    }

    return new ASTLintError($this, "Don't use await in a loop", $node);
  }

  <<__Override>>
  public function getPrettyTextForNode(PrefixUnaryExpression $blame): string {
    $boundary = $this->getAST()
      ->getClosestAncestorOfDescendantOfType<IHasFunctionBody>($blame) ??
      $this->getAST();

    $loops = $boundary->getAncestorsOfDescendant($blame)
      |> Vec\map(
        $$,
        $x ==> $x is ILoopStatement && self::isInLoop($x, $blame) ? $x : null,
      )
      |> Vec\filter_nulls($$);

    $lines = $this->getFile()->getContents() |> Str\split($$, "\n");

    list($blame_line, $_col) = find_position($this->getAST(), $blame);

    if (C\count($loops) === 1) {
      list($line, $_col) = find_position($this->getAST(), C\onlyx($loops));
      if ($line === $blame_line) {
        return $lines[$line - 1];
      }
    }

    $output = vec[];
    foreach ($loops as $loop) {
      list($line, $_col) = find_position($this->getAST(), $loop);
      $output[] = 'Line '.$line.': '.$lines[$line - 1];
    }
    $output[] = 'Line '.$blame_line.': '.$lines[$blame_line - 1];

    return Str\join($output, "\n");
  }

  /**
   * The following statements, although `await`ing in a loop,
   * will never execute more than once.
   * We can detect these cases and not emit a lint error for them.
   * ```
   * return await Asio\curl_exec($url);
   * // or
   * throw new BadRequestException(await $repo->getUserAsync());
   * ```
   *
   * Cases like these are not covered and they should be suppressed.
   * ```
   * // @see https://docs.hhvm.com/hack/asynchronous-operations/await-as-an-expression#limitations
   * $some_value = await $some_awaitable;
   * return await something_else_async($some_value);
   * ```
   */
  private static function isInTerminalStatement(
    PrefixUnaryExpression $node,
    Node $boundary,
  ): bool {
    return C\any(
      $boundary->getAncestorsOfDescendant($node),
      $a ==> $a is ReturnStatement || $a is ThrowStatement,
    );
  }

  /**
   * Checks that the $node is in the part of the $loop that actually loops. This
   * includes the body of the loop as well as e.g. the condition (since it's
   * evaluated at every iteration), but excludes e.g. the initializer in for
   * loops since it's only evaluated once.
   */
  private static function isInLoop(
    ILoopStatement $loop,
    PrefixUnaryExpression $node,
  ): bool {
    return !(
      $loop is ForStatement && ($loop->getInitializer()?->isAncestorOf($node) ?? false) ||
      $loop is ForeachStatement && $loop->getCollection()->isAncestorOf($node)
    );
  }
}
