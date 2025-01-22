#define VK_ESCAPE	27

request DBFCDX
request TWEB

function main()

	hb_threadStart( @WebServer() )	
	
	while inkey(0) != VK_ESCAPE
	end

retu nil 

//----------------------------------------------------------------------------//

function WebServer()

	local oServer 	:= Httpd2()
	
	oServer:SetPort( 81 )
	oServer:SetDirFiles( 'data' )
	
	//	Routing...			

		oServer:Route( '/'		, 'index.html' ) 
		oServer:Route( 'curl1'	, 'curl1.html' ) 
		oServer:Route( 'curl2'	, 'curl2.html' ) 		
		oServer:Route( 'curl3'	, 'curl3.html' ) 		
		oServer:Route( 'curl4'	, 'curl4.html' ) 		
		
	//	-----------------------------------------------------------------------//	
	
	IF ! oServer:Run()
	
		? "=> Server error:", oServer:cError

		RETU 1
	ENDIF
	
RETURN 0

//----------------------------------------------------------------------------//