/***********************************I-SCP-RLH-NUT-1-20/04/2013****************************************/
CREATE TABLE nut.tproducto (
  id_producto SERIAL, 
  nombre VARCHAR(50), 
  descripcion TEXT, 
  precio INTEGER, 
  cantidadprod INTEGER, 
  CONSTRAINT tproducto_pkey PRIMARY KEY(id_producto)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE nut.tnutriente (
  id_nutriente SERIAL, 
  nombre VARCHAR(100), 
  tipo VARCHAR(100), 
  CONSTRAINT tnutriente_pkey PRIMARY KEY(id_nutriente)
)INHERITS (pxp.tbase) 
WITHOUT OIDS;

/***********************************F-SCP-RLH-NUT-1-20/04/2013****************************************/