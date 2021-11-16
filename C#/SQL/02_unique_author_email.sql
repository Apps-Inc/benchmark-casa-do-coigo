ALTER TABLE authors ADD UNIQUE (email);

SELECT constraint_name,
       constraint_type
  FROM information_schema.table_constraints
 WHERE table_name = 'authors'
   AND table_constraints.constraint_type = 'UNIQUE';
