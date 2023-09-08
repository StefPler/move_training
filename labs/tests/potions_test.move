
#[test_only]
module labs::potions_test {
    use std::string::{Self};
    use sui::test_scenario::{Self};
    use sui::transfer::{Self};
    use sui::coin::{Self};
    use sui::sui::SUI;

    use labs::potions::{Self, Potion, AdminCap};
    use labs::potion_store::{Self, PotionStore};

    const EInvalidPurity: u64 = 1;

    const ADMIN: address = @0xCAFFE;
    const USER: address = @0xDECAF;
    const BUYER: address = @0xDADA;


    #[test]
    fun mints_potion() {
        let scenario_val = test_scenario::begin(ADMIN);
        let scenario = &mut scenario_val;

        test_scenario::next_tx(scenario, ADMIN);
        {
            let ctx = test_scenario::ctx(scenario);
            potions::init_for_testing(ctx);
        };

        test_scenario::next_tx(scenario, ADMIN);
        {
            let admin_cap = test_scenario::take_from_sender<AdminCap>(scenario);
            let ctx = test_scenario::ctx(scenario);
            let potion = potions::mint_potion(&admin_cap, string::utf8(b"Liquid Luck"), 20, ctx);
            transfer::public_transfer(potion, USER);
            test_scenario::return_to_sender(scenario, admin_cap);
        };

        test_scenario::next_tx(scenario, USER);
        {
            let potion = test_scenario::take_from_sender<Potion>(scenario);
            assert!(potions::potion_purity(&potion) == 20, EInvalidPurity);
            test_scenario::return_to_sender(scenario, potion);
        };


        test_scenario::end(scenario_val);
    }

    #[test]
    #[expected_failure(abort_code=potion_store::ENotEnoughFunds)]
    fun buying_fails_on_invalid_payment() {
        let scenario_val = test_scenario::begin(ADMIN);
        let scenario = &mut scenario_val;

        // Initialize the potions contract (simulating publishing)
        test_scenario::next_tx(scenario, ADMIN);
        {
            let ctx = test_scenario::ctx(scenario);
            potions::init_for_testing(ctx);
        };

        // Initialize the potion_store contract (simulating publishing)
        test_scenario::next_tx(scenario, ADMIN);
        {
            let ctx = test_scenario::ctx(scenario);
            potion_store::init_for_testing(ctx);
        };

        // Create a potion and transfer it to a user
        test_scenario::next_tx(scenario, ADMIN);
        {
            let admin_cap = test_scenario::take_from_sender<AdminCap>(scenario);
            let ctx = test_scenario::ctx(scenario);
            let potion = potions::mint_potion(&admin_cap, string::utf8(b"Liquid Luck"), 35, ctx);
            transfer::public_transfer(potion, USER);
            test_scenario::return_to_sender<AdminCap>(scenario, admin_cap);
        };

        // List a potion in the potion store
        test_scenario::next_tx(scenario, USER);
        let potion = test_scenario::take_from_sender<Potion>(scenario);
        let potion_store = test_scenario::take_shared<PotionStore>(scenario);
        let id = potion_store::list_potion(&mut potion_store, potion);
        test_scenario::return_shared<PotionStore>(potion_store);

        // Buyer tries to buy with insufficient funds
        test_scenario::next_tx(scenario, BUYER);
        {
            let potion_store = test_scenario::take_shared<PotionStore>(scenario);
            let ctx = test_scenario::ctx(scenario);
            let coin = coin::mint_for_testing<SUI>(10, ctx);
            potion_store::buy_listing(&mut potion_store, coin, id, ctx);
            test_scenario::return_shared<PotionStore>(potion_store);
        };

        test_scenario::end(scenario_val);
    }

}   