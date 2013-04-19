CREATE OR REPLACE FUNCTION "nut"."f_producto_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Nutrición Animales
 FUNCION: 		nut.f_producto_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'nut.tproducto'
 AUTOR: 		 (admin)
 FECHA:	        19-04-2013 10:46:09
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
	v_id_producto	integer;
			    
BEGIN

    v_nombre_funcion = 'nut.f_producto_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'NUT_PRO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2013 10:46:09
	***********************************/

	if(p_transaccion='NUT_PRO_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into nut.tproducto(
			estado_reg,
			cantidad,
			descripcion,
			nombre,
			precio,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			'activo',
			v_parametros.cantidad,
			v_parametros.descripcion,
			v_parametros.nombre,
			v_parametros.precio,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_producto into v_id_producto;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Productos almacenado(a) con exito (id_producto'||v_id_producto||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_producto',v_id_producto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'NUT_PRO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2013 10:46:09
	***********************************/

	elsif(p_transaccion='NUT_PRO_MOD')then

		begin
			--Sentencia de la modificacion
			update nut.tproducto set
			cantidad = v_parametros.cantidad,
			descripcion = v_parametros.descripcion,
			nombre = v_parametros.nombre,
			precio = v_parametros.precio,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_producto=v_parametros.id_producto;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Productos modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_producto',v_parametros.id_producto::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'NUT_PRO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2013 10:46:09
	***********************************/

	elsif(p_transaccion='NUT_PRO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from nut.tproducto
            where id_producto=v_parametros.id_producto;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Productos eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_producto',v_parametros.id_producto::varchar);
              
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
ALTER FUNCTION "nut"."f_producto_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
