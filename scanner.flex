%%

%public
%class Scanner
%line
%column
%unicode
%standalone
%type void

%{
  // Variáveis pra armazenamento
  private String numero = "";
  private String titulo = "";
  private String data = "";
  private String resumo = "";
  private String reivindicacoes = "";
  private StringBuilder buffer = new StringBuilder();
%}

%state ENTRE_PATENTE

// Macros
PatenteInicial  = "<TABLE WIDTH="100%">
<TR>	<TD ALIGN="LEFT" WIDTH="50%"><B>United States Patent </B></TD>
	<TD ALIGN="RIGHT" WIDTH="50%"><B>"
PatenteFinal    = "</B></TD>
</TR>
<TR><TD ALIGN="LEFT" WIDTH="50%"><b>"
TituloInicial   = <HR>
<font size="+1">
TituloFinal     = </font><BR>
DataInicial     = <TR><TD VALIGN="TOP" ALIGN="LEFT" WIDTH="10%" NOWRAP>PCT PUB. Date: 
     </TD><TD ALIGN="LEFT" WIDTH="90%">                    
     <B>
DataFinal       = </B></TD></TR>
</TABLE>
<HR>
<p>
ResumoInicial   = SUMMARY\ OF\ THE\ INVENTION
ResumoFinal     = SUMMARY\ OF\ THE\ INVENTION
ReivindicaçõesInicial  = Claims
ReivindicaçõesFinal    = Claims

%%

//padroes encontrados
// Transição de estado e inicia buffer
{PatenteInicial} {
  yybegin(ENTRE_PATENTE);
  buffer.setLength(0); // limpa buffer
}

// Dentro do trecho de patente
<ENTRE_PATENTE>{
  {PatenteFinal} {
    yybegin(YYINITIAL);
    numero = buffer.toString().trim();
  }
  
  [^] { buffer.append(yytext()); } // adiciona qualquer caractere ao buffer
}

{Titulo}         { titulo = yytext(); }
{Data}           { data = yytext(); }
{Resumo}         { resumo = yytext(); }
{Reivindicações} { reivindicacoes = yytext(); }


<<EOF>> {
  System.out.println("Número da Patente: " + numero);
  System.out.println("Título: " + titulo);
  System.out.println("Data de Publicação: " + data);
  System.out.println("Resumo: " + resumo);
  System.out.println("Reivindicações: " + reivindicacoes);
  return;
}

.|\n { /* ignora os outros caracteres */ }
