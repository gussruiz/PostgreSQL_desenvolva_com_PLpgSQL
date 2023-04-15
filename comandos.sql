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

-- aula 3

create or replace function primeira_pl() returns integer as $$
	begin
		return 1; -- pode-se ter varios comandos mas para retorno sempre return
	end
$$ language plpgsql;

select primeira_pl();


create or replace function segunda_pl() returns integer as $$
	declare 
		primeira_varivavel integer default 3;
	begin
		primeira_varivavel := primeira_varivavel * 2; -- := atribuição 
		return primeira_varivavel;
	end
$$ language plpgsql;

select segunda_pl();

create or replace function terceira_pl() returns integer as $$
	declare 
		primeira_varivavel integer default 3;
	begin
		primeira_varivavel := primeira_varivavel * 2; -- := atribuição 
		
		begin
			primeira_varivavel := 7;
			
		end;
		return primeira_varivavel;
	end
$$ language plpgsql;

select terceira_pl();

-- aula 4

create or replace function cria_a(nome varchar) returns void as $$
	begin
		insert into a (nome) values(cria_a.nome);
	end;
$$ language plpgsql;

select cria_a('Gustavo Silva Ruiz');
select * from a;

create or replace function cria_instrutor_falso() returns instrutor as $$ 
	declare 
		retorno instrutor;
	begin
		select 22, 'Nome Falso', 200::DECIMAL into retorno;
		return retorno;
	end;
$$ language plpgsql;

select id, salario from cria_instrutor_falso();

create or replace function instrutores_bem_pagos(valor_salario DECIMAL) returns setof instrutor as $$
	begin
		return query select * from instrutor where salario > valor_salario; 
	end;
$$ language plpgsql;

select * from instrutores_bem_pagos(300);


create or replace function salario_ok (instrutor instrutor) returns varchar as  $$
	begin
		if instrutor.salario > 200 then
			return 'Salário esta ok';
		else 
			return 'Salário pode aumentar';
		end if;
	end;
$$ language plpgsql;

select nome, salario_ok(instrutor) from instrutor;

-- feito de uma outra forma
create or replace function salario_ok_2 (id_instrutor integer) returns varchar as  $$
	declare 
		instrutor instrutor;
	begin
		select * from instrutor where id = id_instrutor into instrutor;
		if instrutor.salario > 200 then
			return 'Salário esta ok';
		else 
			return 'Salário pode aumentar';
		end if;
	end;
$$ language plpgsql;

select nome, salario_ok_2(instrutor.id) from instrutor;

create or replace function salario_ok_3 (id_instrutor integer) returns varchar as  $$
	declare 
		instrutor instrutor;
	begin
		select * from instrutor where id = id_instrutor into instrutor;
		if instrutor.salario > 300 then
			return 'Salário esta ok';
		else 
			if instrutor.salario = 300 then
				return 'Salário pode aumentar';
			else 
				return 'Salário está defasado';
			end if;
		end if;
	end;
$$ language plpgsql;

select nome, salario_ok_3(instrutor.id) from instrutor;


create or replace function salario_ok_4 (id_instrutor integer) returns varchar as  $$
	declare 
		instrutor instrutor;
	begin
		select * from instrutor where id = id_instrutor into instrutor;
		if instrutor.salario > 300 then
			return 'Salário esta ok';
		elseif instrutor.salario = 300 then
			return 'Salário pode aumentar';
		else 
			return 'Salário está defasado';
		end if;
	end;
$$ language plpgsql;

select nome, salario_ok_4(instrutor.id) from instrutor;


create or replace function salario_ok_5 (id_instrutor integer) returns varchar as  $$
	declare 
		instrutor instrutor;
	begin
		select * from instrutor where id = id_instrutor into instrutor;
		case instrutor.salario
			when 100 then
				return 'Salário muito baixo';
			when 200 then
				return 'Salário baixo';
			when 300 then
				return 'Salário ok';
			else 
				return 'Salário ótimo';
		end case;
	end;
$$ language plpgsql;

select nome, salario_ok_5(instrutor.id) from instrutor;



