# Keeper (WIP)

## Overview

Keeper is a lending protocol that provides flexible access to capital in a pinch. In addition to that, it also serves as "insurance" to trading positions on leveraged trading platforms e.g [Cadence Protocol](https://www.cadenceprotocol.io/).

## Features

1. **Borrowers**: deposit CANTO and receive NOTE backed stable kUSD
2. **Stability providers**: deposit kUSD to earn yield. OR Deposit NOTE to earn yield in the fees from lenders. Yield in the form of CANTO from liquidated slips.
3. **Stakers**: earn rewards that are paid out in NOTE and CANTO which are gotten from issuance, redemption and protection fees.
4. **Traders**: avoid liquidations on external platforms or borrow from existing cadence positions to add margin and increase leverage.

## Installation

To install Keeper, follow these steps:

1. Clone the repository: `git clone https://github.com/od41/keeper.git`
2. Navigate to the project directory: `cd keeper`
3. Install dependencies: `foundry init`
4. Start the application: `foundry test`

## Usage

1. Connect your wallet to the [frontend](https://keeper-ui.vercel.app).
2. Earn yield when you deposit either CANTO or NOTE to receive kUSD.
3. Protect your perpetual positions on Cadence when you purchase a Keeper protect to prevent capital loss in margin calls.

## Technologies Used

- Frontend: NextJS
- Contracts: Foundry
- Protocol: Canto

## Contributors

- [Odafe](https://twitter.com/elder41_) (@od41)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.

## Acknowledgements

We would like to thank the organizers of [Hackathon Name] for providing us with the opportunity to work on this project.