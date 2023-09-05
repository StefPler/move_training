# Move training
Move training material

## Session 1 ([Zoom Recording](https://mystenlabs.zoom.us/rec/share/tRwFdohU5itg8IdFGHfMYWptYBGhQUxGPPGCpf3_aHI15I_nCax_lLfuBmbbK9zG.nLNYOgZr26l4CgsY?startTime=1693901215000))
- Created a simple contract that mints an object, mutates and deletes it.
- Went over basic concepts like primitives, syntax & grammar.
- Deployed the contract on testnet: `sui client publish --gas-budget 200000000`
- Interacted with the contract using the explorer & `sui client call` command.
  - export in the terminal as variables the `packageId` and `potionId` 
  - `sui client call --package $packageId --module potions --function drink_potion --args $potionId --gas-budget 10000000`
  - Fund your account via the Sui Discord faucet channels (or ask me for some funds :D)

## Useful cli commands
- Check active account funds `sui client gas`
- Check active account address `sui client active-address`
- Create a new account `sui keytool generate ed25519`
- Import an existing wallet from a mnemonic `sui keytool import <mnemonic> <key_scheme>`