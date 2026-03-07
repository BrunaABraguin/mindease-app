# MindEase App 🧠✨

Um aplicativo Flutter moderno para bem-estar mental desenvolvido com arquitetura limpa e gerenciamento de estado BLoC.

## 📋 Sobre o Projeto

O MindEase App é uma aplicação Flutter destinada ao cuidado mental e bem-estar, construída seguindo os princípios da Clean Architecture e utilizando o padrão BLoC para gerenciamento de estado. O aplicativo integra-se com Firebase para autenticação e armazenamento de dados.

## 🏗️ Arquitetura

O projeto implementa **Clean Architecture** com as seguintes camadas:

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── firebase_options.dart     # Configurações do Firebase
└── src/
    ├── app/                  # 🎨 Camada de Apresentação (UI)
    │   ├── pages/           # Páginas/telas do app
    │   ├── widgets/         # Componentes reutilizáveis
    │   ├── utils/           # Utilitários da UI
    │   └── navigator.dart   # Navegação
    ├── domain/              # 💼 Camada de Domínio (Regras de Negócio)
    │   ├── entities/        # Entidades do negócio
    │   ├── repositories/    # Contratos dos repositórios
    │   └── usecases/        # Casos de uso
    ├── data/                # 💾 Camada de Dados
    │   ├── repositories/    # Implementações dos repositórios
    │   ├── helpers/         # Auxiliares para dados
    │   └── constants.dart   # Constantes
    └── device/              # 📱 Camada de Dispositivo
        ├── repositories/    # Acesso a recursos do dispositivo
        └── utils/           # Utilitários do dispositivo
```

### Padrões Utilizados

- **BLoC Pattern**: Para gerenciamento de estado reativo e previsível
- **Clean Architecture**: Separação clara de responsabilidades em camadas
- **SOLID Principles**: Código maintível e extensível
- **Dependency Injection**: Usando GetIt para inversão de dependências

## 📦 Principais Pacotes

### 🎯 Gerenciamento de Estado

- `flutter_bloc: ^9.1.1` - Implementação do padrão BLoC
- `equatable: ^2.0.8` - Comparação de objetos para estados

### 🔥 Firebase & Backend

- `firebase_core: ^4.5.0` - Core do Firebase
- `firebase_auth: ^6.2.0` - Autenticação
- `cloud_firestore: ^6.1.3` - Banco de dados NoSQL
- `google_sign_in: ^7.2.0` - Login com Google

### 🏗️ Arquitetura

- `flutter_clean_architecture: ^6.2.0` - Estrutura base para Clean Architecture
- `get_it: ^9.2.1` - Injeção de dependências

### 💾 Armazenamento & Configuração

- `shared_preferences: ^2.5.4` - Persistência local
- `flutter_dotenv: ^6.0.0` - Variáveis de ambiente

### 🔧 Utilitários

- `intl: ^0.20.2` - Internacionalização e formatação de datas
- `flutter_hooks: ^0.21.3+1` - Hooks para otimização de widgets
- `cupertino_icons: ^1.0.8` - Ícones do iOS

### 🧪 Desenvolvimento

- `flutter_test` - Testes unitários
- `flutter_lints: ^6.0.0` - Linting e boas práticas

## ⚙️ Configuração do Projeto

### Pré-requisitos

- Flutter SDK (>=3.11.0)
- Dart SDK
- Android Studio / VS Code
- Firebase CLI (opcional)

### Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto:

```env
# Firebase Configuration
FIREBASE_API_KEY=your_api_key_here
FIREBASE_APP_ID=your_app_id_here
FIREBASE_PROJECT_ID=your_project_id_here

# Outras configurações
APP_NAME=MindEase App
```

## 🚀 Instalação e Execução

### 1. Clone o repositório

```bash
git clone https://github.com/BrunaABraguin/mindease-app.git
cd mindease-app
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Configure o Firebase

- Adicione seus arquivos `google-services.json` (Android) e `GoogleService-Info.plist` (iOS)
- Configure as opções do Firebase em `lib/firebase_options.dart`

### 4. Execute o aplicativo

```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Para uma plataforma específica
flutter run -d chrome  # Web
flutter run -d android # Android
flutter run -d ios     # iOS
```

## 🔧 Scripts Úteis

### Linting e formatação

```bash
# Análise de código
flutter analyze

# Formatação
dart format .

# Lints
flutter pub run flutter_lints
```

### Build

```bash
# APK Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### Testes

```bash
# Executar todos os testes
flutter test

# Executar testes com cobertura
flutter test --coverage
```

## 🌟 Funcionalidades Principais

- ✅ **Autenticação**: Login/registro com Firebase Auth e Google Sign-In
- ✅ **Estado Reativo**: Gerenciamento com BLoC pattern
- ✅ **Armazenamento**: Firestore para dados na nuvem
- ✅ **Persistência Local**: SharedPreferences para configurações
- ✅ **Temas**: Suporte a tema claro e escuro
- ✅ **Configuração Segura**: Variáveis de ambiente com flutter_dotenv

## 📱 Plataformas Suportadas

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 📞 Contato

Bruna Braguin - [@BrunaABraguin](https://github.com/BrunaABraguin)

Link do Projeto: [https://github.com/BrunaABraguin/mindease-app](https://github.com/BrunaABraguin/mindease-app)
