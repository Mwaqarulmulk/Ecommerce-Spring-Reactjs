package com.jianquanwang.ecommerce.service.impl;

import com.jianquanwang.ecommerce.exceptions.APIException;
import com.jianquanwang.ecommerce.exceptions.ResourceNotFoundException;
import com.jianquanwang.ecommerce.model.Address;
import com.jianquanwang.ecommerce.model.User;
import com.jianquanwang.ecommerce.payload.AddressDTO;
import com.jianquanwang.ecommerce.payload.AddressResponse;
import com.jianquanwang.ecommerce.repositories.AddressRepository;
import com.jianquanwang.ecommerce.repositories.UserRepository;
import com.jianquanwang.ecommerce.service.AddressService;
import com.jianquanwang.ecommerce.util.AuthUtil;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AddressServiceImpl implements AddressService {
    @Autowired
    private AddressRepository addressRepository;
    @Autowired
    private ModelMapper modelMapper;
    @Autowired
    private AuthUtil authUtil;
    @Autowired
    private UserRepository userRepository;

    @Override
    public AddressDTO createAddress(AddressDTO addressDTO) {
        User user = authUtil.loggedInUser();
        Address address = modelMapper.map(addressDTO, Address.class);
        List<Address> addresses = user.getAddresses();
        addresses.add(address);
        user.setAddresses(addresses);
        userRepository.save(user);
        address.setUser(user);
        Address savedAddress = addressRepository.save(address);
        return modelMapper.map(savedAddress, AddressDTO.class);
    }

    @Override
    public AddressResponse getAllAddresses() {
        List<Address> addresses = addressRepository.findAll();
        if (addresses.isEmpty()) {
            throw new APIException("No addresses found.");
        }
        AddressResponse response = new AddressResponse();
        response.setContent(addresses.stream().map( address ->{
                    return modelMapper.map(address, AddressDTO.class);
                }).toList()
        );

        return response;
    }

    @Override
    public AddressDTO getAddressesById(Long addressId) {
        Address address = addressRepository.findById(addressId).orElseThrow(()->new ResourceNotFoundException("Address", "AddressId", addressId));
        return modelMapper.map(address, AddressDTO.class);
    }

    @Override
    public AddressResponse getAddressByUser() {
        User user = authUtil.loggedInUser();
        List<Address> addresses = user.getAddresses();
        AddressResponse response = new AddressResponse();
        response.setContent(addresses.stream().map( address ->{
                    return modelMapper.map(address, AddressDTO.class);
                }).toList()
        );

        return response;
    }

    @Override
    public AddressDTO updateAddress(AddressDTO addressDTO, Long addressId) {
        Address existingAddress = addressRepository.findById(addressId).orElseThrow(
                ()->new ResourceNotFoundException("Address", "AddressId", addressId)
        );
        Address address = modelMapper.map(addressDTO, Address.class);
        address.setAddressId(existingAddress.getAddressId());
        User user = existingAddress.getUser();
        user.getAddresses().removeIf(addressItem -> addressItem.getAddressId().equals(addressId));
        user.getAddresses().add(address);
        addressRepository.save(address);
        userRepository.save(user);
        return modelMapper.map(address, AddressDTO.class);
    }

    @Override
    public void deleteAddress(Long addressId) {
        Address existingAddress = addressRepository.findById(addressId).orElseThrow(
                ()->new ResourceNotFoundException("Address", "AddressId", addressId)
        );
        User user = existingAddress.getUser();
        user.getAddresses().removeIf(address -> address.getAddressId().equals(addressId));
        userRepository.save(user);
        addressRepository.deleteById(addressId);
    }
}
