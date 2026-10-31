// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract Amm {
    uint public reserveX;
    uint public reserveY;
    uint public mintedShares;
    uint public totalShares;
    uint constant CAP_NUMERATOR = 6;
    uint constant CAP_DENOMINATOR = 10;
    uint constant FEE_NUMERATOR = 90;
    uint constant FEE_DENOMINATOR = 100;
    mapping (address => uint) public shares;

    
    event poolInitiated(uint reserveX, uint reserveY);
    event withdrawalInitiated(uint shares, uint totalShares);
    event swapYforXcomplete(uint amountY, uint amountXout);
    event swapXforYcomplete(uint amountX, uint amountYout);

    error Invalidshareratio(uint amountX, uint amountY, uint reserveX, uint reserveY);
    error Invalidsharebalance(uint shares, uint share);
    error Excessdemand(uint amountX, uint maxXin);

    function pool(uint amountX, uint amountY) external {
        if(totalShares == 0){
            mintedShares = Math.sqrt(amountX * amountY);
            reserveX = amountX;
            reserveY = amountY;
            totalShares = mintedShares;
            emit poolInitiated(reserveX, reserveY);
        }
        else {
            require((amountX/amountY) == (reserveX/reserveY), Invalidshareratio(amountX, amountY, reserveX, reserveY));            
            mintedShares = (amountX * reserveY)/reserveX;
            reserveX += amountX;
            reserveY += amountY;
            totalShares += mintedShares;
            shares[msg.sender] += mintedShares;
        }
    }
    function withdrawPool (uint share) public{
        require(share <= shares[msg.sender], Invalidsharebalance(share, shares[msg.sender]));
        shares[msg.sender] -= share;
        totalShares -= share;
        uint amountX = (share * reserveX)/totalShares; 
        uint amountY;
        reserveX -= amountX;
        reserveY -= amountY;
        emit withdrawalInitiated(shares[msg.sender], totalShares);
    }
    function swapXforY(uint amountX) public{
        uint amountYout;
        uint amountXin;
        uint maxXin;
        maxXin = (reserveX * CAP_NUMERATOR/CAP_DENOMINATOR);
        amountXin = amountX * FEE_NUMERATOR/FEE_DENOMINATOR;
        amountYout = (amountXin * reserveY)/reserveX;
        require(amountX <= maxXin, Excessdemand(amountX, maxXin));
        reserveX += amountX;
        reserveY -= amountYout;
        emit swapXforYcomplete(amountX, amountYout);

    }  
    function swapYforX(uint amountY) public{
        uint amountXout;
        uint amountYin;
        uint maxYin;
        maxYin = (reserveX * CAP_NUMERATOR/CAP_DENOMINATOR);
        amountYin = amountY * FEE_NUMERATOR/FEE_DENOMINATOR;
        amountXout = (amountYin * reserveX)/reserveY;
        require(amountY <= maxYin, Excessdemand(amountY, maxYin));
        reserveY += amountY;
        reserveX -= amountXout;
        emit swapYforXcomplete(amountY, amountXout);
    }        
}
    
    

