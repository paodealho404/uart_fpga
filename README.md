
# Módulo UART em Verilog

## Descrição
Este é um repositório de Módulo UART em Verilog contendo transmissor e receptor. Totalmente funcional implementado em Verilog HDL. O módulo UART é projetado para facilitar a comunicação serial entre dispositivos, proporcionando transmissão e recepção de dados confiáveis.

## Funcionalidades
- Taxa de Baud Fixa: Configurado para uma taxa de baud de 115200.
- Transmissão de Dados de 8 bits: Suporta quadros de dados de 8 bits.
- Sem Bit de Paridade: Não inclui bit de paridade.
- 1 Bit de Parada: Configurado para 1 bit de parada.
## Estrutura do Repositório
- `uart_tx.v`: Módulo de transmissão UART.
- `uart_rx.v`: Módulo de recepção UART.
- `uart.v`: Módulo UART genérico que integra os módulos de transmissão e recepção.
- `uart_tx_tb.v`: Testbench para o módulo de transmissão UART.
- `uart_rx_tb.v`: Testbench para o módulo de recepção UART.
- `uart_tb.v`: Testbench para o módulo UART genérico.
Começando
Para começar com o módulo UART, clone este repositório e explore os arquivos .v fornecidos. Os testbenches são exemplos detalhados de como testar a funcionalidade do módulo.

## Pré-requisitos
- Simulador Verilog: Qualquer simulador Verilog HDL (por exemplo, ModelSim, VCS) para rodar os testbenches.
- Ferramenta de Síntese: Uma ferramenta de síntese (por exemplo, Xilinx Vivado, Altera Quartus) se você planeja implementar o módulo em hardware FPGA.

## Simulação
Para simular o módulo UART, execute os testbenches fornecidos (uart_tx_tb.v, uart_rx_tb.v, uart_tb.v) usando seu simulador Verilog. Os testbenches são projetados para verificar a correção do módulo em várias condições.