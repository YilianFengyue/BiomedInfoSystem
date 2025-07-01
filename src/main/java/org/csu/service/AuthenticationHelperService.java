package org.csu.service;


import org.csu.domain.Users;

import java.util.Map;

public interface AuthenticationHelperService {

    public Map<String, String> handleLoginSuccess(Users user);
}
