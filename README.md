<div align="center">

# BREATHFIELD

**Um campo de partículas que só se acalma quando tu te acalmas.**

Experiência interativa anti-stress para iPad e iPhone, construída como Swift Playground com SwiftUI e SpriteKit.

![Swift](https://img.shields.io/badge/Swift-6-F05138?style=flat-square&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-0D96F6?style=flat-square&logo=swift&logoColor=white)
![SpriteKit](https://img.shields.io/badge/SpriteKit-000000?style=flat-square&logo=apple&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-16%2B-000000?style=flat-square&logo=apple&logoColor=white)
![Arquitetura](https://img.shields.io/badge/arquitetura-MVVM-6E40C9?style=flat-square)
![Licença](https://img.shields.io/badge/licen%C3%A7a-MIT-green?style=flat-square)

</div>

<!-- Adiciona aqui um GIF ou vídeo curto da experiência: é o que mais chama a atenção num portfólio. -->

---

## Sobre o projeto

A maioria das aplicações de relaxamento diz ao utilizador o que fazer: "respira", "relaxa", "conta até quatro". O BREATHFIELD segue o caminho oposto. Não há instruções. O utilizador toca num campo de partículas vivas e descobre sozinho que **gestos bruscos geram caos e gestos lentos e contínuos criam ordem**.

A calma não aparece de imediato. Ela vai sendo construída aos poucos, e só quando o utilizador mantém um ritmo suave durante algum tempo é que as partículas se organizam num anel estável. A ideia é ensinar calma através do corpo, e não através de texto.

## Como funciona

| Gesto do utilizador | Reação do campo |
| --- | --- |
| Movimento rápido e brusco | O caos aumenta de forma não-linear e as partículas dispersam-se |
| Movimento intermédio | O campo fica instável e tenta organizar-se |
| Movimento lento e contínuo | A ordem cresce de forma lenta e cumulativa |
| Calma mantida ao longo do tempo | As partículas formam um anel e o campo entra num estado estável |

O campo passa por cinco estados (`chaotic`, `destabilizing`, `stabilizing`, `coherent` e `stable`), cada um com o seu próprio feedback visual.

## Destaques técnicos

- **Física procedural própria.** Não usa o motor de física do SpriteKit. Cada partícula tem posição, velocidade e ponto base, e o movimento é integrado a cada frame dentro de `update(_:)`.
- **Duas métricas de ordem.** `fieldOrder` reage rapidamente ao gesto atual. `structuralOrder` muda devagar e representa a estabilidade do campo inteiro. É esta separação que faz a calma parecer "conquistada".
- **Leitura de gestos.** A velocidade do gesto é normalizada e convertida em energia de caos. A suavidade e a continuidade alimentam a ordem.
- **Influência local.** Cada gesto só afeta as partículas num raio à volta do toque, o que cria a sensação de estar a "pentear" o campo.
- **SwiftUI + SpriteKit.** A cena SpriteKit envia as métricas para o ViewModel através de um callback, e a interface SwiftUI reage a essas mudanças.
- **Swift 6** com o modo de linguagem mais recente e concorrência estrita.

## Stack

| Camada | Tecnologia |
| --- | --- |
| Interface | SwiftUI |
| Simulação e renderização | SpriteKit (`SKScene`, `SKShapeNode`, `SpriteView`) |
| Matemática e geometria | CoreGraphics |
| Arquitetura | MVVM |
| Projeto | Swift Playground (`.swiftpm`) |

## Arquitetura

```
BREATHFIELD.swiftpm/
├── MyApp.swift                     # Ponto de entrada
├── Model/
│   ├── Particle.swift              # Estado físico de cada partícula
│   ├── FieldState.swift            # Estados do campo (do caos à estabilidade)
│   └── AppRoute.swift              # Navegação
├── Scene/
│   ├── InteractiveParticleScene.swift  # Núcleo da simulação
│   └── AnimatedParticleScene.swift     # Campo animado do ecrã de introdução
├── ViewModel/
│   ├── FieldViewModel.swift        # Liga gesto, cena e estado
│   ├── GestureViewModel.swift      # Interpretação dos gestos
│   └── AnimatedParticleViewModel.swift
├── View/
│   ├── ContentView.swift
│   ├── CalmIntroView.swift
│   ├── InteractiveFieldView.swift  # Campo interativo principal
│   ├── StableFieldView.swift       # Ecrã de estabilidade
│   ├── CalmDetailsView.swift
│   └── SpriteKitView.swift
└── Utils/
    └── Clamp+Extensions.swift
```

## Como executar

**Requisitos:** Xcode 16 ou superior (ou Swift Playgrounds 4.5+ no iPad), iOS/iPadOS 16+.

```bash
git clone https://github.com/devmiqsaldh/BREATHFIELD.git
```

1. Abre a pasta `BREATHFIELD.swiftpm` no Xcode ou na app Swift Playgrounds.
2. Escolhe um simulador ou um dispositivo (a experiência foi pensada para iPad).
3. Executa e interage com o campo. Não tenhas pressa.

## Privacidade

A aplicação não recolhe nem guarda nenhum dado. Tudo acontece em memória, durante a sessão.

## Autor

**Miqueias Saldanha**: desenvolvedor iOS, Apple Developer Academy | Mackenzie

[![GitHub](https://img.shields.io/badge/GitHub-devmiqsaldh-181717?style=flat-square&logo=github)](https://github.com/devmiqsaldh)

## Licença

Distribuído sob a licença MIT. Consulta o ficheiro [LICENSE](LICENSE).
