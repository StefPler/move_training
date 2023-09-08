import { config } from "dotenv";
import { SuiClient, getFullnodeUrl } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { TransactionBlock } from "@mysten/sui.js/transactions";
config({});

const client = new SuiClient({ url: getFullnodeUrl("testnet") });
const keypair = Ed25519Keypair.deriveKeypair(
  process.env.MNEMONIC_PHRASE as string
);

async function mintPotion() {
  console.log("address", keypair.toSuiAddress());

  const tx = new TransactionBlock();

  const potion = tx.moveCall({
    target: `${process.env.PACKAGE_ID}::potions::mint_potion`,
    arguments: [tx.object(process.env.ADMIN_CAP as string), tx.pure("Liquid Luck"), tx.pure(100)],
  });

  // This is also correct.
  // tx.transferObjects([potion], tx.pure(keypair.toSuiAddress()));


  // This is how we split coins from the gas object.
  // let [coin1, coin2] = tx.splitCoins(tx.gas, [tx.pure(10000000), tx.pure(20000000)]);

  // The above method calls the below method behind the scenes.
  tx.moveCall({
    target: `0x2::transfer::public_transfer`,
    arguments: [potion, tx.pure("0xbd439523283f434aaf0b3b7eb67c2836bb75fb2fa25f4beec0374cf93d949fed")],
    typeArguments: [`${process.env.PACKAGE_ID}::potions::Potion`],
  });

  const result = await client.signAndExecuteTransactionBlock({
    transactionBlock: tx,
    signer: keypair,
    options: {
      showEffects: true,
    },
  });

  console.log("Execution status", result.effects?.status);
  console.log("Result", result.effects);
}

// mintPotion();

async function mintAndResolveInvoice() {
  console.log("address", keypair.toSuiAddress());
  const herbId =
    "0x08030021871fb9b2c8af453031bd4d336ea65b0e36010312f14f573af1109b03";

  const tx = new TransactionBlock();
  const [potion, invoice] = tx.moveCall({
    target: `${process.env.PACKAGE_ID}::potions::mint_potion`,
    arguments: [tx.pure("Liquid Luck"), tx.pure(20)],
  });

  tx.transferObjects([potion], tx.pure(keypair.toSuiAddress()));

  tx.moveCall({
    target: `${process.env.PACKAGE_ID}::potions::pay_invoice`,
    arguments: [tx.object(herbId), invoice]
  });

  const result = await client.signAndExecuteTransactionBlock({
    transactionBlock: tx,
    signer: keypair,
    options: {
      showEffects: true,
    },
  });

  console.log('Status', result.effects?.status);
  console.log('Result', result);
}

// mintAndResolveInvoice();

async function mintPotionAndList() {
  console.log("address", keypair.toSuiAddress());

  const tx = new TransactionBlock();

  const potion = tx.moveCall({
    target: `${process.env.PACKAGE_ID}::potions::mint_potion`,
    arguments: [tx.object(process.env.ADMIN_CAP as string), tx.pure("Another Potion"), tx.pure(50)],
  });

  tx.moveCall({
    target: `${process.env.PACKAGE_ID}::potion_store::list_potion`,
    arguments: [tx.object(process.env.POTION_STORE as string), potion]
  });

  const result = await client.signAndExecuteTransactionBlock({
    transactionBlock: tx,
    signer: keypair,
    options: {
      showEffects: true,
    },
  });

  console.log("Execution status", result.effects?.status);
  console.log("Result", result.effects);
}

// mintPotionAndList();

async function buyListing(listing: string) {
  const tx = new TransactionBlock();

  let payment = tx.splitCoins(tx.gas, [tx.pure(1000000000)]);

  tx.moveCall({
    target: `${process.env.PACKAGE_ID}::potion_store::buy_listing`,
    arguments: [tx.object(process.env.POTION_STORE as string), payment, tx.pure(listing) ]
  });

  let result = await client.signAndExecuteTransactionBlock({
    transactionBlock: tx,
    signer: keypair,
    options: {
      showEffects: true
    }
  });

  console.log('Status', result.effects?.status);
  console.log('Result', result);
}

buyListing("0xdc129d41bdd1ff5fbefd29d3c7c9ad58df253caf16eaa8e7943b8297b1e8af6f");