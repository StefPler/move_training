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

## Session 2 ([Zoom Recording](https://mystenlabs.zoom.us/rec/share/-Y9nkERCvHuNXoRb9gKAPcc5dCyr1DLpTtvrTSqZCXFBPppTZRaNQrhaiX3f3KwC.wuI45q66z5CUJEOP?startTime=1693988277000))
- Discussed in more detail and wrote simple code examples for struct abilities and function syntax.
- Had a look at library code with a focus in the Option module and how its used instead of null.
- Typescript sui SDK example 
  - Set up the environment
  - Programmable transaction block
  - Smart contract design descisions based on PTB features
      - Re-deployed the latest version of the smart contract & set up a .env file with the new packageId and user mnemonic

## Session 3 ([Zoom Recording](https://mystenlabs.zoom.us/rec/share/J_Fockhq6qAv_bBdf3c4UsbI8aK7r6UidhuU0RGV-0gTY4cjK4OpxfmDeCKrvoYt.5hvxjsC5mzW7KHNM))
- Modified the potions module to study new code patterns:
  - Hot potato.
  - init method.
  - Coin & Balance library modules.
  - Dynamic Object Fields with the introduction of a new potion_store module.
- Tested new concepts and code by calling the contract from the Sui SDK and viewed the results in the explorer.

## Session 4 ([Zoom Recording](https://mystenlabs.zoom.us/rec/share/i3cDA-4CUF5tmT4S3Yn0cnsEeUc_CtfdWR7N0zG7BZPpICG4N5GaFvOJjBKeeP-t.SCNAf1iSZRHDohbB?startTime=1694160144000))
- Corrected Dynamic Object Field Move code example & invoked it from the Sui SDK.
- Implemented a Publisher restricted function to mint AdminCaps and send them to addresses.
  - Had a better look into OTW pattern.
- Viewed how to test Move modules:
  - Testing library, syntax & patterns.
  - Expected success tests.
  - Expected failure tests.
  
## Instructions to set up your vs-code / typescript environment
1. Install the node version manager. For mac you can run `brew install nvm`.
1. Use nvm to install a stable node version, e.g: `nvm install 18.15.0`.
1. Install the typescript compiler globally by running `npm install -g typescript`.
1. Install npm dependencies used in this project by running `npm install @mysten/sui.js dotenv`. If you use the existing scripts folder you only need to run `npm install` which will install all dependencies declared in the `package.json` file.
1. To initialize a typescript project run `tsc --init` inside a new folder.
1. Uncomment the outDir variable from the `tsconfig.json` file and type "dist" as the value.
1. Create a script called "start" in the `package.json` with a value of `tsc && node dist/index.js`.
1. Run `npm run start` to compile and exeucte the script.
1. You can also skip steps 5-8 and use `ts-node programmable_transaction.ts` to run the script directly without getting the transpiled artifacts. This requires to install ts-node globally first by running `npm install -g ts-node`

# Useful environment & tooling information
## VS Code extentions
- GitHub Copilot - for code suggestions
- Git Graph - for a visual representation of the git history
- Move syntax & Move analyzer plugin - for syntax highlighting and error checking
- Prettier - for code formatting
- Tailwind CSS IntelliSense - for tailwind css autocomplete and css snippets (useful for react projects that use tailwind)

## Sui cli commands
- Check active account funds `sui client gas`
- Check active account address `sui client active-address`
- Create a new account `sui keytool generate ed25519`
- Import an existing wallet from a mnemonic `sui keytool import <mnemonic> <key_scheme>`
- Check the curent env `sui client active-env`
- Check all available envs along with their urls `sui client envs`
- To switch to another account or env `sui client switch --address <address>` and `sui client switch --env <environment>` respectively.
- To set a new environment `sui client new-env --alias <name_of_network> --rpc <url_of_FN>`
