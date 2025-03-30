package com.jianquanwang.ecommerce.service;

import com.jianquanwang.ecommerce.payload.AddressDTO;
import com.jianquanwang.ecommerce.payload.AddressResponse;

public interface AddressService {
    AddressDTO createAddress(AddressDTO addressDTO);

    AddressResponse getAllAddresses();

    AddressDTO getAddressesById(Long addressId);

    AddressResponse getAddressByUser();

    AddressDTO updateAddress(AddressDTO addressDTO, Long addressId);

    void deleteAddress(Long addressId);
}
