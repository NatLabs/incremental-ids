import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Prelude "mo:base/Prelude";
import Buffer "mo:base/Buffer";

import Bench "mo:bench";
import Fuzz "mo:fuzz";

import Ids "../src";

module {
    public func init() : Bench.Bench {
        let bench = Bench.Bench();

        bench.name("Benchmarking the Incremental Ids");
        bench.description("Benchmarking the performance with 10k calls");

        bench.cols(["Incremental Ids"]);
        bench.rows([
            "next()",
            "sequential release()",
            "next() - reuse released ids",
            "random release() in large key space",
        ]);

        let fuzz = Fuzz.Fuzz();

        let ids = Ids.new();
        let foo_ids = Ids.create(ids, "foo");
        let bar_ids = Ids.create(ids, "bar");

        let limit = 10_000;

        let random_ids_in_keyspace_of_10M = Buffer.Buffer<Nat>(limit);
        for (i in Iter.range(0, limit)) {
            random_ids_in_keyspace_of_10M.add(fuzz.nat.randomRange(0, 10_000_000));
        };

        bench.runner(
            func(row, col) = switch (col, row) {

                case ("Incremental Ids", "next()") {
                    for (i in Iter.range(0, 9_999)) {
                        ignore Ids.Gen.next(foo_ids);
                    };

                    ignore Ids.Gen.next(foo_ids); // 1 extra to prevent the sequence of ids ending at the current next_id from being removed
                };

                case ("Incremental Ids", "sequential release()") {
                    for (i in Iter.range(0, 9_999)) {
                        Ids.Gen.release(foo_ids, i);
                    };
                };

                case ("Incremental Ids", "next() - reuse released ids") {
                    for (i in Iter.range(0, 9_999)) {
                        ignore Ids.Gen.next(foo_ids);
                    };
                };

                case ("Incremental Ids", "random release() in large key space") {
                    bar_ids.next_id := 10_000_000;

                    for (i in random_ids_in_keyspace_of_10M.vals()) {
                        Ids.Gen.release(bar_ids, i);
                    };
                };

                case (_) {
                    Debug.trap("Should be unreachable:\n row = \"" # debug_show row # "\" and col = \"" # debug_show col # "\"");
                };
            }
        );

        bench;
    };
};
