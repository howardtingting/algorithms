/**
 * This file is generated. Do not modify it manually!
 *
 * @generated SignedSource<<071b43505cbdd21bf28bfe78510c618e>>
 */
namespace Facebook\HHAST;
use namespace Facebook\TypeAssert;
use namespace HH\Lib\Dict;
/* HHAST_IGNORE_ALL[5607] 5607 is ignored because of false positives when comparing a generic to a typed value */
/* HHAST_IGNORE_ALL[5624] HHAST_IGNORE_ALL[5639] 5624 and 5639 are ignored because they insist on using co(tra)variant generics. Could this break external consumers? */

<<__ConsistentConstruct>>
final class SoftTypeSpecifier extends Node implements ITypeSpecifier {

  const string SYNTAX_KIND = 'soft_type_specifier';

  private ?Node $_at;
  private ?Node $_type;

  public function __construct(
    ?Node $at,
    ?Node $type,
    ?__Private\SourceRef $source_ref = null,
  ) {
    $this->_at = $at;
    $this->_type = $type;
    parent::__construct($source_ref);
  }

  <<__Override>>
  public static function fromJSON(
    dict<arraykey, mixed> $json,
    string $file,
    int $initial_offset,
    string $source,
    string $_type_hint,
  ): this {
    $offset = $initial_offset;
    $at = Node::fromJSON(
      ($json['soft_at'] ?? dict['kind' => 'missing']) as dict<_, _>,
      $file,
      $offset,
      $source,
      'Node',
    );
    $offset += $at?->getWidth() ?? 0;
    $type = Node::fromJSON(
      ($json['soft_type'] ?? dict['kind' => 'missing']) as dict<_, _>,
      $file,
      $offset,
      $source,
      'Node',
    );
    $offset += $type?->getWidth() ?? 0;
    $source_ref = shape(
      'file' => $file,
      'source' => $source,
      'offset' => $initial_offset,
      'width' => $offset - $initial_offset,
    );
    return new static(
      /* HH_IGNORE_ERROR[4110] */ $at,
      /* HH_IGNORE_ERROR[4110] */ $type,
      $source_ref,
    );
  }

  <<__Override>>
  public function getChildren(): dict<string, Node> {
    return dict[
      'at' => $this->_at,
      'type' => $this->_type,
    ]
      |> Dict\filter_nulls($$);
  }

  <<__Override>>
  public function rewriteChildren<Tret as ?Node>(
    (function(Node, vec<Node>): Tret) $rewriter,
    vec<Node> $parents = vec[],
  ): this {
    $parents[] = $this;
    $at = $this->_at === null ? null : $rewriter($this->_at, $parents);
    $type = $this->_type === null ? null : $rewriter($this->_type, $parents);
    if ($at === $this->_at && $type === $this->_type) {
      return $this;
    }
    return new static($at as ?Node, $type as ?Node);
  }

  public function getAtUNTYPED(): ?Node {
    return $this->_at;
  }

  public function withAt(?Node $value): this {
    if ($value === $this->_at) {
      return $this;
    }
    return new static($value, $this->_type);
  }

  public function hasAt(): bool {
    return $this->_at !== null;
  }

  /**
   * @return unknown
   */
  public function getAt(): ?Node {
    return $this->_at;
  }

  /**
   * @return unknown
   */
  public function getAtx(): Node {
    return TypeAssert\not_null($this->getAt());
  }

  public function getTypeUNTYPED(): ?Node {
    return $this->_type;
  }

  public function withType(?Node $value): this {
    if ($value === $this->_type) {
      return $this;
    }
    return new static($this->_at, $value);
  }

  public function hasType(): bool {
    return $this->_type !== null;
  }

  /**
   * @return unknown
   */
  public function getType(): ?Node {
    return $this->_type;
  }

  /**
   * @return unknown
   */
  public function getTypex(): Node {
    return TypeAssert\not_null($this->getType());
  }
}
