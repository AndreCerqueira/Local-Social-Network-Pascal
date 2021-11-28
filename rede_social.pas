//------------------------------------------------------------------------------------------------------------//
//-----------------PARA ESTE PROGRAMA FUNCIONAR É NECESSARIO COLOCAR NA PASTA EM WINDOWS (C:)-----------------//
//------------------------------------------------------------------------------------------------------------//

Program Rede_Social ;
Type pessoa = record           //significado das variaveis:
     nome:string;              //nome do utilizador
     pass:string;              //pass do utilizador
end;     
Type conv = record             //registo usado no chat
     texto:string;             //texto inserido no chat
end;
            
Var tipo_ficheiro_txt,tipo_ficheiro_txt_2,tipo_ficheiro_txt_3:text;   //tipos de ficheiro de documento de texto
    tipo_ficheiro_dat,tipo_ficheiro_dat_2:file of pessoa;             //tipos de ficheiro de documento dat
    tipo_ficheiro_dat_conversa:file of conv;                          //tipo de ficheiro de documento dat, string apenas usado no documento conversa
    caminho_ficheiro_users,caminho_ficheiro_conversa:string;          //caminho para a lista de users e para o chat
		caminho_ficheiro_amigos,caminho_ficheiro_pedidos:string;          //caminho para a lista de amigos e pedidos
		caminho_ficheiro_historico:string;                                //caminho para o historico de entradas
    utilizador:pessoa;                                                //utilizador é um record com nome e pass
    OP:array[1..4] of string;                                         //array de opçoes de menus
		seguir,apagar,perm_login:boolean;		                              //permissoes do tipo bollean
		login,nome_atual,nome_anterior,pass_atual:string;                 //variaveis segundarias usadas para alterar dados
		cont:integer;                                                     //contador usado para escrever no chat
		dados:string;                                                     //se (dados=pass) alterar pass/(dados=nome) alterar nome
		
//------------------------------------------------------------------------------------------------------------//
//----------------------------------------------------------FUNÇOES-------------------------------------------//
//------------------------------------------------------------------------------------------------------------//

//-------------------------------------------------------TOTAL AMIGOS-----------------------------------------//	
{funçao usada para contar o total de amigos}
Function total_amigos:integer; 
Var linha:string;
		cont_temp:integer;
Begin
total_amigos:=0;
	If(apagar)Then   {<-- caso a conta do utilizador tenha sido apagada ele sai automaticamente da funçao} 
		exit;
	
	Assign(tipo_ficheiro_txt, caminho_ficheiro_amigos);     {<- 1ºabrir documento}                                                        
	Reset(tipo_ficheiro_txt);                               {<- 2ºcomeçar do inicio}                                                      
	  Repeat   	      		  
	    Readln(tipo_ficheiro_txt,linha);                   	{<- 3ºler cada amigo e contar}
			If(linha<>'')Then	
				cont_temp:=cont_temp+1;	                   
		Until(Eof(tipo_ficheiro_txt)); 	
	close(tipo_ficheiro_txt); 
	total_amigos:=cont_temp;	   		
End;  

//-------------------------------------------------------TOTAL PEDIDOS-----------------------------------------//	
Function total_pedidos:integer;
Var linha:string;
		cont_temp:integer;
Begin
total_pedidos:=0;
	If(apagar)Then   {<-- caso a conta do utilizador tenha sido apagada ele sai automaticamente da funçao} 
		exit;
		
	Assign(tipo_ficheiro_txt, caminho_ficheiro_pedidos);   {<- 1ºabrir documento}                                                      
	Reset(tipo_ficheiro_txt);                              {<- 2ºcomeçar do inicio}                                   
		Repeat   	       
		  Readln(tipo_ficheiro_txt,linha);                   {<- 3ºler cada amigo e contar}
			If(linha<>'')Then	
				cont_temp:=cont_temp+1;		                   
		Until(Eof(tipo_ficheiro_txt)); 	
	close(tipo_ficheiro_txt); 
	total_pedidos:=cont_temp;	   		
End;

//------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------PROCEDIMENTOS----------------------------------------//
//------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------PERFIL-----------------------------------------//		
Procedure perfil;
Var Ano,Mes,Dia,Dia_Semana,Hora,Minuto,Segundo,Dec_Segundo:word;
Begin	
	GetDate(Ano, Mes, Dia, Dia_Semana);             {receber os valores correspondentes ao nome das variaveis}
	GetTime(Hora, Minuto, Segundo, Dec_Segundo);

	gotoxy(60,3);
  Writeln('  _________________                            ');
	gotoxy(60,4);              
  Writeln('  |   .-=<>=-.    |   Nome: ',nome_atual);
  gotoxy(60,5);
  Writeln('  |  /__----__\   |                            ');
  gotoxy(60,6);
  Writeln('  | |/ ('')('') \|  |   Amigos: ',total_amigos); 	 {funçao linha 23}
  gotoxy(60,7);
  Writeln('  |  \   __   /   |                            ');
  gotoxy(60,8);                            
  Writeln('  |  ,''--__--''.   |   Pedidos: ',total_pedidos);  {funçao linha 41}
  gotoxy(60,9);
  Writeln('  | /    :|    \  |      ');
  gotoxy(60,10);
  Writeln('  |_______________|   Data: [',Dia,'/',Mes,'/',Ano,'] | Hora: [',Hora,':',Minuto,':',Segundo,']');
  
  {escrever no documento de historico de entrada}
  
  {perm_login é um bollean que é usado para escrever no documento apenas
	quando é efetuada a entrada e nao sempre que o perfil; é chamado	}  
	 
  If(perm_login=false)Then    					
	Begin																	                       
	  Assign(tipo_ficheiro_txt, caminho_ficheiro_historico);  
		Append(tipo_ficheiro_txt); 
		Writeln(tipo_ficheiro_txt,'Data: [',Dia,'/',Mes,'/',Ano,'] | Hora: [',Hora,':',Minuto,':',Segundo,']');    
	  close(tipo_ficheiro_txt);
	  perm_login:=true;
	End;    
End;

//------------------------------------------------------------REGISTRAR-----------------------------------------//		
Procedure registrar;
Var novo_nome:String;
		interromper:boolean;
