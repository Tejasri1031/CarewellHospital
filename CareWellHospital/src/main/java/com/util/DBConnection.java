
package com.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            System.getenv().getOrDefault(
                    "CAREWELL_DB_URL",
                    "jdbc:mysql://localhost:3306/carewell_hospital");

    private static final String USER =
            System.getenv("CAREWELL_DB_USER");

    private static final String PASSWORD =
            System.getenv("CAREWELL_DB_PASSWORD");

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    public static Connection getConnection() throws SQLException {

        if (USER == null || USER.isBlank()
                || PASSWORD == null || PASSWORD.isBlank()) {
            throw new SQLException(
                    "Database credentials are missing. "
                    + "Configure CAREWELL_DB_USER and "
                    + "CAREWELL_DB_PASSWORD.");
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
