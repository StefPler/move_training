module labs::potions {
    // Imports
    use std::string::String;
    use std::option::{Self, Option};

    use sui::object::{Self, UID};
    use sui::tx_context::{TxContext};
    // use sui::transfer;

    // Consts or Error codes

    struct Label has store, drop {
        value: String
    }

    // Structs
    struct Potion has key, store {
        id: UID,
        name: String,
        purity: u64,
        label: Option<Label>
    }

    // Functions
    public fun mint_potion(name: String, purity: u64, ctx: &mut TxContext): Potion {
        let potion = Potion {
            id: object::new(ctx),
            name,
            purity,
            label: option::none<Label>()
        };
        potion
    }

    public fun add_label(potion: &mut Potion, label: String) {
        let label_obj = Label { value: label };
        option::fill(&mut potion.label, label_obj);
    }

    entry fun purify_potion(potion: &mut Potion, purity: u64) {
        if(purity > 100) {
            potion.purity = purity;
        }else {
            potion.purity = potion.purity + purity;
        };
    }

    public fun potion_purity(potion: &Potion): u64 {
        potion.purity
    }

    public fun name(potion: &Potion): &String {
        &potion.name
    }

    fun internal_extract_potion(potion: Potion): u64 {
        let Potion {id, name: _, purity, label: _} = potion;
        object::delete(id);
        purity
    }

    public fun drink_potion(potion: Potion) {
        let _purity = internal_extract_potion(potion);
    }
}