-- Criação das tabelas esperadas pela aplicação (H2 / compatível com outros DBs)
CREATE TABLE IF NOT EXISTS usuario (
    id BIGINT PRIMARY KEY,
    nome VARCHAR(255),
    email VARCHAR(255),
    tipoPerfil VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS trilha (
    id BIGINT PRIMARY KEY,
    nome VARCHAR(255),
    descricao VARCHAR(2000),
    nivel VARCHAR(100)
);

-- Inserir dados de exemplo (os mesmos que estavam em memoria no DAO)
INSERT INTO usuario (id, nome, email, tipoPerfil) VALUES (1, 'Lorena', 'lorena@synapse.com', 'mentor');
INSERT INTO usuario (id, nome, email, tipoPerfil) VALUES (2, 'Ana', 'ana@synapse.com', 'aluno');
INSERT INTO usuario (id, nome, email, tipoPerfil) VALUES (3, 'Bruna', 'bruna@synapse.com', 'aluno');

INSERT INTO trilha (id, nome, descricao, nivel) VALUES (1, 'Fundamentos da Cloud', 'Fundamentos de cloud e arquitetura de soluções.', 'intermediario');
INSERT INTO trilha (id, nome, descricao, nivel) VALUES (2, 'DevOps Básico', 'Introdução a práticas DevOps e CI/CD.', 'iniciante');