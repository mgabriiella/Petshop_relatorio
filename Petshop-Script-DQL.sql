Use petshop;
-- Relatório 1: lista dos empregados admitidos entre 2019-01-01 e 2023-06-30
SELECT 
    e.cpf AS "cpf", 
    e.nome AS "empregado", 
    e.dataadm AS "data de admissão",  
    e.salario AS "salário", 
    e.departamento_iddepartamento AS "departamento",     
    t.numero AS "telefone"     
FROM 
    empregado e   
JOIN 
    telefone t ON e.cpf = t.empregado_cpf   
WHERE 
    e.dataadm >= '2019-01-01' 
    AND e.dataadm <= '2023-06-30'             
ORDER BY 
    e.nome;

-- Relatório 2: lista dos empregados que ganham menos que a média salarial
SELECT 
    e.cpf AS "cpf", 
    e.nome AS "empregado", 
    e.dataadm AS "data de admissão",  
    e.salario AS "salário", 
    e.departamento_iddepartamento AS "departamento",     
    t.numero AS "telefone" 
FROM 
    empregado e   
JOIN 
    telefone t ON e.cpf = t.empregado_cpf
WHERE 
    salario < (SELECT AVG(salario) FROM empregado)
ORDER BY 
    e.nome;

-- Relatório 3: lista dos departamentos com quantidade de empregados e média salarial
SELECT 
    d.nome AS "departamento", 
    COUNT(e.cpf) AS "quantidade de empregados", 
    AVG(e.salario) AS "média salarial", 
    AVG(e.comissao) AS "média da comissão"
FROM 
    departamento d
LEFT JOIN 
    empregado e ON d.iddepartamento = e.departamento_iddepartamento
GROUP BY 
    d.nome
ORDER BY 
    d.nome;

-- Relatório 4: lista dos empregados com total de vendas realizadas
SELECT 
    e.cpf AS "cpf", 
    e.nome AS "empregado", 
    e.sexo AS "sexo", 
    e.salario AS "salário", 
    COUNT(v.idvenda) AS "quantidade vendas", 
    SUM(v.valor) AS "total valor vendido", 
    SUM(e.comissao) AS "total comissão das vendas"
FROM 
    empregado e 
LEFT JOIN 
    venda v ON e.cpf = v.empregado_cpf 
GROUP BY 
    e.cpf, e.nome, e.sexo, e.salario 
ORDER BY 
    COUNT(v.idvenda) DESC;

-- Relatório 5: lista dos empregados que prestaram serviço na venda
SELECT 
    e.nome AS "nome empregado",
    e.cpf AS "cpf empregado",
    e.sexo AS "sexo",
    e.salario AS "salário",
    COUNT(isv.venda_idvenda) AS "quantidade vendas com serviço",
    SUM(isv.valor) AS "total valor vendido com serviço",
    SUM(e.comissao) AS "total comissão das vendas com serviço"
FROM 
    empregado e
JOIN 
    itensservico isv ON e.cpf = isv.empregado_cpf
GROUP BY 
    e.cpf, e.nome, e.sexo, e.salario 
ORDER BY 
    COUNT(isv.venda_idvenda) DESC;

-- Relatório 6: lista dos serviços realizados por um pet
SELECT 
    p.nome AS "nome do pet",
    v.data AS "data do serviço",
    s.nome AS "nome do serviço",
    isv.quantidade AS "quantidade",
    isv.valor AS "valor",
    e.nome AS "empregado que realizou o serviço"
FROM 
    itensservico isv
JOIN 
    servico s ON isv.servico_idservico = s.idservico
JOIN 
    venda v ON isv.venda_idvenda = v.idvenda
JOIN 
    pet p ON isv.pet_idpet = p.idpet
JOIN 
    empregado e ON isv.empregado_cpf = e.cpf
ORDER BY 
    v.data DESC;  

-- Relatório 7: lista das vendas realizadas para um cliente
SELECT 
    v.data AS "data da venda", 
    v.valor AS "valor", 
    v.desconto AS "desconto", 
    (v.valor - v.desconto) AS "valor final", 
    e.nome AS "empregado que realizou a venda"
FROM 
    venda v
JOIN 
    empregado e ON v.empregado_cpf = e.cpf
ORDER BY 
    v.data DESC;


-- Relatório 8: lista dos 10 serviços mais vendidos
SELECT 
    s.nome AS "nome do serviço", 
    COUNT(isv.venda_idvenda) AS "quantidade vendas", 
    SUM(isv.valor) AS "total valor vendido"
FROM 
    itensservico isv
JOIN 
    servico s ON isv.servico_idservico = s.idservico
GROUP BY 
    s.nome
ORDER BY 
    COUNT(isv.venda_idvenda) DESC
LIMIT 10; 

-- Relatório 9: lista das formas de pagamento mais utilizadas nas vendas
SELECT 
    f.tipo AS "tipo forma pagamento",              
    COUNT(v.idvenda) AS "quantidade vendas",         
    SUM(f.valorPago) AS "total valor vendido"       
FROM 
    petshop.formapgvenda f                          
JOIN 
    petshop.venda v ON f.venda_idvenda = v.idvenda  
GROUP BY 
    f.tipo                                      
ORDER BY 
    COUNT(v.idvenda) DESC;                         


-- Relatório 10: balanço das vendas
SELECT 
    DATE(c.datacomp) AS "data compra",                  
    COUNT(c.idcompra) AS "quantidade de compras",       
    SUM(c.valortotal) AS "valor total compra"    
FROM 
    petshop.compras c                                 
GROUP BY 
    DATE(c.datacomp)                                    
ORDER BY 
    DATE(c.datacomp) DESC;                                  

-- Relatório 11: lista dos produtos com fornecedor
SELECT 
	upper(p.nome ) as "Nome do Produto",
    concat("R$", format(p.precoCusto, 2, "de_DE")) as "Valor do Produto",
    p.marca as "Categoria do Produto",
    f.nome as "Nome do Fornecedor",
    f.email as "E-mail do Fornecedor", 
    t.numero as "Telefone do Fornecedor"
	FROM produtos p 
	JOIN 
        itenscompra itensC on p.idProduto = Produtos_idProduto
	JOIN 
		compras c on c.idCompra = itensC.Compras_idCompra
	JOIN 
		fornecedor f on f.cpf_cnpj = Fornecedor_cpf_cnpj
	LEFT JOIN 
		telefone t on f.cpf_cnpj = t.Fornecedor_cpf_cnpj
	ORDER BY 
		upper(p.nome ) desc;

-- Relatório 12: lista dos produtos mais vendidos
SELECT 
    p.nome AS "nome produto",                                
    SUM(iv.quantidade) AS "quantidade (total) vendas",   
    SUM(iv.valor) AS "valor total recebido pela venda do produto"  
FROM 
    petshop.itensvendaprod iv                           
JOIN 
    petshop.produtos p ON iv.produto_idproduto = p.idproduto 
GROUP BY 
    p.nome
ORDER BY 
    SUM(iv.quantidade) DESC;