import Text "mo:base/Text";
import Set "mo:map/Set";
import Map "mo:map/Map";
import Debug "mo:base/Debug";

import GeneratorModule "Generator";
import T "Types";

module {

    type Map<K, V> = Map.Map<K, V>;
    type Set<T> = Set.Set<T>;

    let { thash } = Map;

    public let Gen = GeneratorModule;
    public type Gen = T.Generator;

    public let Generator = GeneratorModule;
    public type Generator = T.Generator;

    public type Ids = T.Ids;

    public func new() : T.Ids {
        return Map.new();
    };

    public func create(ids : T.Ids, key : Text) : T.Generator {

        switch (Map.get(ids, thash, key)) {
            case (?id_gen) return id_gen;
            case (null) {};
        };

        let id_gen = {
            var next_id = 0;
            var released_ids = Set.new<Nat>();
        };

        ignore Map.put(ids, thash, key, id_gen);

        return (id_gen);
    };

    public func reset(ids : T.Ids, key : Text) {

        switch (Map.get(ids, thash, key)) {
            case (?id_gen) {
                Generator.reset(id_gen);
            };
            case (null) Debug.trap("IncrementalIds.reset(): id key '" # key # "' not found");
        };

    };

    public func next(ids : T.Ids, key : Text) : (Nat) {

        let id_gen = switch (Map.get(ids, thash, key)) {
            case (?id_gen) id_gen;
            case (null) Debug.trap("IncrementalIds.next(): id key '" # key # "' not found");
        };

        Generator.next(id_gen);
    };

    public func release(ids : T.Ids, key : Text, id : Nat) {

        let id_gen = switch (Map.get(ids, thash, key)) {
            case (?id_gen) id_gen;
            case (null) Debug.trap("IncrementalIds.release(): id key '" # key # "' not found");
        };

        Generator.release(id_gen, id);

    };

};
