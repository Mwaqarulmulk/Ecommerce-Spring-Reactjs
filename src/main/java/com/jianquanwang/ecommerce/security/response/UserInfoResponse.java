package com.jianquanwang.ecommerce.security.response;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class UserInfoResponse {
    private Long id;
    private String jwtToken;
    private String username;
    private List<String> roles;

    public UserInfoResponse(Long id, List<String> roles, String username) {
        this.id = id;
        this.roles = roles;
        this.username = username;
    }
}
