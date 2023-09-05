module labs::potions {
    // Imports
    use std::string::String;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;


    // Consts or Error codes

    // Structs
    struct Potion has key {
        id: UID,
        name: String,
        purity: u64
    }

    // Functions
    public entry fun mint_potion(name: String, purity: u64, ctx: &mut TxContext) {
        let potion = Potion {
            id: object::new(ctx),
            name,
            purity
        };
        transfer::transfer(potion, tx_context::sender(ctx));
    }

    entry fun purify_potion(potion: &mut Potion, purity: u64) {
        if(purity > 100) {
            potion.purity = purity;
        }else {
            potion.purity = potion.purity + purity;
        };


    }

    public fun get_potion_purity(potion: &Potion): u64 {
        potion.purity
    }

    public fun drink_potion(potion: Potion) {
        let Potion {id, name: _, purity: _} = potion;
        object::delete(id);
    }
}