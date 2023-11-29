`use client`
import { Button } from "@/components/ui/button"
import { ConnectKitButton } from '@/components/ConnectKitButton'

export default function Create() {

  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
    <ConnectKitButton />

    <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm lg:flex">
      <Button>Click me</Button>
    </div>

    </main>
  )
}
