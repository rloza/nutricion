CREATE OR REPLACE FUNCTION "nut"."f_nutriente_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Nutrición Animales
 FUNCION: 		nut.f_nutriente_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'nut.tnutriente'
 AUTOR: 		 (admin)
 FECHA:	        19-04-2013 11:10:44
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_nutriente	integer;
			    
BEGIN

    v_nombre_funcion = 'nut.f_nutriente_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'NUT_NUT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2013 11:10:44
	***********************************/

	if(p_transaccion='NUT_NUT_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into nut.tnutriente(
			estado_reg,
			nombre,
			id_producto,
			tipo,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			'activo',
			v_parametros.nombre,
			v_parametros.id_producto,
			v_parametros.tipo,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_nutriente into v_id_nutriente;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Nutrientes almacenado(a) con exito (id_nutriente'||v_id_nutriente||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_nutriente',v_id_nutriente::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'NUT_NUT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2013 11:10:44
	***********************************/

	elsif(p_transaccion='NUT_NUT_MOD')then

		begin
			--Sentencia de la modificacion
			update nut.tnutriente set
			nombre = v_parametros.nombre,
			id_producto = v_parametros.id_producto,
			tipo = v_parametros.tipo,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_nutriente=v_parametros.id_nutriente;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Nutrientes modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_nutriente',v_parametros.id_nutriente::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'NUT_NUT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2013 11:10:44
	***********************************/

	elsif(p_transaccion='NUT_NUT_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from nut.tnutriente
            where id_nutriente=v_parametros.id_nutriente;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Nutrientes eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_nutriente',v_parametros.id_nutriente::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;
				        
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "nut"."f_nutriente_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
