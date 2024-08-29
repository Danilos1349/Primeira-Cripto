// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IERC20{
    //getters
    function totalSupply() external view returns (uint256); // função de consulta que retorna um númeoro inteiro = ao total de tokens do contrato
    function balanceOf(address account) external view returns (uint256); // Ver o endereço de uma carteira / saldo do endereço
    function allowance(address owner, address spender) external view returns (uint256); // vai permitir que um endereço possa gastar o saldo de outro endereço

    //function
    function transfer(address recipient, uint256 amount) external returns (bool); // amount = quantidade de tokens enviados / bool = vai informar se foi transferido ou não
    function approve (address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    //event
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256); // indexed = se referem as variáveis de endereço atreladas a um evento

}

contract ChinaCoin is IERC20 {

    string public constant name = "China Coin";
    string public constant symbol = "CHINA";
    uint8 public constant decimals = 18;

    mapping (address => uint256) balances;

    mapping (address => mapping(address => uint256)) allowed;

    uint256 totalSupply_ = 10 ether;

    constructor (){
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() external view returns (uint256){
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256){
        return balances[tokenOwner];
    }
    
    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}