# MedTrack

Aplicativo de saúde pessoal para acompanhamento de dados médicos, localização de unidades de saúde e informações de emergência.

---

## Plataformas Suportadas

- Android
- iOS
- Web

---

## Estrutura do Projeto

A aplicação segue uma organização modular, facilitando a manutenção e entendimento:

```
medtrack_app/
├── lib/
│   ├── assets/
        ├── images/    
│   ├── constantes/         
│   ├── modelos/             
│   ├── recursos/           
│   ├── servicos/           
│   └── telas/
│       ├── home/   
        ├── compatilhados/           
│       ├── login/           
│       ├── cadastro/     
│       ├── perfil/         
│       ├── formulario/      
│       └── emergencia/     
├── android/                
├── ios/                    
├── web/                   
├── macos/                   
├── windows/                 
└── pubspec.yaml             
```

---

## Como Executar o Projeto

Para rodar o projeto localmente, siga os passos:

```bash
# Clonar o repositório
git clone <url-do-repositorio>

# Entrar na pasta do projeto
cd medtrack_app

# Instalar dependências
flutter pub get

# Executar o projeto (Android)
flutter run -d android

# Executar o projeto (iOS)
flutter run -d ios

# Executar o projeto (Web)
flutter run -d chrome

```

Após a execução, o sistema estará disponível no dispositivo ou navegador escolhido.

---

## Desenvolvedores

José Henrique Bessa

Natália Rodrigues

Sophia Cavallaro

Mariana Lourenço

Fernanda Garcia

---

## Status do Projeto

Projeto em desenvolvimento para fins acadêmicos.

---