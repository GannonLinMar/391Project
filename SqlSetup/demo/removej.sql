declare
	i NUMBER := 1;
begin
	FOR i IN 1..50 LOOP
		begin
			dbms_job.remove(i);
		EXCEPTION
    		WHEN OTHERS THEN
        		NULL;
		end;
	END LOOP;
end;
/