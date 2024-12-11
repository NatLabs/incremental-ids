## Incremental Ids

Generates and manages reusable sequential Nat IDs starting from 0.

### Motivation

In many use cases, there is a need to generate sequential Nat Ids. However, releasing some of these IDs can lead to gaps or holes in the sequence. To avoid these gaps and ensure full utilization of the available IDs, a mechanism to reuse the released IDs is necessary. This library addresses this issue by providing a common solution for generating and managing these ids with the ability to release and reuse them.

### Usage

```motoko

  import Ids "mo:incremental-ids";

  stable let ids = Ids.new();

  let foo_ids = Ids.create(ids, "foo");
  let bar_ids = Ids.create(ids, "bar");

  assert Ids.next(ids, "foo") == 0;
  assert Ids.next(ids, "foo") == 1;
  assert Ids.next(ids, "foo") == 2;

  Ids.release(ids, "foo", 1);
  assert Ids.next(ids, "foo") == 1;

  assert Ids.Gen.next(bar_ids) == 0;

```

Can access the id generator by name (`Ids.next(ids, "foo")`) or by reference (`Ids.Gen.next(foo_ids)`).
