
CREATE TABLE alum_matriculados
(
  id_alum_matric int NOT NULL GENERATED ALWAYS AS IDENTITY,
  id_escuela     int NOT NULL,
  id_semestre    int NOT NULL,
  n_matriculados int NOT NULL,
  PRIMARY KEY (id_alum_matric),
  CHECK (n_matriculados >= 0)
);

CREATE TABLE ciclo
(
  id_ciclo int NOT NULL GENERATED ALWAYS AS IDENTITY,
  n_ciclo  int NOT NULL,
  id_plan  int NOT NULL,
  PRIMARY KEY (id_ciclo),
  CHECK (n_ciclo >= 1 AND n_ciclo <= 10)
);

CREATE TABLE curso
(
  id_curso     varchar(8)   NOT NULL UNIQUE,
  nombre       varchar(100) NOT NULL,
  tipo         char         NOT NULL,
  creditos     int          NOT NULL,
  t_aprobacion numeric(5,2) NOT NULL,
  id_ciclo     int          NOT NULL,
  PRIMARY KEY (id_curso),
  CHECK (tipo IN ('O', 'E')), -- O: Obligatorio, E: Electivo
  CHECK (creditos > 0),
  CHECK (t_aprobacion >= 0 AND t_aprobacion <= 1)
);

COMMENT ON TABLE curso IS 'curso registrado';

CREATE TABLE curso_tomado
(
  id_ct         int          NOT NULL GENERATED ALWAYS AS IDENTITY,
  id_estudiante varchar(8)   NOT NULL,
  id_curso      varchar(8)   NOT NULL,
  id_semestre   int          NOT NULL,
  nota          int          NOT NULL,
  id_ciclo      int          NOT NULL,
  PRIMARY KEY (id_ct),
  CHECK (nota >= 0 AND nota <= 20)
);

COMMENT ON TABLE curso_tomado IS 'curso tomado';

CREATE TABLE escuela
(
  id_escuela int         NOT NULL,
  nombre     varchar(50) NOT NULL UNIQUE,
  PRIMARY KEY (id_escuela)
);

CREATE TABLE estudiante
(
  id_estudiante varchar(8) NOT NULL UNIQUE,
  id_escuela    int        NOT NULL,
  id_plan       int        NOT NULL,
  anio_ingreso  int        NOT NULL,
  PRIMARY KEY (id_estudiante),
  CHECK (anio_ingreso >= 2000 AND anio_ingreso <= 2025)
);

CREATE TABLE plan
(
  id_plan     int        NOT NULL GENERATED ALWAYS AS IDENTITY,
  nombre      varchar(4) NOT NULL,
  id_escuela  int        NOT NULL,
  anio_inicio int        NOT NULL,
  anio_fin    int        NOT NULL,
  PRIMARY KEY (id_plan),
  CHECK (anio_inicio >= 2000 AND anio_fin <= 2025),
  CHECK (anio_inicio <= anio_fin)
);

CREATE TABLE reprobacion
(
  id_estudiante   varchar(8) NOT NULL,
  id_curso        varchar(8) NOT NULL,
  n_reprobaciones int        NOT NULL,
  PRIMARY KEY (id_estudiante, id_curso),
  CHECK (n_reprobaciones >= 0)
);

CREATE TABLE semestre
(
  id_semestre int        NOT NULL GENERATED ALWAYS AS IDENTITY,
  nombre      varchar(5) NOT NULL,
  inicio      date       NOT NULL,
  fin         date       NOT NULL,
  id_escuela  int        NOT NULL,
  PRIMARY KEY (id_semestre),
  CHECK (inicio < fin),
);

CREATE TABLE tutoria
(
  id_tutoria        int         NOT NULL GENERATED ALWAYS AS IDENTITY,
  id_estudiante     varchar(8)  NOT NULL,
  id_semestre       int         NOT NULL,
  tipo_autorizacion varchar(2)  NOT NULL,
  num_res_autoriza  varchar(20) NOT NULL,
  PRIMARY KEY (id_tutoria),
  CHECK (tipo_autorizacion IN ('AM', 'TO'))
);

ALTER TABLE ciclo
  ADD CONSTRAINT FK_plan_TO_ciclo
    FOREIGN KEY (id_plan)
    REFERENCES plan (id_plan);

ALTER TABLE plan
  ADD CONSTRAINT FK_escuela_TO_plan
    FOREIGN KEY (id_escuela)
    REFERENCES escuela (id_escuela);

ALTER TABLE curso_tomado
  ADD CONSTRAINT FK_estudiante_TO_curso_tomado
    FOREIGN KEY (id_estudiante)
    REFERENCES estudiante (id_estudiante);

ALTER TABLE curso_tomado
  ADD CONSTRAINT FK_curso_TO_curso_tomado
    FOREIGN KEY (id_curso)
    REFERENCES curso (id_curso);

ALTER TABLE curso_tomado
  ADD CONSTRAINT FK_semestre_TO_curso_tomado
    FOREIGN KEY (id_semestre)
    REFERENCES semestre (id_semestre);

ALTER TABLE estudiante
  ADD CONSTRAINT FK_escuela_TO_estudiante
    FOREIGN KEY (id_escuela)
    REFERENCES escuela (id_escuela);

ALTER TABLE estudiante
  ADD CONSTRAINT FK_plan_TO_estudiante
    FOREIGN KEY (id_plan)
    REFERENCES plan (id_plan);

ALTER TABLE reprobacion
  ADD CONSTRAINT FK_estudiante_TO_reprobacion
    FOREIGN KEY (id_estudiante)
    REFERENCES estudiante (id_estudiante);

ALTER TABLE reprobacion
  ADD CONSTRAINT FK_curso_TO_reprobacion
    FOREIGN KEY (id_curso)
    REFERENCES curso (id_curso);

ALTER TABLE alum_matriculados
  ADD CONSTRAINT FK_semestre_TO_alum_matriculados
    FOREIGN KEY (id_semestre)
    REFERENCES semestre (id_semestre);

ALTER TABLE semestre
  ADD CONSTRAINT FK_escuela_TO_semestre
    FOREIGN KEY (id_escuela)
    REFERENCES escuela (id_escuela);

ALTER TABLE curso
  ADD CONSTRAINT FK_ciclo_TO_curso
    FOREIGN KEY (id_ciclo)
    REFERENCES ciclo (id_ciclo);

ALTER TABLE tutoria
  ADD CONSTRAINT FK_estudiante_TO_tutoria
    FOREIGN KEY (id_estudiante)
    REFERENCES estudiante (id_estudiante);

ALTER TABLE tutoria
  ADD CONSTRAINT FK_semestre_TO_tutoria
    FOREIGN KEY (id_semestre)
    REFERENCES semestre (id_semestre);

ALTER TABLE curso_tomado
  ADD CONSTRAINT FK_ciclo_TO_curso_tomado
    FOREIGN KEY (id_ciclo)
    REFERENCES ciclo (id_ciclo);

ALTER TABLE alum_matriculados
  ADD CONSTRAINT FK_escuela_TO_alum_matriculados
    FOREIGN KEY (id_escuela)
    REFERENCES escuela (id_escuela);
