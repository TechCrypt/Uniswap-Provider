// SPDX-License-Identifier: GPL-3.0

pragma solidity =0.6.12;

import "./utils/Ownable.sol";
import "./eth/interfaces/IUniswapV2Factory.sol";
import "./eth/libraries/UniswapV2Library.sol";
import './libraries/TransferHelper.sol';
import "./eth/interfaces/IWETH.sol";
import "./eth/interfaces/IERC20.sol";
import "./libraries/SafeMath.sol";
import "./libraries/Convert.sol";
import "./eth/interfaces/IStorage.sol";


contract TechCUniswapProvider is Ownable {
    using SafeMath for uint256;

    event TechCSwapOperation (
        uint256 amountIn,
        uint256 amountOut,
        address inputToken,
        address outputToken 
    );


    address public WETH;
    address public uniswapFactory;
    address public payment;

    uint256 public providerFee = 1 * 10 ** 7;
    uint256 public constant FEE_DENOMINATOR = 10 ** 10;

    modifier ensure(uint deadline) {
        require(deadline >= block.timestamp, 'TechCUniswapProvider: DEADLINE_EXPIRED');
        _;
    }

    constructor (
        address _weth,
        address _factory,
        address _storage
    ) public {
        require(_weth != address(0), "TechCUniswapProvider: ZERO_WETH_ADDRESS");
        require(_factory != address(0), "TechCUniswapProvider: ZERO_FACTORY_ADDRESS");
        require(_storage != address(0), "TechCUniswapProvider: ZERO_STOAGE_ADDRESS");


        WETH = _weth;
        uniswapFactory = _factory;
        payment = _storage;
    }


    function swapTokensForETHSupportingFee(
        uint amountIn,
        uint swapAmountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external virtual  ensure(deadline) {
        uint amountOut = _swapTokensForETHSupportingFee(amountIn, swapAmountOutMin, path);
        IWETH(WETH).withdraw(amountOut);
        emit TechCSwapOperation(amountIn, amountOut, path[0], path[1]);
        TransferHelper.safeTransferETH(payment, amountOut);
        IStorage(payment).addPartner(path[1], to, amountOut, msg.sender);
    }
       
    

    function _swapTokensForETHSupportingFee(
        uint amountIn,
        uint swapAmountOutMin,
        address[] calldata path
    ) internal virtual returns (uint) {
        require(path[path.length - 1] == WETH, 'TechCUniswapProvider: INVALID_PATH');
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, UniswapV2Library.pairFor(uniswapFactory, path[0], path[1]), amountIn
        );
        uint balanceBefore = IERC20(WETH).balanceOf(address(this));
        _swap(path, address(this));
        uint amountOut = IERC20(WETH).balanceOf(address(this)).sub(balanceBefore);
        require(amountOut >= swapAmountOutMin, 'TechCUniswapProvider: INSUFFICIENT_OUTPUT_AMOUNT');
        return amountOut;
    }

    function swapTokensForTokensSupportingFee(
        uint amountIn,
        uint swapAmountOutMin,
        address[] calldata path,
        address to,
        uint deadline    
        ) external virtual  ensure(deadline) {
        uint amountOut = _swapTokensForTokensSupportingFee(amountIn, swapAmountOutMin, path);
        emit TechCSwapOperation(amountIn, amountOut, path[0], path[1]);
        TransferHelper.safeTransfer(path[path.length - 1], payment, amountOut);
        IStorage(payment).addPartner(path[path.length - 1], to, amountOut, msg.sender);


    }

    function _swapTokensForTokensSupportingFee(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path
    ) internal virtual returns (uint) {
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, UniswapV2Library.pairFor(uniswapFactory, path[0], path[1]), amountIn
        );
        uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(address(this));
        _swap(path, address(this));
        uint amountOut = IERC20(path[path.length - 1]).balanceOf(address(this)).sub(balanceBefore);
        require(amountOut >= amountOutMin, 'TechCUniswapProvider: INSUFFICIENT_OUTPUT_AMOUNT');
        return amountOut;
    }

    function swapETHForTokensSupportingFee(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external virtual payable ensure(deadline) {
        uint amountOut = _swapETHForTokensSupportingFee(amountOutMin, path);
        emit TechCSwapOperation(msg.value, amountOut, path[0], path[1]);
        TransferHelper.safeTransfer(path[path.length - 1], payment, amountOut);
        IStorage(payment).addPartner(path[path.length - 1], to, amountOut, msg.sender);
    }

    function _swapETHForTokensSupportingFee(
        uint amountOutMin,
        address[] calldata path
    ) internal virtual returns (uint) {
        require(path[0] == WETH, 'TechCUniswapProvider: INVALID_PATH');
        uint amountIn = msg.value;
        require(amountIn > 0, 'TechCUniswapProvider: INSUFFICIENT_INPUT_AMOUNT');
        IWETH(WETH).deposit{value: amountIn}();
        assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(uniswapFactory, path[0], path[1]), amountIn));
        uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(address(this));
        _swap(path, address(this));
        uint amountOut = IERC20(path[path.length - 1]).balanceOf(address(this)).sub(balanceBefore);
        require(amountOut >= amountOutMin, 'TechCUniswapProvider: INSUFFICIENT_OUTPUT_AMOUNT');
        return amountOut;
    }

    function _swap(address[] memory path, address _to) internal virtual {
        for (uint i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0,) = UniswapV2Library.sortTokens(input, output);
            require(IUniswapV2Factory(uniswapFactory).getPair(input, output) != address(0), "TechCUniswapProvider: PAIR_NOT_EXIST");
            IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(uniswapFactory, input, output));
            uint amountInput;
            uint amountOutput;
            {
            (uint reserve0, uint reserve1,) = pair.getReserves();
            (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
            amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
            amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
            }
            (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
            address to = i < path.length - 2 ? UniswapV2Library.pairFor(uniswapFactory, output, path[i + 2]) : _to;
            pair.swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }

    receive() external payable { }

    function withdraw(address token) external onlyOwner{
        if (token == WETH) {
            uint256 wethBalance = IERC20(token).balanceOf(address(this));
            if (wethBalance > 0) {
                IWETH(WETH).withdraw(wethBalance);
            }
            TransferHelper.safeTransferETH(owner(), address(this).balance);
        } else {
            TransferHelper.safeTransfer(token, owner(), IERC20(token).balanceOf(address(this)));
        }
    }

    function setFee(uint _fee) external onlyOwner {
        providerFee = _fee;
    }

    function setUniswapFactory(address _factory) external onlyOwner {
        uniswapFactory = _factory;
    }
}