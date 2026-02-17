#!/bin/bash

RPC_URL="https://cloudflare-eth.com"

function rpc_call() {
  METHOD=$1
  PARAMS=$2

  curl -s -X POST $RPC_URL \
    -H "Content-Type: application/json" \
    -d "{
      \"jsonrpc\":\"2.0\",
      \"method\":\"$METHOD\",
      \"params\":$PARAMS,
      \"id\":1
    }" | jq
}

function latest_block() {
  rpc_call "eth_blockNumber" "[]"
}

function get_block() {
  read -p "Enter block number (hex or decimal): " BLOCK
  if [[ $BLOCK != 0x* ]]; then
    BLOCK=$(printf "0x%x" $BLOCK)
  fi
  rpc_call "eth_getBlockByNumber" "[\"$BLOCK\", true]"
}

function get_tx() {
  read -p "Enter transaction hash: " HASH
  rpc_call "eth_getTransactionByHash" "[\"$HASH\"]"
}

function get_balance() {
  read -p "Enter wallet address: " ADDRESS
  rpc_call "eth_getBalance" "[\"$ADDRESS\", \"latest\"]"
}

function chain_id() {
  rpc_call "eth_chainId" "[]"
}

function gas_price() {
  rpc_call "eth_gasPrice" "[]"
}

while true; do
  echo ""
  echo "====== CLI Blockchain Explorer ======"
  echo "1. Latest Block Number"
  echo "2. Get Block By Number"
  echo "3. Get Transaction By Hash"
  echo "4. Get Address Balance"
  echo "5. Get Chain ID"
  echo "6. Current Gas Price"
  echo "0. Exit"
  echo "====================================="
  read -p "Select option: " OPTION

  case $OPTION in
    1) latest_block ;;
    2) get_block ;;
    3) get_tx ;;
    4) get_balance ;;
    5) chain_id ;;
    6) gas_price ;;
    0) exit 0 ;;
    *) echo "Invalid option" ;;
  esac
done
