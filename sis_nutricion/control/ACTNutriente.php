<?php
/**
*@package pXP
*@file gen-ACTNutriente.php
*@author  (admin)
*@date 19-04-2013 10:28:31
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTNutriente extends ACTbase{    
			
	function listarNutriente(){
		$this->objParam->defecto('ordenacion','id_nutriente');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODNutriente','listarNutriente');
		} else{
			$this->objFunc=$this->create('MODNutriente');
			
			$this->res=$this->objFunc->listarNutriente($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarNutriente(){
		$this->objFunc=$this->create('MODNutriente');	
		if($this->objParam->insertar('id_nutriente')){
			$this->res=$this->objFunc->insertarNutriente($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarNutriente($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarNutriente(){
			$this->objFunc=$this->create('MODNutriente');	
		$this->res=$this->objFunc->eliminarNutriente($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>