Begin
clrscr;	
  gotoxy(25,2);
	Writeln('{Registo}');
  gotoxy(25,4);
	Write('Nome: ');
	
		{vai repetir o nome ate que seja inserido um nome valido}
		Repeat
			interromper:=false;
			gotoxy(31,4);
			Write('             ');
			gotoxy(31,4);   
		  Read(novo_nome);  
		  
		  Assign(tipo_ficheiro_dat, caminho_ficheiro_users);   {abrir lista de users}                                                      
			Reset(tipo_ficheiro_dat);   	                       {começar no inicio}    
			  Repeat   	      	  
			    Readln(tipo_ficheiro_dat,utilizador);	           {ler os utlizadores}    
			    
					If(novo_nome=utilizador.nome)Then                {se ja for igual, volta a pedir o numero}    
					Begin
						interromper:=true;	
						Writeln;
						textcolor(12);
						gotoxy(25,6); Writeln('                                                                ');
						gotoxy(25,6);	
						Writeln('O nome ',novo_nome,' já está a ser usado!');	
						textcolor(10);
					End;	
				Until(Eof(tipo_ficheiro_dat)OR(interromper=true)); 
		  close(tipo_ficheiro_dat);
		  
		Until(interromper=false);		                        {ate que nao haja nomes repetidos}  
	  gotoxy(25,6);  Writeln('                                                                ');
						 
	utilizador.nome:=novo_nome;
	
	gotoxy(25,6);
	Write('Pass: ');
  Read(utilizador.pass);       {inserir a pass} 
  
  {guardar os dados no ficheiro dat} 
  Assign(tipo_ficheiro_dat, caminho_ficheiro_users);  
	Reset(tipo_ficheiro_dat);    
	Seek(tipo_ficheiro_dat,filesize(tipo_ficheiro_dat));	 
		                                                                                
  Write(tipo_ficheiro_dat,utilizador);
  
  close(tipo_ficheiro_dat);     {fechar lista de users} 
	
	{criar um documento de texto na pasta da lista de amigos} 
	caminho_ficheiro_amigos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',utilizador.nome,'.txt');
	Assign(tipo_ficheiro_txt, caminho_ficheiro_amigos);  
	Rewrite(tipo_ficheiro_txt);     
  close(tipo_ficheiro_txt);    
	
	{criar um documento de texto na pasta dos pedidos} 
	caminho_ficheiro_pedidos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\pedidos\',utilizador.nome,'.txt');
	Assign(tipo_ficheiro_txt, caminho_ficheiro_pedidos);  
	Rewrite(tipo_ficheiro_txt);     
  close(tipo_ficheiro_txt);   
  
	{criar um documento de texto na pasta dos historicos} 
	caminho_ficheiro_historico:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\historico\',utilizador.nome,'.txt');
	Assign(tipo_ficheiro_txt, caminho_ficheiro_historico);  
	Rewrite(tipo_ficheiro_txt);     
  close(tipo_ficheiro_txt);    
	
	Writeln; Writeln('Conta criada! Clique em qualquer tecla para continuar...');     
  Readkey;
End;

//------------------------------------------------------------ENTRAR-----------------------------------------//		
Procedure entrar;
Type temporario = record
     nome:string;
     pass:string;
end;
Var linha:string;
    i:integer;
    verificar:boolean;
    temp:temporario;
    
Begin
clrscr;
  Assign(tipo_ficheiro_dat, caminho_ficheiro_users);   {abrir lista de users}     
  {$I-} Reset(tipo_ficheiro_dat); {$I+}                {começar no inicio}                                             
		
		If(ioresult<>0)Then
		Begin
		  Writeln;
			Writeln('Não Existem Utilizadores :(');
			Readkey;
			exit;
		End;
  
	gotoxy(25,2);
  Writeln('{ENTRAR}  ');
	
	gotoxy(20,4);
	Write('Nome: ');
  Read(temp.nome);      {ler nome}       
	
	Writeln;
	gotoxy(20,6);
	Write('Pass: ');
  Read(temp.pass);      {ler pass} 
  
  Repeat      {verificar se é valido...} 
  
    Readln(tipo_ficheiro_dat,utilizador);    
    
    If((temp.nome=utilizador.nome)AND(temp.pass=utilizador.pass))Then
      verificar:=true;
    
  Until(Eof(tipo_ficheiro_dat)OR(verificar=true));
  
  If(verificar=false)Then
	Begin
	  Writeln;
	  textcolor(12);
	  Writeln('O seu nome ou palavra-passe estão errados!');
	  textcolor(10);
	End; 
  
  If(verificar=true)Then
  Begin
  	seguir:=true;
  	Writeln; 
	  Writeln; 
		Writeln('Conseguiu Entrar... Clique em qualquer tecla para continuar...');     
		nome_atual:=utilizador.nome;
		pass_atual:=utilizador.pass;  
		perm_login:=false;	{perm_login vai dar permissao para gravar a hora de entrada} 		 
	End;
	
  close(tipo_ficheiro_dat);           {fechar lista de users} 
      
  Readkey;
  
End;

//-------------------------------------------------LISTA-USERS------------------------------------//
Procedure lista_users;
Var linha:string;
    i,y:integer;
Begin
clrscr; y:=2; 
	  
  Assign(tipo_ficheiro_dat, caminho_ficheiro_users);     {abrir lista de users}                                                  
	{$I-} Reset(tipo_ficheiro_dat); {$I+}                  {começar no inicio}                                        
		
		If(ioresult<>0)Then
		Begin
		  Writeln;
			Writeln('Não Existem Utilizadores :(');
			Readkey;
			exit;
		End;
		                                       
  gotoxy(17,2);
  Writeln('{LISTA DE UTILIZADORES}  ');
  
  Writeln; 
  Repeat   	      
  y:=y+2;
	  
    Readln(tipo_ficheiro_dat,utilizador);       {mostrar a lista de utilizadores}  
                        
		gotoxy(25,y);     
    Writeln(utilizador.nome); 	
		            
  Writeln;  
	Writeln;        
	Until(Eof(tipo_ficheiro_dat)); 
	
	If((y=4)AND(utilizador.nome=''))Then   // Vereficar se nao existe users
	Begin
		gotoxy(15,y); 
		Writeln('Não Existem Utilizadores :(');
	End;
	
	close(tipo_ficheiro_dat);                     {fechar lista de users}   
	  
	Writeln;
	Writeln;
	Writeln('Clique em qualquer tecla para voltar');
	Readkey;  
  clrscr;
End;

//------------------------------------------------------------MENU INICIAL-----------------------------------------//		
Procedure menu_inicial;
Begin
	
  gotoxy(25,2);
  Writeln('{Menu Inicial}  ');
  gotoxy(25,5);
  Writeln('1 - Registrar          ');
  gotoxy(25,7);
  Writeln('2 - Entrar          ');
  gotoxy(25,9);
  Writeln('3 - Lista de Utilizadores          ');
  gotoxy(25,11);
  Writeln('0 - Sair         ');
	
	gotoxy(25,14);
	Write('Escolha uma opção: ');
	Read(OP[3]);                        

End;

//------------------------------------------------------------MENU PRINCIPAL-----------------------------------------//		
Procedure menu_principal;
Begin
  If(apagar)Then   {<-- caso a conta tenha sido apagada ele sai automaticamente do menu} 
	Begin
		OP[1]:='4';
		apagar:=false;
		exit;
	End;
	
  gotoxy(20,2);
  Writeln('  {Rede Social Privada do 11ºL}  ');
  gotoxy(25,5);
  Writeln('1 - Chat           ');
  gotoxy(25,7);
  Writeln('2 - Lista de Amigos           ');
  gotoxy(25,9);
  Writeln('3 - Definições           ');
  gotoxy(25,11);
  Writeln('4 - Trocar de Conta           ');
  gotoxy(25,13);
  Writeln('0 - Sair         ');
	
	gotoxy(25,16);
	Write('Escolha uma opção: ');
	Read(OP[1]);                        

End;

