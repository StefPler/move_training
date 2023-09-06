module labs::afriend {

    friend labs::potions;
    
    struct Example has copy, drop, store {
        field: u64
    }

    public(friend) fun create_example(): Example {
        Example {
            field: 25
        }
    }

}