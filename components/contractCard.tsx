`use client`
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"

export default function ContractCard(props: {name: string, address: string}) {

  return (
    <div className=" flex items-center space-x-4 rounded-md border p-4 w-full mt-4">
        <div className="flex-1 space-y-1">
        <p className="text-sm font-medium leading-none">
            {props.name}
        </p>
        <p className="text-sm text-muted-foreground">
            {props.address}
        </p>
        </div>
        <Button>-</Button>
    </div>
  )
}