//------------------------------------------------------------DEFINIÇOES-----------------------------------------//		
Procedure menu_def;
Begin
  clrscr;
	If(apagar)Then   {<-- caso a conta tenha sido apagada ele sai automaticamente do menu} 
	Begin
	  OP[4]:='0';
	  exit;
	End;
	
  gotoxy(20,2);
  Writeln('  {Definições}  ');
  gotoxy(25,5);
  Writeln('1 - Alterar Nome  [Nome Atual: ',nome_atual,']         ');
  gotoxy(25,7);
  Writeln('2 - Alterar Pass  [Pass Atual: ',pass_atual,']         ');
  gotoxy(25,9);
  Writeln('3 - Apagar Conta           ');
  gotoxy(25,11);
  Writeln('4 - Histórico de Entradas        ');
  gotoxy(25,13);
  Writeln('0 - Voltar           ');
	
	gotoxy(25,16);
	Write('Escolha uma opção: ');
	Read(OP[4]); 
  
End;

//------------------------------------------------ALTERAR O NOME NO PROGRAMA TODO------------------------------------//
Procedure alterar_nome_todo_programa;
Var linha,linha_2:string;
		caminho_temp,caminho_temp_temp:string;
		conteudo:conv; 
Begin
	If(nome_anterior<>nome_Atual)Then
	Begin
		//-----------------------------------------------------------------------------------//
		//--------------------------ALTERAR NOME DA LISTA DOS AMIGOS-------------------------//
		//-----------------------------------------------------------------------------------//
		  caminho_ficheiro_amigos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',nome_anterior,'.txt');
			caminho_temp:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',nome_atual,'.txt');
			  
	  	Assign(tipo_ficheiro_txt,caminho_ficheiro_amigos);    Reset(tipo_ficheiro_txt); 
			Assign(tipo_ficheiro_txt_2,caminho_temp);             Rewrite(tipo_ficheiro_txt_2);
			
			  Repeat
			  	Read(tipo_ficheiro_txt,linha);
					Writeln(tipo_ficheiro_txt_2,linha);
			  Until(Eof(tipo_ficheiro_txt));
			  
	    close(tipo_ficheiro_txt);  close(tipo_ficheiro_txt_2);  erase(tipo_ficheiro_txt);
	  
	  //-----------------------------------------------------------------------------------//
		//-----------------------------ALTERAR NOME NOS PEDIDOS------------------------------//
		//-----------------------------------------------------------------------------------//
	    caminho_ficheiro_pedidos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\pedidos\',nome_anterior,'.txt');
			caminho_temp:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\pedidos\',nome_atual,'.txt');
			  
	  	Assign(tipo_ficheiro_txt,caminho_ficheiro_pedidos);    Reset(tipo_ficheiro_txt); 
			Assign(tipo_ficheiro_txt_2,caminho_temp);             Rewrite(tipo_ficheiro_txt_2);
			
			  Repeat
			  	Read(tipo_ficheiro_txt,linha);
					Writeln(tipo_ficheiro_txt_2,linha);
			  Until(Eof(tipo_ficheiro_txt));
			  
	    close(tipo_ficheiro_txt);  close(tipo_ficheiro_txt_2);  erase(tipo_ficheiro_txt);
	  
	  //-----------------------------------------------------------------------------------//
		//-----------------------------ALTERAR NOME NO HISTORICO-----------------------------//
		//-----------------------------------------------------------------------------------//
	    caminho_ficheiro_historico:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\historico\',nome_anterior,'.txt');
			caminho_temp:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\historico\',nome_atual,'.txt');
			  
	  	Assign(tipo_ficheiro_txt,caminho_ficheiro_historico);    Reset(tipo_ficheiro_txt); 
			Assign(tipo_ficheiro_txt_2,caminho_temp);             Rewrite(tipo_ficheiro_txt_2);
			
			  Repeat
			  	Read(tipo_ficheiro_txt,linha);
					Writeln(tipo_ficheiro_txt_2,linha);
			  Until(Eof(tipo_ficheiro_txt));
			  
	    close(tipo_ficheiro_txt);  close(tipo_ficheiro_txt_2);  erase(tipo_ficheiro_txt);
	    	
	  //-----------------------------------------------------------------------------------//
		//--------------------------AVISAR NO CHAT QUE O NOME FOI ALTERADO-------------------//
		//-----------------------------------------------------------------------------------//
			Assign(tipo_ficheiro_dat_conversa, caminho_ficheiro_conversa);
		  Reset(tipo_ficheiro_dat_conversa);
			Seek(tipo_ficheiro_dat_conversa,filesize(tipo_ficheiro_dat_conversa)); 
			
			conteudo.texto:=Concat('<AVISO> O [',nome_anterior,'] alterou o seu nome para: [',nome_atual,']');                                                                                               
		  Write(tipo_ficheiro_dat_conversa,conteudo);
		  
		  close(tipo_ficheiro_dat_conversa); 
			//----------------------------------------------------//
			Assign(tipo_ficheiro_dat_conversa, caminho_ficheiro_conversa);
		  Append(tipo_ficheiro_dat_conversa); 
		  
		  conteudo.texto:='';
			Write(tipo_ficheiro_dat_conversa,conteudo);      
		
		  close(tipo_ficheiro_dat_conversa); 
			  
		//-----------------------------------------------------------------------------------//
		//----------------------ALTERAR NOME NA LISTA DE AMIGOS DOS AMIGOS-------------------//
		//-----------------------------------------------------------------------------------//
			caminho_ficheiro_amigos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',nome_atual,'.txt');  
			Assign(tipo_ficheiro_txt,caminho_ficheiro_amigos);    
			Reset(tipo_ficheiro_txt); 		            
	
			  Repeat
			  	Read(tipo_ficheiro_txt,linha);
			  	
					If(linha<>'')Then
					Begin
						caminho_temp:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',linha,'.txt');
						caminho_temp_temp:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\temp.txt');
						Assign(tipo_ficheiro_txt_2,caminho_temp);    			Reset(tipo_ficheiro_txt_2);
						Assign(tipo_ficheiro_txt_3,caminho_temp_temp);    Rewrite(tipo_ficheiro_txt_3);
							Repeat
							
								Read(tipo_ficheiro_txt_2,linha_2);
								Writeln(tipo_ficheiro_txt_3,linha_2);
								
							Until(Eof(tipo_ficheiro_txt_2));
							
			      close(tipo_ficheiro_txt_2); 	close(tipo_ficheiro_txt_3);		erase(tipo_ficheiro_txt_2); 
			      
			      caminho_temp:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',linha,'.txt');
						caminho_temp_temp:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\temp.txt');
						Assign(tipo_ficheiro_txt_2,caminho_temp);    			Rewrite(tipo_ficheiro_txt_2);
						Assign(tipo_ficheiro_txt_3,caminho_temp_temp);    Reset(tipo_ficheiro_txt_3);
							Repeat
							
								Read(tipo_ficheiro_txt_3,linha_2);
								If(linha_2=nome_anterior)Then
									Writeln(tipo_ficheiro_txt_2,nome_atual)
								Else
									Writeln(tipo_ficheiro_txt_2,linha_2);
									
							Until(Eof(tipo_ficheiro_txt_3));
							
			      close(tipo_ficheiro_txt_2); 	close(tipo_ficheiro_txt_3);		erase(tipo_ficheiro_txt_3); 
					End;
					
			  Until(Eof(tipo_ficheiro_txt));
			  
	    close(tipo_ficheiro_txt);  
	  End;  
