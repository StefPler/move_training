module labs::potions {
    // Imports
    use std::string::String;
    use std::option::{Self, Option};

    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::package::{Self, Publisher};

    // Consts or Error codes
    const POTION_MASTER: address = @0xb862ab02807a85466d98bc677d84ffceb58c7864fd3b29f885d049f1f7c30c44;
    const EInvalidAmount: u64 = 1;
    const ECallerNotPublisher: u64 = 2;

    struct Label has store, drop {
        value: String
    }

    struct MagicalInvoice {
        value: u64
    }

    struct Herbs has key, store {
        id: UID,
        amount: u64
    }

    struct AdminCap has key, store {
        id: UID
    }

    // Structs
    struct Potion has key, store {
        id: UID,
        name: String,
        purity: u64,
        label: Option<Label>
    }

    struct POTIONS has drop {}
    // Functions

    fun init(otw: POTIONS, ctx: &mut TxContext) {
        let herb = Herbs {
            id: object::new(ctx),
            amount: 1
        };
        transfer::public_transfer(herb, tx_context::sender(ctx));
        let admin_cap = AdminCap { id: object::new(ctx) };
        transfer::public_transfer(admin_cap, tx_context::sender(ctx));
        package::claim_and_keep(otw, ctx);
    }

    // Only publisher can call this function
    public fun make_address_admin(publisher: &Publisher, new_admin: address, ctx: &mut TxContext) {
        let is_package_publisher = package::from_module<Potion>(publisher);
        assert!(is_package_publisher, ECallerNotPublisher);
        let admin_cap = AdminCap {
            id: object::new(ctx)
        };
        transfer::public_transfer(admin_cap, new_admin);
    }

    public fun mint_potion_hot_potato(name: String, purity: u64, ctx: &mut TxContext): (Potion, MagicalInvoice) {
        let potion = Potion {
            id: object::new(ctx),
            name,
            purity,
            label: option::none<Label>()
        };
        let invoice = MagicalInvoice { value: 1};
        (potion, invoice)
    }

    public fun mint_potion(_: &AdminCap, name: String, purity: u64, ctx: &mut TxContext): Potion {
        let potion = Potion {
            id: object::new(ctx),
            name,
            purity,
            label: option::none<Label>()
        };
        potion
    }

    public fun pay_invoice(herbs: Herbs, invoice: MagicalInvoice) {
        let MagicalInvoice { value } = invoice;
        assert!(herbs.amount == value,  EInvalidAmount);
        transfer::public_transfer(herbs, POTION_MASTER);
    }

    public fun mix_potions(potion1: Potion, potion2: &mut Potion, ctx: &mut TxContext): Herbs {
        let bonus_purity = internal_extract_potion(potion1);
        let existing_purity = potion_purity(potion2);
        purify_potion(potion2, existing_purity + bonus_purity);
        Herbs { id: object::new(ctx), amount: 1}
    }

    public fun add_label(potion: &mut Potion, label: String) {
        let label_obj = Label { value: label };
        option::fill(&mut potion.label, label_obj);
    }

    entry fun purify_potion(potion: &mut Potion, purity: u64) {
        potion.purity = purity;
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

    public fun borrow_uid(potion: &Potion): &UID {
        &potion.id
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(POTIONS{}, ctx);
    }
}

