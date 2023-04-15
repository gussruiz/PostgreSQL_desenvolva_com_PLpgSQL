-- aula 1 

create function primeira_funcao() returns integer as '
	select (5 - 3) * 2;
' language sql;

select * from primeira_funcao();

select * from primeira_funcao() as numero;

create function soma_dois_numeros(num_1 integer, num_2 integer) returns integer as '
	select num_1 + num_2;
' language sql;

select soma_dois_numeros(2, 2);

select soma_dois_numeros(3, 17);

create function soma_tres_numeros(integer, integer, integer) returns integer as '
	select $1 + $2 + $3;
' language sql;

select soma_tres_numeros(3, 17, 1);

create table a (nome varchar(255) not null);

drop function cria_a;

create or replace function cria_a(nome varchar) returns void as $$
	insert into a (nome) values(cria_a.nome);
$$ language sql;

select cria_a('Gustavo S. Ruiz');

select * from a;

-- aula 2

create table instrutor(
	id serial primary key,
	nome varchar(255) not null,
	salario decimal(10, 2)
);

insert into instrutor (nome, salario) values ('Vincuius Dias', 100);

create or replace function dobro_do_salario(instrutor) returns decimal as $$
	select $1.salario * 2 as dobro;
$$ language sql;

select nome, dobro_do_salario(instrutor.*) as desejo from instrutor;

create or replace function cria_instrutor_falso() returns instrutor as $$ 
	select 22 as id, 'Nome Falso'as nome, 200::DECIMAL as salario;
$$ language sql;

select cria_instrutor_falso();

select * from cria_instrutor_falso();


insert into instrutor (nome, salario) values ('Diogo Mascarenhas', 200);
insert into instrutor (nome, salario) values ('Nicco Steppat', 300);
insert into instrutor (nome, salario) values ('Juliana', 400);
insert into instrutor (nome, salario) values ('Priscila ', 500);


drop function instrutores_bem_pagos;

create or replace function instrutores_bem_pagos(valor_salario DECIMAL) returns setof instrutor as $$
	select * from instrutor where salario > valor_salario; 
$$ language sql;

-- pode ser escrito assim também

create or replace function instrutores_bem_pagos(valor_salario DECIMAL) returns table (id integer , nome varvhar(255), salario decimal) as $$
	select * from instrutor where salario > valor_salario; 
$$ language sql;

select * from instrutores_bem_pagos(300);


create or replace function soma_e_produto (num_1 integer, num_2 integer, out soma integer, out produto integer) as $$
	select num_1 + num_1 as soma, num_1 * num_2 as produto;
$$ language sql;

-- pode ser feito também como

create type dois_valores as (soma integer, produto integer);

create or replace function soma_e_produto (num_1 integer, num_2 integer) returns dois_valores as $$
	select num_1 + num_1 as soma, num_1 * num_2 as produto;
$$ language sql;

select * from soma_e_produto(2, 3);

