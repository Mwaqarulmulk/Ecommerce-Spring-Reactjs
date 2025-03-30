package com.jianquanwang.ecommerce.controller;

import com.jianquanwang.ecommerce.payload.AddressDTO;
import com.jianquanwang.ecommerce.payload.AddressResponse;
import com.jianquanwang.ecommerce.service.AddressService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1")
public class AddressController {
    @Autowired
    AddressService addressService;

    @PostMapping("addresses")
    public ResponseEntity<AddressDTO> createAddress(@Valid @RequestBody AddressDTO addressDTO){
        AddressDTO addedAddressDTO = addressService.createAddress(addressDTO);
        return new ResponseEntity<AddressDTO>(addedAddressDTO, HttpStatus.CREATED);
    }

    @GetMapping("addresses")
    public ResponseEntity<AddressResponse> getAllAddresses(){
        AddressResponse response = addressService.getAllAddresses();
        return new ResponseEntity<AddressResponse>(response, HttpStatus.OK);
    }

    @GetMapping("addresses/{addressId}")
    public ResponseEntity<AddressDTO> getAddressesById(@PathVariable Long addressId){
        AddressDTO addressDTO = addressService.getAddressesById(addressId);
        return new ResponseEntity<>(addressDTO, HttpStatus.OK);
    }

    @GetMapping("users/addresses")
    public ResponseEntity<AddressResponse> getAddressByUser(){
        AddressResponse response = addressService.getAddressByUser();
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PutMapping("addresses/{addressId}")
    public ResponseEntity<AddressDTO>  updateAddress(@Valid @RequestBody AddressDTO addressDTO, @PathVariable Long addressId){
        AddressDTO savedAddressDTO = addressService.updateAddress(addressDTO, addressId);
        return new ResponseEntity<>(savedAddressDTO, HttpStatus.OK);
    }

    @DeleteMapping("addresses/{addressId}")
    public ResponseEntity<String>  deleteAddress(@PathVariable Long addressId){
        addressService.deleteAddress(addressId);
        return new ResponseEntity<>("Address with addressId: " + addressId + " is deleted.", HttpStatus.OK);
    }


}
