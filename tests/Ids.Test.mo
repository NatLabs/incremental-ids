// @testmode wasi
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import { test; suite } "mo:test";

import Ids "../src";

suite(
    "Incremental Ids",
    func() {
        test(
            "Id Generator test",
            func() {
                let ids = Ids.new();

                let foo_ids = Ids.create(ids, "foo");
                let bar_ids = Ids.create(ids, "bar");

                assert Ids.next(ids, "foo") == 0;
                assert Ids.Gen.next(foo_ids) == 1;
                assert Ids.next(ids, "foo") == 2;

                Ids.release(ids, "foo", 1);
                assert Ids.next(ids, "foo") == 1;

                assert Ids.Gen.next(bar_ids) == 0;
                assert Ids.next(ids, "bar") == 1;
                assert Ids.Gen.next(bar_ids) == 2;

                Ids.Gen.release(bar_ids, 1);
                assert Ids.Gen.next(bar_ids) == 1;
            },
        );
    },
);
