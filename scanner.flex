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
%}

// Macros
Patente         = 7022487
Titulo          = United\ States\ Patent
Data            = July\ 31,\ 2003
Resumo          = SUMMARY\ OF\ THE\ INVENTION
Reivindicações  = Claims

%%

//padroes encontrados
{Patente}        { numero = yytext(); }
{Titulo}         { titulo = yytext(); }
{Data}           { data = yytext(); }
{Resumo}         { resumo = yytext(); }
{Reivindicações} { reivindicacoes = yytext(); }

//fim do arquivo como os campos da patente
<<EOF>> {
  System.out.println("Número: " + numero);
  System.out.println("Título: " + titulo);
  System.out.println("Data de Publicação: " + data);
  System.out.println("Resumo: " + resumo);
  System.out.println("Reivindicações: " + reivindicacoes);
  return;
}

.|\n { /* ignora os outros caracteres */ }
