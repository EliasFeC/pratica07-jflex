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

%state ENTRE_PATENTE, ENTRE_TITULO, ENTRE_DATA, ENTRE_RESUMO, ENTRE_REIV

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
ResumoInicial   = </font><BR>
<BR><CENTER><B>Abstract</B></CENTER>
<P>
ResumoFinal     = </P>
<HR>
<TABLE WIDTH="100%"> <TR><TD VALIGN="TOP" ALIGN="LEFT" WIDTH="10%">
ReivindicaçõesInicial  = <HR>
<CENTER><B><I>Claims</B></I></CENTER> <HR> <BR><BR>What is claimed is:<BR><BR>
ReivindicaçõesFinal    = <HR> <CENTER><B><I> Description</B>

%%

// =======================
// PATENTE
{PatenteInicial} {
  yybegin(ENTRE_PATENTE);
  buffer.setLength(0);
}

<ENTRE_PATENTE>{PatenteFinal} {
  yybegin(YYINITIAL);
  numero = buffer.toString().trim();
}

<ENTRE_PATENTE>[^] { buffer.append(yytext()); }

// =======================
// TÍTULO
{TituloInicial} {
  yybegin(ENTRE_TITULO);
  buffer.setLength(0);
}

<ENTRE_TITULO>{TituloFinal} {
  yybegin(YYINITIAL);
  titulo = buffer.toString().trim();
}

<ENTRE_TITULO>[^] { buffer.append(yytext()); }

// =======================
// DATA
{DataInicial} {
  yybegin(ENTRE_DATA);
  buffer.setLength(0);
}

<ENTRE_DATA>{DataFinal} {
  yybegin(YYINITIAL);
  data = buffer.toString().trim();
}

<ENTRE_DATA>[^] { buffer.append(yytext()); }

// =======================
// RESUMO
{ResumoInicial} {
  yybegin(ENTRE_RESUMO);
  buffer.setLength(0);
}

<ENTRE_RESUMO>{ResumoFinal} {
  yybegin(YYINITIAL);
  resumo = buffer.toString().trim();
}

<ENTRE_RESUMO>[^] { buffer.append(yytext()); }

// =======================
// REIVINDICAÇÕES
{ReivindicacoesInicial} {
  yybegin(ENTRE_REIV);
  buffer.setLength(0);
}

<ENTRE_REIV>{ReivindicacoesFinal} {
  yybegin(YYINITIAL);
  reivindicacoes = buffer.toString().trim();
}

<ENTRE_REIV>[^] { buffer.append(yytext()); }

<<EOF>> {
  System.out.println("Número da Patente: " + numero);
  System.out.println("Título: " + titulo);
  System.out.println("Data de Publicação: " + data);
  System.out.println("Resumo: " + resumo);
  System.out.println("Reivindicações: " + reivindicacoes);
  return;
}

.|\n { /* ignora os outros caracteres */ }
