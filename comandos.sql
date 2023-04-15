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
