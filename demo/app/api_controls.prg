function Api_Controls( oDom )

	do case
		case oDom:GetProc() == 'ping'		; DoPing( oDom )						
		
		case oDom:GetProc() == 'enable'	; DoEnable( oDom )						
		case oDom:GetProc() == 'disable'	; DoDisable( oDom )	
		
		case oDom:GetProc() == 'show'		; DoShow( oDom )						
		case oDom:GetProc() == 'hide'		; DoHide( oDom )						
		
		case oDom:GetProc() == 'showrc'	; ( oDom:Show( 'myrowgroup' ), oDom:Show( 'mycol' ) )
		case oDom:GetProc() == 'hiderc'	; ( oDom:Hide( 'myrowgroup' ), oDom:Hide( 'mycol' ) )
		
		case oDom:GetProc() == 'fileupload_basic'	; DoUpload_Basic( oDom )
		case oDom:GetProc() == 'myfiles'			; DoMyFiles( oDom )
		case oDom:GetProc() == 'fileupload'		; DoUpload( oDom )
		
		case oDom:GetProc() == 'valid_id'  		; DoValid_Id( oDom )
		case oDom:GetProc() == 'dlg_autocomplete'	; DoDialog_Autocomplete( oDom )
//		case oDom:GetProc() == 'autoproductos'  	; DoAutoProductos( oDom )
		
		case oDom:GetProc() == 'set_combo_hash'	; DoSet_Combo_Hash( oDom )
		case oDom:GetProc() == 'set_combo_array'	; DoSet_Combo_Array( oDom )
		
		case oDom:GetProc() == 'progress_value'	; DoProgress_Value( oDom )
		
		case oDom:GetProc() == 'echo'				; oDom:SetMsg( oDom:Get( 'name' ) )
		
		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc())
	endcase
	
retu oDom:Send()	

// -------------------------------------------------- //

static function DoPing( oDom )

	oDom:SetMsg( oDom:GetList(.t.) , 'Parameteres received' )				
	oDom:Console( oDom:GetList(.f.), 'Parameteres received' )				
	
retu nil

// -------------------------------------------------- //

static function DoDisable( oDom )

	oDom:Disable( 'myget'   )
	oDom:Disable( 'mymemo'  )
	oDom:Disable( 'mybtn'   )
	oDom:Disable( 'mycheck' )
	oDom:Disable( 'mycombo' )
	oDom:Disable( 'myradio' )	
	
retu nil

// -------------------------------------------------- //

static function DoEnable( oDom )

	oDom:Enable( 'myget'   )
	oDom:Enable( 'mymemo'  )
	oDom:Enable( 'mybtn'   )
	oDom:Enable( 'mycheck' )
	oDom:Enable( 'mycombo' )
	oDom:Enable( 'myradio' )	
	
retu nil

// -------------------------------------------------- //

static function DoShow( oDom )

	oDom:Show( 'mysay'   )
	oDom:Show( 'myget'   )
	oDom:Show( 'mymemo'  )
	oDom:Show( 'mybtn'   )
	oDom:Show( 'mycheck' )
	oDom:Show( 'mycombo' )
	oDom:Show( 'myradio' )	
	oDom:Show( 'myonoff' )	

	
	oDom:Show( 'myrowgroup' )	
	oDom:Show( 'mycol' )	
	
retu nil

// -------------------------------------------------- //

static function DoHide( oDom )

	oDom:Hide( 'mysay'   )
	oDom:Hide( 'myget'   )
	oDom:Hide( 'mymemo'  )
	oDom:Hide( 'mybtn'   )
	oDom:Hide( 'mycheck' )
	oDom:Hide( 'mycombo' )
	oDom:Hide( 'myradio' )	
	oDom:Hide( 'myonoff' )	
	
	
	oDom:Hide( 'myrowgroup'   )
	oDom:Hide( 'mycol'   )
retu nil

// -------------------------------------------------- //

static function DoMyFiles( oDom )

	local cYear := oDom:Get( 'year' )
	local aInfo := oDom:Get( 'files' )
	local hInfo := hb_jsondecode( aInfo )
	local cInfo := ''
	local n
	
	for n := 1 to len( hInfo )
		cInfo += hInfo[n][ 'name' ] + ' ' +  str( hInfo[n][ 'size' ] ) + '<br>'
	next



	oDom:Set( 'info', cInfo)
	
	oDom:Console( cYear ) 
	oDom:Console( hInfo ) 
	

