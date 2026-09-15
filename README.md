# DiscoGame 🎵💿

[![Godot Engine](https://img.shields.io/badge/Godot-4.3%2B-478CBF?style=for-the-badge&logo=godotengine&logoColor=white)](https://godotengine.org/)
[![Platform](https://img.shields.io/badge/Plataforma-Android%20%7C%20PC-brightgreen?style=for-the-badge)](https://github.com/gustavkeller-23/DiscoGame)
[![GDScript](https://img.shields.io/badge/Linguagem-GDScript-blue?style=for-the-badge)](https://docs.godotengine.org/pt-br/4.x/tutorials/scripting/gdscript/gdscript_basics.html)
[![License](https://img.shields.io/badge/Licen%C3%A7a-Educacional-orange?style=for-the-badge)](#-licen%C3%A7a)

**DiscoGame** é um jogo educativo e interativo desenvolvido na **Godot Engine 4.3**, combinando elementos de ritmo, reflexo e associação silábica em um tabuleiro em formato de disco com quatro direções coloridas.

O jogo utiliza o método de estímulo visual e auditivo com imagens reais, ilustrações e fonética, incentivando o aprendizado de forma lúdica e gamificada.

---

## 📱 Download do APK (Android)

Você pode baixar e instalar o jogo diretamente em seu dispositivo Android:

### 📥 [**Baixar Jogo (jogo.apk)**](./APK/jogo.apk)
> 📁 **Localização no repositório:** `APK/jogo.apk` (~64 MB)

### 📲 Como Instalar no Celular:
1. Faça o download do arquivo [jogo.apk](./APK/jogo.apk) no seu dispositivo móvel.
2. Abra o gerenciador de arquivos ou clique na notificação de download concluído.
3. Se solicitado, autorize a **Instalação de fontes desconhecidas** nas configurações do navegador/gerenciador.
4. Conclua a instalação e abra o aplicativo **Disco** para jogar!

---

## 🎮 Como Jogar e Controles

O tabuleiro é dividido em 4 direções/quadrantes coloridos (Amarelo, Azul, Vermelho e Verde). Uma sílaba/palavra é indicada por som e imagem, e o jogador deve responder apontando para a direção correspondente.

### 🕹️ Controles:

| Ação / Direção | Teclado (PC) | Mobile / Touch (Android) |
| :--- | :--- | :--- |
| **Cima** | Seta para Cima (`↑`) | Deslizar para Cima (*Swipe Up*) |
| **Baixo** | Seta para Baixo (`↓`) | Deslizar para Baixo (*Swipe Down*) |
| **Esquerda** | Seta para Esquerda (`←`) | Deslizar para a Esquerda (*Swipe Left*) |
| **Direita** | Seta para Direita (`→`) | Deslizar para a Direita (*Swipe Right*) |

---

## ✨ Funcionalidades

- 🧠 **Associação Silábica e Fonética:** Apresentação de palavras com imagens reais, ilustrações e pronúncia em áudio.
- 🎯 **Níveis de Dificuldade:** Diferentes velocidades e tempos de resposta para desafiar o reflexo.
- 🏆 **Gamificação:** Sistema de pontuação, registro de erros, cronômetro e medalhas de desempenho.
- 📱 **Multiplataforma:** Suporte nativo para toque na tela (swipe) no Android e controle por teclado no PC.
- 🎨 **Interface Estilizada:** Menus intuitivos, tutoriais interativos (*Como Jogar*), efeitos sonoros e animações dinâmicas.

---

## 📁 Estrutura do Projeto

```bash
DiscoGame/
├── APK/                 # Arquivo instalador (.apk) para Android
│   └── jogo.apk
├── android/             # Configurações e templates de exportação Android
├── assets/              # Recursos visuais, ícones, medalhas e áudios (NinoEdu)
├── scenes/              # Cenas da Godot (Menu, Jogo, Tutorial, Níveis, Vitória)
├── scripts/             # Scripts em GDScript (Lógica, Global, Controles)
├── export_presets.cfg   # Definições de exportação
├── project.godot         # Arquivo de configuração principal do projeto
└── icon.svg             # Ícone do projeto
```

---

## 🚀 Como Executar o Projeto na Godot (PC)

### Pré-requisitos
- [Godot Engine 4.3 (Standard)](https://godotengine.org/download)

### Passo a Passo

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/gustavkeller-23/DiscoGame.git
   ```

2. **Abra o Godot Engine:**
   - Clique em **Importar** (*Import*).
   - Navegue até a pasta do projeto e selecione o arquivo `project.godot`.

3. **Execute o Jogo:**
   - Pressione `F5` ou clique no botão **Executar Projeto** (*Run Project*) no canto superior direito da engine.
   - Cena principal: `res://scenes/start.tscn`.

---

## 📌 Objetivos Pedagógicos e Benefícios

Este projeto foi concebido com foco no desenvolvimento educacional e psicomotor:
- **Alfabetização e Vocabulário:** Fixação silábica por estímulo multissensorial (visual e auditivo).
- **Gamificação:** Estímulo contínuo através de metas, pontuação e medalhas.
- **Coordenação Motora e Reflexo:** Rápida tomada de decisão e resposta motora espacial.
- **Repetição Positiva:** Fortalecimento da memória e retenção de conceitos através da prática.

---

## 👨‍💻 Autor

Desenvolvido por **Gustav Keller**  
🔗 GitHub: [@gustavkeller-23](https://github.com/gustavkeller-23)

---

## 📄 Licença

Projeto desenvolvido para fins educacionais e de aprendizagem.
