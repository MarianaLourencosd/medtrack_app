<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=2E7D6B&height=240&section=header&text=MedTrack&fontSize=72&fontColor=ffffff&fontAlignY=38&desc=Sa%C3%BAde%20Digital%20com%20Intelig%C3%AAncia&descSize=22&descAlignY=62" alt="MedTrack" width="100%" />

**Sua saúde organizada, acessível e segura na palma da mão.**

<br>

![Flutter](https://img.shields.io/badge/Flutter-3.13+-2E7D6B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.1+-3FA58A?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-1B5E4F?style=for-the-badge&logo=firebase&logoColor=white)
![OpenStreetMap](https://img.shields.io/badge/OpenStreetMap-flutter__map-4CAF93?style=for-the-badge&logo=openstreetmap&logoColor=white)
![Licença](https://img.shields.io/badge/Licen%C3%A7a-Acad%C3%AAmico-A8D5BA?style=for-the-badge)

<br>

[Sobre](#-sobre-o-projeto) &nbsp;•&nbsp;
[Funcionalidades](#-funcionalidades) &nbsp;•&nbsp;
[Tecnologias](#️-tecnologias) &nbsp;•&nbsp;
[Estrutura](#-estrutura-do-projeto) &nbsp;•&nbsp;
[Como executar](#-como-executar) &nbsp;•&nbsp;
[Autores](#-autores)

</div>

<br>

## 📋 Sobre o Projeto

O **MedTrack** é um aplicativo mobile de saúde desenvolvido em Flutter que centraliza informações médicas pessoais em uma carteira digital acessível e segura.

Ele resolve o problema da dispersão de dados de saúde (tipo sanguíneo, alergias, medicamentos e contatos de emergência), que ficam espalhados em papéis e apps diferentes, dificultando o acesso em situações críticas.


---

## 🎯 Funcionalidades

| Funcionalidade | Descrição |
|:---------------|:----------|
| **Carteira Digital** | Todos os dados de saúde em um só lugar |
| **Emergência** | Mapa com hospitais e UBS próximos (OpenStreetMap) |
| **Medicamentos** | Busca com autocomplete |
| **Dicas de Saúde** | 28 dicas em 7 categorias |
| **Quiz & Mitos** | 3 níveis de dificuldade, mitos e verdades e badges |
| **Formulário de Saúde** | Dados biométricos, médicos e contatos |
| **PDF / QR Code / Lembretes** | Compartilhamento de dados e alertas |
| **Modo Escuro/Claro** | Acessibilidade visual |

---

## 🛠️ Tecnologias

| Camada | Tecnologia |
|:-------|:-----------|
| **Framework** | Flutter + Dart (Android, iOS e Web) |
| **Autenticação** | Firebase Auth |
| **Banco de dados** | Cloud Firestore |
| **Mapas** | OpenStreetMap + flutter_map |
| **Localização** | Geolocator |
| **Ícones** | flutter_svg |
| **Validação de CPF** | validar_brasileiro |
| **Animações** | flutter_confetti |
| **Persistência do tema** | SharedPreferences |

---

## 📁 Estrutura do Projeto

```text
lib/
├── constantes/        # Cores, estilos de texto, espaçamentos, tema
├── modelos/           # Modelos de dados (Hospital, Medicamento, etc.)
├── recursos/          # Recursos compartilhados (CardAcessoRestrito, etc.)
├── servicos/          # Serviços (Auth, Medicamentos, Hospitais, Saúde)
└── telas/
    ├── home/          # Tela principal e widgets
    ├── login/         # Login
    ├── cadastro/      # Cadastro
    ├── perfil/        # Perfil
    ├── formulario/    # Formulário de saúde
    ├── emergencia/    # Emergência
    ├── medicamentos/  # Medicamentos
    ├── dicas/         # Dicas
    ├── quiz/          # Quiz e Mitos
    ├── pdf/           # Exportação em PDF
    ├── qrcode/        # QR Code
    └── lembretes/     # Lembretes
```

---

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK 3.13 ou superior
- Dart SDK
- Android Studio ou VS Code
- Conta Firebase configurada

### Passo a passo

```bash
# 1. Clone o repositório
git clone https://github.com/seu-usuario/medtrack_app.git

# 2. Entre na pasta
cd medtrack_app

# 3. Instale as dependências
flutter pub get

# 4. Execute no Chrome
flutter run -d chrome

# 5. Execute no Android
flutter run -d android
```

---

## 📱 Telas do App

| Tela | Descrição |
|:-----|:----------|
| **Login** | Autenticação com e-mail e senha |
| **Cadastro** | Criação de conta com validação de CPF |
| **Home** | Tela principal com acesso rápido aos recursos |
| **Emergência** | Mapa com hospitais próximos e contatos |
| **Medicamentos** | Busca com autocomplete (base ANVISA) |
| **Dicas** | 28 dicas de saúde por categoria |
| **Quiz** | Perguntas em 3 níveis, mitos e verdades |
| **Formulário** | Dados biométricos e médicos |
| **Perfil** | Dados do usuário |

---

## 🎨 Design

- Material Design 3
- Tema claro e escuro com persistência
- Cor primária: verde `#2E7D6B`
- Tipografia: Montserrat, Karla e Spectral
- Layout responsivo para diferentes tamanhos de tela

---

## 🔐 Segurança

- Autenticação via Firebase Auth
- Dados criptografados no Firestore
- Validação de CPF offline
- Permissões do Android configuradas

---

## 👥 Autores

| Nome |
|:-----|
| Fernanda Garcia de Oliveira |
| José Henrique Bessa |
| Mariana Dos Santos Lourenço |
| Natália Rodrigues |
| Sophia Oliveira Cavallaro |

--- 

<br>

<div align="center">


[Voltar ao topo](#top)

<img src="https://capsule-render.vercel.app/api?type=waving&color=2E7D6B&height=110&section=footer" alt="" width="100%" />

</div>