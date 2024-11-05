

use bug::{contract1::{IContract1Dispatcher, IContract1DispatcherTrait}, contract2::{IContract2Dispatcher, IContract2DispatcherTrait}};
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};


fn deploy_contracts() -> (IContract1Dispatcher, IContract2Dispatcher) {
    let contract1 = declare("Contract1").unwrap().contract_class();
    let (contract_address1, _) = contract1
        .deploy(@array![])
        .unwrap();
    let dispatcher1 = IContract1Dispatcher { contract_address: contract_address1 };

    let contract2 = declare("Contract2").unwrap().contract_class();
    let (contract_address2, _) = contract2
        .deploy(@array![contract_address1.into()])
        .unwrap();
    let dispatcher2 = IContract2Dispatcher { contract_address: contract_address2 };
    (dispatcher1, dispatcher2)
}

#[test]
fn test1(){
    let (contract1, contract2) = deploy_contracts(); 
    let value: u256 = 12345;
    // Try to set directly from contract 1, expected to be working

    let mut res: u256 = contract1.get_value();
    assert(res== 0, 'Wrong initial value');
    contract1.set_value(value); 
    res = contract1.get_value();
    assert(res== value, 'Wrong first value');

    // Try to set contract 1 value through contract 2 without using the stored dispatcher, works too
    let new_value: u256 = 11111; 
    contract2.set_contract1_value(new_value); 
    res = contract2.get_contract1_value();
    assert(res ==  new_value, 'Wrong second value');

    // Try to set contract 1 value through contract 2 using the dispatcher, works
    let final_value: u256 = 998877; 
    contract2.set_contract1_dispatcher_value(final_value); 
    res = contract2.get_contract1_dispatcher_value();
    assert(res ==  final_value, 'Wrong third value');
}