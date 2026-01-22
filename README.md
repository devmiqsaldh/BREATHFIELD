# BREATHFIELD – Anti‑Stress Playground

BREATHFIELD é um aplicativo **experiencial e meditativo** desenvolvido como *Swift Playground*, cujo objetivo é **ensinar calma por meio da interação corporal**, e não por instruções explícitas.

O usuário interage com um **campo de partículas vivas**, onde gestos bruscos aumentam o caos e gestos suaves, contínuos e conscientes organizam lentamente o sistema, culminando na formação de um **tecido estável**.

A experiência foi desenhada para ser **lenta, progressiva e sensorial**, exigindo presença real.

---

## Conceito Central

> *A calma não é um estado imediato — ela emerge com o tempo, o ritmo e a intenção.*

BREATHFIELD utiliza física procedural, feedback visual e interação tátil para criar um **campo responsivo** que reflete o estado do usuário:

* 🔴 Movimento brusco → desorganização, desorientação, aumento do caos
* 🟡 Movimento intermediário → campo instável, tentativa de organização
* 🟢 Movimento suave e contínuo → organização progressiva e formação do tecido

Quando o tecido se forma, o campo entra em **estado estável irreversível**, reforçando a sensação de conquista e repouso.

---

## Funcionalidades Principais

* Campo de partículas sempre ativo (nunca congela)
* Física procedural com múltiplos regimes (caos, transição, estabilidade)
* Leitura contínua de gestos (velocidade, direção e suavidade)
* Desorganização **não‑linear** para gestos bruscos
* Organização **lenta e cumulativa** para gestos calmos
* Formação de um tecido circular robusto (anel estrutural)
* Sincronização total entre estado visual e estado lógico
* Transição para tela de estabilidade após consolidação do campo

---

## Arquitetura

O projeto utiliza **MVVM (Model–View–ViewModel)**, separando claramente:

* Estado e dados (Model)
* Física e simulação (Scene)
* Interface declarativa (View)
* Lógica, coordenação e interpretação de gestos (ViewModel)

```
BREATHFIELD/
├── Model/          # Estruturas de dados e entidades básicas
├── Scene/          # Cenas SpriteKit e simulação física
├── View/           # Interfaces SwiftUI
├── ViewModel/      # Lógica de estado, gestos e coordenação
```

Essa separação permite:

* fácil iteração na experiência
* testes isolados de lógica
* clareza entre visual, física e intenção do usuário

---

##  Frameworks Utilizados

### Frameworks Apple

* **SwiftUI**
  Interface declarativa, estados reativos e composição das telas

* **SpriteKit**
  Simulação do campo de partículas, física procedural e renderização em tempo real

* **Foundation**
  Datas, temporização, utilidades básicas

* **CoreGraphics**
  Vetores, pontos, cálculos geométricos e apoio matemático

* **Combine (indiretamente via SwiftUI)**
  Atualização reativa entre ViewModel, Scene e View

---

##  Ferramentas e Tecnologias

* Xcode 15+
* Swift 5.9+
* Swift Playgrounds / iOS App
* SpriteView (integração SpriteKit + SwiftUI)
* Arquitetura MVVM
* Programação orientada a estados
* Física procedural customizada (sem physics engine padrão)

---

## Estrutura do Código

### App

* `BREATHFIELDApp` / `MyApp` – ponto de entrada do aplicativo

### Model

* `Particle` – estado físico individual (posição, velocidade, base)
* `StrokePoint` – histórico e suavização de gestos (quando aplicável)

### Scene

* `InteractiveParticleScene` – núcleo da simulação

  * controle de caos
  * organização progressiva
  * formação do tecido

### View

* `ContentView` – composição inicial
* `InteractiveFieldView` – campo interativo principal
* `StableFieldView` – estado de campo estabilizado
* `CalmDetailsView` – informações finais e reinício

### ViewModel

* `FieldViewModel` – coordenação entre gesto, cena e estado
* `GestureViewModel` (quando separado) – interpretação e normalização dos gestos

---

## Experiência do Usuário

1. Usuário inicia em um campo caótico
2. Gestos bruscos intensificam a desorganização
3. Gestos cessam → campo permanece instável
4. Gestos suaves e contínuos iniciam organização lenta
5. Após ~2 minutos de calma consistente:

   * partículas formam um tecido circular
   * campo entra em estado estável
6. Interface apresenta a `StableFieldView`
7. Usuário pode reiniciar a experiência conscientemente

---

## Persistência

* Uso de `@AppStorage` para:

  * controlar exibição de introdução
  * estados de progresso da experiência

Nenhuma informação pessoal do usuário é coletada ou armazenada.

---

## 📋 Requisitos

* iOS 17.0+
* iPadOS 17.0+ (otimizado para iPad)
* Xcode 15.0+
* Swift 5.9+

---

## ▶️ Como Usar

1. Clone o repositório
2. Abra o projeto no Xcode
3. Selecione um simulador ou dispositivo real
4. Execute o aplicativo
5. Interaja com o campo:

   * movimentos bruscos → mais caos
   * movimentos suaves → organização lenta

 **Importante:** a experiência não deve ser apressada.

---

## Documentação

* Código comentado seguindo convenções Swift
* Funções críticas documentadas com intenção física e sensorial
* Estrutura pensada para leitura e iteração criativa

---

## Licença

MIT License
