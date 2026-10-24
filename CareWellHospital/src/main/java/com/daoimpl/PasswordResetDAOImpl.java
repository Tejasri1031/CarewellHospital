
package com.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

import com.dao.PasswordResetDAO;
import com.util.DBConnection;

public class PasswordResetDAOImpl implements PasswordResetDAO {

    @Override
    public boolean saveResetToken(
            int userId,
            String tokenHash,
            Timestamp expiresAt) {

        String sql =
                "INSERT INTO password_reset_tokens "
                + "(user_id, token_hash, expires_at) "
                + "VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, tokenHash);
            ps.setTimestamp(3, expiresAt);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Integer getUserIdByValidToken(String tokenHash) {

        String sql =
                "SELECT user_id FROM password_reset_tokens "
                + "WHERE token_hash = ? "
                + "AND expires_at > CURRENT_TIMESTAMP "
                + "AND used_at IS NULL";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, tokenHash);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean markTokenAsUsed(String tokenHash) {

        String sql =
                "UPDATE password_reset_tokens "
                + "SET used_at = CURRENT_TIMESTAMP "
                + "WHERE token_hash = ? "
                + "AND expires_at > CURRENT_TIMESTAMP "
                + "AND used_at IS NULL";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, tokenHash);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean invalidatePreviousTokens(int userId) {

        String sql =
                "UPDATE password_reset_tokens "
                + "SET used_at = CURRENT_TIMESTAMP "
                + "WHERE user_id = ? "
                + "AND used_at IS NULL";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean resetPasswordAtomically(
            String tokenHash,
            String hashedPassword) {

        String selectSql =
                "SELECT t.user_id "
                + "FROM password_reset_tokens t "
                + "JOIN users u ON u.user_id = t.user_id "
                + "WHERE t.token_hash = ? "
                + "AND t.expires_at > CURRENT_TIMESTAMP "
                + "AND t.used_at IS NULL "
                + "AND u.status = 'ACTIVE' "
                + "FOR UPDATE";

        String updatePasswordSql =
                "UPDATE users SET password = ? WHERE user_id = ?";

        String consumeTokenSql =
                "UPDATE password_reset_tokens "
                + "SET used_at = CURRENT_TIMESTAMP "
                + "WHERE token_hash = ? "
                + "AND expires_at > CURRENT_TIMESTAMP "
                + "AND used_at IS NULL";

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {
                int userId;

                // Lock the valid token row to prevent concurrent reuse.
                try (PreparedStatement ps =
                             con.prepareStatement(selectSql)) {

                    ps.setString(1, tokenHash);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            con.rollback();
                            return false;
                        }

                        userId = rs.getInt("user_id");
                    }
                }

                try (PreparedStatement ps =
                             con.prepareStatement(updatePasswordSql)) {

                    ps.setString(1, hashedPassword);
                    ps.setInt(2, userId);

                    if (ps.executeUpdate() != 1) {
                        con.rollback();
                        return false;
                    }
                }

                try (PreparedStatement ps =
                             con.prepareStatement(consumeTokenSql)) {

                    ps.setString(1, tokenHash);

                    if (ps.executeUpdate() != 1) {
                        con.rollback();
                        return false;
                    }
                }

                con.commit();
                return true;

            } catch (Exception e) {
                try {
                    con.rollback();
                } catch (Exception rollbackError) {
                    e.addSuppressed(rollbackError);
                }

                throw e;

            } finally {
                try {
                    con.setAutoCommit(true);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

        } catch (Exception e) {
            System.err.println("Password reset transaction failed.");
            e.printStackTrace();
            return false;
        }
    }
}
