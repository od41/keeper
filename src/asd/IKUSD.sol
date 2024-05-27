// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

interface IKUSD {

    /// @notice Mint amount of asD tokens by providing NOTE. The NOTE:asD exchange rate is always 1:1
    /// @param _amount Amount of tokens to mint
    /// @dev User needs to approve the asD contract for _amount of NOTE
    function mint(uint256 _amount) external;


    function mintFromContract(uint256 _amount, address _account) external;

    /// @notice Burn amount of asD tokens to get back NOTE. Like when minting, the NOTE:asD exchange rate is always 1:1
    /// @param _amount Amount of tokens to burn
    function burn(uint256 _amount) external;

    /// @notice Withdraw the interest that accrued, only callable by the owner.
    /// @param _amount Amount of NOTE to withdraw. 0 for withdrawing the maximum possible amount
    /// @dev The function checks that the owner does not withdraw too much NOTE, i.e. that a 1:1 NOTE:asD exchange rate can be maintained after the withdrawal
    function withdrawCarry(uint256 _amount) external;

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);
}