retu nil

// -------------------------------------------------- //

static function DoUpload( oDom )

	local hPost 		:= UPost()
	local aFiles 		:= UFiles()
	local nFiles		:= len( aFiles ) 
	local aProc 		:= {}
	local n, cSource, cTarget, nRet 
	local nOk			:= 0
	local nKo			:= 0
	local cInfo			:= ''
	
	if nFiles == 0
		oDom:Set( 'info', '')
		oDom:Console( 'No files!')
		retu nil 
	endif 
	
	
	//	-----------------------------------------------------------------------
	//	Una vez tenemos los ficheros cargados, conseguiremos un array con 
	//	todas esta información usando la funcion UFiles()
	//	Cada elemento del array corresponde a un fichero que se ha subido y 
	//	esta en la carpeta temporal de nuestra app, por defecto /.tmp 
	//	El registro de cada elemento es un hash con la siguiente informacion:
	//	'Content-type': MIME del fichero
	//	'success'		: File upload .t./.f.
	//	'error'			: message error 
	//	'filename'		: Nombre del fichero
	//	'ext'			: Extension del fichero
	//	'size'			: Tamaño del fichero
	//	'tmp_name'		: Nombre del fichero temporal ubicado en /.tmp
	//
	//	La operación a hacer ahora seria mover, copiar, importar... el fichero
	//	que esta en 'tmp_name' donde quieras ubicarlo
	//
	//	Si creamos una salida a consola -> _d( aFiles ) veremos el contenido
	//	-----------------------------------------------------------------------	
	// 	Once we have the files loaded, we'll get an array with
	// 	all this information using the UFiles() function
	// 	Each element of the array corresponds to a file that has been uploaded and
	// 	is in the temporary folder of our app, by default /.tmp
	// 	The record of each element is a hash with the following information:
	// 	'Content-type': MIME of the file
	//	'success'		: File upload .t./.f.
	//	'error'			: message error 	
	// 	'filename' 	: Name of the file
	// 	'ext' 			: File extension
	// 	'size' 			: Size of the file
	// 	'tmp_name' 	: Name of the temporary file located in /.tmp
	//	
	// 	The operation to do now would be to move, copy, import... the file
	// 	which is in 'tmp_name' where you want to place it
	//	
	// 	If we create a console output -> _d( aFiles ) we will see the content	
	//	-----------------------------------------------------------------------	
	

		//	Procesa ficheros... / Process files...

		//	https://harbour.github.io/doc/clct3.html#filemove 
		//	https://harbour.github.io/doc/clct3.html#filecopy 
		//	AppPathRepository()
		
		for n := 1 to nFiles

			cSource 	:= aFiles[n][ 'tmp_name' ] 
			cTarget		:= AppPathRepository() + aFiles[n][ 'filename' ] 			
			nRet 		:= FileMove( cSource, cTarget )
			
			/*
			 0      NO_DISK_ERR            No errors
			-2      ER_FILE_NOT_FOUND      File not found
			-3      ER_PATH_NOT_FOUND      Access path not found
			-5      ER_ACCESS_DENIED       Access denied (e.g., network)
			-17     ER_DIFFERENT_DEVICE    Target file not on same drive
			-183	 Cannot create file when that file already exists						
			*/
			
			Aadd( aProc, { 'file' => cSource, 'ret' => nRet } )

			if nRet == 0
				nOk++
			else
				nKo++
			endif
			
		next
		
		
	cInfo := 'Procesed Ok: ' + ltrim(str(nOk)) + '<br>'
	cInfo += 'Procesed Ko: ' + ltrim(str(nKo)) 

	//	Eliminaremos los ficheros seleccionadas del button de seleccionar
	//	We will remove the selected files from the select button

		oDom:ResetFiles( 'btnselect' )
	//	---------------------------------------------------
	
	oDom:Set( 'info', '' )
	oDom:Console( { 'files' => aFiles, 'proc' => aProc } ) 		// Trace vars...
	oDom:SetMsg( cInfo, 'Resumen')
	
retu nil 

// -------------------------------------------------- //

