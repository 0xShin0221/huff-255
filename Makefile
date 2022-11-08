
-include .env

# use the "@" to hide the command from your shell 
deploy-goerli :; @forge script script/${contract}.s.sol:Deploy${contract} --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast  -vvvv

verify-goerli :; @forge  verify-contract --chain-id 5  ${deployed-contract-address} script/${contract}.s.sol:Deploy${contract} ${ETHERSCAN_API_KEY} 