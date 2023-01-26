#!/bin/bash
btcUrl=$(curl 'https://www.mercadobitcoin.net/api/BTC/ticker/' --silent | jq '.ticker.sell' | sed 's/\"//g')
usd=$(curl 'https://economia.awesomeapi.com.br/last/USD-BRL' --silent | jq '.USDBRL.ask' | sed 's/\"//g')

echo "scale=2 ; $btcUrl / $usd" | bc
