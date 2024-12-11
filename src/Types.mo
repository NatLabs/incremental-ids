import Set "mo:map/Set";
import Map "mo:map/Map";

module {
    public type Map<K, V> = Map.Map<K, V>;
    public type Set<T> = Set.Set<T>;

    /// Id Generator
    public type Generator = {
        var next_id : Nat;
        var released_ids : Set<Nat>;
    };

    public type Ids = Map<Text, Generator>;

};
