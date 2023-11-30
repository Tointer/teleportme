"use client"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { ConnectKitButton } from '@/components/ConnectKitButton'
import ContractCard from "@/components/contractCard"
import { useState } from 'react'

export default function Create() {

  const [inputContracts, setInputContracts] = useState<string[]>([])
  const [currentInput, setCurrentInput] = useState<string>('')

  return (
    <main className="flex min-h-screen flex-col items-center justify-start p-4">
      <div className="flex w-full justify-between">
        Project unnamed
        <ConnectKitButton />
      </div>

      <div className="z-10 max-w-5xl w-full items-center justify-center font-mono text-sm lg:flex flex-col p-4">
        Source chain contracts:
        <div className="flex flex-row w-full">
          <Input placeholder="Contract address" onChange={onInputChange} value={currentInput}/>
          <Button onClick={onAddContract}>+</Button>
        </div>
        {inputContracts.map((contract, i) => {
          return <ContractCard name={"Contract "+i} address={inputContracts[i]} key={i}/>
        })}
      </div>

    </main>
  )

  function onInputChange(e: any) {
    setCurrentInput(e.target.value)
  }

  function onAddContract() {
    if(currentInput === '') return
    if(inputContracts.includes(currentInput)) return
    setInputContracts([...inputContracts, currentInput])
    setCurrentInput('')
  }
}