End;

//------------------------------------------------------ALTERAR NOME / PASS-----------------------------------------//	
Procedure alterar;
Var linha:string; 
Begin
clrscr;
	If(dados='nome')Then
	Begin
	  gotoxy(20,2);
		Writeln('{ALTERAR NOME}');
	End;
	If(dados='pass')Then
	Begin	  
		gotoxy(20,2);
		Writeln('{ALTERAR PASS}');
	End;
	
  Assign(tipo_ficheiro_dat,caminho_ficheiro_users);       {abrir lista de users}
  Reset(tipo_ficheiro_dat);                               {começar do inicio}
	
	While not eof(tipo_ficheiro_dat) do
	 Begin
		 Readln(tipo_ficheiro_dat,utilizador);
		  
		 With utilizador do
		 Begin
		 	 //-----------------Alterar Nome-------------//
	     If((dados='nome')AND(nome_atual=utilizador.nome)AND(pass_atual=utilizador.pass))Then
       Begin
		     gotoxy(20,5);
		     Writeln(' Nome Atual: ',utilizador.nome);	    
				 nome_anterior:=utilizador.nome;	   
			   gotoxy(20,7);
			   Write(' Novo Nome: ');   
			   Readln(utilizador.nome);            {inserir novo nome}    
				 nome_atual:=utilizador.nome;
				 alterar_nome_todo_programa;     {procedimento que começa na linha 372}
				  
			 	 seek(tipo_ficheiro_dat,filepos(tipo_ficheiro_dat)-1);  
			   Write(tipo_ficheiro_dat,utilizador);    {substituir nome}
			   close(tipo_ficheiro_dat);
			   
			   caminho_ficheiro_amigos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',utilizador.nome,'.txt'); 
				 caminho_ficheiro_pedidos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\pedidos\',utilizador.nome,'.txt'); 
				 caminho_ficheiro_historico:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\historico\',utilizador.nome,'.txt'); 
			   exit;
			 End;
			 //-----------------Alterar Pass-------------//
			 If((dados='pass')AND(nome_atual=utilizador.nome)AND(pass_atual=utilizador.pass))Then
       Begin
		     gotoxy(20,5);
		     Writeln(' Pass Atual: ',utilizador.pass);		   
			   gotoxy(20,7);
			   Write(' Nova Pass: ');
			   Readln(utilizador.pass);              {inserir novo pass}
				 pass_atual:=utilizador.pass; 
				 
				 seek(tipo_ficheiro_dat,filepos(tipo_ficheiro_dat)-1);  
			   Write(tipo_ficheiro_dat,utilizador);
			   close(tipo_ficheiro_dat); 
				 exit; 
			 End;
			              
	   End;              
	 End;         
End;

//----------------------------------------------------------APAGAR CONTA-----------------------------------//
Procedure apagar_conta;
Var novo_nome,linha,linha_2:string;
		caminho_temp,caminho_temp_temp:string;
		conteudo:conv;
Begin
clrscr;  
	//-----------------------------------------------------------------------------------//
	//----------------------APAGAR NOME NA LISTA DE AMIGOS DOS AMIGOS-------------------//
	//-----------------------------------------------------------------------------------//
		caminho_ficheiro_amigos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',nome_atual,'.txt');  
		Assign(tipo_ficheiro_txt,caminho_ficheiro_amigos);    
		Reset(tipo_ficheiro_txt); 		            

		  Repeat
		  	Read(tipo_ficheiro_txt,linha);
		  	
				If(linha<>'')Then
				Begin
					caminho_temp:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',linha,'.txt');
					caminho_temp_temp:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\temp.txt');
					Assign(tipo_ficheiro_txt_2,caminho_temp);    			Reset(tipo_ficheiro_txt_2);
					Assign(tipo_ficheiro_txt_3,caminho_temp_temp);    Rewrite(tipo_ficheiro_txt_3);
						Repeat
						
							Read(tipo_ficheiro_txt_2,linha_2);
							Writeln(tipo_ficheiro_txt_3,linha_2);
							
						Until(Eof(tipo_ficheiro_txt_2));
						
		      close(tipo_ficheiro_txt_2); 	close(tipo_ficheiro_txt_3);		erase(tipo_ficheiro_txt_2); 
		      
		      caminho_temp:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',linha,'.txt');
					caminho_temp_temp:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\temp.txt');
					Assign(tipo_ficheiro_txt_2,caminho_temp);    			Rewrite(tipo_ficheiro_txt_2);
					Assign(tipo_ficheiro_txt_3,caminho_temp_temp);    Reset(tipo_ficheiro_txt_3);
						Repeat
						
							Read(tipo_ficheiro_txt_3,linha_2);
							If(linha_2<>nome_atual)Then
								Writeln(tipo_ficheiro_txt_2,linha_2);
								
						Until(Eof(tipo_ficheiro_txt_3));
						
		      close(tipo_ficheiro_txt_2); 	close(tipo_ficheiro_txt_3);		erase(tipo_ficheiro_txt_3); 
				End;
				
		  Until(Eof(tipo_ficheiro_txt));
		  
    close(tipo_ficheiro_txt);  
    
  caminho_temp:=('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\temp.dat');
  //-------------------ACABA AQUI O APAGAR NOME NA LISTA DE AMIGOS DOS AMIGOS-------------------//
  
  gotoxy(20,2);
	Writeln('{APAGAR CONTA}');
	
  // abrir 1º ficheiro
  Assign(tipo_ficheiro_dat,caminho_ficheiro_users);
  Reset(tipo_ficheiro_dat);
  
  // abrir 2º ficheiro
  Assign(tipo_ficheiro_dat_2,caminho_temp);
  Rewrite(tipo_ficheiro_dat_2);
  
  // copiar do 1 para o 2 ficheiro
  Repeat
  
    Readln(tipo_ficheiro_dat,utilizador);
    Write(tipo_ficheiro_dat_2,utilizador);   
		 
  Until(eof(tipo_ficheiro_dat));
  
  // fechar os ficheiros e apagar o primeiro
  close(tipo_ficheiro_dat);
  close(tipo_ficheiro_dat_2);
  
  erase(tipo_ficheiro_dat);
  
  
  //  ate aqui movi o ficheiro para um temporario e depois vou mover do temporario para o anteriror mas sem o usuario eleminado
  
  
  //abrir o 2º ficheiro
  Assign(tipo_ficheiro_dat_2,caminho_temp);
  Reset(tipo_ficheiro_dat_2);
  
  //recriar o 1º ficheiro "vazio"
  Assign(tipo_ficheiro_dat,caminho_ficheiro_users);
  Rewrite(tipo_ficheiro_dat);
  
  // copiar do 2 para o 1 ficheiro mas exeto o ficheiro que foi eliminado
  Repeat
  
    Readln(tipo_ficheiro_dat_2,utilizador);
    
    If((utilizador.nome <> nome_atual)OR(utilizador.pass <> pass_atual))Then
	    Write(tipo_ficheiro_dat,utilizador);   
		 
  Until(eof(tipo_ficheiro_dat_2));
  
  // fechar os ficheiros e apagar o 2 / temporario
  close(tipo_ficheiro_dat_2);
  close(tipo_ficheiro_dat);
  erase(tipo_ficheiro_dat_2);
	                                
  Assign(tipo_ficheiro_txt,caminho_ficheiro_amigos);
  close(tipo_ficheiro_txt);
  erase(tipo_ficheiro_txt);
  
  Assign(tipo_ficheiro_txt,caminho_ficheiro_pedidos);
  close(tipo_ficheiro_txt);
  erase(tipo_ficheiro_txt);
  
  Assign(tipo_ficheiro_txt,caminho_ficheiro_historico);
  close(tipo_ficheiro_txt);
  erase(tipo_ficheiro_txt);
  
  //-----------------------------------------------------------------------------------//
	//--------------------------AVISAR NO CHAT QUE A CONTA FOI APAGADA-------------------//
	//-----------------------------------------------------------------------------------//
	Assign(tipo_ficheiro_dat_conversa, caminho_ficheiro_conversa);
 	Reset(tipo_ficheiro_dat_conversa);
	Seek(tipo_ficheiro_dat_conversa,filesize(tipo_ficheiro_dat_conversa));  
	
	conteudo.texto:=Concat('<AVISO> O [',nome_atual,'] apagou a sua conta!!!');                                                                                               
  Write(tipo_ficheiro_dat_conversa,conteudo);
  
  close(tipo_ficheiro_dat_conversa); 
	//----------------------------------------------------//
	Assign(tipo_ficheiro_dat_conversa, caminho_ficheiro_conversa);
  Append(tipo_ficheiro_dat_conversa); 
  
  conteudo.texto:='';
	Write(tipo_ficheiro_dat_conversa,conteudo);      

  close(tipo_ficheiro_dat_conversa);   
		  
  apagar:=true;
  Writeln;
	Writeln('A sua Conta Foi Apagada com sucesso...');
	Readkey;
	clrscr;
