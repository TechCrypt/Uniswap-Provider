# обмен токенов Pancakeswap


> **Contract Address**: 0x114856d2b4737F8423f632787818Df0c3fD7dec2

###  Method swapTokensForETHSupportingFee()

```
    amountIn - required|uint256 // сумма на которую хотите обменять
    swapAmountOutMin - required|uint256 // сумму которую хотите получить
    path - required|array // массив адресов токенов для обмена
    to - required|address // адрес, куда поступят токены
    deadline - required|uint256 // время, за которое должна выполниться транзакция
```
##### Пример:

```
contract = web3.eth.contract(abi=abi, address=address)
amountIn = 100000000;
swapAmountOutMin = 100000000000000;
path = ['0x07de306FF27a2B630B1141956844eB1552B956B5', '0xd0A1E359811322d97991E03f863a0C30C2cF029C'] // usdt address, wrapper eth address
to = 0xb62031Fc947998cB9B55f170566D521E7EdEEF40
deadline = Math.floor(Date.now() / 1000) + 60 * 20
tx = contract.functions.swapTokensForETHSupportingFee(amountIn, swapAmountOutMin, path, to, deadline).buildTransaction({
            "nonce": nonce,
            "from": from_wallet,
            "chainId": 42,
        })
        signed_tx = w3.eth.account.sign_transaction(tx, private_key)
        tx_hash = w3.eth.sendRawTransaction(signed_tx.rawTransaction)
        print("hash:", w3.toHex(tx_hash))
        return {"hash": w3.toHex(tx_hash)}
```

###  Method swapETHForTokensSupportingFee()

```
    swapAmountOutMin - required|uint256 // сумму которую хотите получить
    path - required|array // массив адресов токенов для обмена
    to - required|address // адрес, куда поступят токены
    deadline - required|uint256 // время, за которое должна выполниться транзакция
```
##### Пример:

```
contract = web3.eth.contract(abi=abi, address=address)
swapAmountOutMin = 100000000000000;
path = ['0xd0A1E359811322d97991E03f863a0C30C2cF029C', '0x07de306FF27a2B630B1141956844eB1552B956B5'] //  wrapper eth address, usdt address
to = 0xb62031Fc947998cB9B55f170566D521E7EdEEF40
deadline = Math.floor(Date.now() / 1000) + 60 * 20
tx = contract.functions.swapETHForTokensSupportingFee(swapAmountOutMin, path, to, deadline).buildTransaction({
            "nonce": nonce,
            "from": from_wallet,
            "chainId": 42,
            "value": web3.toWei(1, 'ether')
        })
        signed_tx = w3.eth.account.sign_transaction(tx, private_key)
        tx_hash = w3.eth.sendRawTransaction(signed_tx.rawTransaction)
        print("hash:", w3.toHex(tx_hash))
        return {"hash": w3.toHex(tx_hash)}
```


###  Method swapTokensForTokensSupportingFee()

```
    amountIn - required|uint256 // сумма на которую хотите обменять
    swapAmountOutMin - required|uint256 // сумму которую хотите получить
    path - required|array // массив адресов токенов для обмена
    to - required|address // адрес, куда поступят токены
    deadline - required|uint256 // время, за которое должна выполниться транзакция

```
##### Пример:

```
contract = web3.eth.contract(abi=abi, address=address)
amountIn = 100000000000000;
swapAmountOutMin = 100000000000000;
path = ['0x07de306FF27a2B630B1141956844eB1552B956B5', '0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa'] // usdt address, dai address
to = 0xb62031Fc947998cB9B55f170566D521E7EdEEF40
deadline = Math.floor(Date.now() / 1000) + 60 * 20
tx = contract.functions.swapTokensForTokensSupportingFee(amountIn, swapAmountOutMin, path, to, deadline).buildTransaction({
            "nonce": nonce,
            "from": from_wallet,
            "chainId": 42,
        })
        signed_tx = w3.eth.account.sign_transaction(tx, private_key)
        tx_hash = w3.eth.sendRawTransaction(signed_tx.rawTransaction)
        print("hash:", w3.toHex(tx_hash))
        return {"hash": w3.toHex(tx_hash)}
```