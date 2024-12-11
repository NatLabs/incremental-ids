import Set "mo:map/Set";
import Map "mo:map/Map";
import Debug "mo:base/Debug";

import T "Types";

module {

    let { nhash } = Map;

    public func reset(id_gen : T.Generator) {
        id_gen.next_id := 0;
        Set.clear(id_gen.released_ids);
    };

    public func next(id_gen : T.Generator) : Nat {
        if (Set.size(id_gen.released_ids) > 0) {
            let ?id = Set.pop<Nat>(id_gen.released_ids, nhash) else Debug.trap("IncrementalIds Generator.next(): trying to pop from released_ids but it's empty");
            return (id);
        };

        let id = id_gen.next_id;
        id_gen.next_id += 1;
        id;
    };

    public func release(id_gen : T.Generator, id : Nat) {
        if (id_gen.next_id <= id) {
            return;
        };

        if (id_gen.next_id == (id) + 1) {
            id_gen.next_id -= 1;
        } else {
            Set.add(id_gen.released_ids, nhash, id);
        };
    };

};