End;

//----------------------------------------------------------HISTORICO-------------------------------------------//
Procedure historico;
Var linha:string;
Begin
clrscr;

	gotoxy(25,2);
	Writeln('{Historico de Entradas}'); 
	Writeln; Writeln;
	
  Assign(tipo_ficheiro_txt, caminho_ficheiro_historico);  
	Reset(tipo_ficheiro_txt);
	
	Repeat 
	
		Read(tipo_ficheiro_txt,linha);
		Writeln(linha); 
		Writeln;
		
	Until(Eof(tipo_ficheiro_txt));	
	   
  close(tipo_ficheiro_txt);   
	
	Writeln;	Writeln;
	Writeln('Clique em qualquer tecla para sair...'); 
	Readkey; 
End;

//----------------------------------------------ESCREVER-GUARDAR-NO-FICHEIRO------------------------------------//
Procedure escrever;   
Var conteudo:conv; 
Begin
	  gotoxy(1,cont+6);          //este cont serve para dar um espaçamento do texto do chat
	  Writeln('Escrever: '); 
	  gotoxy(10,cont+6); 		
		Read(conteudo.texto); 	                                                 
	  conteudo.texto:=concat('[',nome_atual,']: ',conteudo.texto);
	  
	  caminho_ficheiro_conversa:=('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\conversa.dat');
	  Assign(tipo_ficheiro_dat_conversa, caminho_ficheiro_conversa);
	  Reset(tipo_ficheiro_dat_conversa);
		Seek(tipo_ficheiro_dat_conversa,filesize(tipo_ficheiro_dat_conversa));	 
                                                                                      
	  Write(tipo_ficheiro_dat_conversa,conteudo);
	  
		conteudo.texto:=''; 
		Write(tipo_ficheiro_dat_conversa,conteudo);
		
	  close(tipo_ficheiro_dat_conversa); 
  
    gotoxy(1,cont+6);
	  Writeln('                                                                                                                  '); 
End;

//-------------------------------------------------LER-FICHEIRO------------------------------------//
Procedure ler;
Var conteudo:conv;
Begin  
  	
	Assign(tipo_ficheiro_dat_conversa, caminho_ficheiro_conversa);
  Reset(tipo_ficheiro_dat_conversa);
 
  Repeat   	      	  
    Readln(tipo_ficheiro_dat_conversa,conteudo);
    Writeln(conteudo.texto); 
		cont:=cont+1;    
	Until(Eof(tipo_ficheiro_dat_conversa));
	
  close(tipo_ficheiro_dat_conversa);            

End;

//------------------------------------------------------------CHAT-----------------------------------------//		
Procedure chat;
Begin
clrscr;
	Repeat           
		
	  gotoxy(20,2);
	  Writeln('  {Messenger Privado do 11ºL}  ');
	  Writeln;
	  
	  ler;  
	  
	  gotoxy(70,2);
	  Writeln(' [1] - Escrever ');
	  gotoxy(70,4);
	  Writeln(' [2] - Atualizar ');
	  gotoxy(70,6);
	  Writeln(' [0] - Voltar ');
		gotoxy(70,8);
	  Writeln(' Opção: ');  
	  gotoxy(78,8);
	  Read(OP[2]);
	  
	  If(OP[2]='1')Then
	  Begin
	    escrever;
	  End;
	  
	  cont:=0;
	  gotoxy(78,8); Writeln('                                      ');  
	Until(OP[2]='0');  
	OP[1]:='5';
End;

//------------------------------------------------------ADICIONAR AMIGOS-----------------------------------------//
Procedure add_amigos;
Var nome_temp,linha:string;
		y:integer;
