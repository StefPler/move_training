module labs::potion_store {

    use sui::object::{Self, UID};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;
    use sui::tx_context::{Self, TxContext};
    use sui::transfer::{Self};
    use sui::dynamic_object_field::{Self as dof};

    use labs::potions::{Potion};

    const ENotEnoughFunds: u64 = 1;

    struct PotionStore has key, store {
        id: UID,
        balance: Balance<SUI>,
    }

    struct Listing has copy, drop, store {
        price: u64
    }

    fun init(ctx: &mut TxContext) {
        let potion_store = PotionStore {
            id: object::new(ctx),
            balance: balance::zero()
        };
        transfer::share_object(potion_store);
    }

    public fun list_potion(potion_store: &mut PotionStore, potion: Potion) {
        let listing = Listing { price: 1000000000 };
        dof::add<Listing, Potion>(&mut potion_store.id, listing, potion);
    }

    public fun buy_listing(potion_store: &mut PotionStore, listing: Listing, payment: Coin<SUI>, ctx: &mut TxContext) {
        assert!(coin::value(&payment) == listing.price, ENotEnoughFunds);

        let payment_in_balance = coin::into_balance(payment);
        balance::join(&mut potion_store.balance, payment_in_balance);
        
        let potion = dof::remove<Listing, Potion>(&mut potion_store.id, listing);
        transfer::public_transfer(potion, tx_context::sender(ctx));
    }
}