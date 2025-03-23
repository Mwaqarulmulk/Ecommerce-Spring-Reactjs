package com.jianquanwang.ecommerce.security.service;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.jianquanwang.ecommerce.model.User;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Data
@EqualsAndHashCode
public class UserDetailsImpl implements UserDetails {
    public static final long serialVersionUID = 1L;

    private Long id;
    private String username;
    private String email;
    @JsonIgnore
    private String password;
    private Collection<? extends GrantedAuthority> authorities;

    public static UserDetailsImpl build(User user) {
        List<SimpleGrantedAuthority> authorities = user.getRoles().stream()
                .map(role -> new SimpleGrantedAuthority(role.getRoleName().name()))
                .toList();
        return new UserDetailsImpl(user.getUserId(),
                user.getUserName(),
                user.getEmail(),
                user.getPassword(),
                authorities);
    }

}
