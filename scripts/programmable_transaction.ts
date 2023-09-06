import { config } from "dotenv";
import { SuiClient, getFullnodeUrl } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { TransactionBlock } from "@mysten/sui.js/transactions";
config({});

async function mintPotion() {
  const client = new SuiClient({ url: getFullnodeUrl("testnet") });
  const keypair = Ed25519Keypair.deriveKeypair(
    process.env.MNEMONIC_PHRASE as string
  );

  console.log("address", keypair.toSuiAddress());

  const tx = new TransactionBlock();

  const potion = tx.moveCall({
    target: `${process.env.PACKAGE_ID}::potions::mint_potion`,
    arguments: [tx.pure("Liquid Luck"), tx.pure(100)],
  });

  // This is also correct.
  // tx.transferObjects([potion], tx.pure(keypair.toSuiAddress()));

  // The above method calls the below method behind the scenes.
  tx.moveCall({
    target: `0x2::transfer::public_transfer`,
    arguments: [potion, tx.pure(keypair.toSuiAddress())],
    typeArguments: [`${process.env.PACKAGE_ID}::potions::Potion`]
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

mintPotion();