static function DoUpload_Basic( oDom )

	local hPost 		:= UPost()
	local aFiles 		:= UFiles()
	local nFiles		:= len( aFiles ) 
	local aProc 		:= {}
	local n, cSource, cTarget, nRet 
	
	if nFiles == 0
		oDom:Set( 'info', '')
		oDom:Console( 'No files!')
		retu nil 
	endif 

		for n := 1 to nFiles

			cSource 	:= aFiles[n][ 'tmp_name' ] 
			cTarget		:= AppPathRepository() + aFiles[n][ 'filename' ] 			
			nRet 		:= FileMove( cSource, cTarget )

			Aadd( aProc, { 'file' => cSource, 'ret' => nRet } )
			
		next


	//	Eliminaremos los ficheros seleccionadas del button de seleccionar
	//	We will remove the selected files from the select button
		
		oDom:ResetFiles( 'btnselect' )
	//	---------------------------------------------------
	
	oDom:Console( { 'files' => aFiles, 'proc' => aProc } ) 		// Trace vars...
	oDom:SetMsg( 'Files upload!' )
	
retu nil 

// -------------------------------------------------- //
//	Autocomplete functions examples
// -------------------------------------------------- //

function DoAuto_Productos()

	local cSearch  := alltrim(lower( UPost()[ 'search' ] ))
	local aRows 	:= {}
	local cAlias   := 'ALIAS' + ltrim(str(hb_milliseconds()))
	
	_d( UPost() )	//	Check via dbgview

	USE ('data/states.dbf') SHARED NEW ALIAS (cAlias)
	SET INDEX TO ('data/states.cdx')
	
	(cAlias)->( OrdSetFocus( 'name' ) )
	(cAlias)->( DbSeek( lower(cSearch), .t. ) ) 

	WHILE alltrim(lower((cAlias)->name)) = cSearch .and. (cAlias)->( !Eof() )		
		Aadd( aRows, { 'value' => alltrim( (cAlias)->name), 'id' => (cAlias)->code } )
		(cAlias)->( DbSkip() )
	END		
	
	UAddHeader("Content-Type", "application/json")
	UWrite( hb_jsonencode( aRows ) )
	
retu nil 


// -------------------------------------------------- //

function DoValid_Id( oDom )

	oDom:SetMsg( 'Valid Id. => ' + oDom:Get( 'myget2' ) )
	
retu nil 

// -------------------------------------------------- //

function DoDialog_Autocomplete( oDom )

	local cHtml := ULoadHtml( 'controls\dlg_autocomplete.html'  )
	local o 	:= {=>}	
	
	//	-------------------------------------------------------------------------------------
	//	TWeb usa el pluggin bootbox para creaar diálogos.
	//	Todos los paràmetros los puedes encontrar aqui -> http://bootboxjs.com/examples.html 
	//	-------------------------------------------------------------------------------------
	
	//o[ 'title' ] 		:= 'My Title...'	
	//o[ 'backdrop' ] 	:= .t.
	//o[ 'onEscape' ] 	:= .f.
	//o[ 'closeButton' ]:= .t.
	//o[ 'className' ] 	:= 'bounceIn fadeOutRight'
	
	oDom:SetDialog( 'xxx', cHtml, 'Test from dialog...', o )


retu nil 


// -------------------------------------------------- //

function DoSet_Combo_Hash( oDom )

	local h := {=>}
	
	h[ 'R' ] := 'Renault'
	h[ 'T' ] := 'Toyota'
	h[ 'H' ] := 'Honda'

	oDom:Set( 'cars', h )

retu nil 

// -------------------------------------------------- //

function DoSet_Combo_Array( oDom )

	local a := {}
	
	Aadd( a, 'Renault' )
	Aadd( a, 'Toyota' )
	Aadd( a, 'Honda' )

	oDom:Set( 'cars', a )

retu nil 

// -------------------------------------------------- //

function DoProgress_Value( oDom )
	local n

	oDom:Set( 'myprogress',  hb_randint(1,100) )
	oDom:Set( 'myprogress-only',  hb_randint(1,100) )
	
	n = hb_randint(1,100)
		oDom:Set( 'myprogress-full',  n )
		oDom:Set( 'myprogress-full',  n, 'Status process: ' + ltrim(str(n)) )
	

retu nil 
