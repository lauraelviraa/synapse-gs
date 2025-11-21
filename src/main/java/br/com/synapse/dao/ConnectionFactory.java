package br.com.synapse.dao; // ajuste o package conforme seu projeto

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {
    private static Connection connection;

    public static Connection getConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                return connection;
            }

            // Lê variáveis de ambiente (defina no Render)
            final String URL = System.getenv("DB_URL");
            final String USER = System.getenv("DB_USER");
            final String PASS = System.getenv("DB_PASSWORD");
            final String DRIVER = System.getenv("DB_DRIVER") != null ? System.getenv("DB_DRIVER") : "oracle.jdbc.driver.OracleDriver";

            if (URL == null || USER == null || PASS == null) {
                throw new RuntimeException("Variáveis de ambiente do banco não configuradas (DB_URL/DB_USER/DB_PASSWORD).");
            }

            Class.forName(DRIVER);
            connection = DriverManager.getConnection(URL, USER, PASS);
            return connection;
        } catch (SQLException e) {
            throw new RuntimeException("Erro de SQL: " + e.getMessage(), e);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver JDBC não encontrado: " + e.getMessage(), e);
        }
    }

    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            System.err.println("Erro ao fechar conexão: " + e.getMessage());
        }
    }
}
