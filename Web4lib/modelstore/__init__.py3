import web4_core

# Create LCT (presence primitive) and an Ed25519 keypair
lct, keypair = web4_core.PyLct.new(web4_core.PyEntityType.Human, None)

# Mint into a ledger — LCTs are blockchain tokens; minting is what witnesses presence
ledger = web4_core.PyInMemoryLedger()
receipt = ledger.mint(lct)

# Sign + verify
sig = keypair.sign(b"hello, web4")
assert lct.verify_signature(b"hello, web4", sig)

# Inclusion proof — anyone can verify this LCT is in the ledger without trusting you
proof = ledger.anchor(lct.id)
assert ledger.verify_proof(proof)
