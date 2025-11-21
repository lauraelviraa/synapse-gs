package br.com.synapse.dao;

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

            // Tenta usar driver definido em variável de ambiente, senão usa H2 (padrão do projeto)
            String driver = System.getenv("DB_DRIVER");
            if (driver == null) {
                driver = "org.h2.Driver";
            }
            Class.forName(driver);

            final String URL = System.getenv("DB_URL");
            final String USERNAME = System.getenv("DB_USER");
            final String PASSWORD = System.getenv("DB_PASSWORD");

            if (URL == null || USERNAME == null || PASSWORD == null) {
                // Se não houver variáveis de ambiente e estiver usando H2, usa as configurações padrão em memória
                if ("org.h2.Driver".equals(driver)) {
                    connection = DriverManager.getConnection("jdbc:h2:mem:synapse;DB_CLOSE_DELAY=-1", "sa", "");
                } else {
                    throw new RuntimeException("Variáveis de ambiente do banco não configuradas.");
                }
            } else {
                connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            }

        } catch (SQLException e) {
            System.out.println("Erro de SQL: " + e.getMessage());
        } catch (ClassNotFoundException e) {
            System.out.println("Erro nome da classe: " + e.getMessage());
        }
        return connection;
    }

    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (Exception e) {
            System.out.println("Erro: " + e.getMessage());
        }
    }
}
