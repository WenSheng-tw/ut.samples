#include "lib/tweb/tweb.ch"

function main()

    LOCAL o,  oWeb
	LOCAL cTxt := ''

	DEFINE WEB oWeb TITLE 'Cols' 
	
	//	We need to specify the relative root path
	//	The reason is that being an index directory ( "\examples" ) and executing html/prg directly, 
	//	the system needs to know where the root path is.
	
		oWeb:cRootRelative = '../'		
		
	//	--------------------------------------------------------------------------------------------	

		DEFINE FORM o ID 'demo' OF oWeb
			o:lDessign  := .T.
			o:cType     := 'md'     //  xs,sm,md,lg
			o:cSizing   := ''     	//  sm,lg

		HTML o
			<div class="alert alert-dark form_title" role="alert">
				<h5 style="margin:0px;">
					<i class="far fa-share-square"></i>
					Test Columns (Resizing screen...) Responsive experience
				</h5>
			</div>
		ENDTEXT
		
		TEXT TO cTxt
			Lorem Ipsum is simply dummy text of the printing and typesetting industry.
			Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, 
			when an unknown printer took a galley of type and scrambled it to make a type specimen book. 
			It has survived not only five centuries, but also the leap into electronic typesetting, 
			remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets 
			containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker 
			including versions of Lorem Ipsum.
		ENDTEXT

		INIT FORM o  
		
			ROW o VALIGN 'top'		// Try without VALIGN CLAUSE
			
				COL o GRID 4
				
					SEPARATOR o LABEL 'Col 1'
					
					SMALL o ID 'ppp' LABEL cTxt GRID 12
					
				ENDCOL o
		
				
				COL o GRID 4
			
					SEPARATOR o LABEL 'Col 2'
					
					GET oGet ID 'dni' VALUE '39690754L' LABEL 'C�digo' GRID 8 OF o
					
				ENDCOL o
				
				COL o GRID 4
			
					SEPARATOR o LABEL 'Col 3'
					
					ROWGROUP o					
					
						
						SWITCH ID 'xxx' LABEL 'OnOff'  GRID 6 OF o
						SWITCH ID 'zzz' LABEL 'OnOff'  GRID 6 OF o
						
					
					ENDROW o
					
				ENDCOL o                
			
			ENDROW o  
			
			ROWGROUP o
			
				SMALL o ID 'ppp' LABEL cTxt GRID 12
			
			ENDROW o			
		
		ENDFORM o 
	
	INIT WEB oWeb RETURN
	
retu nil