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

--aula 5

create or replace function tabuada_v1(num integer) returns setof integer as $$
	declare 
	begin
		return next num * 1;
		return next num * 2;	
		return next num * 3;	
		return next num * 4;	
		return next num * 5;	
		return next num * 6;
		return next num * 7;	
		return next num * 8;	
		return next num * 9;	
		return next num * 10;	
	end;
$$ language plpgsql;

select tabuada_v1(4);

create or replace function tabuada_v2(num integer) returns setof varchar as $$
	declare 
		multiplicador integer default 1;
	begin
		loop
			return next num || ' x ' || multiplicador || ' = ' || num * multiplicador;
			multiplicador := multiplicador + 1;
			exit when multiplicador = 10;
		end loop;
	end;
$$ language plpgsql;

select tabuada_v2(9) as "Tabuada do 9";


create or replace function tabuada_v3(num integer) returns setof varchar as $$
	declare 
		multiplicador integer default 1;
	begin
		while multiplicador < 10 loop
			return next num || ' x ' || multiplicador || ' = ' || num * multiplicador;
			multiplicador := multiplicador + 1;
		end loop;
	end;
$$ language plpgsql;

select tabuada_v3(9) as "Tabuada do 9";


create or replace function tabuada_v4(num integer) returns setof varchar as $$
	begin
		for multiplicador in 1..9 loop
			return next num || ' x ' || multiplicador || ' = ' || num * multiplicador;
		end loop;
	end;
$$ language plpgsql;

select tabuada_v4(9) as "Tabuada do 9";

create or replace function instrutor_com_salario(out nome varchar, out salario_ok varchar) returns setof record as $$
	declare instrutor instrutor;
	begin
		for instrutor in select * from instrutor loop
			nome := instrutor.nome;
			salario_ok := salario_ok_5(instrutor.id);
			return next;
		end loop;
	end;
$$ language plpgsql;

select * from instrutor_com_salario();

-- aula 6

CREATE TABLE aluno (
    id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL
);

CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

CREATE TABLE aluno_curso (
	aluno_id INTEGER NOT NULL REFERENCES aluno(id),
	curso_id INTEGER NOT NULL REFERENCES curso(id),
	PRIMARY KEY (aluno_id, curso_id)
);

create or replace function cria_curso(nome_curso varchar, nome_categoria varchar) returns void as $$
	declare
		id_categoria integer;
	begin
		select id into id_categoria from categoria where nome = nome_categoria;
		
		if not found then
			insert into categoria(nome) values (nome_categoria) returning id into id_categoria;
		end if;
		
		insert into curso(nome, categoria_id) values (nome_curso, id_categoria);
	end;
$$ language plpgsql;

select cria_curso('PHP', 'Programação');

select * from curso;
select * from categoria;

select cria_curso('Java', 'Programação');

select * from curso;
select * from categoria;

create table log_instrutores(
	id serial primary key,
	informacao varchar(255),
	momento_criacao timestamp default current_timestamp
);


create or replace function cria_instrutor (nome_instrutor varchar, salario_instrutor decimal) returns void as $$
	declare
		id_inserido integer;
		media_salarial decimal;
		instrutores_recebem_menos integer;
		total_instrutores integer;
		salario decimal;
		percentual decimal;
	begin
		insert into instrutor (nome, salario) values (nome_instrutor, salario_instrutor) returning id into id_inserido;
		
		select avg(instrutor.salario) into media_salarial from instrutor where id <> id_inserido;
		
		if salario_instrutor > media_salarial then
			insert into log_instrutores (informacao) values (nome_instrutor || 'recebe acima da média');
		end if;
		
		for salario in select instrutor.salario from instrutor where id <> id_inserido loop
			total_instrutores := total_instrutores + 1;
			
			if salario_instrutor > salario then
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			end if;
		end loop;
		percentual = instrutores_recebem_menos::decimal / total_instrutores::decimal * 100;
			
		insert into log_instrutores (informacao) 
			values (nome_instrutor || ' recebe mais do que ' || percentual || '% da grade de instrutores');
	end;
$$ language plpgsql;

select * from instrutor;

select cria_instrutor('Fulana de tal', 1000.00);

select * from instrutor;

select * from log_instrutores;

