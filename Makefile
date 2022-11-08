
-include .env

# use the "@" to hide the command from your shell 
deploy-goerli :; @forge script script/${contract}.s.sol:Deploy${contract} --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast  -vvvv

verify-goerli :; @forge  verify-contract --chain-id 5  0xB435C82a6729460B981fAd7003630F9Fa8BcA43b script/${contract}.s.sol:Deploy${contract} ${ETHERSCAN_API_KEY} 