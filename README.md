# Keeper (WIP)

## Overview

Keeper is a lending protocol that provides flexible access to capital in a pinch. In addition to that, it also serves as "insurance" to trading positions on leveraged trading platforms e.g [Cadence Protocol](https://www.cadenceprotocol.io/).

## Canto Protocol

1. ASD (Automated Stablecoin Deployment): with the Note backed stablecoin SDK on the Canto network,Keeper receives Note deposits and mints a new stablecoin called kUSD.

2. Note (Canto's unit of account): incorporated Note as the unit of account within the ecosystem.

3. Cadence leveraged trading protocol: connected the borrowed stable to prevent margin liquidation when using leverage on Cadence.


## Benefits

1. **Borrowers**: deposit CANTO and receive NOTE backed stable kUSD
2. **Stability providers**: deposit kUSD to earn yield. OR Deposit NOTE to earn yield in the fees from lenders. Yield in the form of CANTO from liquidated slips.
3. **Traders**: avoid liquidations on external platforms or borrow from existing cadence positions to add margin and increase leverage.
4. **Stakers (Future work)**: earn rewards that are paid out in NOTE and CANTO which are gotten from issuance, redemption and protection fees.

[![Live demo icon](/images/live-demo.png)](https://keeper-ui.vercel.app/)

[Video Demo](https://youtu.be/no-video)

## Contracts

Main: [0x000....000](https://) (Testnet)

## Frontend Repository
[Frontend Repo](https://github.com/od41/keeper-ui)

## Usage

![Screenshot of a borrow on Keeper](/images/keeper-ui-screenshot.png)

#### Borrower/Trader

1. Connect your wallet to [Keeper](https://keeper-ui.vercel.app).
2. Mint some new kUSD by depositing CANTO as collateral.
3. Withdraw your newly created kUSD OR create a leveraged position on Cadence and set the protection parameters to prevent liquidations.

#### Liquidity Provider

1. Deposit Note or kUSD to the liquidity pool to earn yield from:
    - Liquidations
    - borrow fees
    - margin protection fees 

## Technologies Used

- Frontend: NextJS
- Contracts: Foundry
- Protocol: Canto

## Installation

To install Keeper, follow these steps:

1. Clone the repository: `git clone https://github.com/od41/keeper.git`
2. Navigate to the project directory: `cd keeper`
3. Install dependencies: `foundry init`
4. Start the application: `foundry test`

## Contributors

- [Odafe](https://twitter.com/elder41_) (@od41)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.

## Acknowledgements

We would like to thank the organizers of [Hackathon Name] for providing us with the opportunity to work on this project.