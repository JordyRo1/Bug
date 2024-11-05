#[starknet::interface]
pub trait IContract2<TContractState> {
    fn set_contract1_value(self: @TContractState, value: u256); 

    fn get_contract1_value(self: @TContractState) -> u256;
    fn set_contract1_dispatcher_value(self: @TContractState, value: u256);
    fn get_contract1_dispatcher_value(self: @TContractState) -> u256;


}

#[starknet::contract]
mod Contract2 {
    use super::IContract2;
    use starknet::{storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess
    }, ContractAddress};
    use bug::contract1::{IContract1Dispatcher, IContract1DispatcherTrait};

    #[storage]
    struct Storage {
        contract1: ContractAddress, 
        contract1_dispatcher: IContract1Dispatcher,
    }

    #[constructor]
    fn constructor(ref self: ContractState, contract1: ContractAddress){
        self.contract1.write(contract1); 
        self.contract1_dispatcher.write(IContract1Dispatcher{contract_address: contract1});
    }

    #[abi(embed_v0)]
    impl IContract2Impl of IContract2<ContractState> {
        fn set_contract1_value(self: @ContractState, value: u256) {
            let contract1 = self.contract1.read(); 
            let dispatcher = IContract1Dispatcher{contract_address: contract1};
            dispatcher.set_value(value); 
        }

        fn get_contract1_value(self: @ContractState) -> u256 {
            let contract1 = self.contract1.read(); 
            let dispatcher = IContract1Dispatcher{contract_address: contract1};
            dispatcher.get_value()
        }

        fn set_contract1_dispatcher_value(self: @ContractState, value: u256) {
            let contract1_dispatcher = self.contract1_dispatcher.read(); 
            contract1_dispatcher.set_value(value); 
        }

        fn get_contract1_dispatcher_value(self: @ContractState) -> u256 {
            let contract1_dispatcher = self.contract1_dispatcher.read(); 
            contract1_dispatcher.get_value()
        }
    }
}
