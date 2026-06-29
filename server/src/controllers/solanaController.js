const { Connection, PublicKey } = require('@solana/web3.js');

const connection = new Connection(process.env.SOLANA_RPC_URL || 'https://api.devnet.solana.com');

async function getHealth(req, res) {
  try {
    const slot = await connection.getSlot();
    res.json({ status: 'ok', slot });
  } catch (error) {
    res.status(500).json({ error: 'Solana RPC failed', details: error.message });
  }
}

async function getBalance(req, res) {
  try {
    const pubkey = new PublicKey(req.params.address);
    const balance = await connection.getBalance(pubkey);
    res.json({ address: req.params.address, balance });
  } catch (error) {
    res.status(400).json({ error: 'Invalid Solana address', details: error.message });
  }
}

module.exports = { getHealth, getBalance };
