package org.csu.util;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;

import java.util.Date;
import java.util.Map;

public class JWTUtil {
    private static final String SECRET = "secret";

    public static String genToken(Map<String, Object> claims) {
        return JWT.create()
                .withClaim("claims",claims)
                .withExpiresAt(new Date(System.currentTimeMillis()+1000*60*60*12))
                .sign(Algorithm.HMAC256(SECRET));
    }

    public static Map<String, Object> parseToken(String token) {
        return JWT.require(Algorithm.HMAC256(SECRET))
                .build()
                .verify(token)
                .getClaim("claims")
                .asMap();
    }
}