Begin
  clrscr;
  
  Assign(tipo_ficheiro_dat, caminho_ficheiro_users);     {fazer uma lista de users para auxiliar a adicionar amigos}                                                    
	Reset(tipo_ficheiro_dat);                             
		                                       
  gotoxy(78,2);
  Writeln('{LISTA DE UTILIZADORES}  ');
  y:=2;
  Writeln; 
  Repeat   	      
  y:=y+2;
	  
    Readln(tipo_ficheiro_dat,utilizador);
                        
		gotoxy(78,y);     
    Writeln(utilizador.nome); 	
		            
  Writeln;  
	Writeln;        
	Until(Eof(tipo_ficheiro_dat)); 
	
	close(tipo_ficheiro_dat); 
	
	gotoxy(17,2);
  Writeln('{ADICIONAR AMIGOS}  ');
	
	gotoxy(17,4);
  Write('[Nome]: ');
  Read(nome_temp);
                                         {verificar se o nome é valido}      
  If(nome_temp<>nome_atual)Then
  Begin                                                             {verificar se nao é ele proprio} 
	  Assign(tipo_ficheiro_txt, caminho_ficheiro_amigos);	                                                         
		Reset(tipo_ficheiro_txt);  	
			Repeat  	 	      	  
		    Readln(tipo_ficheiro_txt,linha); 		     
			Until((Eof(tipo_ficheiro_txt))OR(nome_temp=linha)); 
		close(tipo_ficheiro_txt);
	
		If(nome_temp<>linha)Then                                     {verificar se ja esta na lista de amigos}   
		Begin
			
		  Assign(tipo_ficheiro_dat, caminho_ficheiro_users);	                                                         
			Reset(tipo_ficheiro_dat);  
			                           		                                       
		  Repeat  	 	      	  
		    Readln(tipo_ficheiro_dat,utilizador); 		     
			Until((Eof(tipo_ficheiro_dat))OR(nome_temp=utilizador.nome)); 
			
			If(nome_temp=utilizador.nome)Then                  {verificar se existe ou nao} 
			Begin
			  caminho_ficheiro_pedidos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\pedidos\',nome_temp,'.txt'); 
				 
			  Assign(tipo_ficheiro_txt, caminho_ficheiro_pedidos);                                                         
		  	Append(tipo_ficheiro_txt);   
				Writeln(tipo_ficheiro_txt,nome_atual);    
				Close(tipo_ficheiro_txt);
				  
				Writeln;
			  Writeln('Pedido de amizade enviado...');
				Readkey;
				clrscr;     
			End
			Else
			Begin
				Writeln;
				textcolor(12);
			  Writeln('Este Utilizador não existe...');
				textcolor(10); 
				Readkey;
				clrscr;
			End;	
			
			close(tipo_ficheiro_dat);
			
			Assign(tipo_ficheiro_dat, caminho_ficheiro_users);
			Reset(tipo_ficheiro_dat);  
			                           		                                       
		  Repeat  	 	      	  
		    Readln(tipo_ficheiro_dat,utilizador); 		     
			Until(nome_atual=utilizador.nome); 
			
			caminho_ficheiro_pedidos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\pedidos\',utilizador.nome,'.txt'); 
			
			close(tipo_ficheiro_dat); 
		End
		Else
		Begin
			Writeln;
			textcolor(12);
		  Writeln('Este Utilizador já está na sua lista de amigos...');
			textcolor(10); 
			Readkey;
			clrscr;
		End;
	End
	Else
	Begin
		Writeln;
		textcolor(12);
	  Writeln('Este Utilizador és tu, não te podes adicionar a ti próprio...');
		textcolor(10); 
		Readkey;
		clrscr;
	End; 
End;

//------------------------------------------------------REMOVER AMIGO----------------------------------------//
Procedure remover_amigos;
Var nome_temp,linha,linha_2,caminho_temp:string;
		y,cont_linhas:integer;
Begin
clrscr;
	//mostrar lista de amigos do lado
	Assign(tipo_ficheiro_txt, caminho_ficheiro_amigos);                                                         
	Reset(tipo_ficheiro_txt);                                                        		                               
		gotoxy(78,2);
		Writeln('{LISTA DE AMIGOS}  ');  
		Writeln; 
		y:=2;
		Repeat   	      
		y:=y+2;	cont_linhas:=cont_linhas+1;  
		  Readln(tipo_ficheiro_txt,linha);		                    
			gotoxy(78,y);     
		  Writeln(linha); 			                   
		Until(Eof(tipo_ficheiro_txt)); 	
	close(tipo_ficheiro_txt);    
	
	If(cont_linhas=1)AND(linha='')Then
	Begin
	clrscr;
		gotoxy(17,2);
	  Writeln('{REMOVER AMIGOS}  ');
		gotoxy(17,y);     
    Writeln('[ Ainda não tens Amigos ]'); 
    Writeln;
    Writeln('Clique em qualquer tecla para voltar...');
    cont_linhas:=0;
		Readkey;
		clrscr;	
	End
	Else
	Begin	
	cont_linhas:=0;			
	  gotoxy(17,2);
	  Writeln('{REMOVER AMIGOS}  ');
		
		gotoxy(17,4);
	  Write('[Nome]: ');
	  Read(nome_temp);
	                                         {verificar se o nome é valido}                                                                 {verificar se nao é ele proprio} 
	  Assign(tipo_ficheiro_txt, caminho_ficheiro_amigos);	                                                         
		Reset(tipo_ficheiro_txt);  	
			Repeat  	 	      	  
		    Readln(tipo_ficheiro_txt,linha); 		     
			Until((Eof(tipo_ficheiro_txt))OR(nome_temp=linha)); 
		close(tipo_ficheiro_txt);
	
		If(nome_temp=linha)Then                  {verificar se existe ou nao} 
		Begin	
			//---------------------------------------------------------------------------------------------------------------//	 
			//--------------------------------REMOVER NA LISTA DO UTILIZADOR ONLINE------------------------------------------//
			//---------------------------------------------------------------------------------------------------------------//
			
			caminho_ficheiro_amigos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',utilizador.nome,'.txt'); 
			caminho_temp:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\temp.txt');
			
			Assign(tipo_ficheiro_txt_2,caminho_ficheiro_amigos);    			Reset(tipo_ficheiro_txt_2);
			Assign(tipo_ficheiro_txt_3,caminho_temp);   									Rewrite(tipo_ficheiro_txt_3);
				Repeat
				
					Read(tipo_ficheiro_txt_2,linha_2);
					Writeln(tipo_ficheiro_txt_3,linha_2);
					
				Until(Eof(tipo_ficheiro_txt_2));
				
	    close(tipo_ficheiro_txt_2); 	close(tipo_ficheiro_txt_3);		erase(tipo_ficheiro_txt_2); 
	    
			Assign(tipo_ficheiro_txt_2,caminho_ficheiro_amigos);    			Rewrite(tipo_ficheiro_txt_2);
			Assign(tipo_ficheiro_txt_3,caminho_temp);   									Reset(tipo_ficheiro_txt_3);
				Repeat
				
					Read(tipo_ficheiro_txt_3,linha_2);
					If(linha_2<>nome_temp)Then
						Writeln(tipo_ficheiro_txt_2,linha_2);
						
				Until(Eof(tipo_ficheiro_txt_3));
				
	    close(tipo_ficheiro_txt_2); 	close(tipo_ficheiro_txt_3);		erase(tipo_ficheiro_txt_3); 
	    
	    //---------------------------------------------------------------------------------------------------------------//
		  //--------------------------------REMOVER NA LISTA DO UTILIZADOR SELECIONADO-------------------------------------//
		  //---------------------------------------------------------------------------------------------------------------//
		  
			caminho_ficheiro_amigos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',nome_temp,'.txt'); 
			caminho_temp:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\temp.txt');
			
			Assign(tipo_ficheiro_txt_2,caminho_ficheiro_amigos);    			Reset(tipo_ficheiro_txt_2);
			Assign(tipo_ficheiro_txt_3,caminho_temp);   									Rewrite(tipo_ficheiro_txt_3);
				Repeat
				
					Read(tipo_ficheiro_txt_2,linha_2);
					Writeln(tipo_ficheiro_txt_3,linha_2);
					
				Until(Eof(tipo_ficheiro_txt_2));
				
	    close(tipo_ficheiro_txt_2); 	close(tipo_ficheiro_txt_3);		erase(tipo_ficheiro_txt_2); 
	    
			Assign(tipo_ficheiro_txt_2,caminho_ficheiro_amigos);    			Rewrite(tipo_ficheiro_txt_2);
			Assign(tipo_ficheiro_txt_3,caminho_temp);   									Reset(tipo_ficheiro_txt_3);
				Repeat
				
					Read(tipo_ficheiro_txt_3,linha_2);
					If(linha_2<>utilizador.nome)Then
						Writeln(tipo_ficheiro_txt_2,linha_2);
						
				Until(Eof(tipo_ficheiro_txt_3));
				
	    close(tipo_ficheiro_txt_2); 	close(tipo_ficheiro_txt_3);		erase(tipo_ficheiro_txt_3); 
		  caminho_ficheiro_amigos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',utilizador.nome,'.txt');
		  
			Writeln;
		  Writeln('Utilizador Removido da lista de Amigos...');
			Readkey;
			clrscr;     
		End
		Else
		Begin
			Writeln;
			textcolor(12);
		  Writeln('Este Utilizador não existe ou não está na sua lista de amigos...');
			textcolor(10); 
			Readkey;
			clrscr;
		End;	
	End;			
