
package com.dao;

import java.sql.Timestamp;

public interface PasswordResetDAO {

    boolean saveResetToken(
            int userId,
            String tokenHash,
            Timestamp expiresAt);

    Integer getUserIdByValidToken(String tokenHash);

    boolean markTokenAsUsed(String tokenHash);

    boolean invalidatePreviousTokens(int userId);

    boolean resetPasswordAtomically(
            String tokenHash,
            String hashedPassword);
}
