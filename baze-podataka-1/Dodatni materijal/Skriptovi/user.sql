create user student identified by ftn
	default tablespace USERS temporary tablespace TEMP;


	grant connect, resource to student;

	grant create table to student;

	grant create view to student;

	grant create procedure to student;

	grant create synonym to student;

	grant create sequence to student;

	grant select on dba_rollback_segs to student;

	grant select on dba_segments to student;

	grant unlimited tablespace to student;