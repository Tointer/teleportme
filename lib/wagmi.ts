import { getDefaultConfig } from 'connectkit'
import { createConfig } from 'wagmi'

const walletConnectProjectId = '63830a6d331bc470c8b569eb4cd46f77'

export const config = createConfig(
  getDefaultConfig({
    autoConnect: true,
    appName: 'teleportme',
    walletConnectProjectId,
  })
)