End;

//------------------------------------------------------ACEITAR PEDIDO-----------------------------------------//
Procedure aceitar_pedido;
Var novo_nome,linha,caminho_temp:string;
Begin  

	Write('Nome: ');
	Read(novo_nome);
	
	Assign(tipo_ficheiro_txt,caminho_ficheiro_pedidos);
  Reset(tipo_ficheiro_txt); 
  
  Repeat 
  	Readln(tipo_ficheiro_txt,linha);	 
  Until(eof(tipo_ficheiro_txt)OR(linha=novo_nome));
  
  close(tipo_ficheiro_txt); 
  
  If(linha=novo_nome)Then 
	Begin  
	  caminho_temp:=('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\pedidos\temp.txt');
		
	  // abrir 1º ficheiro
	  Assign(tipo_ficheiro_txt,caminho_ficheiro_pedidos);
	  Reset(tipo_ficheiro_txt);
	  
	  // abrir 2º ficheiro
	  Assign(tipo_ficheiro_txt_2,caminho_temp);
	  Rewrite(tipo_ficheiro_txt_2);
	  
	  // copiar do 1 para o 2 ficheiro
	  Repeat
	  
	    Readln(tipo_ficheiro_txt,linha);
	    Writeln(tipo_ficheiro_txt_2,linha);   
			 
	  Until(eof(tipo_ficheiro_txt));
	  
	  // fechar os ficheiros e apagar o primeiro
	  close(tipo_ficheiro_txt);
	  close(tipo_ficheiro_txt_2);
	  
	  erase(tipo_ficheiro_txt);
	  
	  
	  //  ate aqui movi o ficheiro para um temporario e depois vou mover do temporario para o anteriror mas sem o usuario eleminado
	  
	  
	  //abrir o 2º ficheiro
	  Assign(tipo_ficheiro_txt_2,caminho_temp);
	  Reset(tipo_ficheiro_txt_2);
	  
	  //recriar o 1º ficheiro "vazio"
	  Assign(tipo_ficheiro_txt,caminho_ficheiro_pedidos);
	  Rewrite(tipo_ficheiro_txt);
	  
	  // copiar do 2 para o 1 ficheiro mas exeto o ficheiro que foi eliminado
	  Repeat
	  
	    Readln(tipo_ficheiro_txt_2,linha);
	    
	    If(linha <> novo_nome)Then
		    Writeln(tipo_ficheiro_txt,linha);   
			 
	  Until(eof(tipo_ficheiro_txt_2));
	  
	  // fechar os ficheiros e apagar o 2 / temporario
	  close(tipo_ficheiro_txt_2);
	  close(tipo_ficheiro_txt);
	  
	  erase(tipo_ficheiro_txt_2);
	
	  // adicionar na lista do que enviou o pedido
	  caminho_ficheiro_amigos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',novo_nome,'.txt'); 
	  Assign(tipo_ficheiro_txt,caminho_ficheiro_amigos);
	  Append(tipo_ficheiro_txt);
	  Writeln(tipo_ficheiro_txt,utilizador.nome);   
	  close(tipo_ficheiro_txt);
	  
	  // adicionar na lista do que recebeu o pedido
	  caminho_ficheiro_amigos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',utilizador.nome,'.txt'); 
	  Assign(tipo_ficheiro_txt,caminho_ficheiro_amigos);
	  Append(tipo_ficheiro_txt);
	  Writeln(tipo_ficheiro_txt,novo_nome);   
	  close(tipo_ficheiro_txt);
	  
	  Writeln;
		Writeln('O Pedido foi aceite...');
		Readkey;
		clrscr;
  End
	Else
	Begin
	  textcolor(12);
	  Writeln('Esse Utilizador não existe ou não enviou um pedido...');
		textcolor(10); 
		Readkey;
		clrscr;
	End;		
End;

//------------------------------------------------------RECUSAR PEDIDO-----------------------------------------//
Procedure recusar_pedido;
Var novo_nome,linha,caminho_temp:string;
Begin  

	Write('Nome: ');
	Read(novo_nome);
	
	Assign(tipo_ficheiro_txt,caminho_ficheiro_pedidos);
  Reset(tipo_ficheiro_txt); 
  
  Repeat 
  	Readln(tipo_ficheiro_txt,linha);	 
  Until(eof(tipo_ficheiro_txt)OR(linha=novo_nome));
  
  close(tipo_ficheiro_txt); 
  
  If(linha=novo_nome)Then 
	Begin  
	  caminho_temp:=('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\pedidos\temp.txt');
		
	  // abrir 1º ficheiro
	  Assign(tipo_ficheiro_txt,caminho_ficheiro_pedidos);
	  Reset(tipo_ficheiro_txt);
	  
	  // abrir 2º ficheiro
	  Assign(tipo_ficheiro_txt_2,caminho_temp);
	  Rewrite(tipo_ficheiro_txt_2);
	  
	  // copiar do 1 para o 2 ficheiro
	  Repeat
	  
	    Readln(tipo_ficheiro_txt,linha);
	    Writeln(tipo_ficheiro_txt_2,linha);   
			 
	  Until(eof(tipo_ficheiro_txt));
	  
	  // fechar os ficheiros e apagar o primeiro
	  close(tipo_ficheiro_txt);
	  close(tipo_ficheiro_txt_2);
	  
	  erase(tipo_ficheiro_txt);
	  
	  
	  //  ate aqui movi o ficheiro para um temporario e depois vou mover do temporario para o anteriror mas sem o pedido eleminado
	  
	  
	  //abrir o 2º ficheiro
	  Assign(tipo_ficheiro_txt_2,caminho_temp);
	  Reset(tipo_ficheiro_txt_2);
	  
	  //recriar o 1º ficheiro "vazio"
	  Assign(tipo_ficheiro_txt,caminho_ficheiro_pedidos);
	  Rewrite(tipo_ficheiro_txt);
	  
	  // copiar do 2 para o 1 ficheiro mas exeto o ficheiro que foi eliminado
	  Repeat
	  
	    Readln(tipo_ficheiro_txt_2,linha);
	    
	    If(linha <> novo_nome)Then
		    Writeln(tipo_ficheiro_txt,linha);   
			 
	  Until(eof(tipo_ficheiro_txt_2));
	  
	  // fechar os ficheiros e apagar o 2 / temporario
	  close(tipo_ficheiro_txt_2);
	  close(tipo_ficheiro_txt);
	  
	  erase(tipo_ficheiro_txt_2);
	  
	  Writeln;
		Writeln('O Pedido foi recusado...');
		Readkey;
		clrscr;
  End
	Else
	Begin
	  textcolor(12);
	  Writeln('Esse Utilizador não existe ou não enviou um pedido...');
		textcolor(10); 
		Readkey;
		clrscr;
	End;		
