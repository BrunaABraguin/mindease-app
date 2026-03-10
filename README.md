# MindEase App 🧠✨

Aplicativo Flutter para bem-estar mental e produtividade pessoal, com timer Pomodoro, rastreamento de hábitos, gestão de tarefas e sistema de conquistas — construído com Clean Architecture e BLoC.

---

## Sumário

1. [Sobre o Projeto](#-sobre-o-projeto)
2. [Funcionalidades](#-funcionalidades)
3. [Decisões de Arquitetura](#-decisões-de-arquitetura)
4. [Decisões Técnicas](#-decisões-técnicas)
5. [Estrutura do Projeto](#-estrutura-do-projeto)
6. [Pré-requisitos](#-pré-requisitos)
7. [Instalação e Execução](#-instalação-e-execução)
8. [Variáveis de Ambiente](#-variáveis-de-ambiente)
9. [Scripts e Automação](#-scripts-e-automação)
10. [Testes](#-testes)
11. [CI/CD](#-cicd)
12. [Qualidade de Código](#-qualidade-de-código)
13. [Plataformas Suportadas](#-plataformas-suportadas)
14. [Como Contribuir](#-como-contribuir)
15. [Contato](#-contato)

---

## 📋 Sobre o Projeto

O **MindEase** é uma aplicação multiplataforma voltada ao cuidado mental e produtividade. Permite ao usuário gerenciar hábitos diários, organizar tarefas, utilizar um timer Pomodoro com modo foco e acompanhar conquistas (missões). A autenticação é feita via Firebase Auth com suporte a Google Sign-In, e os dados são persistidos no Cloud Firestore.

---

## 🌟 Funcionalidades

| Funcionalidade | Descrição |
|---|---|
| **Timer Pomodoro** | Ciclos de foco/pausa configuráveis (25/5/15 min padrão), com contagem de sessões e ciclos |
| **Modo Foco** | Extensão do timer com overlay de confetti ao completar um ciclo |
| **Hábitos** | Criação e rastreamento diário de hábitos com calendário e streak |
| **Tarefas** | Gestão de tarefas com prioridade, status de conclusão e tempo gasto |
| **Missões** | Sistema de 16 conquistas em 5 categorias (timer, hábitos, tarefas, perfil, login) |
| **Perfil** | Dashboard de estatísticas, toggle de tema, preferências e autenticação |
| **Autenticação** | Login com Google via Firebase Auth |
| **Persistência** | Firestore (nuvem) + SharedPreferences (local) |
| **Responsividade** | Layout adaptativo: `NavigationBar` no mobile, `NavigationRail` no desktop |

---

## 🏗️ Decisões de Arquitetura

### Clean Architecture

O projeto segue **Clean Architecture** com 4 camadas bem definidas, garantindo separação de responsabilidades, testabilidade e independência de frameworks:

| Camada | Responsabilidade | Localização |
|---|---|---|
| **Apresentação (App)** | UI, navegação, controladores (Cubits), widgets | `lib/src/app/` |
| **Domínio** | Entidades, interfaces de repositório, casos de uso | `lib/src/domain/` |
| **Dados** | Implementações de repositório, data sources, DI | `lib/src/data/` |
| **Dispositivo** | Acesso a recursos específicos da plataforma | `lib/src/device/` |

**Regra de dependência:** as camadas internas (Domínio) não conhecem as camadas externas (Dados, App). A comunicação ocorre via interfaces (contratos de repositório) definidas no Domínio e implementadas na camada de Dados.

### BLoC/Cubit para Gerenciamento de Estado

O padrão **BLoC** (via `flutter_bloc`) foi escolhido por oferecer:

- Estado reativo e previsível (unidirecional)
- Facilidade de teste com `bloc_test`
- Separação clara entre lógica de negócio e UI
- Observabilidade via `BlocObserver` (logs de transições e mudanças)

**Controladores existentes:**

| Cubit | Responsabilidade |
|---|---|
| `TimerCubit` | Estado do timer Pomodoro, ciclos e persistência |
| `HabitsCubit` | Lista de hábitos, data selecionada, operações CRUD |
| `TasksCubit` | Gerenciamento de tarefas |
| `MissionsCubit` | Acompanhamento de missões/conquistas |
| `ProfileCubit` | Autenticação, preferências, dados do perfil |

### Injeção de Dependências

A DI é feita de forma **manual via singletons** nos arquivos `lib/src/data/di/`, sem uso de Service Locator em runtime. Os repositórios e casos de uso são instanciados como variáveis top-level e injetados na árvore de widgets via `MultiRepositoryProvider` e `MultiBlocProvider` no `main.dart`.

| Arquivo DI | Dependências fornecidas |
|---|---|
| `auth_di.dart` | `AuthRepositoryImpl`, `GetAuthStateUseCase`, `SignInWithGoogleUseCase`, `SignOutUseCase` |
| `habit_di.dart` | `HabitRepositoryImpl` |
| `profile_di.dart` | `ProfileRepositoryImpl` |
| `task_di.dart` | `TaskRepositoryImpl` |

### Navegação Adaptativa

O `AppNavigator` implementa navegação por abas com 5 destinos (Timer, Hábitos, Tarefas, Missões, Perfil). O layout se adapta ao tamanho da tela:

- **< 600px (mobile):** `NavigationBar` na parte inferior
- **≥ 600px (tablet/desktop):** `NavigationRail` na lateral esquerda

### Componentização de Widgets

Seguindo regras explícitas de organização:

1. **Widgets específicos de uma página** ficam em `lib/src/app/pages/<page>/widgets/`
2. **Widgets compartilhados** ficam em `lib/src/app/widgets/`
3. Views (`_view.dart`) apenas compõem widgets extraídos, mantendo-se enxutas

---

## ⚙️ Decisões Técnicas

### Stack Principal

| Tecnologia | Versão | Justificativa |
|---|---|---|
| **Flutter** | SDK ≥ 3.11.0 | Framework multiplataforma com boa performance e ecossistema maduro |
| **Dart** | ≥ 3.11.0 | Linguagem do Flutter, com null safety e tipagem forte |
| **Firebase Auth** | ^6.2.0 | Autenticação gerenciada, com suporte a Google Sign-In |
| **Cloud Firestore** | ^6.0.3 | Banco NoSQL em tempo real, com sync offline |
| **flutter_bloc** | ^9.1.1 | Gerenciamento de estado reativo e testável |
| **SharedPreferences** | ^2.5.4 | Persistência local leve para preferências e estado do timer |
| **flutter_dotenv** | ^6.0.0 | Carregamento seguro de variáveis de ambiente |
| **Material 3** | Nativo | Design system moderno do Google, com `useMaterial3: true` |

### Pacotes de Desenvolvimento e Teste

| Pacote | Uso |
|---|---|
| `bloc_test: ^10.0.0` | Testes de estado para Cubits/Blocs |
| `mockito: ^5.6.3` | Mocks baseados em geração de código |
| `mocktail: ^1.0.4` | Mocks sem geração de código |
| `fake_cloud_firestore: ^4.0.1` | Firestore fake para testes de integração |
| `flutter_lints: ^6.0.0` | Regras de lint rigorosas |
| `equatable: ^2.0.8` | Comparação de igualdade para estados BLoC |

### Localização

- Idioma padrão: **Português (Brasil)** — `Locale('pt', 'BR')`
- Formatação de datas via `intl` com `initializeDateFormatting('pt_BR')`

### Tema

- Paleta de cores: Dark Blue (`#2F4158`), Teal (`#3DA8AF`), Golden (`#CDBC73`), Green (`#3BAB79`)
- Material 3 habilitado
- Suporte a tema escuro via preferência do usuário (toggle no perfil)

---

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                          # Bootstrap: Firebase, dotenv, BlocObserver, providers
├── firebase_options.dart              # Configurações por plataforma (gerado via dotenv)
├── theme.dart                         # ThemeData com Material 3
└── src/
    ├── app/                           # 🎨 Camada de Apresentação
    │   ├── navigator.dart             # Navegação adaptativa (NavigationBar/NavigationRail)
    │   ├── pages/
    │   │   ├── timer/                 # Timer Pomodoro
    │   │   │   ├── timer_controller.dart
    │   │   │   ├── timer_view.dart
    │   │   │   └── widgets/
    │   │   ├── focus_mode/            # Modo Foco (extensão do timer)
    │   │   │   ├── focus_mode_view.dart
    │   │   │   └── widgets/
    │   │   ├── habits/                # Rastreamento de hábitos
    │   │   │   ├── habits_controller.dart
    │   │   │   ├── habits_view.dart
    │   │   │   └── widgets/
    │   │   ├── tasks/                 # Gestão de tarefas
    │   │   │   ├── tasks_controller.dart
    │   │   │   ├── tasks_view.dart
    │   │   │   └── widgets/
    │   │   ├── missions/              # Sistema de conquistas
    │   │   │   ├── missions_controller.dart
    │   │   │   ├── missions_view.dart
    │   │   │   └── widgets/
    │   │   └── profile/               # Perfil e configurações
    │   │       ├── profile_controller.dart
    │   │       ├── profile_view.dart
    │   │       └── widgets/
    │   ├── widgets/                   # Widgets compartilhados (cross-page)
    │   └── utils/                     # Constantes, ícones, strings, breakpoints
    │
    ├── domain/                        # 💼 Camada de Domínio
    │   ├── entities/                  # AuthUser, Habit, Task, Mission, Profile, Preferences, TimerEntity
    │   ├── repositories/              # Interfaces abstratas (contratos)
    │   └── usecases/                  # GetAuthState, SignInWithGoogle, SignOut
    │
    ├── data/                          # 💾 Camada de Dados
    │   ├── di/                        # Injeção de dependências (singletons manuais)
    │   ├── repositories/              # Implementações (Firestore, SharedPreferences)
    │   ├── helpers/                   # AuthRemoteDataSource (Firebase Auth)
    │   └── constants.dart
    │
    └── device/                        # 📱 Camada de Dispositivo
        ├── repositories/
        └── utils/
```

---

## 📌 Pré-requisitos

- **Flutter SDK** ≥ 3.11.0 ([instalação](https://docs.flutter.dev/get-started/install))
- **Dart SDK** (incluso no Flutter)
- **Editor**: VS Code (recomendado) ou Android Studio
- **Firebase CLI** (para deploy): `npm install -g firebase-tools`
- **Git** para controle de versão

Verifique a instalação:

```bash
flutter doctor
```

---

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

### 3. Configure as variáveis de ambiente

Crie um arquivo `env` (sem ponto) na raiz do projeto com as credenciais Firebase (veja a seção [Variáveis de Ambiente](#-variáveis-de-ambiente)).

### 4. Configure o Firebase

- Adicione `google-services.json` em `android/app/`
- Adicione `GoogleService-Info.plist` em `ios/Runner/`
- O arquivo `lib/firebase_options.dart` lê as variáveis do `env` automaticamente

### 5. Instale os git hooks (opcional, recomendado)

```bash
sh scripts/install-hooks.sh
```

### 6. Execute o aplicativo

```bash
# Web
flutter run -d chrome

# Web (servidor headless)
flutter run -d web-server --web-port=8080

# Android
flutter run -d <device_id>

# Windows
flutter run -d windows
```

### 7. Build para produção

```bash
# Web
flutter build web --release

# Android APK
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 🔐 Variáveis de Ambiente

O arquivo `env` na raiz do projeto contém as credenciais Firebase. **Nunca commite esse arquivo** — ele é injetado via GitHub Secrets no CI/CD.

```env
# Chaves de API (por plataforma)
FIREBASE_API_KEY_WEB=...
FIREBASE_API_KEY_ANDROID=...
FIREBASE_API_KEY_IOS=...

# Configuração do projeto Firebase
FIREBASE_PROJECT_ID=...
FIREBASE_MESSAGING_SENDER_ID=...
FIREBASE_STORAGE_BUCKET=...
FIREBASE_AUTH_DOMAIN=...

# App IDs (por plataforma)
FIREBASE_APP_ID_WEB=...
FIREBASE_APP_ID_ANDROID=...
FIREBASE_APP_ID_IOS=...
FIREBASE_APP_ID_WINDOWS=...

# Analytics (Web e Windows)
FIREBASE_MEASUREMENT_ID_WEB=...
FIREBASE_MEASUREMENT_ID_WINDOWS=...

# iOS específico
FIREBASE_IOS_CLIENT_ID=...
FIREBASE_IOS_BUNDLE_ID=com.example.mindeaseApp
```

---

## 🔧 Scripts e Automação

### Git Hooks (Pre-commit)

O hook pre-commit executa automaticamente antes de cada commit:

| Etapa | Ação | Bloqueante? |
|---|---|---|
| **1. Lint auto-fix** | `dart fix --apply` + `dart format lib/ test/` | Não (auto-corrige) |
| **2. Análise estática** | `flutter analyze` — detecta imports, variáveis e funções não usadas | Sim |
| **3. Arquivos órfãos** | `dart run scripts/check_unused_files.dart` — detecta `.dart` não referenciados | Sim |
| **4. Cobertura de testes** | `flutter test --coverage` — mínimo de **80%** | Sim |

**Instalação:**

```bash
sh scripts/install-hooks.sh
```

### Comandos úteis

```bash
# Análise de código
flutter analyze

# Formatação de código
dart format lib/ test/

# Auto-fix de lints
dart fix --apply

# Verificar arquivos não utilizados
dart run scripts/check_unused_files.dart
```

---

## 🧪 Testes

O projeto utiliza uma estratégia de testes em múltiplos níveis:

| Tipo | Ferramentas | Localização |
|---|---|---|
| **Unitários** | `flutter_test`, `bloc_test`, `mockito`, `mocktail` | `test/controllers/`, `test/repositories/`, `test/entities/` |
| **Widget** | `flutter_test`, `fake_cloud_firestore` | `test/pages/`, `test/widgets/` |
| **Utilitários** | `flutter_test` | `test/utils/` |

### Executar testes

```bash
# Todos os testes
flutter test

# Com cobertura
flutter test --coverage

# Teste específico
flutter test test/controllers/timer_controller_test.dart
```

### Estrutura de testes

```
test/
├── main_test.dart
├── app/                    # Testes de navegação
├── controllers/            # Testes de Cubits (estado)
├── pages/                  # Testes de widgets/views
├── repositories/           # Testes de repositórios
├── entities/               # Testes de entidades
├── data/                   # Testes da camada de dados
├── domain/                 # Testes da camada de domínio
├── utils/                  # Testes de utilitários
├── widgets/                # Testes de widgets compartilhados
└── mocks/                  # Mocks reutilizáveis
```

---

## 🚢 CI/CD

O projeto possui dois workflows GitHub Actions:

### Deploy on Merge (`firebase-hosting-merge.yml`)

Acionado em **push na `main`** ou **workflow_dispatch**:

```
prepare_env → test_and_quality → build_and_deploy
                                        ↓
                               Firebase Hosting (Web)
```

| Job | Descrição |
|---|---|
| **prepare_env** | Gera o arquivo `env` a partir de GitHub Secrets |
| **test_and_quality** | Executa testes, valida cobertura mínima de **60%**, envia relatório ao SonarCloud |
| **build_and_deploy** | Build web (`flutter build web --release`) e deploy no Firebase Hosting |

### Deploy on PR (`firebase-hosting-pull-request.yml`)

Acionado em **pull requests**:

- Executa os mesmos checks de qualidade (testes + cobertura + SonarCloud)
- Gera preview de deploy no Firebase Hosting

---

## 📊 Qualidade de Código

### SonarCloud

Integrado via GitHub Actions para análise contínua de qualidade:

- **Projeto:** `BrunaABraguin_mindease-app`
- **Cobertura mínima CI:** 60%
- **Cobertura mínima local (pre-commit):** 80%
- **Relatório:** `coverage/lcov.info`

**Exclusões da análise:** arquivos gerados (`*.g.dart`, `*.freezed.dart`), configurações Firebase, diretório `build/`, localizações.

### Lint Rules

O `analysis_options.yaml` define regras rigorosas baseadas no `flutter_lints`, incluindo:

- `always_use_package_imports` — imports absolutos obrigatórios
- `prefer_const_constructors` — constantes sempre que possível
- `avoid_catches_without_on_clauses` — tratamento de erros específico
- `sort_pub_dependencies` — dependências ordenadas no `pubspec.yaml`
- `prefer_final_locals` — variáveis locais imutáveis

---

## 📱 Plataformas Suportadas

| Plataforma | Status |
|---|---|
| Android | ✅ |
| iOS | ✅ |
| Web | ✅ (deploy principal via Firebase Hosting) |
| Windows | ✅ |
| macOS | ✅ |
| Linux | ✅ |

---

## 🤝 Como Contribuir

1. Fork o projeto
2. Instale os git hooks: `sh scripts/install-hooks.sh`
3. Crie uma branch para sua feature: `git checkout -b feature/minha-feature`
4. Faça suas alterações seguindo a arquitetura e regras de componentização
5. Garanta que os testes passam e a cobertura está ≥ 80%: `flutter test --coverage`
6. Commit (o pre-commit validará lint, análise e cobertura automaticamente)
7. Push para a branch: `git push origin feature/minha-feature`
8. Abra um Pull Request

---

## 📞 Contato

Bruna Braguin — [@BrunaABraguin](https://github.com/BrunaABraguin)

Link do Projeto: [https://github.com/BrunaABraguin/mindease-app](https://github.com/BrunaABraguin/mindease-app)
