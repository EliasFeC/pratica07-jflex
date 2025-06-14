%%

%public
%class Scanner
%line
%column
%unicode
%standalone
%type void

%{
  private String numero = "";
  private String titulo = "";
  private String data = "";
  private String resumo = "";
  private String reivindicacoes = "";
  private StringBuilder buffer = new StringBuilder();
%}

// Estados
%state ENTRE_PATENTE ENTRE_TITULO ENTRE_DATA ENTRE_RESUMO ENTRE_REIV

// Macros
PatenteInicial = "<TABLE WIDTH=\"100%\"><TR><TD ALIGN=\"LEFT\" WIDTH=\"50%\"><B>United States Patent </B></TD><TD ALIGN=\"RIGHT\" WIDTH=\"50%\"><B>"
PatenteFinal   = "</B></TD></TR><TR><TD ALIGN=\"LEFT\" WIDTH=\"50%\"><b>"

TituloInicial  = "<font size=\"+1\">"
TituloFinal    = "</font><BR>"

DataInicial    = "PCT PUB. Date: <B>"
DataFinal      = "</B>"

ResumoInicial  = "<CENTER><B>Abstract</B></CENTER><P>"
ResumoFinal    = "</P>"

ReivindicacoesInicial = "<CENTER><B><I>Claims</B></I></CENTER> <HR> <BR><BR>What is claimed is:<BR><BR>"
ReivindicacoesFinal   = "<HR> <CENTER><B><I> Description</B>"

// Qualquer caractere
ANYCHAR = (.|\n)

%%

// Número da patente
{PatenteInicial}        { yybegin(ENTRE_PATENTE); buffer.setLength(0); }
<ENTRE_PATENTE>{PatenteFinal} { yybegin(YYINITIAL); numero = buffer.toString().trim(); }
<ENTRE_PATENTE>{ANYCHAR}      { buffer.append(yytext()); }

// Título
{TituloInicial}         { yybegin(ENTRE_TITULO); buffer.setLength(0); }
<ENTRE_TITULO>{TituloFinal}   { yybegin(YYINITIAL); titulo = buffer.toString().trim(); }
<ENTRE_TITULO>{ANYCHAR}       { buffer.append(yytext()); }

// Data
{DataInicial}           { yybegin(ENTRE_DATA); buffer.setLength(0); }
<ENTRE_DATA>{DataFinal}       { yybegin(YYINITIAL); data = buffer.toString().trim(); }
<ENTRE_DATA>{ANYCHAR}         { buffer.append(yytext()); }

// Resumo
{ResumoInicial}         { yybegin(ENTRE_RESUMO); buffer.setLength(0); }
<ENTRE_RESUMO>{ResumoFinal}   { yybegin(YYINITIAL); resumo = buffer.toString().trim(); }
<ENTRE_RESUMO>{ANYCHAR}       { buffer.append(yytext()); }

// Reivindicações
{ReivindicacoesInicial}       { yybegin(ENTRE_REIV); buffer.setLength(0); }
<ENTRE_REIV>{ReivindicacoesFinal} { yybegin(YYINITIAL); reivindicacoes = buffer.toString().trim(); }
<ENTRE_REIV>{ANYCHAR}             { buffer.append(yytext()); }

// Fim do arquivo
<<EOF>> {
  System.out.println("Número da Patente: " + numero);
  System.out.println("Título: " + titulo);
  System.out.println("Data de Publicação: " + data);
  System.out.println("Resumo:\n" + resumo);
  System.out.println("Reivindicações:\n" + reivindicacoes);
  return;
}

// Ignorar fora de estados
.  { }
\n { }
