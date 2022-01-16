# SSH Configuration

## Authorised (Public) Keys - Remote

### infra-ed25519
`curl https://raw.githubusercontent.com/OllieJC/home-network-public/main/ssh/home-network-infra-ed25519.pub >> ~/.ssh/authorized_keys`

### infra-RSA
`curl https://raw.githubusercontent.com/OllieJC/home-network-public/main/ssh/home-network-infra-rsa.pub >> ~/.ssh/authorized_keys`

## Authorised (Public) Keys - Local

### infra-ed25519
`cat ~/github/home-network-public/ssh/home-network-infra-ed25519.pub >> ~/.ssh/authorized_keys`

### infra-RSA
`cat ~/github/home-network-public/ssh/home-network-infra-rsa.pub >> ~/.ssh/authorized_keys`
