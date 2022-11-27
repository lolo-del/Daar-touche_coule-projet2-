import { ethers } from 'ethers'
import * as ethereum from './ethereum'
//il ya le abi qui nous permet dec communiquer avec le contrat
import { contracts } from '@/contracts.json'
import type { Main } from '$/Main'
//import type { MyShip } from '$/Ship.sol'
import type { MyShip } from '$/Ship.sol'
export type { Main } from '$/Main'



export const correctChain = () => {
  return 31337
}

export const init = async (details: ethereum.Details) => {
  //recup le provider du reseau et la sign quand en modifie des valeur 'set'
  const { provider, signer } = details
  const network = await provider.getNetwork()
  if (correctChain() !== network.chainId) {
    console.error('Please switch to HardHat')
    return null
  }
  const { address, abi } = contracts.Main
  //creer un objet contrat main.sol(adresse de deploiment de main,abi,leprovider du reseau)
  //grace a ce contrat en peut integagire avec ces fonctions
  const contract = new ethers.Contract(address, abi, provider)
  const deployed = await contract.deployed()
  if (!deployed) return null
  const contract_ = signer ? contract.connect(signer) : contract
  return contract_ as any as Main
}

export const myShip = () => contracts.MyShip.address
