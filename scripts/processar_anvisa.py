#!/usr/bin/env python3
"""
Script para processar CSV bruto da ANVISA e gerar medicamentos.json otimizado.

Uso:
    python scripts/processar_anvisa.py dados_brutos.csv assets/medicamentos.json

O CSV da ANVISA (dados abertos) tipicamente contém colunas como:
- NOME_PRODUTO (Nome do Medicamento)
- NOME_SUBSTANCIA (Princípio Ativo)
- ... outras colunas que serão descartadas

Este script:
1. Lê o CSV (detecta encoding e separador automaticamente)
2. Mantém apenas "Nome do Medicamento" e "Princípio Ativo"
3. Remove duplicatas (baseado em nome + princípio ativo)
4. Normaliza strings (remove espaços extras, padroniza case)
5. Exporta JSON compacto para assets/medicamentos.json
"""

import sys
import csv
import json
import argparse
from pathlib import Path
from typing import Dict, List, Set, Tuple


def detectar_encoding(caminho: Path) -> str:
    """Tenta detectar o encoding do arquivo (comum: utf-8, latin-1, cp1252)."""
    for encoding in ('utf-8', 'latin-1', 'cp1252', 'iso-8859-1'):
        try:
            with open(caminho, 'r', encoding=encoding) as f:
                f.read(1024)
            return encoding
        except UnicodeDecodeError:
            continue
    return 'utf-8'  # fallback


def detectar_delimitador(amostra: str) -> str:
    """Detecta o delimitador do CSV (vírgula, ponto e vírgula, tab)."""
    sniffer = csv.Sniffer()
    try:
        return sniffer.sniff(amostra).delimiter
    except csv.Error:
        return ';'  # Padrão brasileiro


def normalizar_texto(texto: str) -> str:
    """Normaliza string: strip, colapsa espaços múltiplos, title case para nomes próprios."""
    if not texto:
        return ''
    # Remove espaços extras e quebras de linha
    texto = ' '.join(texto.split())
    return texto.strip()


def processar_csv_anvisa(
    entrada: Path,
    saida: Path,
    coluna_nome: str = 'NOME_PRODUTO',
    coluna_principio: str = 'NOME_SUBSTANCIA'
) -> Dict[str, int]:
    """
    Processa o CSV da ANVISA e gera JSON otimizado.

    Returns:
        Dict com estatísticas: {'total_linhas': int, 'unicos': int, 'duplicatas_removidas': int}
    """
    encoding = detectar_encoding(entrada)
    print(f'📖 Lendo CSV com encoding: {encoding}')

    with open(entrada, 'r', encoding=encoding) as f:
        amostra = f.read(8192)
        f.seek(0)
        delimitador = detectar_delimitador(amostra)
        print(f'🔍 Delimitador detectado: {repr(delimitador)}')

        leitor = csv.DictReader(f, delimiter=delimitador)

        # Verifica se as colunas esperadas existem
        if leitor.fieldnames is None:
            raise ValueError('CSV vazio ou inválido')

        colunas_lower = {c.lower(): c for c in leitor.fieldnames}
        col_nome = colunas_lower.get(coluna_nome.lower())
        col_principio = colunas_lower.get(coluna_principio.lower())

        if not col_nome or not col_principio:
            print(f'⚠️  Colunas não encontradas. Colunas disponíveis: {leitor.fieldnames}')
            print(f'   Procurando por: {coluna_nome}, {coluna_principio}')
            # Tenta variações comuns
            for c in leitor.fieldnames:
                if 'produto' in c.lower() or 'medicament' in c.lower() or 'nome' in c.lower():
                    if not col_nome:
                        col_nome = c
                if 'substanc' in c.lower() or 'principio' in c.lower() or 'ativo' in c.lower():
                    if not col_principio:
                        col_principio = c

            if not col_nome or not col_principio:
                raise ValueError('Não foi possível identificar colunas de nome e princípio ativo')

        print(f'✅ Usando colunas: "{col_nome}" e "{col_principio}"')

        vistos: Set[Tuple[str, str]] = set()
        medicamentos: List[Dict[str, str]] = []
        total_linhas = 0
        duplicatas = 0

        for linha in leitor:
            total_linhas += 1
            nome_raw = linha.get(col_nome, '')
            principio_raw = linha.get(col_principio, '')

            nome = normalizar_texto(nome_raw)
            principio = normalizar_texto(principio_raw)

            if not nome or not principio:
                continue  # Pula linhas incompletas

            chave = (nome.upper(), principio.upper())
            if chave in vistos:
                duplicatas += 1
                continue

            vistos.add(chave)
            medicamentos.append({
                'nome': nome,
                'principio_ativo': principio
            })

        # Ordena alfabeticamente por nome para melhor UX no autocomplete
        medicamentos.sort(key=lambda m: m['nome'].lower())

        # Escreve JSON compacto (sem indentação para economizar espaço)
        saida.parent.mkdir(parents=True, exist_ok=True)
        with open(saida, 'w', encoding='utf-8') as f_out:
            json.dump(medicamentos, f_out, ensure_ascii=False, separators=(',', ':'))

        stats = {
            'total_linhas': total_linhas,
            'unicos': len(medicamentos),
            'duplicatas_removidas': duplicatas
        }

        print(f'✅ Processamento concluído!')
        print(f'   Linhas lidas: {total_linhas}')
        print(f'   Medicamentos únicos: {len(medicamentos)}')
        print(f'   Duplicatas removidas: {duplicatas}')
        print(f'   Arquivo salvo em: {saida}')
        print(f'   Tamanho: {saida.stat().st_size / 1024:.1f} KB')

        return stats


def main():
    parser = argparse.ArgumentParser(
        description='Processa CSV da ANVISA para JSON otimizado do MedTrack',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos:
  python scripts/processar_anvisa.py dados/ANVISA_MEDICAMENTOS.csv assets/medicamentos.json
  python scripts/processar_anvisa.py dados/brutos.csv assets/medicamentos.json --coluna-nome PRODUTO --coluna-principio ATIVO
        """
    )
    parser.add_argument('entrada', help='Caminho do CSV bruto da ANVISA')
    parser.add_argument('saida', help='Caminho do JSON de saída (ex: assets/medicamentos.json)')
    parser.add_argument('--coluna-nome', default='NOME_PRODUTO', help='Nome da coluna do medicamento')
    parser.add_argument('--coluna-principio', default='NOME_SUBSTANCIA', help='Nome da coluna do princípio ativo')

    args = parser.parse_args()

    entrada = Path(args.entrada)
    saida = Path(args.saida)

    if not entrada.exists():
        print(f'❌ Arquivo de entrada não encontrado: {entrada}')
        sys.exit(1)

    try:
        processar_csv_anvisa(entrada, saida, args.coluna_nome, args.coluna_principio)
    except Exception as e:
        print(f'❌ Erro: {e}')
        sys.exit(1)


if __name__ == '__main__':
    main()