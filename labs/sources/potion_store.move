module labs::potion_store {

    use sui::object::{Self, UID, ID};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;
    use sui::tx_context::{Self, TxContext};
    use sui::transfer::{Self};
    use sui::dynamic_object_field::{Self as dof};

    use labs::potions::{Self, Potion};

    const LISTING_PRICE: u64 = 1000000000;
    const ENotEnoughFunds: u64 = 1;
    const EAnotherError: u64 = 2;

    struct PotionStore has key, store {
        id: UID,
        balance: Balance<SUI>,
    }

    struct Listing has copy, drop, store {
        id: ID,
        price: u64
    }

    fun init(ctx: &mut TxContext) {
        let potion_store = PotionStore {
            id: object::new(ctx),
            balance: balance::zero()
        };
        transfer::share_object(potion_store);
    }

    public fun list_potion(potion_store: &mut PotionStore, potion: Potion): ID {
        let potion_uid_ref = potions::borrow_uid(&potion);
        let id = object::uid_to_inner(potion_uid_ref);
        let listing = Listing { id, price: LISTING_PRICE };
        dof::add<Listing, Potion>(&mut potion_store.id, listing, potion);
        id
    }

    public fun buy_listing(potion_store: &mut PotionStore, payment: Coin<SUI>, listing_id: ID, ctx: &mut TxContext) {
        let listing = Listing { id: listing_id, price: LISTING_PRICE};
        assert!(coin::value(&payment) == LISTING_PRICE, ENotEnoughFunds);

        let payment_in_balance = coin::into_balance(payment);
        balance::join(&mut potion_store.balance, payment_in_balance);
        
        let potion = dof::remove<Listing, Potion>(&mut potion_store.id, listing);
        transfer::public_transfer(potion, tx_context::sender(ctx));
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(ctx)
    }
}