End;

//------------------------------------------------------PEDIDOS AMIZADE-----------------------------------------//
Procedure pedidos_amizade;
Var linha,OP_temp:string;
		y,cont_linhas:integer;                                    
Begin
	Repeat
	  Repeat
		  clrscr;
		  
		  Assign(tipo_ficheiro_txt, caminho_ficheiro_pedidos);                                                         
			Reset(tipo_ficheiro_txt);                             
				                                       
		  gotoxy(25,2);
		  Writeln('{PEDIDOS DE AMIZADE}  ');
		  y:=2;
		
		  Repeat   	      
		  y:=y+2;
			cont_linhas:=cont_linhas+1;  
		    Readln(tipo_ficheiro_txt,linha);
		                        
				gotoxy(25,y);     
		    Writeln(linha); 	
				            
		  Writeln;  
			Writeln;        
			Until(Eof(tipo_ficheiro_txt)); 
			
			close(tipo_ficheiro_txt); 
			
			If(cont_linhas=1)AND(linha='')Then
			Begin
				gotoxy(17,y);     
		    Writeln('[ Ainda não tens Pedidos de Amizade ]'); 
		    Writeln;
		    Writeln('Clique em qualquer tecla para voltar...');
		    cont_linhas:=0;
				Readkey;
				clrscr;	
				exit;
			End; 
			cont_linhas:=0;
			 
			gotoxy(70,2);
		  Writeln(' [1] - Aceitar ');
		  gotoxy(70,4);
		  Writeln(' [2] - Recusar ');
		  gotoxy(70,6);
		  Writeln(' [0] - Voltar ');
			gotoxy(70,8);
		  Writeln(' Opção: ');  
		  gotoxy(78,8);
		  Read(OP_temp);
		  
	  Until((OP_temp='0')OR(OP_temp='1')OR(OP_temp='2')); 
		
		If(OP_temp='1')Then
	    aceitar_pedido;
	  
	  If(OP_temp='2')Then
	    recusar_pedido;
			 
  Until(OP_temp='0');
End;

//-------------------------------------------------LISTA-AMIGOS------------------------------------//
Procedure lista_amigos;
Var linha:string;
    i,y,cont_linhas:integer;
Begin
  Repeat
		Repeat  
		  clrscr; y:=2; 
			  
		  Assign(tipo_ficheiro_txt, caminho_ficheiro_amigos);                                                         
			Reset(tipo_ficheiro_txt);                                                        
				                               
		  gotoxy(17,2);
		  Writeln('{LISTA DE AMIGOS}  ');
		  
		  Writeln; 
		  Repeat   	      
		  y:=y+2;
			cont_linhas:=cont_linhas+1;
			  
		    Readln(tipo_ficheiro_txt,linha);
				                    
				gotoxy(25,y);     
		    Writeln(linha); 	
				                   
			Until(Eof(tipo_ficheiro_txt)); 
			
			close(tipo_ficheiro_txt);   
			 
			If(cont_linhas=1)AND(linha='')Then
			Begin
				gotoxy(17,y);     
		    Writeln('[ Ainda não tens Amigos ]'); 
				cont_linhas:=0;	
			End;
			cont_linhas:=0;	
			
			gotoxy(70,2);
		  Writeln(' [1] - Adicionar ');
		  gotoxy(70,4);
		  Writeln(' [2] - Remover ');
		  gotoxy(70,6);
		  Writeln(' [3] - Pedidos de Amizade '); 
		  gotoxy(70,8);
		  Writeln(' [0] - Voltar ');
			gotoxy(70,10);
		  Writeln(' Opção: ');  
		  gotoxy(78,10);
		  Read(OP[2]);
			  
	  Until((OP[2]='0')OR(OP[2]='1')OR(OP[2]='2')OR(OP[2]='3'));  
	  
	  If(OP[2]='1')Then
	    add_amigos;
	    
	  If(OP[2]='2')Then
	    remover_amigos;  
	  
	  If(OP[2]='3')Then
	    pedidos_amizade;
	  
  Until(OP[2]='0'); 
	OP[1]:='5';
End;
//-------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------INICIO PROGRAMA-------------------------------------------//
//-------------------------------------------------------------------------------------------------------------//
Begin
caminho_ficheiro_conversa:=('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\conversa.dat');
caminho_ficheiro_users:=('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\users.dat');  

                    {Limpar o CHAT}
//Assign(tipo_ficheiro_dat_conversa,caminho_ficheiro_conversa);
//Rewrite(tipo_ficheiro_dat_conversa);
//Close(tipo_ficheiro_dat_conversa);  

	Repeat                                    
	  Repeat
	    menu_inicial;
	    
	    If(OP[3]='1')Then
	    registrar;
	    
	    If(OP[3]='2')Then
	    entrar;
	    
	    If(OP[3]='3')Then
	    lista_users;
	                                  
		  clrscr;
		Until((seguir=true)OR(OP[3]='0'));
	  seguir:=false;
	  
		If(OP[3]<>'0')Then
		Begin
		  Repeat	
			  caminho_ficheiro_amigos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\lista_amigos\',utilizador.nome,'.txt'); 
				caminho_ficheiro_pedidos:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\pedidos\',utilizador.nome,'.txt'); 
				caminho_ficheiro_historico:=Concat('C:\18_19_11L_PSI_M7_FTF_2_AndreCerqueira\historico\',utilizador.nome,'.txt'); 
		    perfil;
		    menu_principal;   
		    
		    If(OP[1]='1')Then
	      chat;
	      
	      If(OP[1]='2')Then
	      lista_amigos;
	      
	      If(OP[1]='3')Then
	      Begin
	        Repeat
	          menu_def;
		          
		        If(OP[4]='1')Then
		        Begin
						  dados:='nome';
						  alterar;
						End;
						  
						If(OP[4]='2')Then
						Begin
						  dados:='pass';
						  alterar;
						End;
							  
						If(OP[4]='3')Then
						  apagar_conta;
						  
						If(OP[4]='4')Then          
							historico;
										           
			  	Until(OP[4]='0');
	      End;
	      
			  clrscr;
			Until((OP[1]='0')OR(OP[1]='1')OR(OP[1]='4'));
		End;
	Until((OP[1]='0')OR(OP[3]='0'));
	
End.











